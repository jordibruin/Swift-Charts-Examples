//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct RangeChartSimpleDetail: View {
    enum DataType: String, CaseIterable, Identifiable {
        case sales
        case heartRate
        
        var id: Self { self }
    }
    
    @State var barWidth = 10.0
    @State var chartColor: Color = .blue
    @State var isShowingPoints: Bool = false
    @State var dataType: DataType = .sales
    
    var body: some View {
        List {
            Section(header: makeHeader(for: self.dataType)) {
                makeChart(for: self.dataType)
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
            Toggle("Show Min & Max Points", isOn: $isShowingPoints.animation())
            Picker("Data", selection: $dataType) {
                ForEach(DataType.allCases) {
                    Text($0.rawValue.capitalized)
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeHeader(for type: DataType) -> some View {
        switch type {
        case .sales:
            Text("Sales in last 12 months")
        case .heartRate:
            VStack(alignment: .leading) {
                Text("Range")
                Text("\(HeartRateData.minBPM)-\(HeartRateData.maxBPM) ")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.black)
                + Text("BPM")
                
                Text("\(HeartRateData.dateInterval), ") + Text(HeartRateData.latestDate, format: .dateTime.year())
                
            }.fontWeight(.semibold)
        }
    }
    
    @ViewBuilder
    private func makeChart(for type: DataType) -> some View {
        switch type {
        case .sales:
            makeSalesChart()
        case .heartRate:
            makeHeartRateChart()
        }
    }
    
    @ViewBuilder
    private func makeSalesChart() -> some View {
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
                .offset(y: -(5 + barWidth / 4))
                .foregroundStyle(.yellow.gradient)
                .symbolSize(barWidth * 5)
                
                PointMark(
                    x: .value("Month", $0.month, unit: .month),
                    y: .value("Sales Max", $0.dailyMax)
                )
                .offset(y: 5 + barWidth / 4)
                .foregroundStyle(.yellow.gradient)
                .symbolSize(barWidth * 5)
            }
        }
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
