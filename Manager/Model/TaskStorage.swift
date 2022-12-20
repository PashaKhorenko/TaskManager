//
//  TaskStorage.swift
//  Manager
//
//  Created by Pasha Khorenko on 10.05.2022.
//

import Foundation
/*
protocol TaskStorageProtocol {
    // Загрузка списка задач
    func load(_ key: String) -> [Task]

    // Обновление списка задач
    func save(tasks: [Task], forKey: String)

}

class TaskStorage: TaskStorageProtocol {
    // Ссылка на хранилище
    private var storage = UserDefaults.standard

    func save(tasks: [Task], forKey: String) {
        let data = tasks.map { try? JSONEncoder().encode($0) }
        storage.set(data, forKey: forKey)
        storage.synchronize()
    }
    
    func load(_ key: String) -> [Task] {
        guard let encodedData = storage.array(forKey: key) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(Task.self, from: $0) }
    }
}
*/
