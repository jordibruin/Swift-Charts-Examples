//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI

struct Point: Hashable, Identifiable {
	let id = UUID()
	let x: Double
	let y: Double
	let val: Double

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

extension Array where Element == Point {
	static func createLineSinPoints(xRange: Range<Int> = 0..<100, randomRange: ClosedRange<Int> = -5...5) -> [Point] {
		stride(from: xRange.lowerBound, through: xRange.upperBound, by: 1).map {
			Point(x: Double($0),
				  y: sin(Double($0) * 0.2) * 100 + Double(Int.random(in: randomRange)),
				  val: 1)
		}
	}

	static func createPlotSinPoints(xRange: Range<Int> = 0..<100, yRange: Range<Int> = 0..<10, randomRange: ClosedRange<Int> = -25...25) -> [Point] {
		var points = [Point]()
		for x in xRange {
			for _ in yRange {
				points.append(Point(x: Double(x),
									y: sin(Double(x) * 0.2) * 100 + Double(Int.random(in: randomRange)),
									val: 0.2))
			}
		}
		return points
	}
}
