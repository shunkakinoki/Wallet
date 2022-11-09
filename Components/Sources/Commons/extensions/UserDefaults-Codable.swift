import Foundation

public extension UserDefaults {

    func set<T: Codable>(object: T, forKey: String) throws {
        let jsonData = try JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }

    func remove(forKey: String) throws {
        removeObject(forKey: forKey)
    }
    
    func removeAll() throws {
        let dictionary = dictionaryRepresentation()
        dictionary.keys.forEach { key in
            removeObject(forKey: key)
        }
    }

    func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        return try JSONDecoder().decode(objectType, from: result)
    }
}
