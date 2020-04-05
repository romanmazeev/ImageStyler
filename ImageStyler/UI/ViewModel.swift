//
//  ViewModel.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 08.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import Combine
import SwiftUI

class ViewModel: ObservableObject {

    // MARK: Input
    @Published var selectedStyleId = 0
    @Published var selectedImage: UIImage?

    // MARK: Output
    @Published private(set) var styles = StylesDataSource.shared.styles
    @Published private(set) var stylizedImage: UIImage?
    @Published private(set) var stylizedImageURL: URL?
    @Published var isError = false
    @Published private(set) var isLoading = true

    private var cancellables: Set<AnyCancellable> = .init()

    private let mlService = MLService()

    init() {
        $selectedImage
            .compactMap { $0 }
            .combineLatest($selectedStyleId)
            .removeDuplicates { $0 == $1 }
            .handleEvents(receiveOutput: { [unowned self] _ in
                self.isLoading = true
            })
            .receive(on: DispatchQueue.global())
            .sink { [unowned self] in
                self.transferImage(selectedStyleIndex: $0.1, selectedImage: $0.0)
            }
            .store(in: &cancellables)

        $selectedStyleId
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .map { StylesDataSource.shared.selectStyle($0) }
            .assign(to: \.styles, on: self)
            .store(in: &cancellables)

        $stylizedImage
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .receive(on: DispatchQueue.global())
            .map { $0.save(key: "Stylized image") }
            .receive(on: RunLoop.main)
            .assign(to: \.stylizedImageURL, on: self)
            .store(in: &cancellables)

        $isError
            .filter { $0 }
            .sink { [unowned self] _ in
                self.isLoading = false
                self.stylizedImage = nil
            }
            .store(in: &cancellables)
    }

    private func transferImage(selectedStyleIndex: Int, selectedImage: UIImage) {
        guard let resizedImage = selectedImage.fixedOrientation()?.cgImage?.resize(toMaxWidth: 1024),
            let pixelBuffer = resizedImage.pixelBuffer else {
                DispatchQueue.main.async { [unowned self] in
                    self.isError = true
                }

                return
        }

        mlService.transfer(pixelBuffer, styleIndex: selectedStyleIndex)
            .map { UIImage(cgImage: CGImage.create(pixelBuffer: $0)!) }
            .receive(on: RunLoop.main)
            .handleEvents(
                receiveOutput: { [unowned self] _ in
                    self.isLoading = false
                }
            )
            .sink(
                receiveCompletion: { [unowned self] result in
                    if case .failure = result {
                        self.isError = true
                    }
                }, receiveValue: { [unowned self] stylizedImage in
                    self.stylizedImage = stylizedImage
                }
            )
            .store(in: &cancellables)
    }
}
