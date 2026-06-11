#if canImport(UIKit)
import SwiftUI
import WebKit

/// Embeds the Neuphlo support chat for one workspace.
///
/// Conversations land in the workspace inbox with the same
/// draft-and-approve flow as email. The visitor session persists
/// across launches via the web view's default data store.
///
/// ```swift
/// NeuphloWidgetView(widgetKey: "your-widget-key")
/// ```
public struct NeuphloWidgetView: UIViewRepresentable {
    private let url: URL

    /// - Parameters:
    ///   - widgetKey: Workspace widget key from Inbox settings → Chat widget.
    ///   - appURL: Neuphlo app origin, for self-hosted installs.
    public init(
        widgetKey: String,
        appURL: URL = URL(string: "https://app.neuphlo.com")!
    ) {
        self.url = appURL
            .appendingPathComponent("widget")
            .appendingPathComponent(widgetKey)
    }

    public func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.websiteDataStore = .default()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .systemBackground
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.load(URLRequest(url: url))
        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {}
}

/// UIKit wrapper for apps that are not SwiftUI-first.
public final class NeuphloWidgetViewController: UIViewController {
    private let url: URL

    public init(
        widgetKey: String,
        appURL: URL = URL(string: "https://app.neuphlo.com")!
    ) {
        self.url = appURL
            .appendingPathComponent("widget")
            .appendingPathComponent(widgetKey)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    public override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.websiteDataStore = .default()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .systemBackground
        webView.load(URLRequest(url: url))
        view = webView
    }
}
#endif
