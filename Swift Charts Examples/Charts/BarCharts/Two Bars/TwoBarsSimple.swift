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
                    .symbol(by: .value("City", series.city))
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
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
