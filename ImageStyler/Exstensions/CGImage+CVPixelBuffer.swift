//
//  CGImage+CVPixelBuffer.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 11.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import CoreGraphics
import CoreImage
import VideoToolbox

extension CGImage {
    var pixelBuffer: CVPixelBuffer? {
        pixelBuffer(
            width: self.width,
            height: self.height,
            pixelFormatType: kCVPixelFormatType_32ARGB,
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            alphaInfo: .noneSkipFirst,
            orientation: .up
        )
    }

    func pixelBuffer(
        width: Int,
        height: Int,
        pixelFormatType: OSType,
        colorSpace: CGColorSpace,
        alphaInfo: CGImageAlphaInfo,
        orientation: CGImagePropertyOrientation
    ) -> CVPixelBuffer? {

        var maybePixelBuffer: CVPixelBuffer?
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ]

        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            pixelFormatType,
            attrs as CFDictionary,
            &maybePixelBuffer
        )

        guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else { return nil }

        let flags = CVPixelBufferLockFlags(rawValue: 0)
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(pixelBuffer, flags) else { return nil }

        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, flags) }

        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(pixelBuffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
            space: colorSpace,
            bitmapInfo: alphaInfo.rawValue
        ) else {
            return nil
        }

        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        return pixelBuffer
    }
}

extension CGImage {
    public static func create(pixelBuffer: CVPixelBuffer) -> CGImage? {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        return cgImage
    }
}
