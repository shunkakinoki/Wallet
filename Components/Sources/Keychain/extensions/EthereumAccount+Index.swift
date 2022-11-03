import Foundation
import Domain

extension EthereumAccount {

    func updateIndex(with address: String) throws -> Int {
        if let indexes = try UserDefaults.standard.get(objectType: Dictionary<Int, String>.self, forKey: "accountAddresses") {
            let numberOfIndexes = indexes.keys.sorted(by: <)
            let number = getNumber(numberOfIndexes)
            return try updateAddressIndex(indexes, index: number, address: address)
        }
        return try updateAddressIndex([:], index: 0, address: address)
    }

    func deleteIndex(with address: String) throws {
        if let indexes = try UserDefaults.standard.get(objectType: Dictionary<Int, String>.self, forKey: "accountAddresses") {
            var indexToSave = indexes
            if let index = indexToSave.firstIndex(where: { $0.value == address }) {
                indexToSave.remove(at: index)
                try UserDefaults.standard.set(object: indexToSave, forKey: "accountAddresses")
            }
        }
    }

    private func updateAddressIndex(_ indexes: [Int: String],  index: Int, address: String) throws -> Int {
        var indexToSave = indexes
        indexToSave[index] = address
        try UserDefaults.standard.set(object: indexToSave, forKey: "accountAddresses")
        return index
    }

    private func getNumber(_ keys: [Int]) -> Int {
        for i in 0..<keys.count {
            if i != keys[i] {
                return i
            }
        }
        return keys.count
    }
}
