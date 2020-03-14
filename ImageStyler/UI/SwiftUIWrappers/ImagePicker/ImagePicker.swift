//
//  ImagePicker.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 09.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct ImagePicker: View {
    @Binding var image: UIImage?
    @Binding var isImageSelected: Bool?
    @Binding var isImageCaptured: Bool?
    let sourceType: UIImagePickerController.SourceType

    var body: some View {
        ImagePickerRepresentable(image: $image, isImageSelected: $isImageSelected, isImageCaptured: $isImageCaptured, sourceType: sourceType)
    }
}

struct PhotoCapture_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(
            image: .constant(nil),
            isImageSelected: .constant(false),
            isImageCaptured: .constant(false),
            sourceType: .photoLibrary)
    }
}
