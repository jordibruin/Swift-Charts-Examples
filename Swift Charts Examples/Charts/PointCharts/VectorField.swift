//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct VectorField: View {
	
	var isOverview: Bool = false

    @State private var grid = Grid(numRows: 20, numCols: 20)
    @State private var degreeOffset = 0.0
    @State private var hueOffset = 0.0
    @State private var opacity = 0.7
    @State private var size = 50.0
    
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
			.navigationBarTitle(ChartType.vectorField.title, displayMode: .inline)
		}
    }

	private var chart: some View {
		Chart(grid.points) { point in
			PointMark(x: .value("x", point.x),
					  y: .value("y", point.y))
			.symbol(Arrow(angle: CGFloat(point.angle(degreeOffset: degreeOffset)), size: size))
			.foregroundStyle(point.angleColor(hueOffset: hueOffset))
			.opacity(opacity)
		}
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.aspectRatio(contentMode: .fit)
	}

    private var customisation: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Degrees Offset: \(degreeOffset, specifier: "%.0f")")
                Slider(value: $degreeOffset, in: 0...360) {
                    Text("Degrees Offset")
                }
                minimumValueLabel: {
                    Text("0")
                }
                maximumValueLabel: {
                    Text("360")
                }
            }
            VStack(alignment: .leading) {
                Text("Hue Offset: \(hueOffset, specifier: "%.0f")")
                Slider(value: $hueOffset, in: -360...360) {
                    Text("Hue Offset")
                }
                minimumValueLabel: {
                    Text("-360")
                }
                maximumValueLabel: {
                    Text("360")
                }
            }
            VStack(alignment: .leading) {
                Text("Opacity: \(opacity, specifier: "%.2f")")
                Slider(value: $opacity, in: 0...1) {
                    Text("Opacity")
                }
                minimumValueLabel: {
                    Text("0")
                }
                maximumValueLabel: {
                    Text("1")
                }
            }
            VStack(alignment: .leading) {
                Text("Symbol Size: \(size, specifier: "%.0f")")
                Slider(value: $size, in: 1...200) {
                    Text("Symbol Size")
                }
                minimumValueLabel: {
                    Text("1")
                }
                maximumValueLabel: {
                    Text("200")
                }
            }
        }
    }
}

struct Arrow: ChartSymbolShape {
    let angle: CGFloat
    let size: CGFloat

    func path(in rect: CGRect) -> Path {
        let w = rect.width * size * 0.05 + 0.6
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 1))
        path.addLine(to: CGPoint(x: -0.2, y: -0.5))
        path.addLine(to: CGPoint(x: 0.2, y: -0.5))
        path.closeSubpath()
        return path.applying(.init(rotationAngle: angle))
            .applying(.init(scaleX: w, y: w))
            .applying(.init(translationX: rect.midX, y: rect.midY))
    }

    var perceptualUnitRect: CGRect {
        return CGRect(x: 0, y: 0, width: 1, height: 1)
    }
}

struct VectorField_Previews: PreviewProvider {
    static var previews: some View {
        VectorField(isOverview: true)
		VectorField()
    }
}
