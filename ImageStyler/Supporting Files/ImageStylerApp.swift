//
//  ImageStylerApp.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 06.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

@main
struct ImageStylerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
