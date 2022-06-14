//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct CustomizableHeatMapDetailView: View {
    @State var numRows: Int = 10
    @State var numCols: Int = 10
    @State var grid = Grid(numRows: 10, numCols: 10)
    @State var showColors = true
    @State var showValues = false
    
    var body: some View {
        List {
            Section {
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
//                        .annotation(position: .overlay, alignment: .center) {
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
//                        .annotation(position: .overlay, alignment: .center) {
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
            }
            .aspectRatio(contentMode: .fit)
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
        .navigationBarTitle("Customizable Heat Map", displayMode: .inline)
    }

    private func reloadGrid() {
        withAnimation {
            grid = Grid(numRows: numRows, numCols: numCols)
        }
    }
}

struct CustomizableHeatMapOverview: View {
    @State var grid = Grid(numRows: 10, numCols: 10)

    var body: some View {
        VStack (alignment: .leading) {
            Text("Customizable Heat Map")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            Chart(grid.points) { point in
                RectangleMark(
                    xStart: .value("xStart", point.x),
                    xEnd: .value("xEnd", point.x + 1),
                    yStart: .value("yStart", point.y),
                    yEnd: .value("yEnd", point.y + 1)
                )
                .foregroundStyle(point.color)
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .aspectRatio(contentMode: .fit)
        }
    }
}

struct CustomizableHeatMap_Previews: PreviewProvider {
    static var previews: some View {
        CustomizableHeatMapOverview()
        CustomizableHeatMapDetailView()
    }
}
