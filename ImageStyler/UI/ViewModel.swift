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
    let selectedStyleId = PassthroughSubject<Int, Never>()
    @Published var selectedImage: UIImage?

    // MARK: Output
    @Published private(set) var styles = StylesDataSource.shared.styles
    @Published private(set) var stylizedImage: UIImage?
    @Published private(set) var stylizedImageURL: URL?
    @Published var isError = false
    @Published private(set) var isLoading = true

    var cancellables: Set<AnyCancellable> = .init()

    private let mlService = MLService()
    private let imageStorageService = ImageStorageService()

    init() {
        selectedStyleId
            .removeDuplicates()
            .combineLatest($selectedImage)
            .handleEvents(receiveOutput: { [unowned self] _ in
                self.isLoading = true
            })
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.global())
            .flatMap { [unowned self] in self.mlService.transfer($0.1!.cgImage!.pixelBuffer(width: 640, height: 640, orientation: .up)!, styleIndex: $0.0) }
            .receive(on: RunLoop.main)
            .map { UIImage(cgImage: CGImage.create(pixelBuffer: $0)!) }
            .replaceError(with: UIImage())
            .handleEvents(receiveOutput: { [unowned self] _ in
                self.isLoading = false
            })
            .assign(to: \.stylizedImage, on: self)
            .store(in: &cancellables)

        selectedStyleId
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .map { StylesDataSource.shared.selectStyle($0) }
            .assign(to: \.styles, on: self)
            .store(in: &cancellables)

        $stylizedImage
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .receive(on: DispatchQueue.global())
            .map { self.imageStorageService.saveImage($0, key: "Stylized image") }
            .receive(on: RunLoop.main)
            .assign(to: \.stylizedImageURL, on: self)
            .store(in: &cancellables)
    }
}

// Combine memory leak fix
extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
       sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}
