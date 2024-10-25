
/// Domain model providing choices as to which sound should be played with a local alarm alert
enum AlarmSound: String, CaseIterable {
    case ocean
    case party
    case brownNoise
    case whiteNoise
    
    var displayString: String {
        switch self {
        case .ocean: "Ocean"
        case .party: "Party"
        case .brownNoise: "Brown Noise"
        case .whiteNoise: "White Noise"
        }
    }
}
