//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts
import DataFactory

struct TwoBarsSimpleOverview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Two Bars")
                .font(.callout)
                .foregroundStyle(.secondary)

            Chart {
                ForEach(LocationData.last30Days) { series in
                    ForEach(series.sales, id: \.weekday) { element in
                        BarMark(
                            x: .value("Day", element.weekday, unit: .day),
                            y: .value("Sales", element.sales)
                        )
                        .accessibilityLabel("\(element.weekday.formatted())")
                        .accessibilityValue("\(element.sales)")
                    }
                    .foregroundStyle(by: .value("City", series.city))
//                    .symbol(by: .value("City", series.city))
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartLegend(.hidden)
            .frame(height: Constants.previewChartHeight)
        }
    }
}

struct TwoBarsOverview_Previews: PreviewProvider {
    static var previews: some View {
        TwoBarsSimpleOverview()
            .padding()
    }
}

struct TwoBarsSimpleDetailView: View {
    @State private var barWidth = 13.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var strideBy: ChartStrideBy = .day
    @State private var showLegend = false
    @State var showBarsStacked = true

    var body: some View {
        List {
            Section {
                Chart(LocationData.last30Days) { series in
                    ForEach(series.sales, id: \.weekday) { element in
                        BarMark(
                            x: .value("Day", element.weekday, unit: .day),
                            y: .value("Sales", element.sales),
                            width: .fixed(barWidth)
                        )
                        .accessibilityLabel("\(element.weekday.formatted())")
                        .accessibilityValue("\(element.sales)")
                    }
                    .foregroundStyle(by: .value("City", series.city))
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
        .navigationBarTitle("Two Bars", displayMode: .inline)
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

struct TwoBarsSimpleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TwoBarsSimpleDetailView()
    }
}
