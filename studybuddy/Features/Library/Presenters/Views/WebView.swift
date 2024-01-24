//
//  WebView.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 28/06/23.
//

import SwiftUI
import WebKit
struct WebView: UIViewRepresentable {
    let fileURL: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: fileURL)
        uiView.load(request)
    }
}
