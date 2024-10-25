import SwiftUI

@main
struct Alarms: App {
    private var alarmsViewModel = AlarmsViewModel()
    
    var body: some Scene {
        WindowGroup {
            AlarmsView(viewModel: alarmsViewModel)
                .task {
                    await alarmsViewModel.requestUserNotificationPermission()
                    await alarmsViewModel.refreshAlarmDetailModels()
                }
                .onAppear {
                    UNUserNotificationCenter.current().delegate = alarmsViewModel
                }
        }
    }
}
