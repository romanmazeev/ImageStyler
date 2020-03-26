//
//  SelectedImageViewModel.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 26.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import Combine
import SwiftUI

class SelectImageViewModel: ObservableObject {
    @Published var selectedImage: UIImage?

    var styledImageView: some View {
        return SelectImageViewBuilder.makeStyledImageView(withSelectedImage: selectedImage)
    }
}
