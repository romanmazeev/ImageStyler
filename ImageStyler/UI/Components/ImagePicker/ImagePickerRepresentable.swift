//
//  ImagePickerRepresentable.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 09.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct ImagePickerRepresentable : UIViewControllerRepresentable {
    @Environment(\.presentationMode) var mode
    @Binding var selectedImage : UIImage?
    let sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
        Coordinator(cancelHandler: {
            self.mode.wrappedValue.dismiss()
        }) { image in
            self.selectedImage = image
            self.mode.wrappedValue.dismiss()
        }
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerRepresentable>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    class Coordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var cancelHandler: (() -> Void)?
        var pickedImageHandler: ((UIImage) -> Void)?

        init(cancelHandler : (() -> Void)?, pickedImageHandler: ((UIImage) -> Void)?) {
            self.cancelHandler = cancelHandler
            self.pickedImageHandler = pickedImageHandler
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            self.pickedImageHandler?(image)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.cancelHandler?()
        }
    }
}
