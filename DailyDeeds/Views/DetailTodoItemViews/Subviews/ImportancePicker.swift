//
//  ImportancePicker.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/23/24.
//

import SwiftUI

struct ImportancePicker: View {
    @State
    var selectedSegment: Int
    
    var body: some View {
        Picker(selection: $selectedSegment, label: Text("")) {
            Res.Image.arrowDown
                .tag(0)
            // да, текст пустой (мне так нравится больше)
            Text("")
                .tag(1)
            Res.Image.exclamationmark2
                .tag(2)
        }
        .pickerStyle(.segmented)
        .scaledToFit()
    }
}

#Preview {
    ImportancePicker(selectedSegment: 2)
}
