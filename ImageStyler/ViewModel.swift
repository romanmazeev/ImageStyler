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
    @Published var selectedImage: UIImage?

    @Published var styles = StylesData.styles
    @Published var selectedStyle = StylesData.styles.first!

    @Published var stylizedImage: UIImage?
    @Published var stylizedImageURL: URL?
    @Published var isLoading = false

    private let mlService = MLService()
    private let imageProcessingService = ImageProcessingService()
    private let imageStorageService = ImageStorageService()
    private var cancellables: Set<AnyCancellable> = .init()

    init() {
        $selectedImage
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.global())
            .flatMap { [unowned self] in
                self.imageProcessingService.resizeImage(image: $0, targetSize: CGSize(width: 640, height: 640))
            }
            .flatMap { [unowned self] in
                self.imageProcessingService.pixelBuffer(from: $0)
            }
            .flatMap { [unowned self] in
                self.mlService.transfer($0, styleIndex: self.selectedStyle.id)
            }
            .flatMap { [unowned self] in
                self.imageProcessingService.image(from: $0)
            }
            .receive(on: RunLoop.main)
            .map { Optional($0) }
            .replaceError(with: nil)
            .assign(to: \.stylizedImage, on: self)
            .store(in: &cancellables)

        $selectedStyle
            .receive(on: RunLoop.main)
            .combineLatest($selectedImage)
            .sink { [unowned self] (_, image) in
                self.stylizedImage = nil
                self.selectedImage = image
            }
            .store(in: &cancellables)

        $stylizedImage
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [unowned self] image in
                self.isLoading = image == nil
            })
            .compactMap { $0 }
            .receive(on: DispatchQueue.global())
            .map { [unowned self] in
                self.imageStorageService.saveImage($0, key: "Stylized image")
            }
            .receive(on: RunLoop.main)
            .assign(to: \.stylizedImageURL, on: self)
            .store(in: &cancellables)
    }
}
