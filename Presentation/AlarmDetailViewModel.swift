import Foundation

/// View model with alarm details 
struct AlarmDetailViewModel: Identifiable {
    let id = UUID()
    let alarmModel: AlarmModel
    let savedImageName = "checkmark.seal.fill"
    
    init(date: Date, saved: Bool, sound: AlarmSound, recurrence: AlarmRecurrence) {
        alarmModel = AlarmModel(date: date, 
                                saved: saved, 
                                sound: sound, 
                                recurrence: recurrence)
    }
    
    var dateString: String {  
        alarmModel.dateString
    }
}

// MARK: Comparable : to filter out alarms that already exist

extension AlarmDetailViewModel: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.alarmModel.date < rhs.alarmModel.date
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.alarmModel.date == rhs.alarmModel.date
    }
}
