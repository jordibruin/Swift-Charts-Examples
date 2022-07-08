//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct GitHubContributionsGraph: View {
    var isOverview: Bool

    private let data: [GitContribution] = GitHubData.contributions.suffix(7 * 20 - 1)

    var body: some View {
        if isOverview {
            chart
        } else {
            List {
                Section {
                    chart
                }
            }
            .navigationBarTitle(ChartType.gitContributions.title, displayMode: .inline)
        }
    }

    private var chart: some View {
        Chart(data) { contribution in
            // NOTE: Chart accessibilityElements are presented in a LTR order
            // If you need to present in order, consider using accessibilityRepresentation
            Plot {
                RectangleMark(
                    xStart: .value("xStart", relativeWeek(date: contribution.date)),
                    xEnd: .value("xEnd", relativeWeek(date: contribution.date) + 1),
                    yStart: .value("yStart", dayOfTheWeek(date: contribution.date)),
                    yEnd: .value("yEnd", dayOfTheWeek(date: contribution.date) + 1)
                )
                .foregroundStyle(by: .value("Level", contribution.level))
                .interpolationMethod(.cardinal)
            }
            .accessibilityLabel("\(contribution.date.formatted(date: .complete, time: .omitted))")
            .accessibilityValue("\(contribution.level) contributions")
            .accessibilityHidden(isOverview)
        }
        .chartForegroundStyleScale(range: Gradient(colors: [.white, .green]))
        .accessibilityChartDescriptor(self)
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 7,
                                         roundLowerBound: false,
                                         roundUpperBound: false)) { _ in
                AxisGridLine(stroke: .init(lineWidth: 1))
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 20,
                                         roundLowerBound: false,
                                         roundUpperBound: false)) { _ in
                AxisGridLine(stroke: .init(lineWidth: 1))
            }
        }
        .chartYScale(domain: .automatic(reversed: true))
        .aspectRatio(20.0/7.0, contentMode: .fit)
    }

    private func dayOfTheWeek(date: Date) -> Int {
        (Calendar.current.dateComponents([.weekday], from: date).weekday ?? 1) - 1
    }

    private func relativeWeek(date: Date) -> Int {
        let firstDate = data.first!.date
        let daysApart = Calendar.current.dateComponents([.day], from: firstDate, to: date).day!
        return daysApart / 7
    }
}

// MARK: - Accessibility

extension GitHubContributionsGraph: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let min = data.map(\.level).min() ?? 0
        let max = data.map(\.level).max() ?? 0

        // A closure that takes a date and converts it to a label for axes
        let dateTupleStringConverter: ((GitContribution) -> (String)) = { dataPoint in
            dataPoint.date.formatted(date: .abbreviated, time: .omitted)
        }
        
        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Date",
            categoryOrder: data.map { dateTupleStringConverter($0) }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Contributions",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(Int(value)) contributions" }

        let series = AXDataSeriesDescriptor(
            name: "Contribution Chart",
            isContinuous: false,
            dataPoints: data.map {
                .init(x: dateTupleStringConverter($0),
                      y: Double($0.level),
                      label: "\($0.date.weekdayString)")
            }
        )

        return AXChartDescriptor(
            title: "GitHub Contribution Data",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
    
    /// This is an unused method that demonstrates why a 1:1 mapping of grid layout
    ///  doesn't work as well.
    ///  We want to allow users to hear highest/lowest contribution values and this method isn't clear
    /// - Returns: a descriptor that lays out data like it is visually in a grid
    private func _gridChartDescriptor() -> AXChartDescriptor {
        
        let weekCount = Double(data.count)/7.0 + 1

        let vmin = data.map(\.level).min() ?? 0
        let vmax = data.map(\.level).max() ?? 0

        // Create the axes
        let xAxis = AXNumericDataAxisDescriptor(
            title: "Week",
            range: Double(0)...Double(weekCount),
            gridlinePositions: []
        ) { "Week \(Int($0) + 1)" }

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Day",
            range: Double(0)...Double(7),
            gridlinePositions: []
        ) { "Day \(Int($0) + 1)" }

        // We use a categorical instead of numeric descriptor since Audio Graphs won't color code
        // data points with a numeric descriptor
        let valueAxis = AXCategoricalDataAxisDescriptor(title: "Count",
                                                        categoryOrder: Array(Int(vmin)...Int(vmax)).map { "\($0) contributions"  } )
        var datapoints: [AXDataPoint] = []
        data.enumerated().forEach { (idx, datapoint) in
            guard datapoint.level > 0 else { return }
            datapoints.append( .init(x: Double(idx / 7),
                                     y: Double(idx % 7),
                                     additionalValues: [ .category("\(datapoint.level) contributions") ],
                                     label: datapoint.date.formatted(date: .complete, time: .omitted)) )
        }
        
        let series = AXDataSeriesDescriptor(name: "Contribution Chart",
                                            isContinuous: false,
                                            dataPoints: datapoints)

        return AXChartDescriptor(
            title: "GitHub Contribution Data",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [valueAxis],
            series: [series]
        )

    }
}

// MARK: - Preview

struct GitHubContributionsGraph_Previews: PreviewProvider {
    static var previews: some View {
        GitHubContributionsGraph(isOverview: true)
        GitHubContributionsGraph(isOverview: false)
    }
}
