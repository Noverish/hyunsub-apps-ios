//
//  ContentView.swift
//  apps
//
//  Created by USER on 2023/01/23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        WebView(url: URL(string: "https://apps.hyunsub.kim")!)
            .ignoresSafeArea()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    let webview = WKWebView()

    func makeUIView(context: Context) -> WKWebView {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
        webview.allowsBackForwardNavigationGestures = true
        webview.scrollView.addSubview(RefreshControl(webview: webview))
        webview.evaluateJavaScript("navigator.userAgent") { [weak webview] (result, error) in
            if let webView = webview, let userAgent = result as? String {
                webView.customUserAgent = userAgent + " Hyunsub/1.0.0"
            }
        }

        return webview
    }

    func updateUIView(_ webview: WKWebView, context: Context) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
    }
}

class RefreshControl: UIRefreshControl {
    let webview: WKWebView

    init(webview: WKWebView) {
        self.webview = webview
        super.init()
        self.addTarget(webview, action: #selector(reloadWebView(_:)), for: .valueChanged)
    }

    @objc func reloadWebView(_ sender: UIRefreshControl) {
        webview.reload()
        sender.endRefreshing()
    }

    required init?(coder: NSCoder) {
        self.webview = WKWebView()
        super.init(coder: coder)
    }
}
