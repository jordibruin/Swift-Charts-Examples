//
//  LineChartSimpleView.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import SwiftUI
import Charts

struct LineChartSimpleDetailView: View {
    
    @State var lineWidth = 2.0
    @State var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State var chartColor: Color = .blue
    
    var body: some View {
        List {
            Section {
                
                Chart(SalesData.last30Days, id: \.day) {
                    LineMark(
                        x: .value("Date", $0.day),
                        y: .value("Sales", $0.sales)
                    )
                    .lineStyle(StrokeStyle(lineWidth: lineWidth))
                    .foregroundStyle(chartColor)
                    .interpolationMethod(interpolationMethod.mode)
                }
                .frame(height: 300)
            }
            
            Section {
                Stepper(value: $lineWidth, in: 1.0...20.0) {
                    HStack {
                        Text("Line Width")
                        Spacer()
                        Text("\(String(format: "%.0f",lineWidth))")
                    }
                }
                
                Picker("Interpolation Method", selection: $interpolationMethod) {
                    ForEach(ChartInterpolationMethod.allCases) { Text($0.mode.description).tag($0) }
                }
                
                ColorPicker("Color Picker", selection: $chartColor)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LineChartSimpleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartSimpleDetailView()
    }
}
