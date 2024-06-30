//
//  DeadlineToggleView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import SwiftUI

struct DeadlineToggleView: View {
    @Binding
    var deadline: Date
    @Binding
    var isDeadlineEnabled: Bool
    @Binding
    var isDatePickerVisible: Bool
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Сделать до")
                if isDeadlineEnabled {
                    Text(deadline, style: .date)
                        .transition(.scale)
                        .foregroundStyle(Color.blue)
                        .onTapGesture {
                            isDatePickerVisible.toggle()
                        }
                }
            }
            Toggle("", isOn: $isDeadlineEnabled)
                .onChange(of: isDeadlineEnabled) { _, newValue in
                    isDatePickerVisible = newValue
                }
        }
        .frame(height: 56)
    }
}
