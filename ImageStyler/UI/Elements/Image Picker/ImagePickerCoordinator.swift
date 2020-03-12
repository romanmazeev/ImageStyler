//
//  ImagePickerCoordinator.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 09.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import UIKit

class ImagePickerCordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var cancelHandler: (() -> Void)?
    var pickedImageHandler: ((UIImage) -> Void)?

    init(cancelHandler : (() -> Void)?, pickedImageHandler: ((UIImage) -> Void)?) {
        self.cancelHandler = cancelHandler
        self.pickedImageHandler = pickedImageHandler
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { fatalError() }
        DispatchQueue.main.async {
            self.pickedImageHandler?(image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async {
            self.cancelHandler?()
        }
    }
}
