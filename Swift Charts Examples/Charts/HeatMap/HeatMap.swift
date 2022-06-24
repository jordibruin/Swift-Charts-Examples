//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct HeatMapOverview: View {
    @State private var grid = Grid(numRows: 10, numCols: 10)
    var data: [Grid.Point] { grid.points }

    var body: some View {
        Chart(data) { point in
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
        .chartForegroundStyleScale(range: Gradient(colors: [.blue, .green, .yellow, .orange, .red]))
        .aspectRatio(contentMode: .fit)
    }
}

struct HeatMap: View {
    @State private var numRows = 10
    @State private var numCols = 10
    @State private var grid = Grid(numRows: 10, numCols: 10)
    @State private var showColors = true
    @State private var showValues = false
    
    var body: some View {
        List {
            Section {
                Chart(grid.points) { point in
                    RectangleMark(
                        xStart: PlottableValue.value("xStart", point.x),
                        xEnd: PlottableValue.value("xEnd", point.x + 1),
                        yStart: PlottableValue.value("yStart", point.y),
                        yEnd: PlottableValue.value("yEnd", point.y + 1)
                    )
                    // TODO: Using foregroundStyle hides the encoding from accessibility
                    .accessibilityLabel("\(point.x)")
                    .accessibilityValue("Y: \(point.y), value: \(point.val.formatted(.number))")
                    .foregroundStyle(by: .value("Value", point.val))
                    // Reported FB10250889
//                        .annotation(position: .overlay) {
//                            Text(showValues ? String(format: "%.0f", point.val) : "")
//                        }
                }
                .chartForegroundStyleScale(range: Gradient(colors: showColors ? [.blue, .green, .yellow, .orange, .red] : [.clear, .blue]))
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
