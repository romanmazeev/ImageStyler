//
//  ImageSourceButton.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct ImageSourceButton: View {
    var style: Style
    var actionHandler: () -> Void
    private var isEnabled: Bool {
        UIImagePickerController.isSourceTypeAvailable(style == .library ? .photoLibrary : .camera)
    }

    enum Style: CaseIterable {
        case library
        case camera
    }

    var body: some View {
        HStack {
            Image(systemName: style == .library ? "photo.on.rectangle" : "camera")
            Button(action: {
                self.actionHandler()
            }) {
                Text(verbatim: style == .library ? "Import from library" : "Take a photo")
            }
            .disabled(!isEnabled)
        }
        .padding()
        .foregroundColor(.white)
        .background(isEnabled ? Color.blue : Color.gray)
        .cornerRadius(12)
    }
}

struct ImageSourceButton_Previews: PreviewProvider {
    static var previews: some View {
        ImageSourceButton(style: .library) {}
    }
}
