//
//  SelectImageViewBuilder.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 26.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

enum SelectImageViewBuilder {
    static func makeStyledImageView(withSelectedImage selectedImage: UIImage?) -> some View {
        let viewModel = StyledImageViewModel(selectedImage: selectedImage)
        return StyledImageView(viewModel: viewModel)
    }
}
