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
    init() {
        configureLogs()
        DDLogInfo("Initializing DailyDeedsApp")
    }
    
    var body: some Scene {
        WindowGroup {
            TodoItemsListView(viewModel: ListTodoItemViewModel(model: TodoItemModel()))
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
