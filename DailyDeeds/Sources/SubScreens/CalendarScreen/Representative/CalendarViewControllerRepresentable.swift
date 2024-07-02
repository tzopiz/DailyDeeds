//
//  CalendarViewControllerRepresentable.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import UIKit
import SwiftUI

struct CalendarViewControllerRepresentable: UIViewControllerRepresentable {
    let items: [TodoItem]
    // TODO: -
    // - [ ] Insert CalendarViewController into the NavigationController's hierarchy in swiftui
    func makeUIViewController(context: Context) -> CalendarViewController {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return CalendarViewController(
            viewModel: CalendarViewModel(todoItems: items),
            layout: layout
        )
    }

    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
        // Обновление данных во ViewController если требуется
    }
}
