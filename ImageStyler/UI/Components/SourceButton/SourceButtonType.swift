//
//  SourceButtonType.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 04.04.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import UIKit

enum SourceButtonType {
    case library
    case camera

    var systemImageName: String {
        switch self {
            case .camera:
                return "camera"
            case .library:
                return "photo.on.rectangle"
        }
    }

    var title: String {
        switch self {
            case .camera:
                return "Take photo using camera"
            case .library:
                return "Select photo from library"
        }
    }

    var isSourceTypeEnabled: Bool {
        UIImagePickerController.isSourceTypeAvailable(self == .library ? .photoLibrary : .camera)
    }
}
