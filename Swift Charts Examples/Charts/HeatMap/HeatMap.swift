//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct HeatMapOverview: View {
    @State private var data = HeatMapData().data

    var body: some View {
        VStack(alignment: .leading) {
            Text("Heat Map")
                .font(.callout)
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                Chart {
                    ForEach(data) {
                        RectangleMark(
                            x: .value("X", $0.x),
                            yStart: .value("Y", $0.y),
                            yEnd: .value("Y", $0.y + 1),
                            width: .fixed(geo.size.width / 10.0)
                        )
                        .opacity($0.value)
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .padding()
            }
            .aspectRatio(contentMode: .fit)
        }
    }
}

struct HeatMapOverview_Previews: PreviewProvider {
    static var previews: some View {
        HeatMapOverview()
            .padding()
    }
}

struct HeatMapDetailView: View {
    @State private var data = HeatMapData().data

    var body: some View {
        VStack(alignment: .leading) {
            Text("Heat Map")
                .font(.callout)
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                Chart {
                    ForEach(data) {
                        RectangleMark(
                            x: .value("X", $0.x),
                            yStart: .value("Y", $0.y),
                            yEnd: .value("Y", $0.y + 1),
                            width: .fixed(geo.size.width / 10.0)
                        )
                        .opacity($0.value)
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .padding()
            }
            .aspectRatio(contentMode: .fit)
        }
    }
}

struct HeatMapDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HeatMapDetailView()
    }
}

struct HeatMapData {
    var data: [DataPoint] = []

    init() {
        for x in 0..<10 {
            for y in 0..<10 {
                if x + y == 9 {
                    data.append(DataPoint(x: x, y: y, value: 1))
                } else {
                    data.append(DataPoint(x: x, y: y, value: Double(Int.random(in: 25..<75))/100.0))
                }
            }
        }
    }

    struct DataPoint: Identifiable {
        let id = UUID()
        let x: Int
        let y: Int
        let value: CGFloat
    }
}
