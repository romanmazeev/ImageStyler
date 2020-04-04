//
//  MLService.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 09.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import CoreML
import Combine

class MLService {
    private let model = ImageStyler()

    func transfer(_ imagePixelBuffer: CVPixelBuffer, styleIndex: Int) -> AnyPublisher<CVPixelBuffer, Error> {
        Future { [unowned self] promise in
            do {
                let styleArray = try MLMultiArray([Double](repeating: 0, count: StylesDataSource.shared.styles.count))
                styleArray[styleIndex] = 1

                let predictionOutput = try self.model.prediction(image: imagePixelBuffer, index: styleArray)

                promise(.success(predictionOutput.stylizedImage))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

