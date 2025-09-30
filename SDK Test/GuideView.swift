//
//  GuideView.swift
//  SDK Test
//
//  Created by Tyler Hendrickson on 9/30/25.
//

import SwiftUI

struct GuideView: View {
    private let url = URL(string:
      "https://nice-incontact-mobile-sdk.s3.us-west-2.amazonaws.com/index.html"
    )!

    var body: some View {
        WebView(url: url)
            .ignoresSafeArea(.all, edges: .bottom) // full page beneath nav bar
            .navigationTitle("Guide")
            .navigationBarTitleDisplayMode(.inline)
    }
}
