//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation
import Charts

enum ChartStrideBy: Identifiable, CaseIterable {
    
    case second
    case minute
    case hour
    case day
    case weekday
    case weekOfYear
    case month
    case year
    
    var id: String { title }
    
    var title: String {
        switch self {
        case .second:
            return "Second"
        case .minute:
            return "Minute"
        case .hour:
            return "Hour"
        case .day:
            return "Day"
        case .weekday:
            return "Weekday"
        case .weekOfYear:
            return "Week of Year"
        case .month:
            return "Month"
        case .year:
            return "Year"
        }
    }
    var time: Calendar.Component {
        switch self {
        case .second:
            return .second
        case .minute:
            return .minute
        case .hour:
            return .hour
        case .day:
            return .day
        case .weekday:
            return .weekday
        case .weekOfYear:
            return .weekOfYear
        case .month:
            return .month
        case .year:
            return .year
        }
    }
}
