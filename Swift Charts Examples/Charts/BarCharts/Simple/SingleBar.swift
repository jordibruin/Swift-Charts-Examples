//
//  BarSimple.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import SwiftUI
import Charts

struct SingleBarDetailView: View {
    @State var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State var chartColor: Color = .blue
    
    var body: some View {
        List {
            Section {
                Chart(SalesData.last30Days, id: \.day) {
                    BarMark(
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

struct AreaChartSimpleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartSimpleDetailView()
    }
}

struct BarChartSimpleOverview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Single Bar")
                .font(.callout)
                .foregroundStyle(.secondary)

            Chart(SalesData.last30Days, id: \.day) {
                BarMark(
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

struct BarChartSimpleOverview_Previews: PreviewProvider {
    static var previews: some View {
        BarChartSimpleOverview()
            .padding()
    }
}
