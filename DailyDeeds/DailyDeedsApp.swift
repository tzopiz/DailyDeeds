//
//  DailyDeedsApp.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import CocoaLumberjackSwift
import SnapKit
import SwiftUI

@main
struct DailyDeedsApp: App {
    private let model = TodoItemModel(
        items: ListTodoItemViewModel.createTodoItems(30)
    )

    init() {
        configureLogs()
    }

    var body: some Scene {
        WindowGroup {
            TodoItemsListView(viewModel: ListTodoItemViewModel(model: model))
        }
    }
    func configureLogs() {

        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7

        DDLog.add(fileLogger)
        DDLog.add(DDOSLogger.sharedInstance)
    }
}
