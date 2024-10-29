import SwiftUI

/// View showing date, recurrence rate, and whether the alarm has been saved
struct AlarmDetailView: View {
    var viewModel: AlarmDetailViewModel
    
    var body: some View {
        HStack { 
            Text(viewModel.dateString)
                .font(.system(size: 17))
                .padding()
            Spacer()
            Text(viewModel.alarmModel.recurrence.displayString)
                .font(.system(size: 17))
                .padding()
            if viewModel.alarmModel.saved {
                Image(systemName: viewModel.savedImageName)
                    .padding(.trailing, 18.5)
            }
        }
        .accessibilityIdentifier("alarm detail view \(viewModel.alarmModel.date)")
    }
}

#Preview {
    let detail = AlarmDetailViewModel(date: Date(timeIntervalSinceNow: 40000000), saved: true, sound: .brownNoise, recurrence: .oneTime)
    AlarmDetailView(viewModel: detail)
    Spacer()
}
