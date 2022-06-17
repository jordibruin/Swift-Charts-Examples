//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI


/*
 This file collects the Accessibility descriptors used for the "simple" versions of
 charts
 */

// TODO: This should be a protocol but since the data objects are in flux this will suffice
private func chartDescriptor(forSingleSeries data: [(day: Date, sales: Int)]) -> AXChartDescriptor {
    let min = data.map(\.sales).min() ?? 0
    let max = data.map(\.sales).max() ?? 0

    let xAxis = AXCategoricalDataAxisDescriptor(
        title: "Days",
        categoryOrder: data.map { $0.day.formatted() }
    )

    let yAxis = AXNumericDataAxisDescriptor(
        title: "Sales",
        range: Double(min)...Double(max),
        gridlinePositions: []
    ) { value in "\(value) sold" }

    let series = AXDataSeriesDescriptor(
        name: "",
        isContinuous: false,
        dataPoints: data.map {
            .init(x: $0.day.formatted(), y: Double($0.sales))
        }
    )

    return AXChartDescriptor(
        title: "Sales per day",
        summary: nil,
        xAxis: xAxis,
        yAxis: yAxis,
        additionalAxes: [],
        series: [series]
    )
}

extension SingleLineOverview: AXChartDescriptorRepresentable {
	func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forSingleSeries: data)
	}
}

extension SingleLineLollipop: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forSingleSeries: data)
    }
}

extension SingleBarOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        chartDescriptor(forSingleSeries: data)
    }
}


extension TwoBarsOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {

        // Create a descriptor for each Series object
        // as that allows auditory comparison with VoiceOver
        // much like the chart does visually and allows individual city charts to be played
        let series = data.map {
            AXDataSeriesDescriptor(
                name: "\($0.city)",
                isContinuous: false,
                dataPoints: $0.sales.map { data in
                        .init(x: "\(data.weekday.formatted())",
                              y: Double(data.sales))
                }
            )
        }

        // Get the minimum/maximum within each city
        // and then the limits of the resulting list
        // to pass in as the Y axis limits
        let limits: [(Int, Int)] = data.map { seriesData in
            let sales = seriesData.sales.map { $0.sales }
            let localMin = sales.min() ?? 0
            let localMax = sales.max() ?? 0
            return (localMin, localMax)
        }

        let min = limits.map { $0.0 }.min() ?? 0
        let max = limits.map { $0.1 }.max() ?? 0

        // Get the unique days to mark the x-axis
        // and then sort them
        let uniqueDays = Set( data
            .map { $0.sales.map { $0.weekday } }
            .joined() )
        let days = Array(uniqueDays).sorted()

        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Days",
            categoryOrder: days.map { $0.formatted() }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Sales",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(value) sold" }

        return AXChartDescriptor(
            title: "Sales per day",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: series
        )
    }
}

extension HeartBeatOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let min = data.min() ?? 0.0
        let max = data.max() ?? 0.0

        // Set the units when creating the axes
        // so users can scrub and pause to narrow on a data point
        let xAxis = AXNumericDataAxisDescriptor(
            title: "Time",
            range: Double(0)...Double(data.count),
            gridlinePositions: []
        ) { value in "\(value)s" }


        let yAxis = AXNumericDataAxisDescriptor(
            title: "Millivolts",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(value) mV" }

        let series = AXDataSeriesDescriptor(
            name: "ECG from \(Date().formatted())",
            isContinuous: true,
            dataPoints: data.enumerated().map {
                .init(x: Double($0), y: $1)
            }
        )

        return AXChartDescriptor(
            title: "ElectroCardiogram (ECG)",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}

extension RangeSimpleOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {

        let min = data.map(\.dailyMin).min() ?? 0
        let max = data.map(\.dailyMax).max() ?? 0
        let salesMin = data.map(\.sales).min() ?? 0
        let salesMax = data.map(\.sales).max() ?? 0

        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Month",
            categoryOrder: data.map { $0.month.formatted() }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Sales Average",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(value) sales per day average" }

        // Create axes for the daily min/max and sales
        // and use the standard X/Y axes for month vs daily average
        let salesAxis = AXNumericDataAxisDescriptor(
            title: "Total Sales",
            range: Double(salesMin)...Double(salesMax),
            gridlinePositions: []
        ) { value in "\(value) total sales" }

        let minAxis = AXNumericDataAxisDescriptor(
            title: "Daily Minimum Sales",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(value) sales min" }

        let maxAxis = AXNumericDataAxisDescriptor(
            title: "Daily Maximum Sales",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(value) sales max" }

        let series = AXDataSeriesDescriptor(
            name: "Daily sales ranges per month",
            isContinuous: false,
            dataPoints: data.map {
                .init(x: $0.month.formatted(),
                      y: Double($0.dailyAverage),
                      additionalValues: [.number(Double($0.sales)),
                                         .number(Double($0.dailyMin)),
                                         .number(Double($0.dailyMax))])
            }
        )

        return AXChartDescriptor(
            title: "Sales per day",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [salesAxis, minAxis, maxAxis],
            series: [series]
        )
    }
}
