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
            var returnColor: Color = .red
            switch val {
            case _ where val < 20.0:
                returnColor = .blue
            case 20..<40:
                returnColor = .green
            case 40..<60:
                returnColor = .yellow
            case 60..<80:
                returnColor = .orange
            case _ where val >= 80:
                returnColor = .red
            default:
                returnColor = .red
            }

            return returnColor.opacity(Double.random(in: 0.75...1.0))
        }

        var accessibilityColorName: String {
            UIColor(color).accessibilityName
        }
        
        func angle(degreeOffset: Double, inRadians: Bool = true) -> Double {
            // around 180-360 range
            let degrees = (val / 100.0) * 180.0 + 180 + degreeOffset
            let radians = (degrees * .pi) / 180.0
            return inRadians ? radians : degrees
        }

        func angleColor(hueOffset: Double) -> Color {
            Color(hue: ((val / 100.0) * 360.0 + hueOffset)/360.0, saturation: 1, brightness: 1)
        }
    }
}
