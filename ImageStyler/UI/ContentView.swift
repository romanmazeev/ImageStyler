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
    @State private var isShareSheetPresented = false
    @State private var isImagePickerShowed = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.selectedImage == nil {
                    initialButtons
                } else {
                    styledImageView
                }
            }
            .navigationBarTitle("Image Styler")
            .navigationBarItems(
                leading:
                    HStack {
                        ForEach(SourceButtonStyle.allCases, id: \.self) { style in
                            SmallSourceButton(
                                style: style,
                                isEnabled: UIImagePickerController.isSourceTypeAvailable(
                                    style == .library ? .photoLibrary : .camera
                                )
                            ) {
                                self.isImagePickerShowed = true
                                self.imagePickerSourceType = style == .library ? .photoLibrary : .camera
                            }
                            .padding(.trailing)
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
                    }
            )
            .sheet(isPresented: $isImagePickerShowed) {
                ImagePicker(selectedImage: self.$viewModel.selectedImage, sourceType: self.imagePickerSourceType)
            }
        }
    }

    var initialButtons: some View {
        VStack {
            Spacer()

            ForEach(SourceButtonStyle.allCases, id: \.self) { style in
                BigSourceButton(
                    style: style,
                    isEnabled: UIImagePickerController.isSourceTypeAvailable(
                        style == .library ? .photoLibrary : .camera
                    )
                ) {
                    self.isImagePickerShowed = true
                    self.imagePickerSourceType = style == .library ? .photoLibrary : .camera
                }
                .padding()
            }

            Spacer()
        }
    }

    var styledImageView: some View {
        VStack {
            Spacer()

            if viewModel.isLoading {
                ActivityIndicator(style: .medium)
            } else if viewModel.stylizedImage != nil {
                Image(uiImage: viewModel.stylizedImage!)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
            } else {

            }

            Spacer()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.styles, id: \.id) { style in
                        StyleView(style: style) {
                            self.viewModel.selectedStyleId.send(style.id)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear(perform: { self.viewModel.selectedStyleId.send(1) })
        .alert(isPresented: $viewModel.isError) {
            Alert(
                title: Text(verbatim: "Error"),
                message: Text(verbatim: "Error on image styling"),
                dismissButton: .default(Text(verbatim: "OK")) {
                }
            )
        }
    }
}

struct StyledImageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
