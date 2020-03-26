//
//  TransferError.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 26.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

enum TransferError: Error {
  case imageResizing(description: String)
  case imageTransfering(description: String)
}
