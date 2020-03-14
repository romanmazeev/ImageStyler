//
//  Filter.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    let filterImage: UIImage
    let filterName: String

    var body: some View {
        VStack {
            Image(uiImage: filterImage)
                .resizable()
                .cornerRadius(12)
                .frame(width: 60, height: 60, alignment: .center)
            Text(verbatim: filterName)
                .font(.footnote)
                .bold()
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(filterImage: UIImage(), filterName: "Example filter")
    }
}
