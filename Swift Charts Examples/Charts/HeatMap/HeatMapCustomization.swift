//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct CustomizableHeatMapDetail: View {
    
    @State var numRows: Int = 10
    @State var numCols: Int = 10
    @State var grid = Grid(numRows: 10, numCols: 10)
    
    var body: some View {
        
        VStack {
            List {
                Section {
                    Chart(grid.points, id: \.self) { point in
                        RectangleMark(
                            xStart: PlottableValue.value("xStart", point.x),
                            xEnd: PlottableValue.value("xEnd", point.x + 1),
                            yStart: PlottableValue.value("yStart", point.y),
                            yEnd: PlottableValue.value("yEnd", point.y + 1)
                        )
                        .foregroundStyle(by: .value("Value", point.val))
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                }
                .frame(height: 300)
                Section {
                    Stepper {
                        Text("Rows: \(numRows)")
                    } onIncrement: {
                        numRows += 1
                        grid = Grid(numRows: numRows, numCols: numCols)
                        grid.generateData()
                    } onDecrement: {
                        numRows -= 1
                        grid = Grid(numRows: numRows, numCols: numCols)
                        grid.generateData()
                    }
                    
                    Stepper {
                        Text("Columns: \(numCols)")
                    } onIncrement: {
                        numCols += 1
                        grid = Grid(numRows: numRows, numCols: numCols)
                        grid.generateData()
                    } onDecrement: {
                        numCols -= 1
                        grid = Grid(numRows: numRows, numCols: numCols)
                        grid.generateData()
                    }
                }
            }

        }
        .onAppear {
            grid.generateData()
        }
    }
}

struct CustomizableHeatMapOverview: View {
    
    @State var gridPoints = [Grid.Point(x: 0, y: 0, val: 1), Grid.Point(x: 0, y: 1, val: 0), Grid.Point(x: 1, y: 1, val: 1), Grid.Point(x: 1, y: 0, val: 0)]
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Customizable Heat Map")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            Chart(gridPoints, id: \.self) { point in
                RectangleMark(
                    xStart: PlottableValue.value("xStart", point.x),
                    xEnd: PlottableValue.value("xEnd", point.x + 1),
                    yStart: PlottableValue.value("yStart", point.y),
                    yEnd: PlottableValue.value("yEnd", point.y + 1)
                )
                .foregroundStyle(by: .value("Value", point.val))
            }
            .frame(height: 250)
            .padding()
        }
    }
}

struct CustomizableHeatMapDetail_Previews: PreviewProvider {
    static var previews: some View {
        CustomizableHeatMapDetail()
    }
}
