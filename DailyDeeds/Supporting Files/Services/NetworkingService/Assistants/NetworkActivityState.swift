//
//  NetworkActivityState.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/19/24.
//

import Foundation

actor NetworkActivityState {
    private(set) var activeRequestsCount: Int = 0
    
    func increment() {
        activeRequestsCount += 1
    }
    
    func decrement() {
        if activeRequestsCount > 0 {
            activeRequestsCount -= 1
        }
    }
}
