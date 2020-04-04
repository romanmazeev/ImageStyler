//
//  SmallSourceButton.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 04.04.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct SmallSourceButton: View {
    let style: SourceButtonStyle
    let isEnabled: Bool
    let actionHandler: () -> Void

    enum Style: CaseIterable {
        case library
        case camera
    }

    var body: some View {
        Button(action: {
            self.actionHandler()
        }) {
            Image(systemName: style == .library ? "photo.on.rectangle" : "camera")
        }
        .disabled(!isEnabled)
    }
}

struct SmallSourceButton_Previews: PreviewProvider {
    static var previews: some View {
        BigSourceButton(style: .library, isEnabled: false) {}
    }
}
