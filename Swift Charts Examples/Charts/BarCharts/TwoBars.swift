//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct TwoBars: View {
	var isOverview: Bool

    var data = LocationData.last7Days
    
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
		Chart(data) { series in
			ForEach(series.sales, id: \.weekday) { element in
				BarMark(
					x: .value("Day", element.weekday, unit: .day),
					y: .value("Sales", element.sales),
                    width: isOverview ? .automatic : .fixed(barWidth)
				)
                .accessibilityLabel("\(series.city) \(element.weekday.weekdayString)")
                .accessibilityValue("\(element.sales) sold")
                .accessibilityHidden(isOverview)
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
        // For the simple overview chart,
        // skip individual labels and only set the chartDescriptor
        .accessibilityChartDescriptor(self)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}
    
    private var customisation: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Bar Width: \(barWidth, specifier: "%.1f")")
                Slider(value: $barWidth, in: 1...20) {
                    Text("Bar Width")
                } minimumValueLabel: {
                    Text("1")
                } maximumValueLabel: {
                    Text("20")
                }
            }
            
            Toggle("Show Chart Legend", isOn: $showLegend)
            Toggle("Show Bars Stacked", isOn: $showBarsStacked)
        }
    }
}

// MARK: - Accessibility

extension TwoBars: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forLocationSeries: data)
    }
}

// MARK: - Preview

struct TwoBars_Previews: PreviewProvider {
    static var previews: some View {
        TwoBars(isOverview: true)
		TwoBars(isOverview: false)
    }
}
