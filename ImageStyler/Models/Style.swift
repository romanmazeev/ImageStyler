//
//  Style.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import Foundation
import SwiftUI

struct Style: Equatable {
    let id: Int
    let image: Image
    let name: String
    var isSelected = false
}
