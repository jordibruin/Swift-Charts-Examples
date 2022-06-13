//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct LineChartSimpleChart: View {
    var body: some View {
        Chart(SalesData.last30Days, id: \.day) {
            LineMark(
                x: .value("Day", $0.day, unit: .day),
                y: .value("Sales", $0.sales)
            )
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

struct LineChartSimpleOverview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Line Chart (Simple)")
                .font(.callout)
                .foregroundStyle(.secondary)

            LineChartSimpleChart()
                .frame(height: 100)
        }
    }
}

struct SalesOverview_Previews: PreviewProvider {
    static var previews: some View {
        LineChartSimpleOverview()
            .padding()
    }
}
