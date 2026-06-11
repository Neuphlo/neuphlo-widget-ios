# NeuphloWidget for iOS

Swift package embedding the [Neuphlo](https://neuphlo.com) support chat in your iOS app. Conversations land in your Neuphlo inbox with the same draft-and-approve flow as email.

## Install

In Xcode: **File → Add Package Dependencies…** and enter:

```
https://github.com/Neuphlo/neuphlo-widget-ios
```

Or in `Package.swift`:

```swift
.package(url: "https://github.com/Neuphlo/neuphlo-widget-ios", from: "0.1.0")
```

## Usage

SwiftUI:

```swift
import NeuphloWidget

struct SupportView: View {
    var body: some View {
        NeuphloWidgetView(widgetKey: "your-widget-key")
    }
}
```

UIKit:

```swift
import NeuphloWidget

let supportVC = NeuphloWidgetViewController(widgetKey: "your-widget-key")
navigationController?.pushViewController(supportVC, animated: true)
```

Identify the signed-in user so conversations are recognized in your inbox:

```swift
NeuphloWidgetView(
    widgetKey: "your-widget-key",
    userId: user.id,
    userName: user.name,
    userEmail: user.email,
    userHash: user.neuphloHash
)
```

`userHash` enables identity verification — compute it **on your backend**
as HMAC-SHA256 of the user id, keyed with the widget identity secret from
Inbox settings → Chat widget. Workspaces with "Require verified identities"
enabled reject identified conversations without a valid hash.

Self-hosted installs pass their own app origin:

```swift
NeuphloWidgetView(
    widgetKey: "your-widget-key",
    appURL: URL(string: "https://neuphlo.your-company.com")!
)
```

The widget key lives in **Inbox settings → Chat widget** in your Neuphlo workspace. The visitor session persists across launches.

Requires iOS 15+.
