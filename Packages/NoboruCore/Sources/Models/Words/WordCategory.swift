import Foundation

public enum WordCategory: String, Codable, CaseIterable {
    case action
    case hold
    case gear
    case excuse
    case location

    public var displayName: String {
        switch self {
        case .action: return "Action"
        case .hold: return "Hold"
        case .gear: return "Gear"
        case .excuse: return "Excuse"
        case .location: return "Location"
        }
    }
}
