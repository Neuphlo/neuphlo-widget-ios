#if canImport(UIKit)
import SwiftUI
import WebKit

enum NeuphloWidgetURL {
    static func build(
        widgetKey: String,
        appURL: URL,
        userId: String?,
        userName: String?,
        userEmail: String?
    ) -> URL {
        let base = appURL
            .appendingPathComponent("widget")
            .appendingPathComponent(widgetKey)
        var components = URLComponents(url: base, resolvingAgainstBaseURL: false)
        var items: [URLQueryItem] = []
        if let userId { items.append(URLQueryItem(name: "uid", value: userId)) }
        if let userName { items.append(URLQueryItem(name: "name", value: userName)) }
        if let userEmail { items.append(URLQueryItem(name: "email", value: userEmail)) }
        if !items.isEmpty { components?.queryItems = items }
        return components?.url ?? base
    }
}


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
    ///   - userId: Your product's user id, stored on the conversation.
    ///   - userName: Display name of the signed-in user.
    ///   - userEmail: Email of the signed-in user, used to recognize them.
    public init(
        widgetKey: String,
        appURL: URL = URL(string: "https://app.neuphlo.com")!,
        userId: String? = nil,
        userName: String? = nil,
        userEmail: String? = nil
    ) {
        self.url = NeuphloWidgetURL.build(
            widgetKey: widgetKey,
            appURL: appURL,
            userId: userId,
            userName: userName,
            userEmail: userEmail
        )
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
        appURL: URL = URL(string: "https://app.neuphlo.com")!,
        userId: String? = nil,
        userName: String? = nil,
        userEmail: String? = nil
    ) {
        self.url = NeuphloWidgetURL.build(
            widgetKey: widgetKey,
            appURL: appURL,
            userId: userId,
            userName: userName,
            userEmail: userEmail
        )
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
