import Foundation
import UIKit
import Commons

public class PresenterView: UIViewController {

    private let logoImage = UIImageView()
    private let startButton = UIButton()

    public var action: () -> Void = {}

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        styleUI()
        layoutUI()
    }
}

extension PresenterView {
    func setupUI() {
        logoImage.image = UIImage(named: "LogoIcon")
        view.addSubview(logoImage)
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }

    func styleUI() {
        startButton.layer.cornerRadius = 16
        startButton.layer.masksToBounds = true
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.systemGray3.cgColor
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        startButton.titleLabel?.textColor = .systemBlue
        startButton.setTitle("Get Started", for: .normal)
    }

    func layoutUI() {
        logoImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(54)
        }
    }
}

extension PresenterView {
    @objc func tapButton() {
        self.action()
    }
}
