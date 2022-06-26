//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct AreaSimple: View {
	var isOverview: Bool

    @State private var lineWidth = 2.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var chartColor: Color = .blue
    @State private var showGradient = true
    @State private var gradientRange = 0.5
    @State private var data: [Sale]

	init(isOverview: Bool = false) {
		self.isOverview = isOverview
		self.data = SalesData.last30Days.map { Sale(day: $0.day, sales: isOverview ? $0.sales : 0) }
	}

    private var gradient: Gradient {
        var colors = [chartColor]
        if showGradient {
            colors.append(chartColor.opacity(gradientRange))
        }
        return Gradient(colors: colors)
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
			.navigationBarTitle(ChartType.areaSimple.title, displayMode: .inline)
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
			AreaMark(
				x: .value("Date", $0.day),
				y: .value("Sales", $0.sales)
			)
			.foregroundStyle(gradient)
			.interpolationMethod(interpolationMethod.mode)

			if !isOverview {
				LineMark(
					x: .value("Date", $0.day),
					y: .value("Sales", $0.sales)
				)
				.lineStyle(StrokeStyle(lineWidth: lineWidth))
				.interpolationMethod(interpolationMethod.mode)
				.foregroundStyle(chartColor)
			}
		}
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}

    private var customisation: some View {
        Section {
            Stepper(value: $lineWidth, in: 1.0...20.0) {
                HStack {
                    Text("Line Width")
                    Spacer()
                    Text("\(String(format: "%.0f", lineWidth))")
                }
            }
            
            Picker("Interpolation Method", selection: $interpolationMethod) {
                ForEach(ChartInterpolationMethod.allCases) { Text($0.mode.description).tag($0) }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
            Toggle("Show Gradient", isOn: $showGradient.animation())

            if showGradient {
                HStack {
                    Slider(value: $gradientRange) {
                        Text("Gradient Range")
                    } minimumValueLabel: {
                        Text("Min")
                    } maximumValueLabel: {
                        Text("Max")
                    }
                    Text("\(String(format: "%.1f", gradientRange))")
                }
            }
        }
    }
}

struct AreaSimple_Previews: PreviewProvider {
    static var previews: some View {
        AreaSimple(isOverview: true)
		AreaSimple()
    }
}
