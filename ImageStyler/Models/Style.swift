//
//  Style.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct Style: Equatable {
    let id: Int
    let image: UIImage
    let name: String
    var isSelected = false
}
