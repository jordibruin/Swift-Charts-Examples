//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct HeartRateRangeChart: View {

	var isOverview: Bool = false

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
            Stepper(value: $barWidth, in: 5.0...20.0) {
                HStack {
                    Text("Bar Width")
                    Spacer()
                    Text("\(String(format: "%.0f", barWidth))")
                }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
        }
    }

	private var chart: some View {
		Chart(HeartRateData.lastWeek, id: \.weekday) {
			BarMark(
				x: .value("Day", $0.weekday, unit: .day),
				yStart: .value("BPM Min", $0.dailyMin),
				yEnd: .value("BPM Max", $0.dailyMax),
				width: .fixed(barWidth)
			)
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

struct HeartRateRangeChart_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateRangeChart(isOverview: true)
		HeartRateRangeChart()
    }
}
