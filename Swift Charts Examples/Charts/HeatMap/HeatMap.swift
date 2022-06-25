//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

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

struct HeatMapOverview: View, AccessibleGradientGrid {
    @State var grid = Grid(numRows: 10, numCols: 10)
    
    var gradientColors: [Color] = [.blue, .green, .yellow, .orange, .red]
    
    
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
        .accessibilityChartDescriptor(self)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartForegroundStyleScale(range: Gradient(colors: gradientColors))
        .aspectRatio(contentMode: .fit)
    }
}

struct HeatMap: View, AccessibleGradientGrid {
    @State var grid = Grid(numRows: 10, numCols: 10)
    var gradientColors: [Color] = [.blue, .green, .yellow, .orange, .red]
    var monotoneColors: [Color] = [.clear, .blue]

    @State private var numRows = 10
    @State private var numCols = 10
    @State private var showColors = true
    @State private var showValues = false
    
    func accessibilityColorName(for point: Grid.Point) -> String {
        let bins = bins
        let color = gradientColors[bins.index(for: point.val) ]
        
        return UIColor(color).accessibilityName
    }
    
    var body: some View {
        List {
            Section {
                Chart(grid.points) { point in
                    // Using accessibilityLabel on the RectangleMark does not work as expected
                    Plot {
                        RectangleMark(
                            xStart: PlottableValue.value("xStart", point.x),
                            xEnd: PlottableValue.value("xEnd", point.x + 1),
                            yStart: PlottableValue.value("yStart", point.y),
                            yEnd: PlottableValue.value("yEnd", point.y + 1)
                        )
                        // TODO: Using foregroundStyle hides the encoding from accessibility
                        .foregroundStyle(by: .value("Value", point.val))
                    }
                    .accessibilityLabel("Point: (\(point.x), \(point.y))")
                    .accessibilityValue("Color: \(accessibilityColorName(for: point))")
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
                .aspectRatio(contentMode: .fit)
            }
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
        .navigationBarTitle(ChartType.customizeableHeatMap.title, displayMode: .inline)
    }

    private func reloadGrid() {
        withAnimation {
            grid = Grid(numRows: numRows, numCols: numCols)
        }
    }
}

struct HeatMap_Previews: PreviewProvider {
    static var previews: some View {
        HeatMapOverview()
        HeatMap()
    }
}
