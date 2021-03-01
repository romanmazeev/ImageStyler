//
//  Style.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct StyleView: View {
    var style: Style
    @Binding var disabled: Bool
    var action: () -> Void

    var body: some View {
        VStack {
            style.image
                .resizable()
                .cornerRadius(12)
                .frame(width: 60, height: 60, alignment: .center)
            Text(verbatim: style.name)
                .font(.footnote)
                .bold()
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(disabled ? Color.gray : Color.blue)
                .opacity(style.isSelected ? 100 : 0)
        )
        .onTapGesture {
            self.action()
        }
    }
}

struct StyleView_Previews: PreviewProvider {
    static var previews: some View {
        StyleView(style: Style(id: 0, image: Image(""), name: "Test", isSelected: false), disabled: .constant(false), action: {})
    }
}
