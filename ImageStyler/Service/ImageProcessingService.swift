//
//  ImageProcessingService.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 11.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import Combine
import SwiftUI

enum ImageProcessingServiceError: Error {
    case bufferCreation
    case contextCreation

    case cgImageCreation
    case imageResizing
}

class ImageProcessingService {
    func pixelBuffer(from image: UIImage) -> AnyPublisher<CVPixelBuffer, Error> {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(image.size.width),
            Int(image.size.height),
            kCVPixelFormatType_32ARGB,
            attrs, &pixelBuffer
        )
        
        guard (status == kCVReturnSuccess) else {
            return Future { $0(.failure(ImageProcessingServiceError.bufferCreation)) }
                .eraseToAnyPublisher()
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: pixelData,
            width: Int(image.size.width),
            height: Int(image.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )

        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return Future { $0(.success(pixelBuffer!)) }
            .eraseToAnyPublisher()
    }

    
    func image(from pixelBuffer: CVPixelBuffer) -> AnyPublisher<UIImage, Error> {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let tempContext = CIContext(options: nil)
        let tempRect = CGRect(x: 0,
                              y: 0,
                              width: CVPixelBufferGetWidth(pixelBuffer),
                              height: CVPixelBufferGetHeight(pixelBuffer))
        if let cgImage = tempContext.createCGImage(ciImage, from: tempRect) {
            return Future { $0(.success(UIImage(cgImage: cgImage))) }
                .eraseToAnyPublisher()
        } else {
            return Future { $0(.failure(ImageProcessingServiceError.cgImageCreation)) }
                .eraseToAnyPublisher()
        }
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> AnyPublisher<UIImage, Error> {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let smallestRatio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * smallestRatio, height: size.height * smallestRatio)

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return Future { promise in
            if let newImage = newImage {
                promise(.success(newImage))
            } else {
                promise(.failure(ImageProcessingServiceError.imageResizing))
            }
        }
        .eraseToAnyPublisher()
    }
}
