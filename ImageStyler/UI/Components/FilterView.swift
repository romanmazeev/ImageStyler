//
//  Filter.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    @State var filter: Filter
    @Binding var selectedFilter: Filter

    var body: some View {
        VStack {
            Image(uiImage: filter.image)
                .resizable()
                .cornerRadius(12)
                .frame(width: 60, height: 60, alignment: .center)
            Text(verbatim: filter.name)
                .font(.footnote)
                .bold()
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(Color.blue)
                .opacity(filter.id == selectedFilter.id ? 100 : 0)
        )
        .onTapGesture {
            if self.selectedFilter != self.filter {
                self.selectedFilter = self.filter
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(filter: Filter(id: 0, image: UIImage(), name: "Test"), selectedFilter: .constant(Filter(id: 0, image: UIImage(), name: "Test")))
    }
}
