//
//  Bundle+AppIcon.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 28.02.2021.
//  Copyright © 2021 Roman Mazeev. All rights reserved.
//

import Foundation

extension Bundle {
    var iconFileName: String? {
        guard let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.first
        else { return nil }
        return iconFileName
    }
}
