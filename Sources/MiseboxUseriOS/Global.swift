//
//  File.swift
//  
//
//  Created by Daniel Watson on 10.03.2024.
//

import Foundation

public struct DateUtility {

    // Shared date formatter
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    // Function to create a date
    public static func createDate(year: Int, month: Int, day: Int, timeZone: TimeZone = TimeZone(secondsFromGMT: 0) ?? .current) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }

    // Convenience method to format a date
    public static func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
