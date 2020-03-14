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
    @Binding var image : UIImage?
    @Binding var isImageSelected: Bool?
    @Binding var isImageCaptured: Bool?
    var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
        Coordinator(cancelHandler: {
            self.mode.wrappedValue.dismiss()
            switch self.sourceType  {
                case .camera: self.isImageCaptured = false
                case .photoLibrary: self.isImageSelected = false
                case .savedPhotosAlbum: break
                @unknown default: break
            }

        }) { image in
            self.image = image
            switch self.sourceType  {
                case .camera: self.isImageCaptured = true
                case .photoLibrary: self.isImageSelected = true
                case .savedPhotosAlbum: break
                @unknown default: break
            }

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
}
