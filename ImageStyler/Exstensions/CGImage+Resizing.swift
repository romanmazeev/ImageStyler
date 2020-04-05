//
//  CGImage+Resizing.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 05.04.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import CoreGraphics

extension CGImage {
    func resize(toMaxWidth maxWith: Int) -> CGImage? {
        var ratio: Float = 0.0
        let imageWidth = Float(self.width)
        let imageHeight = Float(self.height)

        if (imageWidth > imageHeight) {
            ratio = Float(maxWith) / imageWidth
        } else {
            ratio = Float(maxWith) / imageHeight
        }

        if ratio > 1 {
            ratio = 1
        }

        let width = imageWidth * ratio
        let height = imageHeight * ratio

        guard let colorSpace = self.colorSpace, let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: self.bitsPerComponent,
            bytesPerRow: self.bytesPerRow,
            space: colorSpace,
            bitmapInfo: self.alphaInfo.rawValue
        ) else {
            return nil
        }

        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: Int(width), height: Int(height)))

        return context.makeImage()
    }
}
