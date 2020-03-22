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
    @State private var isImageSelected: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                NavigationLink(destination: StyledImageView(), isActive: self.$isImageSelected) {
                    // SwiftUI workaround
                   Spacer().fixedSize()
                }

                ForEach(ImageSourceButton.Style.allCases, id: \.self) { style in
                    ImageSourceButton(style: style) {
                        self.isImagePickerShowed = true
                        self.sourceType =  style == .library ? .photoLibrary : .camera
                    }
                    .padding()
                }

                Spacer()
            }
            .navigationBarTitle("Select image")
            .sheet(isPresented: $isImagePickerShowed) {
                ImagePicker(
                    image: self.$viewModel.selectedImage,
                    isImageSelected: self.$isImageSelected,
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
