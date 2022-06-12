//
//  LineChartSimple.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

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
            Text("\(SalesData.last30DaysTotal, format: .number) Sales")
                .font(.title2.bold())

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
