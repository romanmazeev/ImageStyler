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
        Style(id: 0, imageData: UIImage(named: "vanGogh")!.jpegData(compressionQuality: 0)!, name: "Van Gogh"),
        Style(id: 1, imageData: UIImage(named: "tsunami")!.jpegData(compressionQuality: 0)!, name: "Tsunami"),
        Style(id: 2, imageData: UIImage(named: "lsd")!.jpegData(compressionQuality: 0)!, name: "Trippy"),
        Style(id: 3, imageData: UIImage(named: "barocco")!.jpegData(compressionQuality: 0)!, name: "Barocco"),
        Style(id: 4, imageData: UIImage(named: "virus")!.jpegData(compressionQuality: 0)!, name: "Virus")
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
