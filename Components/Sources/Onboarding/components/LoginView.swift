import Foundation
import UIKit
import Commons

public class LoginView: UIViewController {

    private let logoImage = UIImageView()
    private let createButton = UIButton()
    private let importButton = UIButton()

    public var createWalletAction: () -> Void = {}
    public var importWalletAction: () -> Void = {}

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        styleUI()
        layoutUI()
    }
}

extension LoginView {
    func setupUI() {
        logoImage.image = UIImage(named: "LogoIcon")
        view.addSubview(logoImage)
        view.addSubview(createButton)
        view.addSubview(importButton)
    }

    func styleUI() {
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.systemGray3.cgColor
        createButton.backgroundColor = .systemBackground
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitle("Create new", for: .normal)
        createButton.addTarget(self, action: #selector(createWallet), for: .touchUpInside)

        importButton.layer.cornerRadius = 16
        importButton.layer.masksToBounds = true
        importButton.layer.borderWidth = 1
        importButton.layer.borderColor = UIColor.systemGray3.cgColor
        importButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        importButton.setTitle("Add existing", for: .normal)
        importButton.addTarget(self, action: #selector(importWallet), for: .touchUpInside)
    }

    func layoutUI() {
        logoImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        createButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(importButton.snp.top).offset(-20)
            make.height.equalTo(54)
        }

        importButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(54)
        }
    }
}

extension LoginView {

    @objc func createWallet() {
        self.createWalletAction()
    }

    @objc func importWallet() {
        self.importWalletAction()
    }
}
