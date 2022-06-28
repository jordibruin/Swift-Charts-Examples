//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct LinePlot: View {
	var isOverview: Bool

	private var linePoints: [Point]
	private var plotPoints: [Point]

	@State private var plotChartColor: Color = .blue
	@State private var lineChartColor: Color = .red

	init(isOverview: Bool) {
		self.isOverview = isOverview
		self.linePoints = .createLineSinPoints()
		self.plotPoints = .createPlotSinPoints(yRange: isOverview ? 0..<5 : 0..<10)
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
			.navigationBarTitle(ChartType.linePoint.title, displayMode: .inline)
		}
    }

	private var chart: some View {
		Chart {
			ForEach(plotPoints) { point in
                Plot {
                    PointMark(
                        x: .value("x", point.x),
                        y: .value("y", point.y)
                    )
                }
                .accessibilityLabel("Plot Series")
                .accessibilityValue("X: \(point.x), Y: \(point.y)")
                .accessibilityHidden(isOverview)
			}
			.foregroundStyle(plotChartColor.opacity(0.2))

			ForEach(linePoints) { point in
                Plot {
                    LineMark(
                        x: .value("x", point.x),
                        y: .value("y", point.y)
                    )
                }
                .accessibilityLabel("Line Series")
                .accessibilityValue("X: \(point.x), Y: \(point.y)")
                .accessibilityHidden(isOverview)
			}
			.foregroundStyle(lineChartColor)
		}
        .accessibilityChartDescriptor(self)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}

	private var customisation: some View {
		Section {
			ColorPicker("Plot Chart Color", selection: $plotChartColor, supportsOpacity: false)
			ColorPicker("Line Chart Color", selection: $lineChartColor, supportsOpacity: false)
		}
	}
}

// MARK: - Accessibility

extension LinePlot: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let lineMin = linePoints.map(\.y).min() ?? 0
        let lineMax = linePoints.map(\.y).max() ?? 0
        let plotMin = plotPoints.map(\.y).min() ?? 0
        let plotMax = plotPoints.map(\.y).max() ?? 0
        let ymin = min(lineMin, plotMin)
        let ymax = max(lineMax, plotMax)

        let xAxis = AXNumericDataAxisDescriptor(
            title: "Index",
            range: Double(0)...max(linePoints.map(\.x).max() ?? 0,
                                   plotPoints.map(\.x).max() ?? 0),
            gridlinePositions: []
        ) { value in "\(Int(value))" }

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Value",
            range: Double(ymin)...Double(ymax),
            gridlinePositions: []
        ) { value in "\(value)" }

        let lineSeries = AXDataSeriesDescriptor(
            name: "Line data series",
            isContinuous: true,
            dataPoints: linePoints.map {
                .init(x: Double($0.x), y: Double($0.y))
            }
        )
        
        let plotSeries = AXDataSeriesDescriptor(
            name: "Plot data series",
            isContinuous: false,
            dataPoints: plotPoints.map {
                .init(x: Double($0.x), y: Double($0.y))
            }
        )

        return AXChartDescriptor(
            title: "Generated Sine data",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [lineSeries, plotSeries]
        )
    }
}

// MARK: - Preview

struct LinePlotPoints_Previews: PreviewProvider {
    static var previews: some View {
		LinePlot(isOverview: true)
        LinePlot(isOverview: false)
    }
}
