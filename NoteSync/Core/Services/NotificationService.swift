//
//  NotificationService.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 08/05/26.
//

import Foundation
import UserNotifications
import Combine

@MainActor
class NotificationService: ObservableObject {
    @Published private(set) var permissionNotificationStatus: Bool = false
    
    func requestAuthorization () async  {
        do {
            let center = UNUserNotificationCenter.current()
            try await center.requestAuthorization(options: [.alert, .badge, .sound])
           
        } catch  {
            print(error)
        }
        
        await getAuthStatus()
    }
    
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized,
                .ephemeral,
                .provisional:
            permissionNotificationStatus = true
        default:
            permissionNotificationStatus = false
        }
    }
}
