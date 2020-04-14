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
    @Published var selectedStyleId = StylesDataSource.shared.styles.first?.id ?? 0
    @Published var selectedImage: UIImage?

    // MARK: Output
    @Published private(set) var styles = StylesDataSource.shared.styles
    @Published private(set) var stylizedImage: UIImage?
    @Published private(set) var stylizedImageURL: URL?
    @Published var isError = false
    @Published var isLoading = false

    private var cancellables: Set<AnyCancellable> = .init()

    private let mlService = MLService()

    init() {
        $selectedImage
            .compactMap { $0 }
            .combineLatest($selectedStyleId)
            .filter { _ in !self.isLoading }
            .removeDuplicates { $0 == $1 }
            .handleEvents(receiveOutput: { [unowned self] output in
                self.styles = StylesDataSource.shared.selectStyle(output.1)
                self.isLoading = true
            })
            .receive(on: DispatchQueue.global())
            .setFailureType(to: Error.self)
            .flatMap { [unowned self] in self.mlService.transfer($0.0, styleIndex: $0.1) }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [unowned self] result in
                    if case .failure = result {
                        self.isError = true
                        self.isLoading = false
                        self.stylizedImage = nil
                    }
                }, receiveValue: { [unowned self] stylizedImage in
                    self.isError = false
                    self.isLoading = false
                    self.stylizedImage = stylizedImage
                }
            )
            .store(in: &cancellables)

        $stylizedImage
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .receive(on: DispatchQueue.global())
            .map { $0.save(key: "Stylized image") }
            .receive(on: RunLoop.main)
            .assign(to: \.stylizedImageURL, on: self)
            .store(in: &cancellables)
    }
}
