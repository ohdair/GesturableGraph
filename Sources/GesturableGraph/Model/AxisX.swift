//
//  AxisX.swift
//
//
//  Created by 박재우 on 10/23/23.
//

import Foundation

public struct AxisX {
    public var time: UnitOfTime = .hours

    public enum UnitOfTime {
        case seconds
        case minutes
        case hours
        case days
        case months

        var data: [Date] {
            let calendar = Calendar.current
            let date = Date()

            switch self {
            case .seconds:
                return stride(from: 0, to: 60, by: 20).map { second in
                    calendar.date(bySettingHour: 0, minute: 0, second: second, of: date)!
                }
            case .minutes:
                return stride(from: 0, to: 60, by: 20).map { minute in
                    calendar.date(bySettingHour: 0, minute: minute, second: 0, of: date)!
                }
            case .hours:
                return stride(from: 0, to: 24, by: 6).map { hour in
                    calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date)!
                }
            case .days:
                return stride(from: 1, to: 31, by: 10).map { day in
                    calendar.date(from: DateComponents(day: day))!
                }
            case .months:
                return stride(from: 1, to: 12, by: 3).map { month in
                    calendar.date(from: DateComponents(month: month))!
                }
            }
        }

        func dateFormatter(date: Date) -> String {
            let dateFormatter = DateFormatter()
            switch self {
            case .seconds:
                dateFormatter.dateFormat = "ss초"
            case .minutes:
                dateFormatter.dateFormat = "mm분"
            case .hours:
                dateFormatter.dateFormat = "a h시"
            case .days:
                dateFormatter.dateFormat = "dd일"
            case .months:
                dateFormatter.dateFormat = "MM월"
            }
            return dateFormatter.string(from: date)
        }
    }
}
