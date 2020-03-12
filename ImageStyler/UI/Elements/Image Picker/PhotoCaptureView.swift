//
//  PhotoCaptureView.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 09.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct PhotoCaptureView: View {
    @Binding var image: UIImage?

    var body: some View {
        ImagePicker(image: $image)
    }
}

struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView(image: .constant(nil))
    }
}
