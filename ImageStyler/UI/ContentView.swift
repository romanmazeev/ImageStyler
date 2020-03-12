//
//  ContentView.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 06.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ViewModel()
    @State private var isImagePickerShowed = false
    
    var body: some View {
        VStack {
            ZStack {
                viewModel.stylizedImage.map(Image.init(uiImage:))?
                .resizable()
                .scaledToFit()
                ActivityIndicator(isAnimating: $viewModel.isLoading, style: .medium)
            }

            Spacer()

            Button("Choose photo to Van Gogh") {
                self.isImagePickerShowed = true
            }.padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(10)

            Spacer()
        }.sheet(isPresented: self.$isImagePickerShowed){
            PhotoCaptureView(image: self.$viewModel.selectedImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
