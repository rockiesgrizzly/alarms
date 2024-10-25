import Foundation

/// Model retrieved from the endpoint
struct AlarmResponseModel: Decodable {
    let timestamp: String
    let sound: String
    let recurring: String
    
    enum Sound: String, Decodable {
        case brownNoise
        case ocean
        case party
        case whiteNoise
        
        private enum CodingKeys: String, CodingKey {
            case brownNoise = "brown-noise"
            case ocean
            case party
            case whiteNoise = "white-noise"
        }
    }
    
    enum Recurrence: String, Decodable {
        case yearly
        case monthly
        case weekly
        case oneTime
        
        private enum CodingKeys: String, CodingKey {
            case yearly
            case monthly
            case weekly
            case oneTime = "one-time"
        }
    }
    
    init(timestamp: String, sound: String, recurring: String) {
        self.timestamp = timestamp
        self.sound = sound
        self.recurring = recurring
    }
}
