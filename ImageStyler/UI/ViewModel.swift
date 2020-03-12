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
    // Input
    @Published var selectedImage: UIImage?

    // Output
    @Published var stylizedImage: UIImage?
    @Published var isLoading = false

    private let mlService = MLService()
    private let imageProcessingService = ImageProcessingService()
    private var cancellables: Set<AnyCancellable> = .init()

    init() {

        $selectedImage
            .compactMap { $0 }
            .map { self.imageProcessingService.resizeImage(image: $0, targetSize: CGSize(width: 640, height: 640)) }
            .setFailureType(to: Error.self)
            .flatMap { [unowned self] in
                self.imageProcessingService.pixelBuffer(from: $0)
            }
            .receive(on: DispatchQueue.global())
            .flatMap { [unowned self] in
                self.mlService.transfer($0, styleNumber: 1)
            }
            .receive(on: RunLoop.main)
            .flatMap { [unowned self] in
                self.imageProcessingService.image(from: $0)
            }
            .map { Optional($0) }
            .assertNoFailure()
            .assign(to: \.stylizedImage, on: self)
            .store(in: &cancellables)
    }
}
