//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct SingleBarThreshold: View {
	var isOverview: Bool = false
    
    @State private var threshold = 150.0
    @State var belowColor: Color = .blue
    @State var aboveColor: Color = .orange
    
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
			.navigationBarTitle(ChartType.singleBarThreshold.title, displayMode: .inline)
		}
    }

	private var chart: some View {
		Chart(SalesData.last30Days, id: \.day) {
			BarMark(
				x: .value("Date", $0.day),
				y: .value("Sales", $0.sales)
			)
			.foregroundStyle($0.sales > Int(threshold) ? aboveColor.gradient :  belowColor.gradient)
			RuleMark(
				y: .value("Threshold", threshold)
			)
			.lineStyle(StrokeStyle(lineWidth: 2))
			.foregroundStyle(.red)
			.annotation(position: .top, alignment: .leading) {
				Text("\(threshold, specifier: "%.0f")")
					.font(.title2.bold())
					.foregroundColor(.primary)
					.background {
						ZStack {
							RoundedRectangle(cornerRadius: 8)
								.fill(.background)
							RoundedRectangle(cornerRadius: 8)
								.fill(.quaternary.opacity(0.7))
						}
						.padding(.horizontal, -8)
						.padding(.vertical, -4)
					}
					.padding(.bottom, 4)
			}
		}
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}

    private var customisation: some View {
        Group {
            Section {
                VStack(alignment: .leading) {
                    Text("Threshold: \(threshold, specifier: "%.0f")")
                    Slider(value: $threshold, in: 0...275) {
                        Text("Threshold")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("275")
                    }
                }
            }
            
            Section {
                ColorPicker("Below Threshold Color", selection: $belowColor)
                ColorPicker("Above Threshold Color", selection: $aboveColor)
            }
        }
    }
}

struct SingleBarThreshold_Previews: PreviewProvider {
    static var previews: some View {
        SingleBarThreshold(isOverview: true)
		SingleBarThreshold()
    }
}
