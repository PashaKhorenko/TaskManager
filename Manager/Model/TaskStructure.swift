//
//  TaskStructure.swift
//  Manager
//
//  Created by Pasha Khorenko on 09.05.2022.
//

import Foundation

protocol TaskProtocol {
    var title: String { get set }
    var deadLineDate: Date { get set }
    var priority: Int { get set }
    var description: String? { get set }
    var isCompleted: Bool { get set }
}

struct Task: TaskProtocol, Codable {
    var isCompleted: Bool
    var title: String
    var deadLineDate: Date
    var priority: Int
    var description: String?
}
