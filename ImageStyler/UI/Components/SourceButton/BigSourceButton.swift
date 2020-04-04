//
//  BigSourceButton.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct BigSourceButton: View {
    let style: SourceButtonStyle
    let isEnabled: Bool
    let actionHandler: () -> Void

    var body: some View {
        Button(action: {
            self.actionHandler()
        }) {
            HStack {
                Image(systemName: style == .library ? "photo.on.rectangle" : "camera")
                Text(verbatim: style == .library ? "Import from library" : "Take a photo")
            }
        }
        .disabled(!isEnabled)
        .padding()
        .foregroundColor(.white)
        .background(isEnabled ? Color.blue : Color.gray)
        .cornerRadius(12)
    }
}

struct BigSourceButton_Previews: PreviewProvider {
    static var previews: some View {
        BigSourceButton(style: .library, isEnabled: false) {}
    }
}
