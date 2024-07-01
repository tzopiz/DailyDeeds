//
//  ImportancePicker.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

struct ImportancePicker: View {
    @Binding
    var selectedSegment: Importance
    
    var body: some View {
        HStack {
            Text("Важность")
            Spacer()
            Picker(selection: $selectedSegment, label: Text("")) {
                Image(.arrowDown)
                    .tag(Importance.low)
                Text("") // как будто без 'нет' симпотней 😄
                    .tag(Importance.medium)
                Image(.exclamationmark2)
                    .tag(Importance.high)
            }
            .frame(width: 150)
            .pickerStyle(.segmented)
        }
        .frame(height: 56)
    }
}
