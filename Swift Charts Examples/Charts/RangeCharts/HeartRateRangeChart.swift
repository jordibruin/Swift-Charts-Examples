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
		Chart(data, id: \.weekday) { dataPoint in
            Plot {
                BarMark(
                    x: .value("Day", dataPoint.weekday, unit: .day),
                    yStart: .value("BPM Min", dataPoint.dailyMin),
                    yEnd: .value("BPM Max", dataPoint.dailyMax),
                    width: .fixed(isOverview ? 8 : barWidth)
                )
                .clipShape(Capsule())
                .foregroundStyle(chartColor.gradient)
            }
            .accessibilityLabel(dataPoint.weekday.weekdayString)
            .accessibilityValue("\(dataPoint.dailyMin) to \(dataPoint.dailyMax) BPM")
            .accessibilityHidden(isOverview)

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
            date.formatted(date: .complete, time: .omitted)
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

        let series = AXDataSeriesDescriptor(
            name: "Last Week",
            isContinuous: false,
            dataPoints: data.map {
                .init(x: dateStringConverter($0.weekday),
                      y: Double($0.dailyAverage),
                      label: "Min: \($0.dailyMin) BPM, Max: \($0.dailyMax) BPM")
            }
        )

        return AXChartDescriptor(
            title: "Heart Rate range",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
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
