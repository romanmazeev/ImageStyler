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
}

class ImageProcessingService {
    func pixelBuffer(from image: UIImage) -> Future<CVPixelBuffer, Error> {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return Future { promise in
                promise(.failure(ImageProcessingServiceError.bufferCreation))
            }
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return Future { promise in
            promise(.success(pixelBuffer!))
        }

    }
    
    func image(from pixelBuffer: CVPixelBuffer) -> Future<UIImage, Error> {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let tempContext = CIContext(options: nil)
        guard let cgImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0,
                                                                            y: 0,
                                                                            width: CVPixelBufferGetWidth(pixelBuffer),
                                                                            height: CVPixelBufferGetHeight(pixelBuffer))) else {
                                                                                return Future { promise in
                                                                                    promise(.failure(ImageProcessingServiceError.cgImageCreation))
                                                                                }
        }
        return Future { promise in
            promise(.success(UIImage(cgImage: cgImage)))
        }
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
