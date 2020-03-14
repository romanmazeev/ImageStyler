//
//  ShareSheet.swift
//  ImageStyler
//
//  Created by Roman Mazeev on 14.03.2020.
//  Copyright © 2020 Roman Mazeev. All rights reserved.
//

import SwiftUI

struct ShareSheet: View {
    @State var activityItems: [Any]

    var body: some View {
        ShareSheetRepresentable(activityItems: activityItems)
    }
}

struct ShareSheet_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheet(activityItems: [])
    }
}
