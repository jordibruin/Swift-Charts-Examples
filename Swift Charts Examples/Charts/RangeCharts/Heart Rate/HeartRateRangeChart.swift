//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct HeartRateRangeChartDetail: View {
    @State var barWidth = 10.0
    @State var chartColor: Color = .red
    @State var isShowingPoints: Bool = false
    
    var body: some View {
        List {
            Section(header: makeHeader()) {
                makeHeartRateChart()
                    .frame(height: 300)
            }
            
            customisation
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var customisation: some View {
        Section {
            Stepper(value: $barWidth, in: 5.0...20.0) {
                HStack {
                    Text("Bar Width")
                    Spacer()
                    Text("\(String(format: "%.0f",barWidth))")
                }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
        }
    }
    
    @ViewBuilder
    private func makeHeader() -> some View {
        VStack(alignment: .leading) {
            Text("Range")
            Text("\(HeartRateData.minBPM)-\(HeartRateData.maxBPM) ")
                .font(.system(.title, design: .rounded))
                .foregroundColor(.black)
            + Text("BPM")
            
            Text("\(HeartRateData.dateInterval), ") + Text(HeartRateData.latestDate, format: .dateTime.year())
            
        }.fontWeight(.semibold)
    }
    
    @ViewBuilder
    private func makeHeartRateChart() -> some View {
        Chart(HeartRateData.lastWeek, id: \.weekday) {
            BarMark(
                x: .value("Day", $0.weekday, unit: .day),
                yStart: .value("BPM Min", $0.dailyMin),
                yEnd: .value("BPM Max", $0.dailyMax),
                width: .fixed(barWidth)
            )
            .clipShape(Capsule())
            .foregroundStyle(chartColor.gradient)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: ChartStrideBy.day.time)) { _ in
                AxisTick()
                AxisGridLine()
                AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
            }
        }
    }
}

struct HeartRateRangeChartDetail_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateRangeChartDetail()
    }
}

struct HeartRateRangeChartOverview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Heart Rate Range Chart")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            Chart(HeartRateData.lastWeek, id: \.weekday) {
                BarMark(
                    x: .value("Day", $0.weekday, unit: .day),
                    yStart: .value("BPM Min", $0.dailyMin),
                    yEnd: .value("BPM Max", $0.dailyMax),
                    width: .fixed(10)
                )
                .clipShape(Capsule())
                .foregroundStyle(.red.gradient)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: ChartStrideBy.day.time)) { _ in
                    AxisTick()
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                }
            }
            .frame(height: 100)
        }
    }
}


struct HeartRateRangeChart_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateRangeChartOverview()
    }
}
