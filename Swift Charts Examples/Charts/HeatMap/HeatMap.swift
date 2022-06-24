//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct HeatMapOverview: View {
    @State private var grid = Grid(numRows: 10, numCols: 10)

    var body: some View {
        Chart(grid.points) { point in
            RectangleMark(
                xStart: .value("xStart", point.x),
                xEnd: .value("xEnd", point.x + 1),
                yStart: .value("yStart", point.y),
                yEnd: .value("yEnd", point.y + 1)
            )
            .foregroundStyle(by: .value("Value", point.val))
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartForegroundStyleScale(range: Gradient(colors: [.blue, .green, .yellow, .orange, .red]))
        .aspectRatio(contentMode: .fit)
    }
}

struct HeatMap: View {

	var isOverview: Bool

    @State private var numRows = 10
    @State private var numCols = 10
    @State private var grid = Grid(numRows: 10, numCols: 10)
    @State private var showColors = true
    @State private var showValues = false

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
  			.navigationBarTitle(ChartType.customizeableHeatMap.title, displayMode: .inline)
  		}
    }

	private var chart: some View {
		Chart(grid.points) { point in
			if showColors {
				RectangleMark(
					xStart: PlottableValue.value("xStart", point.x),
					xEnd: PlottableValue.value("xEnd", point.x + 1),
					yStart: PlottableValue.value("yStart", point.y),
					yEnd: PlottableValue.value("yEnd", point.y + 1)
				)
				.foregroundStyle(point.color)
				// does not compile when annotations are paired with both `chartYAxis` and `chartXAxis`
				// Reported FB10250889
//                        .annotation(position: .overlay) {
//                            Text(showValues ? String(format: "%.0f", point.val) : "")
//                        }
			} else {
				RectangleMark(
					xStart: PlottableValue.value("xStart", point.x),
					xEnd: PlottableValue.value("xEnd", point.x + 1),
					yStart: PlottableValue.value("yStart", point.y),
					yEnd: PlottableValue.value("yEnd", point.y + 1)
				)
				.foregroundStyle(by: .value("Value", point.val))
//                        .annotation(position: .overlay) {
//                            Text(showValues ? String(format: "%.0f", point.val) : "")
//                        }
			}
		}
		.chartYAxis {
			AxisMarks(values: .automatic(desiredCount: grid.numRows,
										 roundLowerBound: false,
										 roundUpperBound: false)) { _ in
				AxisGridLine()
				AxisTick()
				AxisValueLabel(centered: true)
			}
		}
		.chartXAxis {
			AxisMarks(values: .automatic(desiredCount: grid.numCols,
										 roundLowerBound: false,
										 roundUpperBound: false)) { _ in
				AxisGridLine()
				AxisTick()
				AxisValueLabel(centered: true)
			}
		}
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}

	private var customisation: some View {
		Section {
			Stepper {
				Text("Rows: \(numRows)")
			} onIncrement: {
				numRows += 1
				reloadGrid()
			} onDecrement: {
				numRows -= 1
				reloadGrid()
			}
			Stepper {
				Text("Columns: \(numCols)")
			} onIncrement: {
				numCols += 1
				reloadGrid()
			} onDecrement: {
				numCols -= 1
				reloadGrid()
			}
			Toggle("Show Colors", isOn: $showColors)
//                Toggle("Show Annotations", isOn: $showValues)
		}
	}

    private func reloadGrid() {
        withAnimation {
            grid = Grid(numRows: numRows, numCols: numCols)
        }
    }
}

struct HeatMap_Previews: PreviewProvider {
    static var previews: some View {
        HeatMap(isOverview: true)
		HeatMap(isOverview: false)
    }
}
