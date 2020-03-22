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
    @Binding var selectedStyle: Style

    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: style.imageData)!)
                .resizable()
                .cornerRadius(12)
                .frame(width: 60, height: 60, alignment: .center)
            Text(verbatim: style.name)
                .font(.footnote)
                .bold()
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(Color.blue)
                .opacity(style.id == selectedStyle.id ? 100 : 0)
        )
        .onTapGesture {
            if self.selectedStyle != self.style {
                self.selectedStyle = self.style
            }
        }
    }
}

struct StyleView_Previews: PreviewProvider {
    static var previews: some View {
        StyleView(style: Style(id: 0, imageData: Data(), name: "Test"), selectedStyle: .constant(Style(id: 0, imageData: Data(), name: "Test")))
    }
}
