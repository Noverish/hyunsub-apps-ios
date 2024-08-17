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
        UIWebView(url: URL(string: "https://apps.hyunsub.kim")!)
            .ignoresSafeArea()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UIWebView: UIViewRepresentable {
    let url: URL
    let webview = WebView()

    func makeUIView(context: Context) -> WKWebView {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
        return webview
    }

    func updateUIView(_ webview: WKWebView, context: Context) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
    }
}

class WebView: WKWebView {
    init() {
        super.init(frame: CGRect.zero, configuration: WKWebViewConfiguration())
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)
        super.scrollView.addSubview(refreshControl)

        super.allowsBackForwardNavigationGestures = true
        
        super.evaluateJavaScript("navigator.userAgent") { [weak self] (result, error) in
            if let webView = self, let userAgent = result as? String {
                webView.customUserAgent = userAgent + " Hyunsub/1.0.0"
            }
        }

        if #available(iOS 16.4, *) {
            super.isInspectable = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func reloadWebView(_ sender: UIRefreshControl) {
        super.reload()
        sender.endRefreshing()
    }
}
