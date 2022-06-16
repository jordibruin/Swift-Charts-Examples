//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI


/*
 This file collects the Accessibility descriptors used for the "simple" versions of
 charts
 */

extension SingleLineOverview: AXChartDescriptorRepresentable {
	func makeChartDescriptor() -> AXChartDescriptor {

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
}

extension SingleBarOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {

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
