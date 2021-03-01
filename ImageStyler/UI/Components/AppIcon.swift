//
//  AppIcon.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 28.02.2021.
//  Copyright © 2021 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct AppIcon: View {
    var body: some View {
        Bundle.main.iconFileName
            .flatMap { UIImage(named: $0) }
            .map { Image(uiImage: $0) }
    }
}
