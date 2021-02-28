//
//  SmallSourceButton.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 04.04.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct SmallSourceButton: View {
    let type: SourceButtonType
    let actionHandler: () -> Void

    var body: some View {
        Button(action: {
            self.actionHandler()
        }) {
            Image(systemName: type == .library ? "photo.on.rectangle" : "camera")
        }
        .disabled(!UIImagePickerController.isSourceTypeAvailable(type == .library ? .photoLibrary : .camera))
    }
}

struct SmallSourceButton_Previews: PreviewProvider {
    static var previews: some View {
        SmallSourceButton(type: .library) {}
    }
}
