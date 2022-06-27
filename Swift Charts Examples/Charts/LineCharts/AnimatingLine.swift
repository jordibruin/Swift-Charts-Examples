//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct AnimatingLine: View {
	var isOverview: Bool

    @State private var x: Double = -0.4

	var body: some View {
		if isOverview {
			chart
				.allowsHitTesting(false)
		} else {
			List {
				Section {
					chart
				}

				customisation
			}
            .onAppear {
                if !isOverview {
                    x = -1
                    withAnimation(.linear(duration: 2)) {
                        x = 1
                    }
                }
            }
			.navigationBarTitle(ChartType.animatingLine.title, displayMode: .inline)
		}
	}

	private var chart: some View {
		AnimatedChart(x: x, isOverview: isOverview)
	}

	private var customisation: some View {
		Section {
			Button {
				withAnimation(.linear(duration: 2)) {
					x = (x == 1) ? -1 : 1
				}
			} label: {
				Text("Animate")
			}
			VStack(alignment: .leading) {
				Text("X Value: \(x, specifier: "%.2f")")
					.animation(.none)
				Slider(value: $x, in: -1...1) {
					Text("X Value")
				} minimumValueLabel: {
					Text("-1")
				} maximumValueLabel: {
					Text("1")
				}
			}
		}
	}
}

struct AnimatedChart: View, Animatable {

	var isOverview = false
	var animatableData: Double = 0

	init(x: Double, isOverview: Bool) {
		self.animatableData = x
		self.isOverview = isOverview
	}

	let samples = stride(from: -1, through: 1, by: 0.01).map {
		Sample(x: $0, y: pow($0, 3))
	}

	var body: some View {
		Chart {
			// Ideally, there'd be a way to not evaluate this every time.
			ForEach(samples) { sample in
				LineMark(
					x: .value("x", sample.x),
					y: .value("y", sample.y)
				)
                .accessibilityLabel("\(sample.x)")
                .accessibilityValue("\(sample.y)")
                .accessibilityHidden(isOverview)
			}

			PointMark(
				x: .value("x", animatableData),
				y: .value("y", pow(animatableData, 3))
			)
		}
        .accessibilityChartDescriptor(self)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}

	struct Sample: Identifiable {
		var x: Double
		var y: Double

		var id: some Hashable { x }
	}
}

// MARK: - Accessibility

extension AnimatedChart: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let xAxis = AXNumericDataAxisDescriptor(title: "Position",
                                                range: -1...1,
                                                gridlinePositions: []) { String(format: "%.2f", $0) }
        
        let yAxis = AXNumericDataAxisDescriptor(title: "Value",
                                                range: -1...1,
                                                gridlinePositions: []) { String(format: "%.2f", $0) }
        
        let series = AXDataSeriesDescriptor(name: "Data",
                                            isContinuous: true, dataPoints: self.samples.map {
            .init(x: $0.x, y: $0.y)
        })
        
        return AXChartDescriptor(title: "Animated Change in Data",
                                 summary: nil,
                                 xAxis: xAxis,
                                 yAxis: yAxis,
                                 additionalAxes: [],
                                 series: [series])
    }
}

// MARK: - Preview

struct AnimatingLine_Previews: PreviewProvider {
    static var previews: some View {
        AnimatingLine(isOverview: true)
        AnimatingLine(isOverview: false)
    }
}

