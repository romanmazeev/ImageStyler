//
//  ImageSourceButton.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct ImageSourceButton: View {
    @State var style: Style
    @State var actionHandler: () -> Void

    enum Style {
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
        }
    .padding()
    .foregroundColor(.white)
    .background(Color.blue)
    .cornerRadius(12)
    }
}

struct ImageSourceButton_Previews: PreviewProvider {
    static var previews: some View {
        ImageSourceButton(style: .library) {}
    }
}
