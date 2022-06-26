//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct TwoBars: View {
	var isOverview: Bool = false

    @State private var barWidth = 13.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var strideBy: ChartStrideBy = .day
    @State private var showLegend = false
    @State var showBarsStacked = true

    var body: some View {
		if isOverview {
			chart
		} else {
			List {
				Section {
					chart
				}

				customisation
			}
			.navigationBarTitle(ChartType.twoBars.title, displayMode: .inline)
		}
    }

	private var chart: some View {
		Chart(LocationData.last7Days) { series in
			ForEach(series.sales, id: \.weekday) { element in
				BarMark(
					x: .value("Day", element.weekday, unit: .day),
					y: .value("Sales", element.sales),
					width: .fixed(barWidth)
				)
				.accessibilityLabel("\(element.weekday.formatted())")
				.accessibilityValue("\(element.sales)")
				.foregroundStyle(by: .value("City", series.city))
			}
			.symbol(by: .value("City", series.city))
			.interpolationMethod(.catmullRom)
			.position(by: .value("City", showBarsStacked ? "Common" : series.city))
		}
		.chartXAxis {
			AxisMarks(values: .stride(by: strideBy.time)) { _ in
				AxisTick()
				AxisGridLine()
				AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
			}
		}
		.chartLegend((showLegend && !isOverview) ? .visible : .hidden)
		.chartLegend(position: .top)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}
    
    private var customisation: some View {
        Section {
            Stepper(value: $barWidth, in: 1.0...20.0) {
                HStack {
                    Text("Bar Width")
                    Spacer()
                    Text("\(String(format: "%.0f", barWidth))")
                }
            }
            
            Toggle("Show Chart Legend", isOn: $showLegend)
            Toggle("Show Bars Stacked", isOn: $showBarsStacked)
        }
    }
}

struct TwoBars_Previews: PreviewProvider {
    static var previews: some View {
        TwoBars(isOverview: true)
		TwoBars()
    }
}
