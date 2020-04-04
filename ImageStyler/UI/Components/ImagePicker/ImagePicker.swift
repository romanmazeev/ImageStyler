//
//  ImagePicker.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 09.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct ImagePicker: View {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType

    var body: some View {
        ImagePickerRepresentable(selectedImage: $selectedImage, sourceType: sourceType)
    }
}

struct PhotoCapture_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(selectedImage: .constant(nil), sourceType: .photoLibrary)
    }
}
