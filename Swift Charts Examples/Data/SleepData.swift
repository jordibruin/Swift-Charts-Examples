//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI

enum SleepStage: Int, CaseIterable, Identifiable {
    case deep
    case core
    case rem
    case awake

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .deep:
            return "Deep"
        case .core:
            return "Core"
        case .rem:
            return "REM"
        case .awake:
            return "Awake"
        }
    }

    /// Fill colors sampled from the Health app.
    var color: Color {
        switch self {
        case .deep:
            return Color(red: 0.212, green: 0.204, blue: 0.635)
        case .core:
            return Color(red: 0.039, green: 0.514, blue: 0.996)
        case .rem:
            return Color(red: 0.388, green: 0.824, blue: 1.000)
        case .awake:
            return Color(red: 1.000, green: 0.404, blue: 0.310)
        }
    }
}

struct SleepSegment: Identifiable {
    let id = UUID()
    let stage: SleepStage
    let start: Date
    let end: Date

    var duration: TimeInterval { end.timeIntervalSince(start) }
}

enum SleepData {
    static let nightStart = date(year: 2022, month: 6, day: 13)
    static let nightEnd = date(year: 2022, month: 6, day: 13, hour: 8)

    /// Total time spent in all stages except awake.
    static var timeAsleep: TimeInterval {
        lastNight
            .filter { $0.stage != .awake }
            .reduce(0) { $0 + $1.duration }
    }

    static let lastNight: [SleepSegment] = {
        typealias Time = (hour: Int, minutes: Int, seconds: Int)
        let stages: [(SleepStage, Time, Time)] = [
            (.core, (0, 35, 6), (0, 55, 43)),
            (.deep, (0, 55, 43), (1, 6, 44)),
            (.core, (1, 6, 44), (1, 11, 3)),
            (.deep, (1, 11, 3), (1, 16, 48)),
            (.core, (1, 16, 48), (1, 17, 46)),
            (.deep, (1, 17, 46), (1, 25, 55)),
            (.core, (1, 25, 55), (1, 36, 56)),
            (.rem, (1, 36, 56), (1, 44, 8)),
            (.core, (1, 44, 8), (2, 6, 11)),
            (.awake, (2, 6, 11), (2, 7, 9)),
            (.core, (2, 7, 9), (2, 29, 12)),
            (.deep, (2, 29, 12), (2, 46, 56)),
            (.core, (2, 46, 56), (3, 8, 2)),
            (.rem, (3, 8, 2), (3, 10, 54)),
            (.core, (3, 10, 54), (3, 16, 11)),
            (.rem, (3, 16, 11), (3, 32, 58)),
            (.core, (3, 32, 58), (5, 17, 57)),
            (.awake, (5, 17, 57), (5, 18, 55)),
            (.core, (5, 18, 55), (5, 24, 11)),
            (.rem, (5, 24, 11), (6, 6, 23)),
            (.core, (6, 6, 23), (6, 40, 25))
        ]
        return stages.map { stage, start, end in
            SleepSegment(
                stage: stage,
                start: date(year: 2022, month: 6, day: 13, hour: start.hour, minutes: start.minutes, seconds: start.seconds),
                end: date(year: 2022, month: 6, day: 13, hour: end.hour, minutes: end.minutes, seconds: end.seconds)
            )
        }
    }()
}
