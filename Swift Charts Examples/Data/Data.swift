//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation

func date(year: Int, month: Int, day: Int = 1, hour: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minutes, second: seconds)) ?? Date()
}

enum Constants {
    static let previewChartHeight: CGFloat = 100
    static let detailChartHeight: CGFloat = 300
}

/// Data for the daily and monthly sales charts.
enum SalesData {
    /// Sales by day for the last 30 days.
    static let last30Days = [
        (day: date(year: 2022, month: 5, day: 8), sales: 168),
        (day: date(year: 2022, month: 5, day: 9), sales: 117),
        (day: date(year: 2022, month: 5, day: 10), sales: 106),
        (day: date(year: 2022, month: 5, day: 11), sales: 119),
        (day: date(year: 2022, month: 5, day: 12), sales: 109),
        (day: date(year: 2022, month: 5, day: 13), sales: 104),
        (day: date(year: 2022, month: 5, day: 14), sales: 196),
        (day: date(year: 2022, month: 5, day: 15), sales: 172),
        (day: date(year: 2022, month: 5, day: 16), sales: 122),
        (day: date(year: 2022, month: 5, day: 17), sales: 115),
        (day: date(year: 2022, month: 5, day: 18), sales: 138),
        (day: date(year: 2022, month: 5, day: 19), sales: 110),
        (day: date(year: 2022, month: 5, day: 20), sales: 106),
        (day: date(year: 2022, month: 5, day: 21), sales: 187),
        (day: date(year: 2022, month: 5, day: 22), sales: 187),
        (day: date(year: 2022, month: 5, day: 23), sales: 119),
        (day: date(year: 2022, month: 5, day: 24), sales: 160),
        (day: date(year: 2022, month: 5, day: 25), sales: 144),
        (day: date(year: 2022, month: 5, day: 26), sales: 152),
        (day: date(year: 2022, month: 5, day: 27), sales: 148),
        (day: date(year: 2022, month: 5, day: 28), sales: 240),
        (day: date(year: 2022, month: 5, day: 29), sales: 242),
        (day: date(year: 2022, month: 5, day: 30), sales: 173),
        (day: date(year: 2022, month: 5, day: 31), sales: 143),
        (day: date(year: 2022, month: 6, day: 1), sales: 137),
        (day: date(year: 2022, month: 6, day: 2), sales: 123),
        (day: date(year: 2022, month: 6, day: 3), sales: 146),
        (day: date(year: 2022, month: 6, day: 4), sales: 214),
        (day: date(year: 2022, month: 6, day: 5), sales: 250),
        (day: date(year: 2022, month: 6, day: 6), sales: 146)
    ].map { Sale(day: $0.day, sales: $0.sales) }

    /// Total sales for the last 30 days.
    static var last30DaysTotal: Int {
        last30Days.map { $0.sales }.reduce(0, +)
    }

    static var last30DaysAverage: Double {
        Double(last30DaysTotal / last30Days.count)
    }

    /// Sales by month for the last 12 months.
    static let last12Months = [
        (month: date(year: 2021, month: 7), sales: 3952, dailyAverage: 127, dailyMin: 95, dailyMax: 194),
        (month: date(year: 2021, month: 8), sales: 4044, dailyAverage: 130, dailyMin: 96, dailyMax: 189),
        (month: date(year: 2021, month: 9), sales: 3930, dailyAverage: 131, dailyMin: 101, dailyMax: 184),
        (month: date(year: 2021, month: 10), sales: 4217, dailyAverage: 136, dailyMin: 96, dailyMax: 193),
        (month: date(year: 2021, month: 11), sales: 4006, dailyAverage: 134, dailyMin: 104, dailyMax: 202),
        (month: date(year: 2021, month: 12), sales: 3994, dailyAverage: 129, dailyMin: 96, dailyMax: 190),
        (month: date(year: 2022, month: 1), sales: 4202, dailyAverage: 136, dailyMin: 96, dailyMax: 203),
        (month: date(year: 2022, month: 2), sales: 3749, dailyAverage: 134, dailyMin: 98, dailyMax: 200),
        (month: date(year: 2022, month: 3), sales: 4329, dailyAverage: 140, dailyMin: 104, dailyMax: 218),
        (month: date(year: 2022, month: 4), sales: 4084, dailyAverage: 136, dailyMin: 93, dailyMax: 221),
        (month: date(year: 2022, month: 5), sales: 4559, dailyAverage: 147, dailyMin: 104, dailyMax: 242),
        (month: date(year: 2022, month: 6), sales: 1023, dailyAverage: 170, dailyMin: 120, dailyMax: 250)
    ]

    /// Total sales for the last 12 months.
    static var last12MonthsTotal: Int {
        last12Months.map { $0.sales }.reduce(0, +)
    }

    static var last12MonthsDailyAverage: Int {
        last12Months.map { $0.dailyAverage }.reduce(0, +) / last12Months.count
    }
}

struct Sale {
    let day: Date
    var sales: Int
}

/// Data for the sales by location and weekday charts.
enum LocationData {
    /// A data series for the lines.
    struct Series: Identifiable {
        /// The name of the city.
        let city: String

        /// Average daily sales for each weekday.
        /// The `weekday` property is a `Date` that represents a weekday.
        let sales: [(weekday: Date, sales: Int)]

        /// The identifier for the series.
        var id: String { city }
    }
    
    /// Sales by location and weekday for the last 7 days.
    static let last7Days: [Series] = [
        .init(city: "Cupertino", sales: [
            (weekday: date(year: 2022, month: 5, day: 1), sales: 54),
            (weekday: date(year: 2022, month: 5, day: 2), sales: 42),
            (weekday: date(year: 2022, month: 5, day: 3), sales: 88),
            (weekday: date(year: 2022, month: 5, day: 4), sales: 49),
            (weekday: date(year: 2022, month: 5, day: 5), sales: 42),
            (weekday: date(year: 2022, month: 5, day: 6), sales: 61),
            (weekday: date(year: 2022, month: 5, day: 7), sales: 67)
        ]),
        .init(city: "San Francisco", sales: [
            (weekday: date(year: 2022, month: 5, day: 1), sales: 81),
            (weekday: date(year: 2022, month: 5, day: 2), sales: 90),
            (weekday: date(year: 2022, month: 5, day: 3), sales: 52),
            (weekday: date(year: 2022, month: 5, day: 4), sales: 72),
            (weekday: date(year: 2022, month: 5, day: 5), sales: 84),
            (weekday: date(year: 2022, month: 5, day: 6), sales: 84),
            (weekday: date(year: 2022, month: 5, day: 7), sales: 137)
        ])
    ]

    /// Sales by location and weekday for the last 30 days.
    static let last30Days: [Series] = [
        .init(city: "Cupertino", sales: [
            (weekday: date(year: 2022, month: 5, day: 1), sales: 54),
            (weekday: date(year: 2022, month: 5, day: 2), sales: 42),
            (weekday: date(year: 2022, month: 5, day: 3), sales: 88),
            (weekday: date(year: 2022, month: 5, day: 4), sales: 49),
            (weekday: date(year: 2022, month: 5, day: 5), sales: 42),
            (weekday: date(year: 2022, month: 5, day: 6), sales: 61),
            (weekday: date(year: 2022, month: 5, day: 7), sales: 67),
            (weekday: date(year: 2022, month: 5, day: 8), sales: 54),
            (weekday: date(year: 2022, month: 5, day: 9), sales: 47),
            (weekday: date(year: 2022, month: 5, day: 10), sales: 42),
            (weekday: date(year: 2022, month: 5, day: 11), sales: 71),
            (weekday: date(year: 2022, month: 5, day: 12), sales: 56),
            (weekday: date(year: 2022, month: 5, day: 13), sales: 81),
            (weekday: date(year: 2022, month: 5, day: 14), sales: 40),
            (weekday: date(year: 2022, month: 5, day: 15), sales: 49),
            (weekday: date(year: 2022, month: 5, day: 16), sales: 42),
            (weekday: date(year: 2022, month: 5, day: 17), sales: 58),
            (weekday: date(year: 2022, month: 5, day: 18), sales: 66),
            (weekday: date(year: 2022, month: 5, day: 19), sales: 62),
            (weekday: date(year: 2022, month: 5, day: 20), sales: 77),
            (weekday: date(year: 2022, month: 5, day: 21), sales: 55),
            (weekday: date(year: 2022, month: 5, day: 22), sales: 52),
            (weekday: date(year: 2022, month: 5, day: 23), sales: 42),
            (weekday: date(year: 2022, month: 5, day: 24), sales: 49),
            (weekday: date(year: 2022, month: 5, day: 25), sales: 58),
            (weekday: date(year: 2022, month: 5, day: 26), sales: 61),
            (weekday: date(year: 2022, month: 5, day: 27), sales: 68),
            (weekday: date(year: 2022, month: 5, day: 28), sales: 43),
            (weekday: date(year: 2022, month: 5, day: 29), sales: 49),
            (weekday: date(year: 2022, month: 5, day: 30), sales: 125)
        ]),
        .init(city: "San Francisco", sales: [
            (weekday: date(year: 2022, month: 5, day: 1), sales: 81),
            (weekday: date(year: 2022, month: 5, day: 2), sales: 90),
            (weekday: date(year: 2022, month: 5, day: 3), sales: 52),
            (weekday: date(year: 2022, month: 5, day: 4), sales: 72),
            (weekday: date(year: 2022, month: 5, day: 5), sales: 84),
            (weekday: date(year: 2022, month: 5, day: 6), sales: 84),
            (weekday: date(year: 2022, month: 5, day: 7), sales: 137),
            (weekday: date(year: 2022, month: 5, day: 8), sales: 99),
            (weekday: date(year: 2022, month: 5, day: 9), sales: 81),
            (weekday: date(year: 2022, month: 5, day: 10), sales: 52),
            (weekday: date(year: 2022, month: 5, day: 11), sales: 66),
            (weekday: date(year: 2022, month: 5, day: 12), sales: 84),
            (weekday: date(year: 2022, month: 5, day: 13), sales: 84),
            (weekday: date(year: 2022, month: 5, day: 14), sales: 122),
            (weekday: date(year: 2022, month: 5, day: 15), sales: 147),
            (weekday: date(year: 2022, month: 5, day: 16), sales: 66),
            (weekday: date(year: 2022, month: 5, day: 17), sales: 72),
            (weekday: date(year: 2022, month: 5, day: 18), sales: 62),
            (weekday: date(year: 2022, month: 5, day: 19), sales: 55),
            (weekday: date(year: 2022, month: 5, day: 20), sales: 84),
            (weekday: date(year: 2022, month: 5, day: 21), sales: 122),
            (weekday: date(year: 2022, month: 5, day: 22), sales: 81),
            (weekday: date(year: 2022, month: 5, day: 23), sales: 95),
            (weekday: date(year: 2022, month: 5, day: 24), sales: 63),
            (weekday: date(year: 2022, month: 5, day: 25), sales: 72),
            (weekday: date(year: 2022, month: 5, day: 26), sales: 74),
            (weekday: date(year: 2022, month: 5, day: 27), sales: 79),
            (weekday: date(year: 2022, month: 5, day: 28), sales: 93),
            (weekday: date(year: 2022, month: 5, day: 29), sales: 84),
            (weekday: date(year: 2022, month: 5, day: 30), sales: 87)
        ])
    ]

    /// The best weekday and location for the last 30 days.
    static let last30DaysBest = (
        city: "San Francisco",
        weekday: date(year: 2022, month: 5, day: 8),
        sales: 137
    )

    /// The best weekday and location for the last 12 months.
    static let last12MonthsBest = (
        city: "San Francisco",
        weekday: date(year: 2022, month: 5, day: 8),
        sales: 113
    )

    /// Sales by location and weekday for the last 12 months.
    static let last12Months: [Series] = [
        .init(city: "Cupertino", sales: [
            (weekday: date(year: 2022, month: 5, day: 2), sales: 64),
            (weekday: date(year: 2022, month: 5, day: 3), sales: 60),
            (weekday: date(year: 2022, month: 5, day: 4), sales: 47),
            (weekday: date(year: 2022, month: 5, day: 5), sales: 55),
            (weekday: date(year: 2022, month: 5, day: 6), sales: 55),
            (weekday: date(year: 2022, month: 5, day: 7), sales: 105),
            (weekday: date(year: 2022, month: 5, day: 8), sales: 67)
        ]),
        .init(city: "San Francisco", sales: [
            (weekday: date(year: 2022, month: 5, day: 2), sales: 57),
            (weekday: date(year: 2022, month: 5, day: 3), sales: 56),
            (weekday: date(year: 2022, month: 5, day: 4), sales: 66),
            (weekday: date(year: 2022, month: 5, day: 5), sales: 61),
            (weekday: date(year: 2022, month: 5, day: 6), sales: 60),
            (weekday: date(year: 2022, month: 5, day: 7), sales: 77),
            (weekday: date(year: 2022, month: 5, day: 8), sales: 113)
        ])
    ]
}

struct PopulationByAgeData {
    /// A data series for the bars.
    struct Series: Identifiable {
        typealias Population = (ageRange: String, percentage: Int)

        /// Sex.
        let sex: String

        /// Percentage population for ageRange
        let population: [Population]

        /// The identifier for the series.
        var id: String { sex }
    }

    /// Sales by location and weekday for the last 12 months.
    static let example: [Series] = [
        .init(sex: "Male", population: [
            (ageRange: "0-10", percentage: 3),
            (ageRange: "11-20", percentage: 29),
            (ageRange: "21-30", percentage: 14),
            (ageRange: "31-40", percentage: 4),
            (ageRange: "41-50", percentage: 7),
            (ageRange: "51-60", percentage: 2),
            (ageRange: "61-70", percentage: 25),
            (ageRange: "71-80", percentage: 6),
            (ageRange: "81-90", percentage: 9),
            (ageRange: "91+", percentage: 1)
        ]),
        .init(sex: "Female", population: [
            (ageRange: "0-10", percentage: 38),
            (ageRange: "11-20", percentage: 2),
            (ageRange: "21-30", percentage: 10),
            (ageRange: "31-40", percentage: 22),
            (ageRange: "41-50", percentage: 7),
            (ageRange: "51-60", percentage: 4),
            (ageRange: "61-70", percentage: 3),
            (ageRange: "71-80", percentage: 5),
            (ageRange: "81-90", percentage: 1),
            (ageRange: "91+", percentage: 8)
        ]),
    ]
}

struct DataUsageData {
    /// A data series for the bars.
    struct Series: Identifiable {
        /// Data Group.
        let category: String

        /// Size of data in gigabytes?
        let size: Double

        /// The identifier for the series.
        var id: String { category }
    }

    static let example: [Series] = [
        .init(category: "Apps", size: 61.6),
        .init(category: "Photos", size: 8.2),
        .init(category: "iOS", size: 5.7),
        .init(category: "System Data", size: 2.6)
    ]
}

// MARK: - Heart Rate data

enum HeartRateData {
    /// Heart Rate for the last week
    static let lastWeek = [
        (weekday: date(year: 2022, month: 7, day: 1), dailyAverage: 127, dailyMin: 95, dailyMax: 194),
        (weekday: date(year: 2022, month: 7, day: 1), dailyAverage: 130, dailyMin: 200, dailyMax: 239),

        (weekday: date(year: 2022, month: 7, day: 2), dailyAverage: 131, dailyMin: 101, dailyMax: 184),

        (weekday: date(year: 2022, month: 7, day: 3), dailyAverage: 136, dailyMin: 96, dailyMax: 193),
        (weekday: date(year: 2022, month: 7, day: 3), dailyAverage: 136, dailyMin: 80, dailyMax: 93),

        (weekday: date(year: 2022, month: 7, day: 4), dailyAverage: 134, dailyMin: 104, dailyMax: 202),

        (weekday: date(year: 2022, month: 7, day: 5), dailyAverage: 129, dailyMin: 90, dailyMax: 95),
        (weekday: date(year: 2022, month: 7, day: 5), dailyAverage: 129, dailyMin: 96, dailyMax: 190),

        (weekday: date(year: 2022, month: 7, day: 6), dailyAverage: 136, dailyMin: 96, dailyMax: 203),

        (weekday: date(year: 2022, month: 7, day: 7), dailyAverage: 134, dailyMin: 98, dailyMax: 200)
    ]

    // MARK: - Static constants

    static let minBPM: Int = {
        Self.lastWeek.min { a, b in
            a.dailyMin < b.dailyMin
        }?.dailyMin ?? 0
    }()

    static let maxBPM: Int = {
        Self.lastWeek.max { a, b in
            a.dailyMax < b.dailyMax
        }?.dailyMax ?? 0
    }()

    static let earliestDate: Date = {
        Self.lastWeek.min { a, b in
            a.weekday < b.weekday
        }?.weekday ?? Date()
    }()

    static let latestDate: Date = {
        Self.lastWeek.max { a, b in
            a.weekday < b.weekday
        }?.weekday ?? Date()
    }()

    static let dateInterval: DateInterval = {
        DateInterval(start: earliestDate, end: latestDate)
    }()
}

// MARK: - Time Sheet data

enum TimeSheetData {
    static let lastDay = [
        /// Monday
        (department: "Bread", clockIn: date(year: 2022, month: 6, day: 13, hour: 08, minutes: 00), clockOut: date(year: 2022, month: 6, day: 13, hour: 09, minutes: 28)),
        (department: "Bread", clockIn: date(year: 2022, month: 6, day: 13, hour: 09, minutes: 47), clockOut: date(year: 2022, month: 6, day: 13, hour: 12, minutes: 04)),
        (department: "Butchery", clockIn: date(year: 2022, month: 6, day: 13, hour: 13, minutes: 01), clockOut: date(year: 2022, month: 6, day: 13, hour: 15, minutes: 10)),
        (department: "Butchery", clockIn: date(year: 2022, month: 6, day: 13, hour: 15, minutes: 33), clockOut: date(year: 2022, month: 6, day: 13, hour: 17, minutes: 01)),
        (department: "Vegetables", clockIn: date(year: 2022, month: 6, day: 13, hour: 17, minutes: 02), clockOut: date(year: 2022, month: 6, day: 13, hour: 18, minutes: 08))
        ]
    /// Time Sheet Date for the last week
    static let lastWeek = [
        /// Monday
        (department: "Bread", clockIn: date(year: 2022, month: 6, day: 13, hour: 08, minutes: 00), clockOut: date(year: 2022, month: 6, day: 13, hour: 09, minutes: 28)),
        (department: "Bread", clockIn: date(year: 2022, month: 6, day: 13, hour: 09, minutes: 47), clockOut: date(year: 2022, month: 6, day: 13, hour: 12, minutes: 04)),
        (department: "Butchery", clockIn: date(year: 2022, month: 6, day: 13, hour: 13, minutes: 01), clockOut: date(year: 2022, month: 6, day: 13, hour: 15, minutes: 10)),
        (department: "Butchery", clockIn: date(year: 2022, month: 6, day: 13, hour: 15, minutes: 33), clockOut: date(year: 2022, month: 6, day: 13, hour: 17, minutes: 01)),
        (department: "Vegetables", clockIn: date(year: 2022, month: 6, day: 13, hour: 17, minutes: 02), clockOut: date(year: 2022, month: 6, day: 13, hour: 18, minutes: 08)),
        /// Tuesday
        (department: "Bread", clockIn: date(year: 2022, month: 6, day: 14, hour: 08, minutes: 00), clockOut: date(year: 2022, month: 6, day: 14, hour: 09, minutes: 28)),
        (department: "Bread", clockIn: date(year: 2022, month: 6, day: 14, hour: 09, minutes: 47), clockOut: date(year: 2022, month: 6, day: 14, hour: 12, minutes: 04)),
        (department: "Bread", clockIn: date(year: 2022, month: 6, day: 14, hour: 13, minutes: 01), clockOut: date(year: 2022, month: 6, day: 14, hour: 15, minutes: 10)),
        (department: "Bread", clockIn: date(year: 2022, month: 6, day: 14, hour: 15, minutes: 33), clockOut: date(year: 2022, month: 6, day: 14, hour: 17, minutes: 01)),
        /// Wednesday
        (department: "Counter", clockIn: date(year: 2022, month: 6, day: 15, hour: 15, minutes: 58), clockOut: date(year: 2022, month: 6, day: 15, hour: 18, minutes: 34)),
        (department: "Counter", clockIn: date(year: 2022, month: 6, day: 15, hour: 19, minutes: 03), clockOut: date(year: 2022, month: 6, day: 15, hour: 22, minutes: 10)),
        /// Thursday
        (department: "Vegetables", clockIn: date(year: 2022, month: 6, day: 17, hour: 05, minutes: 15), clockOut: date(year: 2022, month: 6, day: 17, hour: 06, minutes: 13)),
        (department: "Vegetables", clockIn: date(year: 2022, month: 6, day: 17, hour: 06, minutes: 33), clockOut: date(year: 2022, month: 6, day: 17, hour: 08, minutes: 52)),
        (department: "Vegetables", clockIn: date(year: 2022, month: 6, day: 17, hour: 09, minutes: 15), clockOut: date(year: 2022, month: 6, day: 17, hour: 11, minutes: 46)),
        (department: "Vegetables", clockIn: date(year: 2022, month: 6, day: 17, hour: 12, minutes: 58), clockOut: date(year: 2022, month: 6, day: 17, hour: 14, minutes: 26)),
        (department: "Vegetables", clockIn: date(year: 2022, month: 6, day: 17, hour: 15, minutes: 05), clockOut: date(year: 2022, month: 6, day: 17, hour: 15, minutes: 51)),
        (department: "Vegetables", clockIn: date(year: 2022, month: 6, day: 17, hour: 19, minutes: 33), clockOut: date(year: 2022, month: 6, day: 17, hour: 21, minutes: 01))
    ]
}

// MARK: - Weather Data

enum WeatherData {
	static let hourlyUVIndex: [(date: Date, uvIndex: Int)] = [
		(.startOfDay.addingTimeInterval(3600*0), 0),
		(.startOfDay.addingTimeInterval(3600*1), 0),
		(.startOfDay.addingTimeInterval(3600*2), 0),
		(.startOfDay.addingTimeInterval(3600*3), 0),
		(.startOfDay.addingTimeInterval(3600*4), 0),
		(.startOfDay.addingTimeInterval(3600*5), 0),
		(.startOfDay.addingTimeInterval(3600*6), 0),
		(.startOfDay.addingTimeInterval(3600*7), 1),
		(.startOfDay.addingTimeInterval(3600*8), 4),
		(.startOfDay.addingTimeInterval(3600*9), 6),
		(.startOfDay.addingTimeInterval(3600*10), 9),
		(.startOfDay.addingTimeInterval(3600*11), 12),
		(.startOfDay.addingTimeInterval(3600*12), 12),
		(.startOfDay.addingTimeInterval(3600*13), 11),
		(.startOfDay.addingTimeInterval(3600*14), 9),
		(.startOfDay.addingTimeInterval(3600*15), 6),
		(.startOfDay.addingTimeInterval(3600*16), 3),
		(.startOfDay.addingTimeInterval(3600*17), 1),
		(.startOfDay.addingTimeInterval(3600*18), 0),
		(.startOfDay.addingTimeInterval(3600*19), 0),
		(.startOfDay.addingTimeInterval(3600*20), 0),
		(.startOfDay.addingTimeInterval(3600*21), 0),
		(.startOfDay.addingTimeInterval(3600*22), 0),
		(.startOfDay.addingTimeInterval(3600*23), 0)
	]
}

extension Date {
	static var startOfDay: Date {
		Calendar.current.startOfDay(for: .now)
	}
}

extension Date {
	func nearestHour() -> Date? {
		var components = NSCalendar.current.dateComponents([.minute, .second, .nanosecond], from: self)
		let minute = components.minute ?? 0
		let second = components.second ?? 0
		let nanosecond = components.nanosecond ?? 0
		components.minute = minute >= 30 ? 60 - minute : -minute
		components.second = -second
		components.nanosecond = -nanosecond
		return Calendar.current.date(byAdding: components, to: self)
	}
}

extension Array {
	func appending(contentsOf: [Element]) -> Array {
		var a = Array(self)
		a.append(contentsOf: contentsOf)
		return a
	}
}
