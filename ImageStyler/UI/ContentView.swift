//
//  ContentView.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 12.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State private var isShareSheetPresented = false
    @State private var isImagePickerShowed = false
    @State private var isPhotoCaptureViewShowed = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.selectedImage == nil {
                    initialButtons
                } else {
                    imageStyling
                }
            }
            .navigationBarTitle("Image Styler")
            .navigationBarItems(
                leading:
                    HStack {
                        SmallSourceButton(type: .library) {
                            isImagePickerShowed = true
                        }
                        .fullScreenCover(isPresented: $isImagePickerShowed) {
                            ImagePicker(selectedImage: self.$viewModel.selectedImage, sourceType: .photoLibrary)
                                .ignoresSafeArea()
                        }
                        .padding(.trailing)

                        SmallSourceButton(type: .camera) {
                            isPhotoCaptureViewShowed = true
                        }
                        .fullScreenCover(isPresented: $isPhotoCaptureViewShowed) {
                            ImagePicker(selectedImage: self.$viewModel.selectedImage, sourceType: .camera)
                                .ignoresSafeArea()
                        }
                    }
                    .opacity(self.viewModel.selectedImage == nil ? 0 : 1)
                , trailing:
                    Button(action: {
                        self.isShareSheetPresented = true
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                    .disabled(self.viewModel.isLoading)
                    .opacity(self.viewModel.selectedImage == nil ? 0 : 1)
                    .sheet(isPresented: $isShareSheetPresented) {
                        ShareSheet(shareImageURL: self.viewModel.stylizedImageURL!)
                            .ignoresSafeArea()
                    }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $viewModel.isError) {
            Alert(
                title: Text(verbatim: "Error"),
                message: Text(verbatim: "viewModel.errorMessage!"),
                dismissButton: .default(Text(verbatim: "OK")) {
                    self.viewModel.selectedImage = nil
                }
            )
        }
    }

    var initialButtons: some View {
        VStack {
            Spacer()

            BigSourceButton(type: .library) {
                isImagePickerShowed = true
            }
            .padding()

            BigSourceButton(type: .camera) {
                isPhotoCaptureViewShowed = true
            }

            Spacer()
        }
    }

    var imageStyling: some View {
        if verticalSizeClass == .compact {
            return AnyView(
                HStack {
                    Spacer()

                    styledImage

                    Spacer()

                    filtersScroll
                }
            )
        } else {
            return AnyView(
                VStack {
                    Spacer()

                    styledImage
                    
                    Spacer()

                    filtersScroll
                }
            )
        }
    }

    var styledImage: some View {
        if viewModel.isLoading {
            return AnyView(ProgressView())
        } else if viewModel.stylizedImage != nil {
            if verticalSizeClass == .compact {
                return AnyView(
                    Image(uiImage: viewModel.stylizedImage!)
                        .resizable()
                        .scaledToFit()
                        .padding()
                )
            } else {
                return AnyView(
                    Image(uiImage: viewModel.stylizedImage!)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                )
            }
        } else {
            return AnyView(EmptyView())
        }
    }

    var filtersScroll: some View {
        ScrollView(verticalSizeClass == .compact ? .vertical : .horizontal, showsIndicators: false) {
            if verticalSizeClass == .compact {
                VStack {
                    filters
                }
                .padding()
            } else {
                HStack {
                    filters
                }
                .padding()
            }
        }
    }

    var filters: some View {
        ForEach(viewModel.styles, id: \.id) { style in
            StyleView(style: style, disabled: self.$viewModel.isLoading) {
                self.viewModel.selectedStyleId = style.id
            }
        }
    }
}

struct StyledImageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
