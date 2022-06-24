//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct ScatterChartOverview: View {
    
    @State var data = LocationData.last30Days
    
    var body: some View {
        Chart {
            ForEach(data) { series in
                ForEach(series.sales, id: \.weekday) { element in
                    PointMark(
                        x: .value("Day", element.weekday, unit: .day),
                        y: .value("Sales", element.sales)
                    )
                }
                .foregroundStyle(by: .value("City", series.city))
                .symbol(by: .value("City", series.city))
            }
        }
        .accessibilityChartDescriptor(self)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
        .frame(height: Constants.previewChartHeight)
    }
}

struct ScatterChart: View {
    @State private var pointSize = 10.0
    @State private var showLegend = false
    
    var body: some View {
        List {
            Section {
                Chart {
                    ForEach(LocationData.last30Days) { series in
                        ForEach(series.sales, id: \.weekday) { element in
                            PointMark(
                                x: .value("Day", element.weekday, unit: .day),
                                y: .value("Sales", element.sales)
                            )
                            .accessibilityLabel("\(series.city), \(element.weekday.formatted(date: .complete, time: .omitted))")
                            .accessibilityValue("\(element.sales) sold")
                        }
                        .foregroundStyle(by: .value("City", series.city))
                        .symbol(by: .value("City", series.city))
                        .symbolSize(pointSize * 5)
                    }
                }
                .chartLegend(showLegend ? .visible : .hidden)
                .chartLegend(position: .bottomLeading)
                .frame(height: Constants.detailChartHeight)
            }
            
            customisation
        }
        .navigationBarTitle(ChartType.scatter.title, displayMode: .inline)
    }
    
    private var customisation: some View {
        Section {
            Stepper(value: $pointSize.animation(), in: 1.0...20.0) {
                HStack {
                    Text("Point Width")
                    Spacer()
                    Text("\(String(format: "%.0f", pointSize))")
                }
            }
            
            Toggle("Show Chart Legend", isOn: $showLegend.animation())
        }
    }
}

struct ScatterChart_Previews: PreviewProvider {
    static var previews: some View {
        ScatterChartOverview()
        ScatterChart()
    }
}
