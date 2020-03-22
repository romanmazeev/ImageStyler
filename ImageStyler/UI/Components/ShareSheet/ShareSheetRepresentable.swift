//
//  ShareSheetRepresentable.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct ShareSheetRepresentable: UIViewControllerRepresentable {
    typealias CompletionHandler = (
        _ activityType: UIActivity.ActivityType?,
        _ completed: Bool, _ returnedItems: [Any]?,
        _ error: Error?
    ) -> Void

    let activityItems: [URL?]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems as [Any], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
