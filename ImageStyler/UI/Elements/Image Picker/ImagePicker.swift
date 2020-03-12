//
//  ImagePicker.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 09.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    @Environment(\.presentationMode) var mode
    @Binding var image : UIImage?

    func makeCoordinator() -> ImagePickerCordinator {
        ImagePickerCordinator(cancelHandler: {
            self.mode.wrappedValue.dismiss()
        }) { image in
            self.image = image
            self.mode.wrappedValue.dismiss()
        }
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
}
