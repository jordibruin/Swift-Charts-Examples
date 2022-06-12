//
//  LineChartSimpleView.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import SwiftUI
import Charts

struct LineChartSimpleDetailView: View {
    var body: some View {
        VStack {
            Chart(SalesData.last30Days, id: \.day) {
                LineMark(
                    x: .value("Date", $0.day),
                    y: .value("Sales", $0.sales)
                )
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            .frame(height: 300)
            .padding(.horizontal)
        }
        
    }
}

struct LineChartSimpleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartSimpleDetailView()
    }
}
