//
//  ITodoResponse.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/18/24.
//

import Foundation

protocol ITodoResponse {
    associatedtype Element
    var status: String { get }
    var result: Element { get }
    var revision: Int { get }
}
