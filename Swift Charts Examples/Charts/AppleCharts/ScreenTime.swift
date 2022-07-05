//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

// Reduces clutter when re-used and in type annotations
fileprivate typealias AccessibilitySummary = (date: Date, totalDuration: TimeInterval, description: String)

struct ScreenTime: View {
	var isOverview: Bool

    @State private var weekData = ScreenTimeValue.week.makeDayValues()
	@State private var selectedDate: Date = date(year: 2022, month: 06, day: 20)
    
    /// A grouping of the startOfDay Date, the total hours of screen time on the date
    /// and a descriptive breakdown of usage categories
    /// for use with accessibilityChartDescriptor and label/value of WeekChart data
    private var accessibilityGroupedWeekData: [AccessibilitySummary] {
        
        // NOTE: weekData's valueDate are the start of date for each day based on makeDayValues()
        let grouped = Dictionary(grouping: weekData) { $0.valueDate }
        let summaries: [AccessibilitySummary] = grouped.map { k, v in
            let totalDuration: TimeInterval = v.reduce(0.0) { $0 + $1.duration }
            let summaries = v.map { "\($0.category.rawValue): \($0.duration.durationDescription)"}
            return (date: k,
                    totalDuration: totalDuration,
                    description: summaries.formatted(.list(type: .and)))
        }
        
        return summaries.sorted { $0.date < $1.date }
        
    }
    
    /// A grouping by the hour of the day, of the total hours of screen time
    /// and a descriptive breakdown of usage categories
    /// for use with accessibilityChartDescriptor and label/value of DayChart data
    private var accessibilityGroupedDayData: [AccessibilitySummary] {
        
        let grouped = Dictionary(grouping: getDayValue()) {
            // Since the sample data only uses hours, we group by the date
            $0.valueDate
            // If, the schema changes to include minute data, use the following to get the startOfHour
            // let hour = Calendar.current.component(.hour, from: $0.valueDate)
            // return Calendar.current.date(from: .init(hour: hour)) ?? $0.valueDate
        }
        let summaries: [AccessibilitySummary] = grouped.map { k, v in
            let totalDuration: TimeInterval = v.reduce(0.0) { $0 + $1.duration }
            let summaries = v.map { "\($0.category.rawValue): \($0.duration.durationDescription)"}
            return (date: k,
                    totalDuration: totalDuration,
                    description: summaries.formatted(.list(type: .and)))
        }
        
        return summaries.sorted { $0.date < $1.date }
        
    }

	var body: some View {
		ZStack {
			if isOverview {
                VStack {
                    weekChart
                    dayChart
                }
                .frame(height: 300)
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
        .accessibilityRepresentation {
            Chart {
                ForEach(accessibilityGroupedWeekData, id: \.date) { dataPoint in
                    Plot {
                        BarMark(
                            x: .value("date", dataPoint.date, unit: .day),
                            y: .value("duration", dataPoint.totalDuration)
                        )
                    }
                    .accessibilityLabel("\(dataPoint.date.formatted(Date.FormatStyle().month(.wide).day(.defaultDigits).weekday(.wide)))")
                    .accessibilityValue(dataPoint.description)
                    .accessibilityHidden(isOverview)
                }
            }
        }
        .accessibilityChartDescriptor(WeekChartDescriptor(summaries: accessibilityGroupedWeekData))
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
				// .relative(presentation: .numeric, unitsStyle: .wide)
			}
		}
        .accessibilityRepresentation {
            Chart {
                ForEach(accessibilityGroupedDayData, id: \.date) { dataPoint in
                    Plot {
                        BarMark(
                            x: .value("date", dataPoint.date, unit: .hour),
                            y: .value("duration", dataPoint.totalDuration)
                        )
                    }
                    .accessibilityLabel("\(dataPoint.date.formatted(date: .omitted, time: .standard))")
                    .accessibilityValue(dataPoint.description)
                    .accessibilityHidden(isOverview)
                }
            }
        }
//        .accessibilityChartDescriptor(WeekChartDescriptor(summaries: accessibilityGroupedWeekData))
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
	}

	private func getDayValue() -> [ScreenTimeValue] {
		ScreenTimeValue.week.filter({ Calendar.current.isDate($0.valueDate, inSameDayAs: selectedDate) })
	}
}

// MARK: - Accessibility

struct WeekChartDescriptor: AXChartDescriptorRepresentable {
    
    fileprivate let summaries: [AccessibilitySummary]
    
    func makeChartDescriptor() -> AXChartDescriptor {
        
        let min = 0
        let max = summaries.map(\.totalDuration).max() ?? 0

        // A closure that takes a date and converts it to a label for axes
        let dateStringConverter: ((AccessibilitySummary) -> (String)) = { dataPoint in
            dataPoint.date
                .formatted(
                    Date.FormatStyle()
                        .month(.wide)
                        .day(.defaultDigits)
                        .weekday(.wide)
                )
        }
        
        // The axes and descriptions here mirror Apple's implementation of the Screen time graph
        // So we simply describe the total usage time instead of detailing the usage breakdown
        let xAxis = AXCategoricalDataAxisDescriptor(title: "Time",
                                                    categoryOrder: summaries.map { dateStringConverter($0) } )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Usage",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "Total usage: \(value.durationDescription)" }
        
        
        // If, however you want to put the usage categories in the audio graph,
        // add label: point.description to the dataPoints init here
        let series = AXDataSeriesDescriptor(
            name: "Device Usage",
            isContinuous: false,
            dataPoints: summaries.map { point in
                    .init(x: dateStringConverter(point),
                          y: Double(point.totalDuration))
            }
        )

        return AXChartDescriptor(
            title: "Screen Time Data",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}

// MARK: - Preview

struct ScreenTime_Previews: PreviewProvider {
	static var previews: some View {
		ScreenTime(isOverview: true)
		ScreenTime(isOverview: false)
	}
}
