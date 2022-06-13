//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct RangeChartSimpleOverview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Range Chart")
                .font(.callout)
                .foregroundStyle(.secondary)

            Chart(SalesData.last12Months, id: \.month) {
                BarMark(
                    x: .value("Month", $0.month, unit: .month),
                    yStart: .value("Sales Min", $0.dailyMin),
                    yEnd: .value("Sales Max", $0.dailyMax)
                )
                .foregroundStyle(.blue.gradient)
                .clipShape(Capsule())
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: Constants.previewChartHeight)
        }
    }
}

struct RangeChartSimpleOverview_Previews: PreviewProvider {
    static var previews: some View {
        RangeChartSimpleOverview()
    }
}

struct RangeChartSimpleDetailView: View {
    @State private var barWidth = 10.0
    @State private var chartColor: Color = .blue
    @State private var isShowingPoints: Bool = false
    
    var body: some View {
        List {
            Section {
                Chart(SalesData.last12Months, id: \.month) {
                    BarMark(
                        x: .value("Month", $0.month, unit: .month),
                        yStart: .value("Sales Min", $0.dailyMin),
                        yEnd: .value("Sales Max", $0.dailyMax),
                        width: .fixed(barWidth)
                    )
                    .clipShape(Capsule())
                    .foregroundStyle(chartColor.gradient)
                    
                    if isShowingPoints {
                        PointMark(
                            x: .value("Month", $0.month, unit: .month),
                            y: .value("Sales Min", $0.dailyMin)
                        )
                        .offset(y: -5)
                        .foregroundStyle(.yellow.gradient)
                        
                        PointMark(
                            x: .value("Month", $0.month, unit: .month),
                            y: .value("Sales Max", $0.dailyMax)
                        )
                        .offset(y: 5)
                        .foregroundStyle(.yellow.gradient)
                    }
                }
                .frame(height: Constants.detailChartHeight)
            }
            
            customisation
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var customisation: some View {
        Section {
            Stepper(value: $barWidth, in: 5.0...20.0) {
                HStack {
                    Text("Bar Width")
                    Spacer()
                    Text("\(String(format: "%.0f", barWidth))")
                }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
            Toggle("Show Min & Max Points", isOn: $isShowingPoints.animation())
        }
    }
}

struct RangeChartSimpleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RangeChartSimpleDetailView()
    }
}
