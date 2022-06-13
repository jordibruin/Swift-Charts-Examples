//
//  TwoBarsSimple.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import SwiftUI
import Charts

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
                .frame(height: 100)
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
    @State var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State var strideBy: ChartStrideBy = .day
    @State var showLegend = false

    var body: some View {
        List {
            Section {
                Chart(LocationData.last30Days) { series in
                    ForEach(series.sales, id: \.weekday) { element in
                        BarMark(
                            x: .value("Day", element.weekday, unit: .day),
                            y: .value("Sales", element.sales)
                        )
                        .accessibilityLabel("\(element.weekday.formatted())")
                        .accessibilityValue("\(element.sales)")
                    }
                    .foregroundStyle(by: .value("City", series.city))
                    .symbol(by: .value("City", series.city))
                    .interpolationMethod(.catmullRom)
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
                .frame(height: 240)
            }
            
            customisation
        }

        .navigationBarTitle("Two Bars", displayMode: .inline)
    }
    
    
    var customisation: some View {
        Section {
            Toggle("Show Chart Legend", isOn: $showLegend)
        }
    }
}

struct TwoBarsSimpleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TwoBarsSimpleDetailView()
    }
}
