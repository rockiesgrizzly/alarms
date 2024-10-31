import SwiftUI

/// First view to which `AlarmsApp` hands off. Presents a list of alarm detail views and an alarm entry popover.
struct AlarmsView: View {
    @ObservedObject var viewModel: AlarmsViewModel
    
    var body: some View {
        Spacer()
        
        List(viewModel.alarmDetailViewModels, id: \.id) {
                AlarmDetailView(viewModel: $0)
        }
        
        Button(action: {
            viewModel.showAlarmEntryView.toggle()
        }) {
            Image(systemName: "plus")
        }
        .popover(isPresented: $viewModel.showAlarmEntryView, content: {
            AlarmEntryView(isPresented: $viewModel.showAlarmEntryView, 
                           userCompletedEntry: $viewModel.userCompletedEntryView, 
                           userEnteredAlarmDate: $viewModel.userEnteredAlarmDate,
                           userChosenSound: $viewModel.userChosenAlarmSound,
                           userChosenRecurrence: $viewModel.userChosenRecurrence)
        })
        
        Spacer()
    }
}

// MARK: - #Preview

#Preview {
    let detail = AlarmDetailViewModel(date: Date(timeIntervalSinceNow: 40000000), saved: true, sound: .brownNoise, recurrence: .oneTime)
    let detail2 = AlarmDetailViewModel(date: Date(), saved: false, sound: .party, recurrence: .weekly)
    let previewModel = AlarmsViewModel(alarmDetailViewModels: [detail, detail2])
    AlarmsView(viewModel: previewModel)
}

fileprivate extension AlarmsViewModel {
    /// Convenience init for Preview only
    convenience init(alarmDetailViewModels: [AlarmDetailViewModel] = [AlarmDetailViewModel]()) {
        self.init()
        self.alarmDetailViewModels = alarmDetailViewModels
    }
}

