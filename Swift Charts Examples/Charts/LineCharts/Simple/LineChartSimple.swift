//
//  LineChartSimple.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import SwiftUI
import Charts

struct LineChartSimpleOverview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Line Chart")
                .font(.callout)
                .foregroundStyle(.secondary)

            Chart(SalesData.last30Days, id: \.day) {
                LineMark(
                    x: .value("Day", $0.day, unit: .day),
                    y: .value("Sales", $0.sales)
                )
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
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
