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
				PointMark(
					x: .value("x", point.x),
					y: .value("y", point.y)
				)
			}
			.foregroundStyle(plotChartColor.opacity(0.2))

			ForEach(linePoints) { point in
				LineMark(
					x: .value("x", point.x),
					y: .value("y", point.y)
				)
			}
			.foregroundStyle(lineChartColor)
		}
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

struct LinePlotPoints_Previews: PreviewProvider {
    static var previews: some View {
		LinePlot(isOverview: true)
        LinePlot(isOverview: false)
    }
}
