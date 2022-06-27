//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct HeartRateRangeChart: View {
	var isOverview: Bool

    @State var data = HeartRateData.lastWeek

    @State private var barWidth = 10.0
    @State private var chartColor: Color = .red
    
    var body: some View {
		if isOverview {
			chart
		} else {
			List {
				Section(header: header) {
					chart
				}

				customisation
			}
			.navigationBarTitle(ChartType.rangeHeartRate.title, displayMode: .inline)
		}

    }
    
    private var customisation: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Bar Width: \(barWidth, specifier: "%.1f")")
                Slider(value: $barWidth, in: 5...20) {
                    Text("Bar Width")
                } minimumValueLabel: {
                    Text("5")
                } maximumValueLabel: {
                    Text("20")
                }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
        }
    }

	private var chart: some View {
		Chart(data, id: \.weekday) {
			BarMark(
				x: .value("Day", $0.weekday, unit: .day),
				yStart: .value("BPM Min", $0.dailyMin),
				yEnd: .value("BPM Max", $0.dailyMax),
                width: .fixed(isOverview ? 8 : barWidth)
			)
            .accessibilityLabel($0.weekday.weekdayString)
            .accessibilityValue("\($0.dailyMin) to \($0.dailyMax) BPM")
            .accessibilityHidden(isOverview)
			.clipShape(Capsule())
			.foregroundStyle(chartColor.gradient)
		}
		.chartXAxis {
			AxisMarks(values: .stride(by: ChartStrideBy.day.time)) { _ in
				AxisTick()
				AxisGridLine()
				AxisValueLabel(format: .dateTime.weekday(.abbreviated))
			}
		}
        .accessibilityChartDescriptor(self)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}

    private var header: some View {
        VStack(alignment: .leading) {
            Text("Range")
            Text("\(HeartRateData.minBPM)-\(HeartRateData.maxBPM) ")
                .font(.system(.title, design: .rounded))
                .foregroundColor(.primary)
            + Text("BPM")
            
            Text("\(HeartRateData.dateInterval), ") + Text(HeartRateData.latestDate, format: .dateTime.year())
            
        }
        .fontWeight(.semibold)
    }
}

// MARK: - Accessibility

extension HeartRateRangeChart: AXChartDescriptorRepresentable {
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

// MARK: - Preview

struct HeartRateRangeChart_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateRangeChart(isOverview: true)
		HeartRateRangeChart(isOverview: false)
    }
}
