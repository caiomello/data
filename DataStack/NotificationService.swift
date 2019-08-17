//
//  NotificationService.swift
//  DataStack
//
//  Created by Caio Mello on 8/17/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation
import UserNotifications
import MobileCoreServices // For UTIs

public protocol NotificationServiceDelegate {
    var notificationsEnabled: Bool { get }
    var notificationTime: Int { get }
}

public struct NotificationContent {
    let imageFilePath: String?
    let title: String
    let subtitle: String?
    let body: String?
    let date: Date
    let identifier: String
    let userInfo: [AnyHashable: Any]

    public init(imageFilePath: String?, title: String, subtitle: String?, body: String?, date: Date, identifier: String, userInfo: [AnyHashable: Any]) {
        self.imageFilePath = imageFilePath
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.date = date
        self.identifier = identifier
        self.userInfo = userInfo
    }
}

public struct NotificationService {
    private let delegate: NotificationServiceDelegate
    private let debugMode: Bool

    public init(delegate: NotificationServiceDelegate, debugMode: Bool = false) {
        self.delegate = delegate
        self.debugMode = debugMode
    }
}

// MARK: - Operations

extension NotificationService {
    public func requestAuthorization(_ completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { (granted, error) in
            completion(granted)
        }
    }

    public func scheduleNotifications(withContent content: [NotificationContent]) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                if self.delegate.notificationsEnabled {
                    content.forEach({ self.scheduleNotification(withContent: $0) })
                }
            case .denied:
                break
            case .notDetermined:
                break
            @unknown default:
                break
            }
        }
    }

    private func scheduleNotification(withContent content: NotificationContent) {
        let notification = UNMutableNotificationContent()
        notification.title = content.title
        notification.userInfo = content.userInfo

        if let subtitle = content.subtitle {
            notification.subtitle = subtitle
        }

        if let body = content.body {
            notification.body = body
        }

        if let imagePath = content.imageFilePath, let attachment = imageAttachment(withPath: imagePath) {
            notification.attachments = [attachment]
        }

        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        let components: DateComponents = {
            if debugMode {
//                Test components (fire 2s from now)
                return Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: Date().addingTimeInterval(2))
            } else {
                var components = calendar.dateComponents([.hour, .day, .month, .year], from: content.date)
                components.hour = delegate.notificationTime
                return components
            }
        }()

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: content.identifier, content: notification, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        })
    }

    public func cancelNotifications(withIdentifiers identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    public func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // Helpers

    private func imageAttachment(withPath path: String) -> UNNotificationAttachment? {
        let originalFileURL = URL(fileURLWithPath: path)
        let copyFolderURL = FileManager.default.temporaryDirectory.appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
        let copyFileURL = copyFolderURL.appendingPathComponent(originalFileURL.lastPathComponent)

        do {
            try FileManager.default.createDirectory(atPath: copyFolderURL.path, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.copyItem(atPath: originalFileURL.path, toPath: copyFileURL.path)

            return try UNNotificationAttachment(identifier: "image",
                                                url: copyFileURL,
                                                options: [UNNotificationAttachmentOptionsTypeHintKey: kUTTypeJPEG])

        } catch {
            print("Error creating notification attachment: \(error)")
            return nil
        }
    }
}
