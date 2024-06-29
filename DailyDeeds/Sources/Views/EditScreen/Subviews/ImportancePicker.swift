//
//  ImportancePicker.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

struct ImportancePicker: View {
    @Binding
    var selectedSegment: Int
    
    var body: some View {
        HStack {
            Text("Важность")
            Spacer()
            Picker(selection: $selectedSegment, label: Text("")) {
                Res.Image.arrowDown
                    .tag(0)
                Text("") // как будто без 'нет' симпотней 😄
                    .tag(1)
                Res.Image.exclamationmark2
                    .tag(2)
            }
            .frame(width: 150)
            .pickerStyle(.segmented)
        }
        .frame(height: 56)
    }
}
