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
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .camera

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
                        ForEach(SourceButtonStyle.allCases, id: \.self) { style in
                            SmallSourceButton(
                                style: style,
                                isEnabled: UIImagePickerController.isSourceTypeAvailable(
                                    style == .library ? .photoLibrary : .camera
                                )
                            ) {
                                self.sourceButtonTapped(style: style)
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
        .navigationViewStyle(StackNavigationViewStyle())
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
                    self.sourceButtonTapped(style: style)
                }
                .padding()
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
            return AnyView(ActivityIndicator(style: .medium))
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
            StyleView(style: style) {
                self.viewModel.selectedStyleId = style.id
            }
        }
    }

    private func sourceButtonTapped(style: SourceButtonStyle) {
        self.isImagePickerShowed = true
        self.imagePickerSourceType = style == .library ? .photoLibrary : .camera
    }
}

struct StyledImageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
