//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct AreaSimple: View {
	var isOverview: Bool

    @State var data: [Sale]
    @State private var lineWidth = 2.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var chartColor: Color = .blue
    @State private var showGradient = true
    @State private var gradientRange = 0.5

	init(isOverview: Bool) {
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
                .accessibilityLabel($0.day.formatted(date: .complete, time: .omitted))
                .accessibilityValue("\($0.sales) sold")
                .accessibilityHidden(isOverview)
				.lineStyle(StrokeStyle(lineWidth: lineWidth))
				.interpolationMethod(interpolationMethod.mode)
				.foregroundStyle(chartColor)
			}
		}
        .accessibilityChartDescriptor(self)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}

    private var customisation: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Line Width: \(lineWidth, specifier: "%.1f")")
                Slider(value: $lineWidth, in: 1...20) {
                    Text("Line Width")
                } minimumValueLabel: {
                    Text("1")
                } maximumValueLabel: {
                    Text("20")
                }
            }
            
            Picker("Interpolation Method", selection: $interpolationMethod) {
                ForEach(ChartInterpolationMethod.allCases) { Text($0.mode.description).tag($0) }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
            Toggle("Show Gradient", isOn: $showGradient.animation())

            if showGradient {
                VStack(alignment: .leading) {
                    Text("Gradiant Opacity Range: \(String(format: "%.1f", gradientRange))")
                    Slider(value: $gradientRange) {
                        Text("Gradiant Opacity Range")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("1")
                    }
                }
            }
        }
    }
}

// MARK: - Accessibility

extension AreaSimple: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        AccessibilityHelpers.chartDescriptor(forSalesSeries: data)
    }
}

// MARK: - Preview

struct AreaSimple_Previews: PreviewProvider {
    static var previews: some View {
        AreaSimple(isOverview: true)
		AreaSimple(isOverview: false)
    }
}
