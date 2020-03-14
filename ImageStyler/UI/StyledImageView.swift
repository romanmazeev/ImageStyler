//
//  StyledImageView.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 12.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct StyledImageView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(uiImage: viewModel.stylizedImage ?? UIImage())
                    .resizable()
                    .scaledToFit()
                ActivityIndicator(isAnimating: $viewModel.isLoading, style: .medium)
            }
        }
        .navigationBarTitle("Stylized image")
    }
}

struct StyledImageView_Previews: PreviewProvider {
    static var previews: some View {
        StyledImageView(viewModel: ViewModel())
    }
}
