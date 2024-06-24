//
//  DeadlineView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/25/24.
//

import SwiftUI
import Combine

class DeadlineManager: ObservableObject {
    @Published 
    var deadline: Date?
    
    init(deadline: Date? = nil) {
        self.deadline = deadline
    }
}

struct DeadlineView: View {
    @StateObject
    var manager = DeadlineManager()
    @State
    private var isDeadlineEnabled = false
    @State
    private var isDatePickerVisible = false
    
    var body: some View {
        toggleView
        if isDatePickerVisible {
            datePickerView
        }
    }
    
    private var toggleView: some View {
        Toggle(isOn: $isDeadlineEnabled) {
            VStack(alignment: .leading) {
                Text("Сделать до")
                    .font(.system(size: 19))
                if let deadline = manager.deadline {
                    Button {
                        withAnimation {
                            isDatePickerVisible.toggle()
                        }
                    } label: {
                        Text(deadline, style: .date)
                    }
                    .tint(Color.blue)
                }
            }
        }
        .padding(4)
        .tint(Color.green)
        .onChange(of: isDeadlineEnabled) {
            withAnimation {
                if !isDeadlineEnabled {
                    manager.deadline = nil
                    isDatePickerVisible = false
                } else if manager.deadline == nil {
                    manager.deadline = Date().tomorrow
                }
            }
        }
        .onReceive(manager.$deadline) { newDeadline in
            isDeadlineEnabled = newDeadline != nil
            if newDeadline == nil {
                isDatePickerVisible = false
            }
        }
    }
    private var datePickerView: some View {
        DatePicker(
            "Выберите дату",
            selection: Binding(
                get: {
                    manager.deadline ?? Date().tomorrow
                },
                set: { newDate in
                    manager.deadline = newDate
                    isDatePickerVisible = true
                }
            ),
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .opacity(isDatePickerVisible ? 1 : 0)
        .animation(.easeInOut, value: isDatePickerVisible)
    }
    
}



#Preview {
    Form {
        DeadlineView(manager: DeadlineManager(deadline: .now))
    }
}
