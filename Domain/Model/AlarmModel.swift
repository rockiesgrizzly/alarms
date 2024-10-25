import Foundation

/// Domain model with alarm information
struct AlarmModel {
    let id: UUID?
    let date: Date    
    let saved: Bool
    let sound: AlarmSound
    let recurrence: AlarmRecurrence
    
    init(id: UUID? = nil, date: Date = Date(), saved: Bool = false, sound: AlarmSound = .ocean, recurrence: AlarmRecurrence = .oneTime) {
        self.id = id
        self.date = date
        self.saved = saved
        self.sound = sound
        self.recurrence = recurrence
    }
    
    var dateString: String {  
        date
            .formatted(
                .dateTime
                    .month(.wide)
                    .day()
                    .year()
                    .hour(.conversationalDefaultDigits(amPM: .abbreviated))
                    .minute())
    }
}
