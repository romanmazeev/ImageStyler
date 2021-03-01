//
//  ExamplesDataSource.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 01.03.2021.
//  Copyright © 2021 Roman Mazeev. All rights reserved.
//

import SwiftUI

class ExamplesDataSource {
    static var shared: ExamplesDataSource = {
        ExamplesDataSource()
    }()

    private init() {}

    let examples: [Image] = (1...8).map { Image("example\($0)") }
}

extension ExamplesDataSource: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

