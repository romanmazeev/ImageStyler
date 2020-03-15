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
    
    @State var selectedImage: UIImage?
    @State private var isShareSheetPresented = false
    
    var body: some View {
        VStack {
            ZStack {
                Image(uiImage: viewModel.stylizedImage ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .padding([.horizontal, .top])
                ActivityIndicator(isAnimating: $viewModel.isLoading, style: .medium)
            }

            Spacer()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.styles, id: \.id) { filter in
                        FilterView(filter: filter, selectedFilter: self.$viewModel.selectedFilter)
                    }
                }
                .padding()
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
        StyledImageView()
    }
}
