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
    @State private var isShareSheetPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(uiImage: viewModel.stylizedImage ?? UIImage())
                .padding()
                .scaledToFit()
                ActivityIndicator(isAnimating: $viewModel.isLoading, style: .medium)
            }
        }
        .navigationBarTitle("Stylized image")
        .navigationBarItems(trailing: Button(action: {
            if self.viewModel.stylizedImage != nil {
                self.isShareSheetPresented = true
            }
        }, label: {
            Image(systemName: "square.and.arrow.up")
        }))
        .sheet(isPresented: $isShareSheetPresented) {
            ShareSheet(activityItems: [self.viewModel.$stylizedImage])
        }
    }
}

struct StyledImageView_Previews: PreviewProvider {
    static var previews: some View {
        StyledImageView(viewModel: ViewModel())
    }
}
