import SafariExtension
import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

  private var context: NSExtensionContext?

  func beginRequest(with context: NSExtensionContext) {
    guard let method = context.requestMethod() else { return }
    Task {
      let response = NSExtensionItem()
      defer { context.completeRequest(returningItems: [response], completionHandler: nil) }
      response.userInfo = ["message": method.getRequest().response ?? ""]
    }
  }
}
