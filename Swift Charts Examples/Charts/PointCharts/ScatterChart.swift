//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct ScatterChart: View {
	var isOverview: Bool

    @State var data = LocationData.last30Days
    @State private var pointSize = 10.0
    @State private var showLegend = false
    
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
			.navigationBarTitle(ChartType.scatter.title, displayMode: .inline)
		}

    }

	private var chart: some View {
		Chart {
			ForEach(data) { series in
				ForEach(series.sales, id: \.weekday) { element in
					PointMark(
						x: .value("Day", element.weekday, unit: .day),
						y: .value("Sales", element.sales)
					)
                    .accessibilityLabel("\(series.city), \(element.weekday.formatted(date: .complete, time: .omitted))")
                    .accessibilityValue("\(element.sales) sold")
                    .accessibilityHidden(isOverview)
				}
				.foregroundStyle(by: .value("City", series.city))
				.symbol(by: .value("City", series.city))
				.symbolSize(pointSize * 5)
			}
		}
		.chartLegend((showLegend && !isOverview) ? .visible : .hidden)
		.chartLegend(position: .bottomLeading)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
        .accessibilityChartDescriptor(self)
	}

    private var customisation: some View {
        Section {
            Stepper(value: $pointSize.animation(), in: 1.0...20.0) {
                HStack {
                    Text("Point Width")
                    Spacer()
                    Text("\(String(format: "%.0f", pointSize))")
                }
            }
            
            Toggle("Show Chart Legend", isOn: $showLegend.animation())
        }
    }
}

// MARK: - Accessibility

extension ScatterChart: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forLocationSeries: data)
    }
}

// MARK: - Preview

struct ScatterChart_Previews: PreviewProvider {
	static var previews: some View {
        ScatterChart(isOverview: true)
		ScatterChart(isOverview: false)
    }
}
