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

    var body: some View {
        NavigationView {
            if viewModel.selectedImage == nil {
                WelcomeView(viewModel: viewModel)
            } else {
                ImageStylingView(viewModel: viewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StyledImageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
