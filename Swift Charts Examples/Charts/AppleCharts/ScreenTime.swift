//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct ScreenTime: View {

	var isOverview: Bool

	init(isOverview: Bool) {
		self.isOverview = isOverview
	}

	private var weekData = ScreenTimeValue.week.makeDayValues()
	@State private var selectedDate: Date = date(year: 2022, month: 06, day: 20)

	var body: some View {
		ZStack {
			if isOverview {
				dayChart
					.frame(height: Constants.previewChartHeight)
			} else {
				List {
					Section {
						VStack {
							weekChart
							dayChart
						}
						.frame(height: 300)
					}
				}
				.navigationTitle(ChartType.screenTime.title)
				.navigationBarTitleDisplayMode(.inline)
			}
		}
		.chartForegroundStyleScale([
			ScreenTimeCategory.social: Color.blue,
			ScreenTimeCategory.entertainment: Color.teal,
			ScreenTimeCategory.productivityFinance: Color.orange,
			ScreenTimeCategory.other: Color.gray
		])
	}

	private var weekChart: some View {
		Chart {
			ForEach(weekData) { category in
				let isSelected = Calendar.current.isDate(category.valueDate, inSameDayAs: selectedDate)
				BarMark(
					x: .value("date", category.valueDate, unit: .day),
					y: .value("duration", category.duration)
				)
				.foregroundStyle(by: .value("category", isSelected ? category.category : ScreenTimeCategory.other))
			}
		}
		.chartYAxis {
			AxisMarks(values: .automatic(desiredCount: 3)) { value in
				AxisGridLine()

				let formatter: DateComponentsFormatter = {
					let formatter = DateComponentsFormatter()
					formatter.unitsStyle = .abbreviated
					formatter.allowedUnits = [.hour]
					return formatter
				}()

				if let timeInterval = value.as(TimeInterval.self), let formatted = formatter.string(from: timeInterval) {
					AxisValueLabel(formatted)
				}
			}
		}
		.chartXAxis {
			AxisMarks(values: .stride(by: .day)) { _ in
				AxisGridLine()
				AxisTick()
				AxisValueLabel(format: .dateTime.weekday(.narrow))
			}
		}
		.chartLegend(.hidden)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.chartOverlay { proxy in
			GeometryReader { geo in
				Rectangle().fill(.clear).contentShape(Rectangle())
					.gesture(
						DragGesture(minimumDistance: 0)
							.onChanged { value in
								let x = value.location.x - geo[proxy.plotAreaFrame].origin.x
								if let date: Date = proxy.value(atX: x) {
									selectedDate = Calendar.current.startOfDay(for: date)
								}
							}
					)
			}
		}

	}

	private var dayChart: some View {
		Chart {
			ForEach(getDayValue()) { value in
				BarMark(
					x: .value("date", value.valueDate, unit: .hour),
					y: .value("duration", value.duration)
				)
				.foregroundStyle(by: .value("category", value.category))
			}
		}
		.chartXScale(domain: Calendar.current.startOfDay(for: selectedDate)...Calendar.current.startOfDay(for: selectedDate).addingTimeInterval(60*60*24))
		.chartYAxis {
			AxisMarks(values: [TimeInterval(0), TimeInterval(30*60), TimeInterval(60*60)]) { value in
				AxisGridLine()

				let formatter: DateComponentsFormatter = {
					let formatter = DateComponentsFormatter()
					formatter.unitsStyle = .abbreviated
					formatter.allowedUnits = [.minute]
					return formatter
				}()

				if let timeInterval = value.as(TimeInterval.self), let formatted = formatter.string(from: timeInterval) {
					AxisValueLabel(formatted)
				}
			}
		}
		.chartLegend(isOverview ? .hidden : .automatic)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
	}

	private func getDayValue() -> [ScreenTimeValue] {
		ScreenTimeValue.week.filter({ Calendar.current.isDate($0.valueDate, inSameDayAs: selectedDate) })
	}
}

struct ScreenTime_Previews: PreviewProvider {
	static var previews: some View {
		ScreenTime(isOverview: true)
		ScreenTime(isOverview: false)
	}
}
