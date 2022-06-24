//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct SingleBarOverview: View {

    var data = SalesData.last30Days

    var body: some View {
        Chart(data, id: \.day) {
            BarMark(
                x: .value("Day", $0.day, unit: .day),
                y: .value("Sales", $0.sales)
            )
            .foregroundStyle(Color.blue.gradient)
        }
        .accessibilityChartDescriptor(self)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: Constants.previewChartHeight)
    }
}

struct SingleBar: View {
    @State private var barWidth = 7.0
    @State private var chartColor: Color = .blue
    @State private var data: [Sale] = SalesData.last30Days.map { Sale(day: $0.day, sales: 0) }
    
    var body: some View {
        List {
            Section {
                Chart(data, id: \.day) {
                    BarMark(
                        x: .value("Date", $0.day),
                        y: .value("Sales", $0.sales),
                        width: .fixed(barWidth)
                    )
                    .accessibilityLabel($0.day.formatted(date: .complete, time: .omitted))
                    .accessibilityValue("\($0.sales) sold")
                    .foregroundStyle(chartColor.gradient)
                }
                .frame(height: Constants.detailChartHeight)
            }
            
            customisation
        }
        .navigationBarTitle(ChartType.singleBar.title, displayMode: .inline)
        .onAppear {
            for index in data.indices {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.02) {
                    withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                        data[index].sales = SalesData.last30Days[index].sales
                    }
                }
            }
        }
    }
    
    private var customisation: some View {
        Section {
            Stepper(value: $barWidth, in: 1.0...20.0) {
                HStack {
                    Text("Bar Width")
                    Spacer()
                    Text("\(String(format: "%.0f", barWidth))")
                }
            }
            ColorPicker("Color Picker", selection: $chartColor)
        }
    }
}

struct SingleBar_Previews: PreviewProvider {
    static var previews: some View {
        SingleBarOverview()
        SingleBar()
    }
}
