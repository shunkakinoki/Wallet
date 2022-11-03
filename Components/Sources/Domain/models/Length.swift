import Foundation

public enum Length {
    case word12
    case word24

    public var strength: Int {
        switch self {
        case .word12:
            return 128
        case .word24:
            return 256
        }
    }
}
