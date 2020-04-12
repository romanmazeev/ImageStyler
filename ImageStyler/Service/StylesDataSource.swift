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

    var styles: [Style] = [
        Style(id: 0, image: UIImage(named: "vanGogh")!, name: "Van Gogh"),
        Style(id: 1, image: UIImage(named: "tsunami")!, name: "Tsunami"),
        Style(id: 2, image: UIImage(named: "lsd")!, name: "Trippy"),
        Style(id: 3, image: UIImage(named: "barocco")!, name: "Barocco"),
        Style(id: 4, image: UIImage(named: "virus")!, name: "Virus")
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
