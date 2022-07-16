//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct HeatMap: View {
	var isOverview: Bool

	@State private var numRows = 10
	@State private var numCols = 10
	@State private var showColors = true
	@State private var showValues = false

    @State var grid = Grid(numRows: 10, numCols: 10)
    
    var gradientColors: [Color] = [.blue, .green, .yellow, .orange, .red]
    var monotoneColors: [Color] = [.clear, .blue]

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
            Plot {
                let xVal = Int(point.x)
                let yVal = Int(point.y)
                let val = Int(point.val * 100)
                RectangleMark(
                    xStart: PlottableValue.value("xStart", xVal),
                    xEnd: PlottableValue.value("xEnd", xVal + 1),
                    yStart: PlottableValue.value("yStart", yVal),
                    yEnd: PlottableValue.value("yEnd", yVal + 1)
                )
                .foregroundStyle(by: .value("Value", val))
            }
            .accessibilityLabel("Point: (\(point.x), \(point.y))")
            .accessibilityValue("Color: \(accessibilityColorName(for: point))")
            .accessibilityHidden(isOverview)
			// Reported FB10250889
			//                        .annotation(position: .overlay) {
			//                            Text(showValues ? String(format: "%.0f", point.val) : "")
			//                        }
		}
		.chartForegroundStyleScale(range: Gradient(colors: showColors ? gradientColors : monotoneColors))
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
        .accessibilityChartDescriptor(self)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.aspectRatio(contentMode: .fit)
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
    
    func accessibilityColorName(for point: Point) -> String {
        let bins = bins
        let color = gradientColors[bins.index(for: point.val) ]
        
        return UIColor(color).accessibilityName
    }
}

// MARK: - Accessibility

protocol AccessibleGradientGrid {
    var grid: Grid { get set }
    var gradientColors: [Color] { get set }
}

extension AccessibleGradientGrid {
    var bins: NumberBins<Double> {
        let values = grid.points.map { $0.val }
        let min = values.min() ?? 0
        let max = values.max() ?? 0
        return NumberBins(range: min-1...max+1, count: gradientColors.count)
    }
    var accessibilityColorNames: [String] {
        return gradientColors.map { UIColor($0).accessibilityName }
    }
}

extension HeatMap: AXChartDescriptorRepresentable, AccessibleGradientGrid {
    func makeChartDescriptor() -> AXChartDescriptor {
       
        // The general approach here is to create a Series for each category/bin/group/gradient
        
        // Create an array of elements, each of which is an array of points.
        // The outer arrays indices line up with the gradientColors, so each nested list contains
        // points categorized as a color
        // Doing this allows VoiceOver to create a different "note"
        // for each data point that shares an X/Y values
        let bin = self.bins
        let data = grid.points
        var categories = Array(repeating: Array<Point>(),
                               count: gradientColors.count)
        data.forEach { point in
            categories[bin.index(for: point.val)].append(point)
        }
        
        // Limits for each axis
        let xmin = data.map(\.x).min() ?? 0
        let xmax = data.map(\.x).max() ?? 0
        let ymin = data.map(\.y).min() ?? 0
        let ymax = data.map(\.y).max() ?? 0
        let vmin = data.map(\.val).min() ?? 0
        let vmax = data.map(\.val).max() ?? 0
        
        // Create the axes
        let xAxis = AXNumericDataAxisDescriptor(
            title: "Horizontal Position",
            range: Double(xmin)...Double(xmax),
            gridlinePositions: Array(stride(from: xmin, to: xmax, by: 1)).map { Double($0) }
        ) { "X: \($0)" }

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Vertical Position",
            range: Double(ymin)...Double(ymax),
            gridlinePositions: Array(stride(from: ymin, to: ymax, by: 1)).map { Double($0) }
        ) { "Y: \($0)" }
        
        let valueAxis = AXNumericDataAxisDescriptor(
            title: "Value based Color",
            range: Double(vmin)...Double(vmax),
            gridlinePositions: []
        ) { "Color: \($0)" }
        
        // Finally create the series with the color category as a 3rd axes
        let series: [AXDataSeriesDescriptor] = categories.enumerated().map { idx, colorSeries in
            let dataPoints = colorSeries.map { point in
                return AXDataPoint(x: Double(point.x),
                                   y: Double(point.y),
                                   additionalValues: [.category(accessibilityColorNames[idx])],
                                   label: nil)
            }
            
            return AXDataSeriesDescriptor(name: accessibilityColorNames[idx],
                                          isContinuous: false,
                                          dataPoints: dataPoints)
            
        }

        return AXChartDescriptor(
            title: "Grid Data",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [valueAxis],
            series: series
        )
        
    }
}

// MARK: - Preview

struct HeatMap_Previews: PreviewProvider {
	static var previews: some View {
		HeatMap(isOverview: true)
		HeatMap(isOverview: false)
	}
}
