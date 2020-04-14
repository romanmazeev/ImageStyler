//
//  StylesDataSource.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 15.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

class StylesDataSource {
    static var shared: StylesDataSource = {
        StylesDataSource()
    }()

    private init() {}

    // Only good styles
    var styles: [Style] = [
        Style(id: 1, image: UIImage(named: "triangles")!, name: "Triangles"),
        Style(id: 2, image: UIImage(named: "lines")!, name: "Lines"),
        Style(id: 4, image: UIImage(named: "wood")!, name: "Wood"),
        Style(id: 5, image: UIImage(named: "paints")!, name: "Paints"),
        Style(id: 6, image: UIImage(named: "web")!, name: "Web")
    ]

    func selectStyle(_ selectedStyleId: Int) -> [Style] {
        let selectedStyleIndex = styles.firstIndex(where: { $0.id == selectedStyleId })
        var updatedStyles = styles
        updatedStyles[selectedStyleIndex!].isSelected = true
        return updatedStyles
    }
}

extension StylesDataSource: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
