//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation
import SwiftUI

struct Grid {
    let numRows: Int
    let numCols: Int
    var points = [Point]()

    init(numRows: Int, numCols: Int) {
        self.numRows = numRows
        self.numCols = numCols
        generateData()
    }
    
    mutating func generateData() {
        for rowIndex in 0..<numRows {
            for colIndex in 0..<numCols {
                let maxValue = numRows + numCols - 2
                let variance = Double.random(in: 0..<20) - 10
                let value = (Double(rowIndex + colIndex) * 100)/Double(maxValue) + variance
                let point = Point(x: Double(colIndex), y: Double(rowIndex), val: value)
                points.append(point)
            }
        }
    }
}
