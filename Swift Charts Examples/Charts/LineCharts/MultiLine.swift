//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct MultiLine: View {
    @State var isOverview: Bool

    let data = LocationData.last30Days
    
    var body: some View {
        if isOverview {
            chart
                .accessibilityChartDescriptor(self)
        } else {
            List {
                Section {
                    chart
                }
            }
            .navigationBarTitle(ChartType.multiLine.title, displayMode: .inline)
        }
    }

    private var chart: some View {
        Chart(data) { series in
            ForEach(series.sales, id: \.weekday) { element in
                LineMark(
                    x: .value("Date", element.weekday),
                    y: .value("Sales", element.sales)
                )
                .accessibilityLabel("\(series.city) \(element.weekday.formatted(date: .abbreviated, time: .standard))")
                .accessibilityValue("\(element.sales) sold")
                .interpolationMethod(.cardinal)
                .foregroundStyle(by: .value("City", series.city))
            }
        }
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
        .chartLegend(isOverview ? .hidden : .automatic)
        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
    }
}

struct MultiLine_Previews: PreviewProvider {
    static var previews: some View {
        MultiLine(isOverview: true)
        MultiLine(isOverview: false)
    }
}
