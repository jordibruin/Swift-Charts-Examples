//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct HeatMapMultiColorOverview: View {
    @State private var data = HeatMapData().data

    var body: some View {
        VStack(alignment: .leading) {
            Text("Heat Map Multi Color")
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
                        .foregroundStyle(
                            correctColor(value: $0.value)
                        )
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .padding()
            }
            .aspectRatio(contentMode: .fit)
        }
    }
    
    func correctColor(value: CGFloat) -> Color {
        if value < 0.25 {
            return .red
        } else if value < 0.5 {
            return .orange
        } else if value < 0.8 {
            return .yellow
        } else {
            return .green
        }
    }
}

struct HeatMapMultiColorOverview_Previews: PreviewProvider {
    static var previews: some View {
        HeatMapMultiColorOverview()
            .padding()
    }
}

struct HeatMapMultiColorDetailView: View {
    @State private var data = HeatMapData().data

    var body: some View {
        List {
            Section {
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
                            .foregroundStyle(
                                correctColor(value: $0.value)
                            )
                            
                        }
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .padding()
                    
                }
                .aspectRatio(contentMode: .fit)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func correctColor(value: CGFloat) -> Color {
        if value < 0.25 {
            return .red
        } else if value < 0.5 {
            return .orange
        } else if value < 0.8 {
            return .yellow
        } else {
            return .green
        }
    }
}

struct HeatMapMultiColorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HeatMapMultiColorDetailView()
    }
}
