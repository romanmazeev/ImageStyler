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
            .handleEvents(receiveOutput: { [unowned self] _ in
                self.stylizedImage = nil
                self.isLoading =  true
            })
            .receive(on: DispatchQueue.global())
            .compactMap { $0 }
            .setFailureType(to: Error.self)
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
            .map { Optional($0) }
            .assertNoFailure()
            .receive(on: RunLoop.main)
            .assign(to: \.stylizedImage, on: self)
            .store(in: &cancellables)


        $selectedStyle
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                self.selectedImage = self.selectedImage
            }
            .store(in: &cancellables)

        $stylizedImage
            .compactMap { $0 }
            .handleEvents(receiveOutput: { [unowned self] _ in
                self.isLoading = false
            })
            .receive(on: DispatchQueue.global())
            .map { [unowned self] in
                self.imageStorageService.saveImage($0, key: "Stylized image")
            }
            .receive(on: RunLoop.main)
            .assign(to: \.stylizedImageURL, on: self)
            .store(in: &cancellables)
    }
}
