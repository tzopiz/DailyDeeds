//
//  DataPickerView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

struct DataPickerView: View {
    @State
    var deadline: Date
    var body: some View {
        // FIXME: - default deadline tommorow -
        DatePicker(
            .init(""),
            selection: $deadline,
            in: Date()...,
            displayedComponents: .date
        )
        // FIXME: - add animation -
        .datePickerStyle(.graphical)
    }
}

#Preview {
    DataPickerView(deadline: .now)
        .padding()
}
