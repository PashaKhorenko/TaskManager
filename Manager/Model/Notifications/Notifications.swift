//
//  Notifications.swift
//  Manager
//
//  Created by Паша Хоренко on 22.12.2022.
//

import UIKit
import UserNotifications

enum timeEnum {
    case Five
    case Ten
}

class Notifications: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Notifications Autorisation
    
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            guard granted else { return }
            self.getNotificationsSettings()
        }
    }
    
    func getNotificationsSettings() {
        notificationCenter.getNotificationSettings { settings in
            print("Notifications settings: \(settings)")
        }
    }
    
    // MARK: - Send Notification
    
    func sentNotification(for task: Task) {
        let identifierForRequest = "\(task.dateOfCreation!)"
        let identifierForCategory = "categoryID"
        
        // Step 1: Create the notification content
        let content = UNMutableNotificationContent()
        
        content.title = "Task Manager"
        content.subtitle = task.title!
        content.body = "There are 20 minutes left for the task"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = identifierForCategory
        
        // Step 2: Create the notification trigger
        guard let date = task.deadlineDate?.addingTimeInterval(-20 * 60)  else { return }
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Step 3: Create the notification request
        let request = UNNotificationRequest(identifier: identifierForRequest,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            guard let error else { return }
            print("Error with notifications: \(error.localizedDescription)")
        }
                                
        // Create actions for notifications category
        let remindAfterFiveActions = UNNotificationAction(identifier: "five", title: "Remind in 5 minutes.")
        let remindAfterTenActions = UNNotificationAction(identifier: "ten", title: "Remind in 10 minutes.")
        
        // Create notifications category
        let category = UNNotificationCategory(identifier: identifierForCategory,
                                              actions: [remindAfterFiveActions, remindAfterTenActions],
                                              intentIdentifiers: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    // MARK: - Remove Notifications
    func remove(with id: [String]) {
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: id)
    }
    
    // MARK: - Reminder
    func reminderAfter(_ time: timeEnum) {
        var identifierForRequest: String {
            switch time {
            case .Five:
                return "afterFiveMinutes"
            case .Ten:
                return "afterTenMinutes"
            }
        }
        
        // Step 1: Create the notification content
        let content = UNMutableNotificationContent()
        
        var bodyText: String {
            switch time {
            case .Five:
                return "There are 15 minutes left for the task."
            case .Ten:
                return "There are 10 minutes left for the task."
            }
        }
        
        content.title = "Task Manager"
        content.subtitle = "\(time) minutes passed"
        content.body = bodyText
        content.sound = UNNotificationSound.default
        
        // Step 2: Create the notification trigger
        var timeForTrigger: TimeInterval {
            switch time {
            case .Five:
                return 5 * 60
            case .Ten:
                return 10 * 60
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeForTrigger, repeats: false)
        
        // Step 3: Create the notification request
        let request = UNNotificationRequest(identifier: identifierForRequest,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            guard let error else { return }
            print("Error with notifications: \(error.localizedDescription)")
        }
    }
}


// MARK: - UNUserNotificationCenterDelegate

extension Notifications: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default Action")
        case "five":
            print("Remain in 5 minutes Action")
            reminderAfter(.Five)
        case "ten":
            print("Remain in 10 minutes Action")
            reminderAfter(.Ten)
        default:
            print("Unknown Action")
        }
        
        completionHandler()
    }

}
