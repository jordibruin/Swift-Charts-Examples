//
//  TwoBarsDetail.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import SwiftUI
import Charts



struct TwoBarsSimpleDetailView: View {

    @State var lineWidth = 2.0
    @State var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State var strideBy: ChartStrideBy = .day

    var body: some View {
        List {
            Section {
                Chart(LocationData.last30Days) { series in
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
                    .interpolationMethod(.catmullRom)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: strideBy.time)) { _ in
                        AxisTick()
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                    }
                }
                .chartLegend(position: .top)
                .frame(height: 240)
            }
            
            customisation
        }

        .navigationBarTitle("Two Bars", displayMode: .inline)
    }
    
    
    var customisation: some View {
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
            
//            Picker("Stride By", selection: $strideBy) {
//                ForEach(ChartStrideBy.allCases) { Text($0.title).tag($0)
//                }
//            }
        }
    }
}

struct TwoBarsSimpleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TwoBarsSimpleDetailView()
    }
}
