//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct TwoBarsOverview: View {

    var data = LocationData.last7Days

    var body: some View {
        Chart {
            ForEach(LocationData.last7Days) { series in
                ForEach(series.sales, id: \.weekday) { element in
                    BarMark(
                        x: .value("Day", element.weekday, unit: .day),
                        y: .value("Sales", element.sales)
                    )
                    .accessibilityLabel("\(element.weekday.formatted())")
                    .accessibilityValue("\(element.sales)")
                    .foregroundStyle(by: .value("City", series.city))
                }
            }
        }
        // For the simple overview chart,
        // skip individual labels and only set the chartDescriptor
        .accessibilityChartDescriptor(self)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
        .frame(height: Constants.previewChartHeight)
    }
}

struct TwoBars: View {
    @State private var barWidth = 13.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var strideBy: ChartStrideBy = .day
    @State private var showLegend = false
    @State var showBarsStacked = true

    var body: some View {
        List {
            Section {
                Chart(LocationData.last7Days) { series in
                    ForEach(series.sales, id: \.weekday) { element in
                        BarMark(
                            x: .value("Day", element.weekday, unit: .day),
                            y: .value("Sales", element.sales),
                            width: .fixed(barWidth)
                        )
                        .accessibilityLabel("\(series.city) \(element.weekday.weekdayString)")
                        .accessibilityValue("\(element.sales) sold")
                        .foregroundStyle(by: .value("City", series.city))
                    }
                    .symbol(by: .value("City", series.city))
                    .interpolationMethod(.catmullRom)
                    .position(by: .value("City", showBarsStacked ? "Common" : series.city))
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: strideBy.time)) { _ in
                        AxisTick()
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                    }
                }
                .chartLegend(showLegend ? .visible : .hidden)
                .chartLegend(position: .top)
                .frame(height: Constants.detailChartHeight)
            }
            
            customisation
        }
        .navigationBarTitle(ChartType.twoBars.title, displayMode: .inline)
    }
    
    private var customisation: some View {
        Section {
            Stepper(value: $barWidth, in: 1.0...20.0) {
                HStack {
                    Text("Bar Width")
                    Spacer()
                    Text("\(String(format: "%.0f", barWidth))")
                }
            }
            
            Toggle("Show Chart Legend", isOn: $showLegend)
            Toggle("Show Bars Stacked", isOn: $showBarsStacked)
        }
    }
}

struct TwoBars_Previews: PreviewProvider {
    static var previews: some View {
        TwoBarsOverview()
        TwoBars()
    }
}
