//
//  Combine+Assign.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 05.04.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import Combine

// Combine memory leak fix
extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
       sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}
