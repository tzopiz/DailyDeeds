//
//  CategoryPickerRow.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/4/24.
//

import SwiftUI

struct CategoryPickerRow: View {
    @Binding
    var selecetedCategory: Category
    
    var body: some View {
        NavigationLink {
            CategoryPickerListView(selectedCategory: $selecetedCategory)
        } label: {
            HStack {
                Text("Категория")
                Spacer()
                Text(selecetedCategory.name)
                    .foregroundStyle(Color.blue)
            }
        }
        .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
        .frame(height: 56)
    }
}
