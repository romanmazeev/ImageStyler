//
//  StyledImageView.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 12.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI
import Combine

struct StyledImageView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var isShareSheetPresented = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if viewModel.stylizedImage != nil {
                Image(uiImage: viewModel.stylizedImage!)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
            } else {
                ActivityIndicator(isAnimating: $viewModel.isLoading, style: .medium)
            }

            Spacer()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.styles, id: \.id) { style in
                        StyleView(style: style, selectedStyle: self.$viewModel.selectedStyle)
                    }
                }
                .padding()
            }
        }

        .navigationBarTitle("Stylized image")
        .navigationBarItems(trailing:
            Button(action: {
                self.isShareSheetPresented = true
            }, label: {
                Image(systemName: "square.and.arrow.up")
            })
            .disabled(self.viewModel.stylizedImage == nil)
        )
        .sheet(isPresented: $isShareSheetPresented) {
            ShareSheet(shareImageURL: self.viewModel.stylizedImageURL!)
        }
    }
}

struct StyledImageView_Previews: PreviewProvider {
    static var previews: some View {
        StyledImageView()
    }
}
