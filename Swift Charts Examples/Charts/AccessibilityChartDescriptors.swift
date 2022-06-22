//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI


/*
 This file collects the Accessibility descriptors used for the "Overview" versions of
 charts. The detailed versions simply use accessibilityLabel/accessibilityValue for each Mark.
 
 NOTE: Filed FB10320202 indicating some Mark types do not use label/value set on the Mark
 */


extension Date {
    // Used for charts where the day of the week is used: visually  M/T/W etc
    // (but we want VoiceOver to read out the full day)
    var weekdayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"

        return formatter.string(from: self)
    }
}

// TODO: This should be a protocol but since the data objects are in flux this will suffice
private func chartDescriptor(forSalesSeries data: [(day: Date, sales: Int)]) -> AXChartDescriptor {
    let min = data.map(\.sales).min() ?? 0
    let max = data.map(\.sales).max() ?? 0

    // A closure that takes a date and converts it to a label for axes
    let dateTupleStringConverter: (((day: Date, sales: Int)) -> (String)) = { dataPoint in
        dataPoint.day.formatted(date: .abbreviated, time: .omitted)
    }
    
    let xAxis = AXCategoricalDataAxisDescriptor(
        title: "Days",
        categoryOrder: data.map { dateTupleStringConverter($0) }
    )

    let yAxis = AXNumericDataAxisDescriptor(
        title: "Sales",
        range: Double(min)...Double(max),
        gridlinePositions: []
    ) { value in "\(Int(value)) sold" }

    let series = AXDataSeriesDescriptor(
        name: "Daily sale quantity",
        isContinuous: false,
        dataPoints: data.map {
            .init(x: dateTupleStringConverter($0), y: Double($0.sales), label: "\($0.day.weekdayString)")
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
    
    let dateStringConverter: ((Date) -> (String)) = { date in
        date.formatted(date: .abbreviated, time: .omitted)
    }
    
    // Create a descriptor for each Series object
    // as that allows auditory comparison with VoiceOver
    // much like the chart does visually and allows individual city charts to be played
    let series = data.map { dataPoint in
        AXDataSeriesDescriptor(
            name: "\(dataPoint.city)",
            isContinuous: false,
            dataPoints: dataPoint.sales.map { data in
                    .init(x: dateStringConverter(data.weekday),
                          y: Double(data.sales),
                          label: "\(dataPoint.city): \(data.weekday.weekdayString)")
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
        categoryOrder: days.map { dateStringConverter($0) }
    )

    let yAxis = AXNumericDataAxisDescriptor(
        title: "Sales",
        range: Double(min)...Double(max),
        gridlinePositions: []
    ) { value in "\(Int(value)) sold" }

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
        title: "Position",
        range: Double(xmin)...Double(xmax),
        gridlinePositions: Array(stride(from: xmin, to: xmax, by: 1)).map { Double($0) }
    ) { "X: \($0)" }

    let yAxis = AXNumericDataAxisDescriptor(
        title: "Value",
        range: Double(ymin)...Double(ymax),
        gridlinePositions: Array(stride(from: ymin, to: ymax, by: 1)).map { Double($0) }
    ) { "Y: \($0)" }
    
    let valueAxis = AXNumericDataAxisDescriptor(
        title: "Value based Color",
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

extension SingleBarThresholdOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        // TODO: The threshold chart should indicate to VoiceOver users when a datapoint is above threshold
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

extension AnimatedChart: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let xAxis = AXNumericDataAxisDescriptor(title: "Position",
                                                range: -1...1,
                                                gridlinePositions: []) { String(format: "%.2f", $0) }
        
        let yAxis = AXNumericDataAxisDescriptor(title: "Value",
                                                range: -1...1,
                                                gridlinePositions: []) { String(format: "%.2f", $0) }
        
        let series = AXDataSeriesDescriptor(name: "Data",
                                            isContinuous: true, dataPoints: self.samples.map {
            .init(x: $0.x, y: $0.y)
        })
        
        return AXChartDescriptor(title: "Animated Change in Data",
                                 summary: nil,
                                 xAxis: xAxis,
                                 yAxis: yAxis,
                                 additionalAxes: [],
                                 series: [series])
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
        
        let dateStringConverter: ((Date) -> (String)) = { date in
            date.formatted(.dateTime.month(.wide))
        }
        
        let min = data.map(\.dailyMin).min() ?? 0
        let max = data.map(\.dailyMax).max() ?? 0
        let salesMin = data.map(\.sales).min() ?? 0
        let salesMax = data.map(\.sales).max() ?? 0

        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Month",
            categoryOrder: data.map { dateStringConverter($0.month) }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Sales Average",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(Int(value)) sales per day average" }

        // Create axes for the daily min/max and sales
        // and use the standard X/Y axes for month vs daily average
        let salesAxis = AXNumericDataAxisDescriptor(
            title: "Total Sales",
            range: Double(salesMin)...Double(salesMax),
            gridlinePositions: []
        ) { value in "\(Int(value)) total sales" }

        let minAxis = AXNumericDataAxisDescriptor(
            title: "Daily Minimum Sales",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(Int(value)) sales min" }

        let maxAxis = AXNumericDataAxisDescriptor(
            title: "Daily Maximum Sales",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(Int(value)) sales max" }

        let series = AXDataSeriesDescriptor(
            name: "Daily sales ranges per month",
            isContinuous: false,
            dataPoints: data.map {
                .init(x: dateStringConverter($0.month),
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
        
        let dateStringConverter: ((Date) -> (String)) = { date in
            date.formatted(date: .abbreviated, time: .omitted)
        }
        
        let min = data.map(\.dailyMin).min() ?? 0
        let max = data.map(\.dailyMax).max() ?? 0
        
        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Day",
            categoryOrder: data.map { dateStringConverter($0.weekday) }
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

        // FIXME: This is not verbalized when scrubbing the summary
        let maxAxis = AXNumericDataAxisDescriptor(
            title: "Daily Maximum Heartrate",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "Maximum: \(Int(value)) BPM" }

        let series = AXDataSeriesDescriptor(
            name: "Last Week",
            isContinuous: false,
            dataPoints: data.map {
                .init(x: dateStringConverter($0.weekday),
                      y: Double($0.dailyAverage),
                      additionalValues: [.number(Double($0.dailyMin)),
                                         .number(Double($0.dailyMax))])
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

extension OneDimensionalBarOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let min = data.map(\.size).min() ?? 0
        let max = data.map(\.size).max() ?? 0

        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Category",
            categoryOrder: data.map { $0.category }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Size",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(String(format:"%.2f", value)) GB" }

        let series = AXDataSeriesDescriptor(
            name: "Data Usage Example",
            isContinuous: false,
            dataPoints: data.map {
                .init(x: $0.category, y: $0.size)
            }
        )

        return AXChartDescriptor(
            title: "Data Usage by category",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}

extension TimeInterval {
    var durationDescription: String {
        let hqualifier = (hours == 1) ? "hour" : "hours"
        let mqualifier = (minutes == 1) ? "minute" : "minutes"
        
        return String(format:"%d \(hqualifier) %02d \(mqualifier)", hours, minutes)
    }

    var hours: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    
    var minutes: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
}

extension TimeSheetBarOverview: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        
        let intervals = data.map {
            (department: $0.department,
             duration: $0.clockOut.timeIntervalSince($0.clockIn),
             clockIn: $0.clockIn,
             clockOut: $0.clockOut)
        }
        
        let min = intervals.map(\.duration).min() ?? 0
        let max = intervals.map(\.duration).max() ?? 0

        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Department",
            categoryOrder: data.map { $0.department }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Duration",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(value.durationDescription)" }

        let series = AXDataSeriesDescriptor(
            name: "Timesheet Example",
            isContinuous: false,
            dataPoints: intervals.map {
                .init(x: $0.department,
                      y: $0.duration,
                      label: "Clock in: \($0.clockIn.formatted(date: .omitted, time: .shortened)), Clock out: \($0.clockOut.formatted(date: .omitted, time: .shortened))")
            }
        )

        return AXChartDescriptor(
            title: "Timesheet by department",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}
