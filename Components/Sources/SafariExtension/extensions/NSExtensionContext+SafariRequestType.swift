import Foundation
import SafariServices

public enum SafariRequestType {
    case getAccounts
    case changeAccount(Any?)
    case getBalance
    case getSelectAccount
    case getHostConfiguration(Any?)
    case getLightConfiguration
    case postHostConfiguration(Any?)
    case deleteAllHostConfiguration
    case postTransaction(Any?)
    case postPersonalSignature(Any?)
    case postSignature(Any?)
    case postTypedSignature(Any?)

    public func getRequest() -> SafariExtensionRequest {
        switch self {
        case .getAccounts:
            return GetAccountsSafariRequest()
        case .changeAccount(let parameters):
            return PostChangeAccountSafariRequest(parameters: parameters)
        case .getBalance:
            return GetBalanceSafariRequest()
        case .getSelectAccount:
            return GetSelectedAccountSafariRequest()
        case .getLightConfiguration:
            return GetLightConfigurationSafariRequest()
        case .getHostConfiguration(let parameters):
            return GetHostConfigurationSafariRequest(parameters: parameters)
        case .postHostConfiguration(let parameters):
            return PostHostConfigurationSafariRequest(parameters: parameters)
        case .deleteAllHostConfiguration:
            return DeleteAllHostConfigurationSafariRequest()
        case .postTransaction(let parameters):
            return PostTransactionSafariRequest(parameters: parameters)
        case .postPersonalSignature(let parameters):
            return PostSignatureSafariRequest(parameters: parameters, signatureType: .personal)
        case .postSignature(let parameters):
            return PostSignatureSafariRequest(parameters: parameters, signatureType: .message)
        case .postTypedSignature(let parameters):
            return PostSignatureSafariRequest(parameters: parameters, signatureType: .typed)
        }
    }
}

public extension NSExtensionContext {

    func requestMethod() -> SafariRequestType? {
        guard let item = inputItems.first as? NSExtensionItem,
              let rawMessage = item.userInfo?[SFExtensionMessageKey],
                let message = rawMessage as? [String: Any],
              let method = message["method"] as? String else {
            return nil
        }

        switch method {
        case "requestAccounts":
            return .getAccounts
        case "changeAccount":
            return .changeAccount(message["params"])
        case "signTransaction":
            return .postTransaction(message["params"])
        case "signPersonalMessage":
            return .postPersonalSignature(message["params"])
        case "signTypedMessage":
            return .postTypedSignature(message["params"])
        case "storeHostConfiguration":
            return .postHostConfiguration(message["params"])
        case "getHostConfiguration":
            return .getHostConfiguration(message["params"])
        case "deleteAllHostConfiguration":
            return .deleteAllHostConfiguration
        case "getLightConfiguration":
            return .getLightConfiguration
        default:
            return nil
        }
    }
}
