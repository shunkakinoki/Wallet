import Combine
import Foundation
import Session

protocol SplashViewModel {
  func invoke()
}

public final class SplashViewModelImp: SplashViewModel {

  private let isSigned: IsSigned

  public init(isSigned: IsSigned) {
    self.isSigned = isSigned
  }

  func invoke() {
    if isSigned.get() {
      syncDataModels()
    } else {
      logOut()
    }
  }
}

extension SplashViewModelImp {
  private func syncDataModels() {
    NotificationCenter.default.post(name: .lightLogIn, object: nil)
  }
  private func logOut() {
    NotificationCenter.default.post(name: .lightLogOut, object: nil)
  }
}
