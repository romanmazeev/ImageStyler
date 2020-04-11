//
//  MLService.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 09.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import CoreML
import Combine
import UIKit.UIImage

class MLService {
    private let model = ImageStyler()

    func transfer(_ image: UIImage, styleIndex: Int) -> AnyPublisher<UIImage, Error> {
        guard let resizedImage = image.fixedOrientation()?.cgImage?.resize(toMaxWidth: 1024),
            let pixelBuffer = resizedImage.pixelBuffer else {
                return Fail(error: MLError.imagePreprocessingError)
                    .eraseToAnyPublisher()
        }

        return Future { [unowned self] promise in
            do {
                let styleArray = try MLMultiArray([Double](repeating: 0, count: StylesDataSource.shared.styles.count))
                styleArray[styleIndex] = 1

                let predictionOutput = try self.model.prediction(image: pixelBuffer, index: styleArray)

                guard let stylizedImage = CGImage.create(pixelBuffer: predictionOutput.stylizedImage) else {
                    return promise(.failure(MLError.bufferToImageError))
                }

                promise(.success(UIImage(cgImage: stylizedImage)))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

enum MLError: Error {
    case imagePreprocessingError
    case bufferToImageError
}
