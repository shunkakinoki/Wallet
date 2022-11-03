import Foundation
import Session
import Combine
import EthereumServices
import UIKit
import SwiftUI
import Domain

public final class HomeViewModel: ObservableObject {

    private let selectedWallet: SelectedWallet
    private let getHostConfiguration: GetHostConfiguration

    @Published
    var configurations = [HostConfigurationModel.HostConfigurationParameters]()

    @Published
    var selectedRawAddress: String = ""

    @Published
    var selectedAddress: String = ""

    @Published
    var color: String = ""

    @Published
    var name: String = ""

    init(selectedWallet: SelectedWallet = SelectedWalletImp(), getHostConfiguration: GetHostConfiguration = GetHostConfigurationImp()) {
        self.selectedWallet = selectedWallet
        self.getHostConfiguration = getHostConfiguration
    }

    public func getWalletSelected() {
        do {
            let walletSelected = try selectedWallet.selected()
            self.selectedAddress = walletSelected.address.eip55Description.addressFormat()
            self.selectedRawAddress = walletSelected.address.eip55Description
            self.name = walletSelected.name
            self.color = walletSelected.color.rawValue
        } catch {
            self.selectedRawAddress = ""
            self.selectedAddress = ""
            self.name = ""
        }
    }

    public func getConfiguration() {
        self.configurations = []
        if let configurations = getHostConfiguration.get() {
            self.configurations.append(contentsOf: configurations)
        }
    }

    public func getChainImage(chainId: String) -> String {
        return retrieveChainName(with: chainId)
    }

    func retrieveChainName(with chainId: String) -> String {
        switch chainId {
        case "0x1":
            return "ethereum"
        case "0x5":
            return "goerli"
        case "0xa":
            return "optimism"
        case "0x89":
            return "polygon"
        case "0xa4b1":
            return "arbitrum"
        default:
            return "ethereum"
        }
    }
}
