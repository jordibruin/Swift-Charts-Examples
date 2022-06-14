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
                let point = Point(x: colIndex, y: rowIndex, val: value)
                points.append(point)
            }
        }
    }
    
    struct Point: Hashable, Identifiable {
        let id = UUID()
        let x: Int
        let y: Int
        let val: Double

        var color: Color {
            switch val {
            case _ where val < 20.0:
                return .blue
            case 20..<40:
                return .green
            case 40..<60:
                return .yellow
            case 60..<80:
                return .orange
            case _ where val >= 80:
                return .red
            default:
                return .red
            }
        }
    }
}
