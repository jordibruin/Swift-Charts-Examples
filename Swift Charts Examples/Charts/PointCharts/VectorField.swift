//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct VectorField: View {
	var isOverview: Bool

    @State var grid = Grid(numRows: 20, numCols: 20)
    
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
            // Use accessibility modifiers on the Plot,
            // otherwise modifier order may prevent accessibility being actually set
            Plot {
                PointMark(x: .value("x", point.x),
                          y: .value("y", point.y))
                .symbol(Arrow(angle: CGFloat(point.angle(degreeOffset: degreeOffset)), size: size))
                .foregroundStyle(point.angleColor(hueOffset: hueOffset))
                .opacity(opacity)
            }
            .accessibilityLabel("Point: (\(point.x), \(point.y))")
            .accessibilityValue("Angle: \(Int(point.angle(degreeOffset: degreeOffset, inRadians: false))) degrees, Color: \(XColor(point.angleColor(hueOffset: degreeOffset)).accessibilityName)")
            .accessibilityHidden(isOverview)
		}
        .accessibilityChartDescriptor(self)
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

// MARK: - Accessibility

extension VectorField: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        
        // The general approach here is to create a Series for each angle based color
        let data = grid.points
    
        // Create a dictionary mapping color names to points they apply to
        // i.e. [Colorname(String) : list of points that are categorized as Colorname]
        var unorderedColorGroups: [String: [Point]] = [:]
        data.forEach { point in
            let colorName = XColor(point.angleColor(hueOffset: 0)).accessibilityName
            if
                unorderedColorGroups.keys.contains(colorName),
                var pointList = unorderedColorGroups[colorName] {
                pointList.append(point)
                unorderedColorGroups[colorName] = pointList
            } else {
                unorderedColorGroups[colorName] = [point]
            }
        }
        
        // Limits for each axis
        let xmin = data.map(\.x).min() ?? 0
        let xmax = data.map(\.x).max() ?? 0
        let ymin = data.map(\.y).min() ?? 0
        let ymax = data.map(\.y).max() ?? 0
        let vmin = data.map(\.val).min() ?? 0
        let vmax = data.map(\.val).max() ?? 0
        
        // Create the axes
        let xAxis = AXNumericDataAxisDescriptor(
            title: "Horizontal Position",
            range: Double(xmin)...Double(xmax),
            gridlinePositions: Array(stride(from: xmin, to: xmax, by: 1)).map { Double($0) }
        ) { "X: \($0)" }

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Vertical Position",
            range: Double(ymin)...Double(ymax),
            gridlinePositions: Array(stride(from: ymin, to: ymax, by: 1)).map { Double($0) }
        ) { "Y: \($0)" }
        
        let valueAxis = AXNumericDataAxisDescriptor(
            title: "Value based Color",
            range: Double(vmin)...Double(vmax),
            gridlinePositions: []
        ) { "Color: \($0)" }
        
        // Finally create the series with the color category as a 3rd axes
        let series: [AXDataSeriesDescriptor] = unorderedColorGroups.map { (colorName, points) in
            let dataPoints = points.map { point in
                AXDataPoint(x: Double(point.x),
                            y: Double(point.y),
                            additionalValues: [.category(colorName)],
                            label: nil)
            }
            
            return AXDataSeriesDescriptor(name: colorName,
                                          isContinuous: false,
                                          dataPoints: dataPoints)
        }
        
        return AXChartDescriptor(
            title: "Vector Field Data",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [valueAxis],
            series: series
        )
    }
}

// MARK: - Preview

struct VectorField_Previews: PreviewProvider {
    static var previews: some View {
        VectorField(isOverview: true)
		VectorField(isOverview: false)
    }
}
