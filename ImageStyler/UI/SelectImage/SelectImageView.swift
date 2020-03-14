//
//  SelectImageView.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 06.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct SelectImageView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State private var isImagePickerShowed = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera

    @State private var isImageSelected: Bool? = false
    @State private var isImageCaptured: Bool? = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                NavigationLink(destination: StyledImageView(), tag: true, selection: $isImageSelected) {
                    ImageSourceButton(style: .library) {
                        self.isImagePickerShowed = true
                        self.sourceType = .photoLibrary
                    }
                }

                Spacer()

                NavigationLink(destination: StyledImageView(), tag: true, selection: $isImageCaptured) {
                    ImageSourceButton(style: .camera) {
                        self.isImagePickerShowed = true
                        self.sourceType = .camera
                    }
                }

                Spacer()
            }
            .navigationBarTitle("Select image")
            .sheet(isPresented: $isImagePickerShowed) {
                ImagePicker(
                    image: self.$viewModel.selectedImage,
                    isImageSelected: Binding(self.$isImageSelected)!,
                    isImageCaptured: Binding(self.$isImageCaptured)!,
                    sourceType: self.sourceType
                )
            }
        }
    }
}

struct SelectImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageView()
    }
}
