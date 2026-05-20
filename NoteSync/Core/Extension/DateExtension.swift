//
//  DateExtension.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 20/05/26.
//

import Foundation

extension Date {
    func toString(
        format: String = "yyyy-MM-dd HH:mm:ss",
        locale: Locale = Locale(identifier: "id_ID"),
        timeZone: TimeZone = .current
    ) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        formatter.timeZone = timeZone
        
        return formatter.string(from: self)
    }
    
    func timeAgo() -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        switch secondsAgo {
            
        case 0..<minute:
            return "\(secondsAgo) detik lalu"
            
        case minute..<hour:
            return "\(secondsAgo / minute) menit lalu"
            
        case hour..<day:
            return "\(secondsAgo / hour) jam lalu"
            
        case day..<week:
            return "\(secondsAgo / day) hari lalu"
            
        default:
            return self.toString(format: "dd MMM yyyy")
        }
    }
}
