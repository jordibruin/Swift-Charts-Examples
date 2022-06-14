//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts
import DataFactory

struct SingleBarDetailView: View {
    
    @State private var lineWidth = 2.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var chartColor: Color = .blue
    
    var body: some View {
        List {
            Section {
                Chart(SalesData.last30Days, id: \.day) {
                    BarMark(
                        x: .value("Date", $0.day),
                        y: .value("Sales", $0.sales)
                    )
                    .lineStyle(StrokeStyle(lineWidth: lineWidth))
                    .foregroundStyle(chartColor)
                    .interpolationMethod(interpolationMethod.mode)
                }
                .frame(height: Constants.detailChartHeight)
            }
            
            customisation
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var customisation: some View {
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
}

struct SingleLineChartSimpleDetailView_Previews: PreviewProvider {
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
            .frame(height: Constants.previewChartHeight)
        }
    }
}

struct BarChartSimpleOverview_Previews: PreviewProvider {
    static var previews: some View {
        BarChartSimpleOverview()
            .padding()
    }
}
