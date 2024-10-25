import SwiftUI

/// First view to which `AlarmsApp` hands off. Presents a list of alarm detail views and an alarm entry popover.
struct AlarmsView: View {
    @StateObject var viewModel: AlarmsViewModel
    
    var body: some View {
        Spacer()
        List {
            ForEach(viewModel.alarmDetailViewModels) {
                AlarmDetailView(viewModel: $0)
            } 
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

#Preview {
    AlarmsView(viewModel: AlarmsViewModel())
}

