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

    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let completionWithItemsHandler: CompletionHandler? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = completionWithItemsHandler
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
