import Foundation

protocol UseCase_GetAlarmsProtocol {
    static var alarmDetailViewModels: [AlarmDetailViewModel] { get async throws }
}

/// Retrieves `alarmDetailViewModels` from a repository
struct UseCase_GetAlarms: UseCase_GetAlarmsProtocol {
    static var repositoryType: any AlarmsDataRepositoryProtocol.Type = AlarmsDataRepository.self
    
    static var alarmDetailViewModels: [AlarmDetailViewModel] {
        get async throws {
            try await repositoryType
                .alarmsResponses
                .alarmDetailViewModels
        }
    }
}

// MARK: - AlarmDetailViewModel : interface

extension [AlarmResponseModel] {
    var alarmDetailViewModels: [AlarmDetailViewModel] {
        compactMap({ $0.alarmDetailViewModel })
    }
}

// MARK: - AlarmResponseModel : interface

extension AlarmResponseModel {
    var alarmDetailViewModel: AlarmDetailViewModel {
        AlarmDetailViewModel(date: formattedDate ?? Date(), 
                             saved: true, 
                             sound: AlarmSound(rawValue: sound) ?? .whiteNoise,
                             recurrence: AlarmRecurrence(rawValue: recurring) ?? .oneTime)
    }
    
    var formattedDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" 
        return dateFormatter.date(from: timestamp)
    }
}
