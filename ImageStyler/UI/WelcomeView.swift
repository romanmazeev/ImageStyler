//
//  WelcomeView.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 28.02.2021.
//  Copyright © 2021 Roman Mazeev. All rights reserved.
//

import SwiftUI
import Combine
import VisualEffects

struct WelcomeView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isImagePickerShowed = false
    @State private var isPhotoCaptureViewShowed = false

    private let columns: [GridItem] = [.init(.adaptive(minimum: 300, maximum: 800), spacing: nil, alignment: .top)]

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 8) {
                    Section(header: Color.clear.frame(height: 8)) { EmptyView() }
                    ForEach(1...8, id: \.self) { index in
                        Image("example\(index)")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    }
                    Section(footer: Color.clear.frame(height: 168)) { EmptyView() }
                }
            }
            .padding(.horizontal)

            VStack(spacing: 0) {
                Divider()
                imageSelectionButtonsView
            }
            .background(VisualEffectBlur(blurStyle: .prominent, vibrancyStyle: .fill) {})
        }
        .navigationBarItems(trailing: EmptyView())
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationTitle("Examples")
    }

    private var imageSelectionButtonsView: some View {
        VStack {
            BigSourceButton(type: .library) {
                isImagePickerShowed = true
            }
            .fullScreenCover(isPresented: $isImagePickerShowed) {
                ImagePicker(selectedImage: self.$viewModel.selectedImage, sourceType: .photoLibrary)
                    .ignoresSafeArea()
            }

            BigSourceButton(type: .camera) {
                isPhotoCaptureViewShowed = true
            }
            .fullScreenCover(isPresented: $isPhotoCaptureViewShowed) {
                ImagePicker(selectedImage: self.$viewModel.selectedImage, sourceType: .camera)
                    .ignoresSafeArea()
            }
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 40)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(viewModel: ViewModel())
    }
}
