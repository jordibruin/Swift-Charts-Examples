//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI


extension Date {
    // Used for charts where the day of the week is used: visually  M/T/W etc
    // (but we want VoiceOver to read out the full day)
    var weekdayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"

        return formatter.string(from: self)
    }
}

/*
 This file collects the Accessibility descriptors used for the "simple" versions of
 charts
 */

// TODO: This should be a protocol but since the data objects are in flux this will suffice
private func chartDescriptor(forSalesSeries data: [(day: Date, sales: Int)]) -> AXChartDescriptor {
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

private func chartDescriptor(forLocationSeries data: [LocationData.Series]) -> AXChartDescriptor {
    
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

private func chartDescriptor(forGrid data: [Grid.Point]) -> AXChartDescriptor {
    let xmin = data.map(\.x).min() ?? 0
    let xmax = data.map(\.x).max() ?? 0
    let ymin = data.map(\.y).min() ?? 0
    let ymax = data.map(\.y).max() ?? 0
    let vmin = data.map(\.val).min() ?? 0
    let vmax = data.map(\.val).max() ?? 0
    
    let xAxis = AXNumericDataAxisDescriptor(
        title: "X",
        range: Double(xmin)...Double(xmax),
        gridlinePositions: Array(stride(from: xmin, to: xmax, by: 1)).map { Double($0) }
    ) { "X: \($0)" }

    let yAxis = AXNumericDataAxisDescriptor(
        title: "Y",
        range: Double(ymin)...Double(ymax),
        gridlinePositions: Array(stride(from: ymin, to: ymax, by: 1)).map { Double($0) }
    ) { "Y: \($0)" }
    
    let valueAxis = AXNumericDataAxisDescriptor(
        title: "Value",
        range: Double(vmin)...Double(vmax),
        gridlinePositions: []
    ) { "Color: \($0)" }

    let series = AXDataSeriesDescriptor(
        name: "",
        isContinuous: false,
        dataPoints: data.map {
            .init(x: Double($0.x),
                  y: Double($0.y),
                  additionalValues: [.category($0.accessibilityColorName)])
        }
    )

    return AXChartDescriptor(
        title: "Grid Data",
        summary: nil,
        xAxis: xAxis,
        yAxis: yAxis,
        additionalAxes: [valueAxis],
        series: [series]
    )
}

extension SingleLineOverview: AXChartDescriptorRepresentable {
	func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forSalesSeries: data)
	}
}

extension SingleLineLollipop: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forSalesSeries: data)
    }
}

extension SingleBarOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        chartDescriptor(forSalesSeries: data)
    }
}

extension AreaSimpleOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forSalesSeries: data)
    }
}

extension TwoBarsOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forLocationSeries: data)
    }
}

extension ScatterChartOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forLocationSeries: data)
    }
}


// TODO: This is virtually the same as TwoBarsOverview's chartDescriptor. Use a protocol?
extension PyramidChartOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {

        // Create a descriptor for each Series object
        // as that allows auditory comparison with VoiceOver
        // much like the chart does visually and allows individual city charts to be played
        let series = data.map {
            AXDataSeriesDescriptor(
                name: "\($0.sex)",
                isContinuous: false,
                dataPoints: $0.population.map { data in
                        .init(x: "\(data.ageRange)",
                              y: Double(data.percentage))
                }
            )
        }

        // Get the minimum/maximum within each series
        // and then the limits of the resulting list
        // to pass in as the Y axis limits
        let limits: [(Int, Int)] = data.map { seriesData in
            let percentages = seriesData.population.map { $0.percentage }
            let localMin = percentages.min() ?? 0
            let localMax = percentages.max() ?? 0
            return (localMin, localMax)
        }

        let min = limits.map { $0.0 }.min() ?? 0
        let max = limits.map { $0.1 }.max() ?? 0

        // Get the unique age ranges to mark the x-axis
        // and then sort them
        let uniqueRanges = Set( data
            .map { $0.population.map { $0.ageRange } }
            .joined() )
        let ranges = Array(uniqueRanges).sorted()

        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Age Ranges",
            categoryOrder: ranges.map { $0 }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Population percentage",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(value)%" }

        return AXChartDescriptor(
            title: "Population by age",
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

extension HeartRateRangeChartOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        
        let min = data.map(\.dailyMin).min() ?? 0
        let max = data.map(\.dailyMax).max() ?? 0

        // Use this for the label, so dates are verbalized accurately
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        
        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Day",
            categoryOrder: data.map { $0.weekday.formatted() }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Heart Rate",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "Average: \(Int(value)) BPM" }
        
        let minAxis = AXNumericDataAxisDescriptor(
            title: "Daily Minimum Heartrate",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "Minimum: \(Int(value)) BPM" }

        let maxAxis = AXNumericDataAxisDescriptor(
            title: "Daily Maximum Heartrate",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "Maximum: \(Int(value)) BPM" }

        let series = AXDataSeriesDescriptor(
            name: "Last Week",
            isContinuous: false,
            dataPoints: data.map {
                .init(x: $0.weekday.formatted(),
                      y: Double($0.dailyAverage),
                      additionalValues: [.number(Double($0.dailyMin)),
                                         .number(Double($0.dailyMax))],
                      label: formatter.string(from: $0.weekday))
            }
        )

        return AXChartDescriptor(
            title: "Heart Rate range",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [minAxis, maxAxis],
            series: [series]
        )
    }
}

extension HeatMapOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forGrid: data)
    }
}

extension VectorFieldOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let base = chartDescriptor(forGrid: data)
  
        // Add the vector field's angle to the grid based series
        if
            let series = base.series.first,
            let name = series.name {
            let modifiedSeries = AXDataSeriesDescriptor(
                name: name,
                isContinuous: series.isContinuous,
                dataPoints: data.map {
                    .init(x: Double($0.x),
                          y: Double($0.y),
                          additionalValues: [
                            .category($0.accessibilityColorName),
                          ],
                          label: "Angle: \(Int($0.angle(degreeOffset: 0, inRadians: false))) degrees")
                })

            base.series = [modifiedSeries]
        }
        
        return base
    }
}
