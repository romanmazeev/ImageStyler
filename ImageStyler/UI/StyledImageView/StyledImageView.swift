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
    @ObservedObject var viewModel: StyledImageViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
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
        .alert(isPresented: $viewModel.isError) {
            Alert(
                title: Text(verbatim: "Error"),
                message: Text(verbatim: viewModel.errorMessage!),
                dismissButton: .default(Text(verbatim: "OK")) {
                    self.mode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear(perform: viewModel.transferImage)
    }
}

struct StyledImageView_Previews: PreviewProvider {
    static var previews: some View {
        StyledImageView(viewModel: StyledImageViewModel(selectedImage: UIImage()))
    }
}
