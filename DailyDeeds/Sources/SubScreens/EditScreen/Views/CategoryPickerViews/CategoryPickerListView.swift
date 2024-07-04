//
//  CategoryPickerListView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/5/24.
//

import SwiftUI

struct CategoryPickerListView: View {
    @Binding
    var selectedCategory: Category
    
    @State
    private var isPresented: Bool = false
    @Environment(\.dismiss)
    private var dismiss
    var body: some View {
        List {
            defaultCategoriesView
            userCategoriesView
        }
        .scrollContentBackground(.backPrimary)
        .navigationTitle("Категории")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            CreateNewCategoryView()
        }
    }
    
    private var defaultCategoriesView: some View {
        ForEach(0..<Categories.shared.defaultCategories.count, id: \.self) { index in
            let item = Categories.shared.defaultCategories[index]
            categoryListRow(for: item)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCategory = item
                    dismiss()
                }
        }
    }
    
    private var userCategoriesView: some View {
        ForEach(Categories.shared.userCategories.indices, id: \.self) { index in
            let item = Categories.shared.userCategories[index]
            categoryListRow(for: item)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCategory = item
                    dismiss()
                }
        }
        .onDelete { indexSet in
            Categories.shared.remove(atOffsets: indexSet)
        }
    }
    
    @ViewBuilder
    private func categoryListRow(for item: Category) -> some View {
        HStack {
            Text(item.name)
            Spacer()
            if let color = item.color {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: color))
                    .frame(width: 28, height: 28)
            }
        }
        .padding(4)
    }
}
