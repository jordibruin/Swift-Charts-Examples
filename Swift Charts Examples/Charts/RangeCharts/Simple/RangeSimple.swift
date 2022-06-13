//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct RangeChartSimpleDetail: View {
    
    @State var barWidth = 10.0
    @State var chartColor: Color = .blue
    
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
                }
                .frame(height: 300)
            }
            
            customisation
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var customisation: some View {
        Section {
            Stepper(value: $barWidth, in: 1.0...20.0) {
                HStack {
                    Text("Bar Width")
                    Spacer()
                    Text("\(String(format: "%.0f",barWidth))")
                }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
        }
    }
}

struct RangeChartSimpleDetail_Previews: PreviewProvider {
    static var previews: some View {
        RangeChartSimpleDetail()
    }
}

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
            .frame(height: 100)
        }
    }
}


struct SingleRangeChart_Previews: PreviewProvider {
    static var previews: some View {
        RangeChartSimpleOverview()
    }
}
