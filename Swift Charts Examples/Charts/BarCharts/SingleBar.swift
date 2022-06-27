//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct SingleBar: View {
	var isOverview: Bool

    @State var data: [Sale] = SalesData.last30Days

    @State private var barWidth = 7.0
    @State private var chartColor: Color = .blue

	init(isOverview: Bool) {
		self.isOverview = isOverview
	}
    
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
			.navigationBarTitle(ChartType.singleBar.title, displayMode: .inline)
			.onAppear {
				for index in data.indices {
					DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.02) {
						withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
							data[index].sales = SalesData.last30Days[index].sales
						}
					}
				}
			}
		}
    }

	private var chart: some View {
		Chart(data, id: \.day) {
			BarMark(
				x: .value("Date", $0.day),
				y: .value("Sales", $0.sales),
                width: isOverview ? .automatic : .fixed(barWidth)
			)
            .accessibilityLabel($0.day.formatted(date: .complete, time: .omitted))
            .accessibilityValue("\($0.sales) sold")
            .accessibilityHidden(isOverview)
			.foregroundStyle(chartColor.gradient)
		}
        .accessibilityChartDescriptor(self)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.chartYAxis(isOverview ? .hidden : .automatic)
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
            ColorPicker("Color Picker", selection: $chartColor)
        }
    }
}

// MARK: - Accessibility

extension SingleBar: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        chartDescriptor(forSalesSeries: data)
    }
}

// MARK: - Preview

struct SingleBar_Previews: PreviewProvider {
    static var previews: some View {
        SingleBar(isOverview: true)
		SingleBar(isOverview: false)
    }
}
