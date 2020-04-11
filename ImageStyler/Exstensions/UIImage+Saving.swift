//
//  UIImage+Saving.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 05.04.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import UIKit

extension UIImage {
    func save(key: String) -> URL? {
        guard let jpegRepresentation = self.jpegData(compressionQuality: 0) else { return nil }

        guard let filePath = FileManager.default.urls(
            for: .cachesDirectory,
            in: FileManager.SearchPathDomainMask.userDomainMask
        ).first?.appendingPathComponent(key + ".jpeg") else {
            return nil
        }

        try? jpegRepresentation.write(to: filePath, options: .atomic)
        return filePath
    }
}
