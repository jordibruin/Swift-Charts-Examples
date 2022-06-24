//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Charts
import SwiftUI

struct TimeSheetBar: View {

	var isOverview: Bool

    private let monday = TimeSheetData.lastDay
    private let startOfOpeningHours = date(year: 2022, month: 6, day: 13, hour: 05, minutes: 00)
    private let endOfOpeningsHours = date(year: 2022, month: 6, day: 13, hour: 22, minutes: 00)
    private let weekStart = date(year: 2022, month: 6, day: 13, hour: 05, minutes: 00)
    private let weekEnd = date(year: 2022, month: 6, day: 18, hour: 20, minutes: 00)

    var body: some View {
		if isOverview {
			Chart(TimeSheetData.lastDay, id: \.clockIn) {
				BarMark(
					xStart: .value("Clocking In", $0.clockIn),
					xEnd: .value("Clocking Out", $0.clockOut),
					y: .value("Department", $0.department)
				)
				.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
				.foregroundStyle(TimeSheetBar.colors[$0.department] ?? .gray)
			}
			.chartXAxis(.hidden)
			.chartYAxis(.hidden)
			.frame(height: Constants.previewChartHeight)
		} else {
			List {
				Section("Monday \(monday[0].clockIn.formatted(date: .abbreviated, time: .omitted))") {
					EventChart(headerTitle: "Day total: \(TimeSheetBar.getEventsTotalDuration(monday))",
							   events: monday,
							   chartXScaleRangeStart: startOfOpeningHours,
							   chartXScaleRangeEnd: endOfOpeningsHours)
				}

				Section("Week 24 - 2022") {
					EventChart(headerTitle: "Week total: \(TimeSheetBar.getEventsTotalDuration(TimeSheetData.lastWeek))",
							   events: TimeSheetData.lastWeek,
							   chartXScaleRangeStart: weekStart,
							   chartXScaleRangeEnd: weekEnd)
				}
			}
			.navigationBarTitle(ChartType.timeSheetBar.title, displayMode: .inline)
		}

    }

    static let colors: [String: Color] = [
        "Bread": .yellow,
        "Butchery": .red,
        "Counter": .black,
        "Vegetables": .green
    ]

    static func getEventsTotalDuration(_ events: [(department: String, clockIn: Date, clockOut: Date)]) -> String {
        var durationInSeconds: TimeInterval = 0
        for event in events {
            durationInSeconds += event.clockIn.distance(to: event.clockOut)
        }
        return getFormattedDuration(seconds: durationInSeconds)
    }

    static func getFormattedDuration(seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour, .minute]

        return formatter.string(from: seconds) ?? "N/A"
    }
}

struct EventChart: View {
    @State private var selectedEvent: (department: String, clockIn: Date, clockOut: Date)?
    @State private var plotWidth: CGFloat = 0

    var headerTitle: String
    var events: [(department: String, clockIn: Date, clockOut: Date)]
    var chartXScaleRangeStart: Date
    var chartXScaleRangeEnd: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(headerTitle)
                .font(.title3.bold())

            Chart {
                ForEach(events, id: \.clockIn) { event in
                    BarMark(
                        xStart: .value("Clocking In", event.clockIn),
                        xEnd: .value("Clocking Out", event.clockOut),
                        y: .value("Department", event.department)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .foregroundStyle(getForegroundColor(department: event.department))

                    if let selectedEvent, selectedEvent == event {
                        RuleMark(x: .value("Event Middle", getEventMiddle(start: selectedEvent.clockIn, end: selectedEvent.clockOut)))
                            .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                            .offset(x: (plotWidth / getEventMiddle(start: selectedEvent.clockIn, end: selectedEvent.clockOut))) // Align with middle of bar
                            .annotation(position: .top) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Clocked in \(selectedEvent.clockIn.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                    Text("Clocked out \(selectedEvent.clockOut.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                    Text("Duration: \(TimeSheetBar.getEventsTotalDuration([selectedEvent]))")
                                        .font(.body.bold())
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background {
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(.white.shadow(.drop(radius: 2)))
                                }
                            }
                    }
                }
            }
            .padding(.top, 40)
            .frame(height: Constants.detailChartHeight)
            .chartXScale(domain: chartXScaleRangeStart...chartXScaleRangeEnd)
            .chartOverlay { proxy in
                GeometryReader { geoProxy in
                    Rectangle()
                        .fill(.clear).contentShape(Rectangle())
                        .gesture(
                            SpatialTapGesture()
                                .onEnded { value in
                                    let location = value.location

                                    if let date: Date = proxy.value(atX: location.x) {
                                        if let event = events.first(where: { _, clockedIn, clockedOut in
                                            date >= clockedIn && date <= clockedOut
                                        }) {
                                            self.selectedEvent = event
                                            self.plotWidth = proxy.plotAreaSize.width
                                        }
                                    }
                                }
                        )
                }
            }
        }
    }

    private func getEventMiddle(start: Date, end: Date) -> Date {
        Date(timeInterval: (end.timeIntervalSince1970 - start.timeIntervalSince1970) / 2, since: start)
    }

    private func getEventMiddle(start: Date, end: Date) -> CGFloat {
        CGFloat((start.timeIntervalSince1970 + end.timeIntervalSince1970) / 2)
    }

    private func getForegroundColor(department: String) -> AnyGradient {
        if let color = TimeSheetBar.colors[department] {
            return color.gradient
        }
        return Color.gray.gradient
    }
}

struct TimeSheetBar_Previews: PreviewProvider {
    static var previews: some View {
		TimeSheetBar(isOverview: true)
        TimeSheetBar(isOverview: false)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
