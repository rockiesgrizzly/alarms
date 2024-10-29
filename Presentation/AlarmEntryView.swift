import SwiftUI

/// View allowing a user to set an alarm
struct AlarmEntryView: View {
    @Binding var isPresented: Bool
    @Binding var userCompletedEntry: Bool
    @Binding var userEnteredAlarmDate: Date
    @Binding var userChosenSound: AlarmSound
    @Binding var userChosenRecurrence: AlarmRecurrence
    
    var body: some View {
        VStack {
            Text("Add Alarm")
                .font(.headline)
            DatePicker("", selection: $userEnteredAlarmDate, 
                       displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.wheel)
            Picker("", selection: $userChosenSound) {
                ForEach(AlarmSound.allCases, id: \.self) {
                    Text("\($0.displayString)")
                }
            }
            Picker("", selection: $userChosenRecurrence) {
                ForEach(AlarmRecurrence.allCases, id: \.self) {
                    Text("\($0.displayString)")
                }
            }
            HStack {
                Spacer()
                Button("Cancel") {
                    isPresented = false
                }
                Spacer()
                Button("Save") {
                    isPresented = false
                    userCompletedEntry = true
                }
                Spacer()
            }.padding(.vertical, 16)
        }
        .padding()
    }
}

#Preview {
    AlarmEntryView(isPresented: .constant(true), userCompletedEntry:.constant(false), userEnteredAlarmDate: .constant(Date()), userChosenSound: .constant(.ocean), userChosenRecurrence: .constant(.weekly))
    Spacer()
}
