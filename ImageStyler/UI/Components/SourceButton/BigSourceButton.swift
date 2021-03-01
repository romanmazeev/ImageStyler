//
//  BigSourceButton.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct BigSourceButton: View {
    let type: SourceButtonType
    let actionHandler: () -> Void

    var body: some View {
        Button(action: {
            self.actionHandler()
        }) {
            HStack {
                Image(systemName: type.systemImageName)
                Text(verbatim: type.title)
            }
        }
        .disabled(!type.isSourceTypeEnabled)
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .foregroundColor(.white)
        .background(type.isSourceTypeEnabled ? Color.blue : Color.gray)
        .cornerRadius(12)
    }
}

struct BigSourceButton_Previews: PreviewProvider {
    static var previews: some View {
        BigSourceButton(type: .library) {}
    }
}
