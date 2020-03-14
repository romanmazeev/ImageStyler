//
//  ImagePickerView.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 09.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct ImagePickerView: View {
    @Binding var image: UIImage?
    @Binding var isImageSelected: Bool?
    @Binding var isImageCaptured: Bool?

    var sourceType: UIImagePickerController.SourceType

    var body: some View {
        ImagePickerRepresentable(image: $image, isImageSelected: $isImageSelected, isImageCaptured: $isImageCaptured, sourceType: sourceType)
    }
}

struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(image: .constant(nil), isImageSelected: .constant(nil), isImageCaptured: .constant(nil), sourceType: .photoLibrary)
    }
}
