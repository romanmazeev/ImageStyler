//
//  ImageStylingView.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 28.02.2021.
//  Copyright © 2021 Roman Mazeev. All rights reserved.
//

import SwiftUI
import Combine
import VisualEffects
import ImageViewer

struct ImageStylingView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isImagePickerShowed = false
    @State private var isPhotoCaptureViewShowed = false
    @State private var isShareSheetPresented = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.stylizedImage != nil {
                stylizedImageView
            }
            
            Spacer()
            
            filtersView
        }
        .navigationBarItems(
            leading: navigationBarLeadingItems,
            trailing: Button(action: {
                self.isShareSheetPresented = true
            }, label: {
                Image(systemName: "square.and.arrow.up")
            })
            .disabled(self.viewModel.isLoading || self.viewModel.stylizedImageURL == nil)
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheet(shareImageURL: self.viewModel.stylizedImageURL!)
                    .ignoresSafeArea()
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $viewModel.isError) {
            Alert(
                title: Text(verbatim: "Error"),
                message: Text(verbatim: "viewModel.errorMessage!"),
                dismissButton: .default(Text(verbatim: "OK")) {
                    self.viewModel.selectedImage = nil
                }
            )
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    private var navigationBarLeadingItems: some View {
        HStack {
            SmallSourceButton(type: .library) {
                isImagePickerShowed = true
            }
            .padding(.trailing)
            .fullScreenCover(isPresented: $isImagePickerShowed) {
                ImagePicker(selectedImage: self.$viewModel.selectedImage, sourceType: .photoLibrary)
                    .ignoresSafeArea()
            }

            SmallSourceButton(type: .camera) {
                isPhotoCaptureViewShowed = true
            }
            .fullScreenCover(isPresented: $isPhotoCaptureViewShowed) {
                ImagePicker(selectedImage: self.$viewModel.selectedImage, sourceType: .camera)
                    .ignoresSafeArea()
            }
        }
    }

    private var stylizedImageView: some View {
        Image(uiImage: viewModel.stylizedImage!)
            .resizable()
            .scaledToFit()
            .pinchToZoom()
    }

    private var filtersView: some View {
        VStack(spacing: 0) {
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.styles, id: \.id) { style in
                        StyleView(style: style, disabled: self.$viewModel.isLoading) {
                            self.viewModel.selectedStyleId = style.id
                        }
                    }
                }
                .padding([.horizontal, .top])
                .padding(.bottom, 40)
            }
            .background(VisualEffectBlur(blurStyle: .prominent, vibrancyStyle: .fill) {})
        }
    }
}

struct ImageStylingView_Previews: PreviewProvider {
    static var previews: some View {
        ImageStylingView(viewModel: ViewModel())
    }
}
