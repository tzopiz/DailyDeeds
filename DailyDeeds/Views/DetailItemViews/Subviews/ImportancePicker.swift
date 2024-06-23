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
            Image("arrow.down")
                .tag(0)
            Text("")
                .tag(1)
            Image("exclamationmark.2")
                .tag(2)
        }
        .pickerStyle(.segmented)
        .scaledToFit()
    }
}

#Preview {
    ImportancePicker(selectedSegment: 2)
}
