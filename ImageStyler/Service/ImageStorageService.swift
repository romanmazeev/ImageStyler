//
//  ImageStorageService.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 15.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

class ImageStorageService {
    let imageCache = NSCache<NSString, UIImage>()

    func saveImage(_ image: UIImage, key: String) ->  URL? {
        guard let jpegRepresentation = image.jpegData(compressionQuality: 0) else { return nil }
        if let filePath = filePath(forKey: key) {
            try! jpegRepresentation.write(to: filePath, options: .atomic)
            return filePath
        } else {
            return nil
        }
    }

    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .cachesDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }

        return documentURL.appendingPathComponent(key + ".jpeg")
    }

}
