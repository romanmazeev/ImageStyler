//
//  StyledImageViewModel.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 08.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import Combine
import SwiftUI

class StyledImageViewModel: ObservableObject {
    let selectedImage: UIImage?
    @Published var selectedStyle = StylesData.styles.first!

    // MARK: Output
    @Published private(set) var styles = StylesData.styles
    @Published private(set) var stylizedImage: UIImage?
    @Published private(set) var stylizedImageURL: URL?
    @Published private(set) var errorMessage: String?
    @Published var isLoading: Bool = true
    @Published var isError: Bool = false

    private var cancellables: Set<AnyCancellable> = .init()

    private let mlService = MLService()
    private let imageProcessingService = ImageProcessingService()
    private let imageStorageService = ImageStorageService()

    init(selectedImage: UIImage?) {
        self.selectedImage = selectedImage
        setupOutputSubscriptions()
    }

    private func setupOutputSubscriptions() {
        $errorMessage
            .receive(on: RunLoop.main)
            .map { $0 != nil }
            .assign(to: \.isError, on: self)
            .store(in: &cancellables)

        $stylizedImage
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .receive(on: DispatchQueue.global())
            .map { self.imageStorageService.saveImage($0, key: "Stylized image") }
            .receive(on: RunLoop.main)
            .assign(to: \.stylizedImageURL, on: self)
            .store(in: &cancellables)

        $selectedStyle
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                self.stylizedImage = nil
                self.transferImage()
        }
        .store(in: &cancellables)
    }

    func transferImage() {
        guard let selectedImage = selectedImage else { return }
        isLoading = true
        imageProcessingService.resizeImage(image: selectedImage, targetSize: CGSize(width: 640, height: 640))
            .receive(on: DispatchQueue.global())
            .flatMap { self.imageProcessingService.pixelBuffer(from: $0) }
            .flatMap { self.mlService.transfer($0, styleIndex: self.selectedStyle.id) }
            .flatMap { self.imageProcessingService.image(from: $0) }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                }, receiveValue: { image in
                    self.stylizedImage = image
                    self.isLoading = false
                    self.errorMessage = nil
                }
            )
            .store(in: &cancellables)
    }
}
