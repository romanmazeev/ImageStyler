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
    @State private var filters: [Filter] = [Filter(image: UIImage(named: "artDeco")!, name: "Art deco")]
    
    var body: some View {
            VStack {
                ZStack {
                    Image(uiImage: viewModel.stylizedImage ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .padding()
                    ActivityIndicator(isAnimating: $viewModel.isLoading, style: .medium)
                }

                Spacer()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<filters.count) { filterIndex in
                            FilterView(filterImage: self.filters[filterIndex].image, filterName: self.filters[filterIndex].name)
                        }
                    }
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

    struct Filter {
        let image: UIImage
        let name: String
    }
}

struct StyledImageView_Previews: PreviewProvider {
    static var previews: some View {
        StyledImageView(viewModel: ViewModel())
    }
}
