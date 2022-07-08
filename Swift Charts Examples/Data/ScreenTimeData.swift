//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation
import Charts

enum ScreenTimeCategory: String, Plottable {
	case social = "Social"
	case entertainment = "Entertainment"
	case productivityFinance = "Productivity & Finance"
	case other = "Other"

	var index: Int {
		switch self {
		case .social:
			return 0
		case .entertainment:
			return 1
		case .productivityFinance:
			return 2
		case .other:
			return 3
		}
	}
}

struct ScreenTimeValue: Identifiable {
	let valueDate: Date
	let category: ScreenTimeCategory
	var duration: TimeInterval

	var id: Date { valueDate }
}

extension ScreenTimeValue {
	static var week: [ScreenTimeValue] = []
		.appending(contentsOf: Self.monday)
		.appending(contentsOf: Self.tuesday)
		.appending(contentsOf: Self.wednesday)
		.appending(contentsOf: Self.thursday)
		.appending(contentsOf: Self.friday)
		.appending(contentsOf: Self.saturday)
		.appending(contentsOf: Self.sunday)

	static var monday: [ScreenTimeValue] = [
		// 12 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 00), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 00), category: .other, duration: 33*60),
		// 1 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 01), category: .social, duration: 16*60),
		// 6 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 06), category: .social, duration: 12*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 06), category: .other, duration: 2*60),
		// 7 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 07), category: .social, duration: 32*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 07), category: .entertainment, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 07), category: .productivityFinance, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 07), category: .other, duration: 2*60),
		// 8 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 08), category: .social, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 08), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 08), category: .other, duration: 3*60),
		// 9 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 09), category: .social, duration: 7*60),
		// 11 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 11), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 11), category: .other, duration: 60),
		// 12 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 12), category: .social, duration: 35*60),
		// 1 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 13), category: .social, duration: 7*60),
		// 2 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 14), category: .social, duration: 6*60),
		// 3 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 15), category: .social, duration: 5*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 15), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 15), category: .other, duration: 2*60),
		// 4 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 16), category: .social, duration: 38*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 16), category: .entertainment, duration: 60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 16), category: .other, duration: 3*60),
		// 5 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 17), category: .social, duration: 27*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 17), category: .entertainment, duration: 20*60),
		// 6 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 18), category: .social, duration: 22*60),
		// 7 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 19), category: .social, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 19), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 19), category: .other, duration: 2*60),
		// 8 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 20), category: .social, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 20), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 20), category: .other, duration: 13*60),
		// 9 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 21), category: .social, duration: 11*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 21), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 21), category: .productivityFinance, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 21), category: .other, duration: 5*60),
		// 10 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 22), category: .productivityFinance, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 22), category: .other, duration: 60),
		// 11 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 23), category: .social, duration: 28*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 23), category: .productivityFinance, duration: 2*60),
	]
	static var tuesday: [ScreenTimeValue] = [
		// 12 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 00), category: .social, duration: 5*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 00), category: .other, duration: 30),
		// 6 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 06), category: .social, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 06), category: .other, duration: 60),
		// 7 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 07), category: .social, duration: 14*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 07), category: .other, duration: 60),
		// 8 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 08), category: .social, duration: 8*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 08), category: .other, duration: 2*60),
		// 10 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 10), category: .social, duration: 30),
		// 11 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 11), category: .social, duration: 5*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 11), category: .other, duration: 60),
		// 12 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 12), category: .social, duration: 8*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 12), category: .social, duration: 30),
		// 4 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 16), category: .social, duration: 2*60),
		// 5 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 17), category: .social, duration: 8*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 17), category: .other, duration: 60),
		// 6 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 18), category: .social, duration: 16*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 18), category: .entertainment, duration: 29*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 18), category: .productivityFinance, duration: 12*60),
		// 7 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 19), category: .social, duration: 9*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 19), category: .entertainment, duration: 5*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 19), category: .other, duration: 60),
		// 8 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 20), category: .social, duration: 10*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 20), category: .productivityFinance, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 20), category: .other, duration: 11*60),
		// 9 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 21), category: .social, duration: 8*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 21), category: .entertainment, duration: 3*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 21), category: .other, duration: 30*60),
		// 10 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 22), category: .social, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 22), category: .other, duration: 43*60),
		// 11 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 23), category: .social, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 23), category: .entertainment, duration: 35*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 23), category: .other, duration: 8*60),
	]
	static var wednesday: [ScreenTimeValue] = [
		// 12 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 00), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 00), category: .other, duration: 33*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 01), category: .social, duration: 16*60),
		// 6 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 06), category: .social, duration: 12*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 06), category: .other, duration: 2*60),
		// 7 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 07), category: .social, duration: 32*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 07), category: .entertainment, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 07), category: .productivityFinance, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 07), category: .other, duration: 2*60),
		// 8 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 08), category: .social, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 08), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 08), category: .other, duration: 3*60),
		// 9 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 09), category: .social, duration: 7*60),
		// 11 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 11), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 11), category: .other, duration: 60),
		// 12 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 12), category: .social, duration: 35*60),
		// 1 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 13), category: .social, duration: 7*60),
		// 2 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 14), category: .social, duration: 6*60),
		// 3 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 15), category: .social, duration: 5*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 15), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 15), category: .other, duration: 2*60),
		// 4 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 16), category: .social, duration: 38*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 16), category: .entertainment, duration: 60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 16), category: .other, duration: 3*60),
		// 5 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 17), category: .social, duration: 27*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 17), category: .entertainment, duration: 20*60),
		// 6 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 18), category: .social, duration: 22*60),
		// 7 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 19), category: .social, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 19), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 19), category: .other, duration: 2*60),
		// 8 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 20), category: .social, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 20), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 20), category: .other, duration: 13*60),
		// 9 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 21), category: .social, duration: 11*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 21), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 21), category: .productivityFinance, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 21), category: .other, duration: 5*60),
		// 10 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 22), category: .productivityFinance, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 22), category: .other, duration: 60),
		// 11 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 23), category: .social, duration: 28*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 23), category: .productivityFinance, duration: 2*60),
	]
	static var thursday: [ScreenTimeValue] = [
		// 12 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 00), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 00), category: .other, duration: 33*60),
		// 1 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 01), category: .social, duration: 16*60),
		// 6 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 06), category: .social, duration: 12*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 06), category: .other, duration: 2*60),
		// 7 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 07), category: .social, duration: 32*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 07), category: .entertainment, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 07), category: .productivityFinance, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 07), category: .other, duration: 2*60),
		// 8 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 08), category: .social, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 08), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 08), category: .other, duration: 3*60),
		// 9 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 09), category: .social, duration: 7*60),
		// 11 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 11), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 11), category: .other, duration: 60),
		// 12 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 12), category: .social, duration: 35*60),
		// 1 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 13), category: .social, duration: 7*60),
		// 2 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 14), category: .social, duration: 6*60),
		// 3 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 15), category: .social, duration: 5*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 15), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 15), category: .other, duration: 2*60),
		// 4 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 16), category: .social, duration: 38*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 16), category: .entertainment, duration: 60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 16), category: .other, duration: 3*60),
		// 5 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 17), category: .social, duration: 27*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 17), category: .entertainment, duration: 20*60),
		// 6 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 18), category: .social, duration: 22*60),
		// 7 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 19), category: .social, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 19), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 19), category: .other, duration: 2*60),
		// 8 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 20), category: .social, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 20), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 20), category: .other, duration: 13*60),
		// 9 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 21), category: .social, duration: 11*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 21), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 21), category: .productivityFinance, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 21), category: .other, duration: 5*60),
		// 10 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 22), category: .productivityFinance, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 22), category: .other, duration: 60),
		// 11 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 23), category: .social, duration: 28*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 23), category: .productivityFinance, duration: 2*60),
	]
	static var friday: [ScreenTimeValue] = [
		// 12 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 00), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 00), category: .other, duration: 33*60),
		// 1 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 01), category: .social, duration: 16*60),
		// 6 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 06), category: .social, duration: 12*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 06), category: .other, duration: 2*60),
		// 7 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 07), category: .social, duration: 32*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 07), category: .entertainment, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 07), category: .productivityFinance, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 07), category: .other, duration: 2*60),
		// 8 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 08), category: .social, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 08), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 08), category: .other, duration: 3*60),
		// 9 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 09), category: .social, duration: 7*60),
		// 11 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 11), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 11), category: .other, duration: 60),
		// 12 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 12), category: .social, duration: 35*60),
		// 1 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 13), category: .social, duration: 7*60),
		// 2 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 14), category: .social, duration: 6*60),
		// 3 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 15), category: .social, duration: 5*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 15), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 15), category: .other, duration: 2*60),
		// 4 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 16), category: .social, duration: 38*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 16), category: .entertainment, duration: 60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 16), category: .other, duration: 3*60),
		// 5 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 17), category: .social, duration: 27*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 17), category: .entertainment, duration: 20*60),
		// 6 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 18), category: .social, duration: 22*60),
		// 7 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 19), category: .social, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 19), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 19), category: .other, duration: 2*60),
		// 8 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 20), category: .social, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 20), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 20), category: .other, duration: 13*60),
		// 9 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 21), category: .social, duration: 11*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 21), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 21), category: .productivityFinance, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 21), category: .other, duration: 5*60),
		// 10 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 22), category: .productivityFinance, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 22), category: .other, duration: 60),
		// 11 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 23), category: .social, duration: 28*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 23), category: .productivityFinance, duration: 2*60),
	]
	static var saturday: [ScreenTimeValue] = [
		// 12 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 00), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 00), category: .other, duration: 33*60),
		// 1 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 01), category: .social, duration: 16*60),
		// 6 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 06), category: .social, duration: 12*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 06), category: .other, duration: 2*60),
		// 7 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 07), category: .social, duration: 32*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 07), category: .entertainment, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 07), category: .productivityFinance, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 07), category: .other, duration: 2*60),
		// 8 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 08), category: .social, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 08), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 08), category: .other, duration: 3*60),
		// 9 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 09), category: .social, duration: 7*60),
		// 11 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 11), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 11), category: .other, duration: 60),
		// 12 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 12), category: .social, duration: 35*60),
		// 1 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 13), category: .social, duration: 7*60),
		// 2 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 14), category: .social, duration: 6*60),
		// 3 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 15), category: .social, duration: 5*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 15), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 15), category: .other, duration: 2*60),
		// 4 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 16), category: .social, duration: 38*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 16), category: .entertainment, duration: 60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 16), category: .other, duration: 3*60),
		// 5 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 17), category: .social, duration: 27*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 17), category: .entertainment, duration: 20*60),
		// 6 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 18), category: .social, duration: 22*60),
		// 7 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 19), category: .social, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 19), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 19), category: .other, duration: 2*60),
		// 8 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 20), category: .social, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 20), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 20), category: .other, duration: 13*60),
		// 9 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 21), category: .social, duration: 11*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 21), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 21), category: .productivityFinance, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 21), category: .other, duration: 5*60),
		// 10 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 22), category: .productivityFinance, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 22), category: .other, duration: 60),
		// 11 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 23), category: .social, duration: 28*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 23), category: .productivityFinance, duration: 2*60),
	]
	static var sunday: [ScreenTimeValue] = [
		// 12 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 00), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 00), category: .other, duration: 33*60),
		// 1 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 01), category: .social, duration: 16*60),
		// 6 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 06), category: .social, duration: 12*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 06), category: .other, duration: 2*60),
		// 7 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 07), category: .social, duration: 32*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 07), category: .entertainment, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 07), category: .productivityFinance, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 07), category: .other, duration: 2*60),
		// 8 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 08), category: .social, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 08), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 08), category: .other, duration: 3*60),
		// 9 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 09), category: .social, duration: 7*60),
		// 11 AM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 11), category: .social, duration: 25*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 11), category: .other, duration: 60),
		// 12 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 12), category: .social, duration: 35*60),
		// 1 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 13), category: .social, duration: 7*60),
		// 2 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 14), category: .social, duration: 6*60),
		// 3 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 15), category: .social, duration: 5*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 15), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 15), category: .other, duration: 2*60),
		// 4 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 16), category: .social, duration: 38*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 16), category: .entertainment, duration: 60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 16), category: .other, duration: 3*60),
		// 5 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 17), category: .social, duration: 27*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 17), category: .entertainment, duration: 20*60),
		// 6 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 18), category: .social, duration: 22*60),
		// 7 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 19), category: .social, duration: 2*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 19), category: .entertainment, duration: 30),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 19), category: .other, duration: 2*60),
		// 8 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 20), category: .social, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 20), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 20), category: .other, duration: 13*60),
		// 9 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 21), category: .social, duration: 11*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 21), category: .entertainment, duration: 13*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 21), category: .productivityFinance, duration: 15*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 21), category: .other, duration: 5*60),
		// 10 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 22), category: .productivityFinance, duration: 17*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 22), category: .other, duration: 60),
		// 11 PM
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 23), category: .social, duration: 28*60),
		ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 23), category: .productivityFinance, duration: 2*60),
	]
}

extension Array where Element == ScreenTimeValue {
	func makeDayValues() -> [ScreenTimeValue] {

		let days = Dictionary(grouping: self, by: { Calendar.current.startOfDay(for: $0.valueDate) })

		return days.reduce([ScreenTimeValue]()) { partialResult, day in
			var result = partialResult
			day.value.forEach({ value in
				if let index = result.firstIndex(where: { ($0.category == value.category) && (Calendar.current.isDate($0.valueDate, inSameDayAs: day.key)) }) {
					result[index].duration += value.duration
				} else {
					result.append(ScreenTimeValue(valueDate: day.key, category: value.category, duration: value.duration))
				}
			})
			return result.sorted(by: { $0.category.index < $1.category.index })
		}
	}
}
