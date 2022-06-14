//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation

func makeDate(
	year: Int,
	month: Int,
	day: Int = 1,
	hour: Int = 0,
	minutes: Int = 0,
	seconds: Int = 0
) -> Date {
	let components = DateComponents(
		year: year,
		month: month,
		day: day,
		hour: hour,
		minute: minutes,
		second: seconds
	)
    return Calendar.current.date(from: components) ?? Date()
}

public enum Constants {
    public static let previewChartHeight: CGFloat = 100
    public static let detailChartHeight: CGFloat = 300
}

/// Data for the daily and monthly sales charts.
public enum SalesData {
    /// Sales by day for the last 30 days.
    public static let last30Days = [
        (day: makeDate(year: 2022, month: 5, day: 8), sales: 168),
        (day: makeDate(year: 2022, month: 5, day: 9), sales: 117),
        (day: makeDate(year: 2022, month: 5, day: 10), sales: 106),
        (day: makeDate(year: 2022, month: 5, day: 11), sales: 119),
        (day: makeDate(year: 2022, month: 5, day: 12), sales: 109),
        (day: makeDate(year: 2022, month: 5, day: 13), sales: 104),
        (day: makeDate(year: 2022, month: 5, day: 14), sales: 196),
        (day: makeDate(year: 2022, month: 5, day: 15), sales: 172),
        (day: makeDate(year: 2022, month: 5, day: 16), sales: 122),
        (day: makeDate(year: 2022, month: 5, day: 17), sales: 115),
        (day: makeDate(year: 2022, month: 5, day: 18), sales: 138),
        (day: makeDate(year: 2022, month: 5, day: 19), sales: 110),
        (day: makeDate(year: 2022, month: 5, day: 20), sales: 106),
        (day: makeDate(year: 2022, month: 5, day: 21), sales: 187),
        (day: makeDate(year: 2022, month: 5, day: 22), sales: 187),
        (day: makeDate(year: 2022, month: 5, day: 23), sales: 119),
        (day: makeDate(year: 2022, month: 5, day: 24), sales: 160),
        (day: makeDate(year: 2022, month: 5, day: 25), sales: 144),
        (day: makeDate(year: 2022, month: 5, day: 26), sales: 152),
        (day: makeDate(year: 2022, month: 5, day: 27), sales: 148),
        (day: makeDate(year: 2022, month: 5, day: 28), sales: 240),
        (day: makeDate(year: 2022, month: 5, day: 29), sales: 242),
        (day: makeDate(year: 2022, month: 5, day: 30), sales: 173),
        (day: makeDate(year: 2022, month: 5, day: 31), sales: 143),
        (day: makeDate(year: 2022, month: 6, day: 1), sales: 137),
        (day: makeDate(year: 2022, month: 6, day: 2), sales: 123),
        (day: makeDate(year: 2022, month: 6, day: 3), sales: 146),
        (day: makeDate(year: 2022, month: 6, day: 4), sales: 214),
        (day: makeDate(year: 2022, month: 6, day: 5), sales: 250),
        (day: makeDate(year: 2022, month: 6, day: 6), sales: 146)
    ]

    /// Total sales for the last 30 days.
    public static var last30DaysTotal: Int {
        last30Days.map { $0.sales }.reduce(0, +)
    }

    public static var last30DaysAverage: Double {
        Double(last30DaysTotal / last30Days.count)
    }

    /// Sales by month for the last 12 months.
    public static let last12Months = [
        (month: makeDate(year: 2021, month: 7), sales: 3952, dailyAverage: 127, dailyMin: 95, dailyMax: 194),
        (month: makeDate(year: 2021, month: 8), sales: 4044, dailyAverage: 130, dailyMin: 96, dailyMax: 189),
        (month: makeDate(year: 2021, month: 9), sales: 3930, dailyAverage: 131, dailyMin: 101, dailyMax: 184),
        (month: makeDate(year: 2021, month: 10), sales: 4217, dailyAverage: 136, dailyMin: 96, dailyMax: 193),
        (month: makeDate(year: 2021, month: 11), sales: 4006, dailyAverage: 134, dailyMin: 104, dailyMax: 202),
        (month: makeDate(year: 2021, month: 12), sales: 3994, dailyAverage: 129, dailyMin: 96, dailyMax: 190),
        (month: makeDate(year: 2022, month: 1), sales: 4202, dailyAverage: 136, dailyMin: 96, dailyMax: 203),
        (month: makeDate(year: 2022, month: 2), sales: 3749, dailyAverage: 134, dailyMin: 98, dailyMax: 200),
        (month: makeDate(year: 2022, month: 3), sales: 4329, dailyAverage: 140, dailyMin: 104, dailyMax: 218),
        (month: makeDate(year: 2022, month: 4), sales: 4084, dailyAverage: 136, dailyMin: 93, dailyMax: 221),
        (month: makeDate(year: 2022, month: 5), sales: 4559, dailyAverage: 147, dailyMin: 104, dailyMax: 242),
        (month: makeDate(year: 2022, month: 6), sales: 1023, dailyAverage: 170, dailyMin: 120, dailyMax: 250)
    ]

    /// Total sales for the last 12 months.
    public static var last12MonthsTotal: Int {
        last12Months.map { $0.sales }.reduce(0, +)
    }

    public static var last12MonthsDailyAverage: Int {
        last12Months.map { $0.dailyAverage }.reduce(0, +) / last12Months.count
    }
}

/// Data for the sales by location and weekday charts.
public enum LocationData {
    /// A data series for the lines.
    public struct Series: Identifiable {
        /// The name of the city.
        public let city: String

        /// Average daily sales for each weekday.
        /// The `weekday` property is a `Date` that represents a weekday.
        public let sales: [(weekday: Date, sales: Int)]

        /// The identifier for the series.
        public var id: String { city }
    }

    /// Sales by location and weekday for the last 30 days.
    public static let last30Days: [Series] = [
        .init(city: "Cupertino", sales: [
            (weekday: makeDate(year: 2022, month: 5, day: 2), sales: 54),
            (weekday: makeDate(year: 2022, month: 5, day: 3), sales: 42),
            (weekday: makeDate(year: 2022, month: 5, day: 4), sales: 88),
            (weekday: makeDate(year: 2022, month: 5, day: 5), sales: 49),
            (weekday: makeDate(year: 2022, month: 5, day: 6), sales: 42),
            (weekday: makeDate(year: 2022, month: 5, day: 7), sales: 125),
            (weekday: makeDate(year: 2022, month: 5, day: 8), sales: 67)

        ]),
        .init(city: "San Francisco", sales: [
            (weekday: makeDate(year: 2022, month: 5, day: 2), sales: 81),
            (weekday: makeDate(year: 2022, month: 5, day: 3), sales: 90),
            (weekday: makeDate(year: 2022, month: 5, day: 4), sales: 52),
            (weekday: makeDate(year: 2022, month: 5, day: 5), sales: 72),
            (weekday: makeDate(year: 2022, month: 5, day: 6), sales: 84),
            (weekday: makeDate(year: 2022, month: 5, day: 7), sales: 84),
            (weekday: makeDate(year: 2022, month: 5, day: 8), sales: 137)
        ])
    ]

    /// The best weekday and location for the last 30 days.
    public static let last30DaysBest = (
        city: "San Francisco",
        weekday: makeDate(year: 2022, month: 5, day: 8),
        sales: 137
    )

    /// The best weekday and location for the last 12 months.
    public static let last12MonthsBest = (
        city: "San Francisco",
        weekday: makeDate(year: 2022, month: 5, day: 8),
        sales: 113
    )

    /// Sales by location and weekday for the last 12 months.
    public static let last12Months: [Series] = [
        .init(city: "Cupertino", sales: [
            (weekday: makeDate(year: 2022, month: 5, day: 2), sales: 64),
            (weekday: makeDate(year: 2022, month: 5, day: 3), sales: 60),
            (weekday: makeDate(year: 2022, month: 5, day: 4), sales: 47),
            (weekday: makeDate(year: 2022, month: 5, day: 5), sales: 55),
            (weekday: makeDate(year: 2022, month: 5, day: 6), sales: 55),
            (weekday: makeDate(year: 2022, month: 5, day: 7), sales: 105),
            (weekday: makeDate(year: 2022, month: 5, day: 8), sales: 67)
        ]),
        .init(city: "San Francisco", sales: [
            (weekday: makeDate(year: 2022, month: 5, day: 2), sales: 57),
            (weekday: makeDate(year: 2022, month: 5, day: 3), sales: 56),
            (weekday: makeDate(year: 2022, month: 5, day: 4), sales: 66),
            (weekday: makeDate(year: 2022, month: 5, day: 5), sales: 61),
            (weekday: makeDate(year: 2022, month: 5, day: 6), sales: 60),
            (weekday: makeDate(year: 2022, month: 5, day: 7), sales: 77),
            (weekday: makeDate(year: 2022, month: 5, day: 8), sales: 113)
        ])
    ]
}

public struct PopulationByAgeData {
    /// A data series for the bars.
    public struct Series: Identifiable {
		public typealias Population = [(ageRange: String, percentage: Int)]
        /// Sex.
        public let sex: String

        /// Percentage population for ageRange
        public let population: Population

        /// The identifier for the series.
        public var id: String { sex }

		public init(sex: String, population: Population) {
			self.sex = sex
			self.population = population
		}
    }
    
    /// Sales by location and weekday for the last 12 months.
    public static let example: [Series] = [
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

public struct DataUsageData {
    /// A data series for the bars.
    public struct Series: Identifiable {
        /// Data Group.
        public let category: String

        /// Size of data in gigabytes?
        public let size: Double

        /// The identifier for the series.
        public var id: String { category }
    }
    
    public static let example: [Series] = [
        .init(category: "Apps", size: 61.6),
        .init(category: "Photos", size: 8.2),
        .init(category: "iOS", size: 5.7),
        .init(category: "System Data", size: 2.6)
//        .init(category: "Photos", size: )
        
    ]
}
