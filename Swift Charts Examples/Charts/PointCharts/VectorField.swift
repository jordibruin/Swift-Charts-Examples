//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct VectorFieldOverview: View {
    @State private var grid = Grid(numRows: 20, numCols: 20)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(ChartType.vectorField.title)
                .font(.callout)
                .foregroundStyle(.secondary)
            
            Chart(grid.points) { point in
                let angle = (point.val * 2.0 * .pi)/100.0
                PointMark(x: .value("x", point.x),
                          y: .value("y", point.y))
                .symbol(Arrow(angle: CGFloat(angle), size: 50))
                .foregroundStyle(by: .value("angle", angle))
                .opacity(0.7)
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .aspectRatio(contentMode: .fit)
        }
    }
}

struct VectorField: View {
    @State private var grid = Grid(numRows: 20, numCols: 20)
    
    var body: some View {
        List {
            Section {
                Chart(grid.points) { point in
                    let angle = (point.val * 2.0 * .pi)/100.0
                    PointMark(x: .value("x", point.x),
                              y: .value("y", point.y))
                    .symbol(Arrow(angle: CGFloat(angle), size: 50))
                    .foregroundStyle(by: .value("angle", angle))
                    .opacity(0.7)
                }
                .aspectRatio(contentMode: .fit)
            }
        }
        .navigationBarTitle(ChartType.vectorField.title, displayMode: .inline)
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
        VectorField()
    }
}
