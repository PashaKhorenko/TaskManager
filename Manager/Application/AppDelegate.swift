//
//  AppDelegate.swift
//  Manager
//
//  Created by Pasha Khorenko on 20.03.2022.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }

            self.notificationCenter.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }

        notificationCenter.delegate = self

        return true
    }
    
    func sendNotification(for task: Task) {
        let context = UNMutableNotificationContent()
        context.title = task.title
        context.body = "There are 5 minutes left for the task."
        context.sound = UNNotificationSound.default
        
        let date = task.deadLineDate.addingTimeInterval(TimeInterval(-5.0 * 60.0))
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                             from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: false)
        let id = "\(task.deadLineDate)"
        let request = UNNotificationRequest(identifier: id,
                                            content: context,
                                            trigger: trigger)
        
        notificationCenter.add(request)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(#function)
        completionHandler([.banner, .list, .sound])
    }

    // дія по натисканню на сповіщення
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
    }

}
