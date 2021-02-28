//
//  ShareSheet.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    let shareImageURL: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [shareImageURL], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ShareSheet_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheet(shareImageURL: URL(fileURLWithPath: ""))
    }
}
