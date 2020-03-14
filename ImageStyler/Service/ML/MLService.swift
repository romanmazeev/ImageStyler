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
    private let numberOfStyles = 1

    func transfer(_ imagePixelBuffer: CVBuffer, styleIndex: Int) -> Future<CVPixelBuffer, Error> {
        Future { promise in
            let model = ImageStyler()
            do {
                let styleArray = try MLMultiArray([Double](repeating: 0, count: self.numberOfStyles))
                styleArray[styleIndex] = 1

                let predictionOutput = try model.prediction(image: imagePixelBuffer, index: styleArray)

                promise(.success(predictionOutput.stylizedImage))
            } catch {
                promise(.failure(error))
            }
        }
    }
}

