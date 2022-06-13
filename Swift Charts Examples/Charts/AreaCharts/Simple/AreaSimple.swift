//
//  AreaChartSimple.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import Foundation

//
//  LineChartSimpleView.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import SwiftUI
import Charts

struct AreaChartSimpleDetailView: View {
    @State var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State var chartColor: Color = .blue
    
    var body: some View {
        List {
            Section {
                Chart(SalesData.last30Days, id: \.day) {
                    AreaMark(
                        x: .value("Date", $0.day),
                        y: .value("Sales", $0.sales)
                    )
                    .foregroundStyle(chartColor)
                    .interpolationMethod(interpolationMethod.mode)
                }
                .frame(height: 300)
            }
            
            customisation
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var customisation: some View {
        Section {
            Picker("Interpolation Method", selection: $interpolationMethod) {
                ForEach(ChartInterpolationMethod.allCases) { Text($0.mode.description).tag($0) }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
        }
    }
}

struct BarChartSimpleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartSimpleDetailView()
    }
}

struct AreaChartSimpleOverview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Area Chart")
                .font(.callout)
                .foregroundStyle(.secondary)

            Chart(SalesData.last30Days, id: \.day) {
                AreaMark(
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

struct AreaChartSimpleOverview_Previews: PreviewProvider {
    static var previews: some View {
        AreaChartSimpleOverview()
            .padding()
    }
}
