import Foundation
import UIKit
import SnapKit
import Import
import SwiftUI

public class OnboardingView: UIViewController {

    private let presenterView = PresenterView()
    private let loginView = LoginView()
    private let scrollView = UIScrollView()
    private let viewModel = OnboardingViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        styleUI()
        layoutUI()
        presenterActions()
        loginActions()
    }
}

// MARK: - Onboarding Actions
extension OnboardingView {

    func presenterActions() {
        presenterView.action = {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut, animations: {
                    self.scrollView.setContentOffset(
                        CGPoint(x: 0, y: self.loginView.view.frame.origin.y),
                        animated:  true
                    )
                }, completion: nil)
        }
    }

    func loginActions() {
        loginView.importWalletAction = {
            let importView = ImportView()
            self.present(UIHostingController(rootView: importView), animated: true)
        }
        loginView.createWalletAction = {
            self.viewModel.createMainWallet()
        }
    }
}

// MARK: - Styling
extension OnboardingView {

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.contentInsetAdjustmentBehavior = .never

        addViewController(viewController: presenterView)
        addViewController(viewController: loginView)
    }

    private func styleUI() {

    }

    private func layoutUI() {
        scrollView.snp.makeConstraints { (make) in
            make.top.trailing.leading.bottom.height.width.equalToSuperview()
        }
        presenterView.view.snp.makeConstraints { (make) in
            make.top.trailing.leading.height.width.equalToSuperview()
        }
        loginView.view.snp.makeConstraints { (make) in
            make.trailing.leading.bottom.height.width.equalToSuperview()
            make.top.equalTo(presenterView.view.snp.bottom)
        }
    }
}

// MARK: - Helpers
extension OnboardingView {
    private func addViewController(viewController: UIViewController) {
        scrollView.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
}
