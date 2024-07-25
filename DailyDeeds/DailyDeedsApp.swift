//
//  DailyDeedsApp.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/14/24.
//

import CocoaLumberjackSwift
import SnapKit
import SwiftData
import SwiftUI

@main
struct DailyDeedsApp: App {
    // TODO: Add compiler directives
    private let container: ModelContainer
    let model: TodoItemModel
    
    init() {
        do {
            container = try ModelContainer(for: TodoItem.self)
            model = TodoItemModel(modelContext: container.mainContext)
            configureLogs()
            DDLogInfo("Initializing DailyDeedsApp")
        } catch {
            DDLogError("Failed to create ModelContainer for TodoItem, \(error).")
            fatalError()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TodoItemsListView(
                viewModel: ListTodoItemViewModel(model: model)
            )
        }
        .modelContainer(container)
    }
    
    func configureLogs() {

        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7

        DDLog.add(fileLogger)
        DDLog.add(DDOSLogger.sharedInstance)
    }
}
