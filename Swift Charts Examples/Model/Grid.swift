//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation

struct Grid {
    
    let numRows: Int
    let numCols: Int
    var points = [Point]()
    
    mutating func generateData() {
        for rowIndex in 0..<numRows {
            for colIndex in 0..<numCols {
                points.append(Point(x: colIndex, y: rowIndex, val: rowIndex == colIndex ? 100 : Int.random(in: 0..<50)))
            }
        }
    }
    
    struct Point: Hashable {
        let x: Int
        let y: Int
        let val: Int
    }
}
