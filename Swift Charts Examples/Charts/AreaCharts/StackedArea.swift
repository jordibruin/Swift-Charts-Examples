//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct StackedArea: View {
    @State var isOverview: Bool

    private let data = LocationData.last30Days

    var body: some View {
        if isOverview {
            chart
        } else {
            List {
                Section {
                    chart
                }
            }
            .navigationBarTitle(ChartType.stackedArea.title, displayMode: .inline)
        }
    }

    private var chart: some View {
        Chart(data) { series in
            ForEach(series.sales, id: \.weekday) { element in
                AreaMark(
                    x: .value("Date", element.weekday),
                    y: .value("Sales", element.sales),
                    stacking: .center
                )
                .interpolationMethod(.cardinal)
                .foregroundStyle(by: .value("City", series.city))
            }
        }
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
        .chartLegend(isOverview ? .hidden : .automatic)
        .chartForegroundStyleScale(range: Gradient(colors: [.yellow, .blue]))
        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
    }
}

struct StackedArea_Previews: PreviewProvider {
    static var previews: some View {
        StackedArea(isOverview: true)
        StackedArea(isOverview: false)
    }
}
