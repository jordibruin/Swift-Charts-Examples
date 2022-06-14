//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts
import DataFactory

struct AreaChartSimpleDetailView: View {
    
    @State private var lineWidth = 2.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var chartColor: Color = .blue
    @State private var showGradient: Bool = true
    @State private var gradientRange = 1.0

    private var gradient: Gradient {
        var colors = [chartColor]
        if showGradient {
            colors.append(chartColor.opacity(-gradientRange))
        }
        return Gradient(colors: colors)
    }

    var body: some View {
        List {
            Section {
                Chart(SalesData.last30Days, id: \.day) {
                    AreaMark(
                        x: .value("Date", $0.day),
                        y: .value("Sales", $0.sales)
                    )
                    .foregroundStyle(gradient)
                    .interpolationMethod(interpolationMethod.mode)

                    LineMark(
                        x: .value("Date", $0.day),
                        y: .value("Sales", $0.sales)
                    )
                    .lineStyle(StrokeStyle(lineWidth: lineWidth))
                    .interpolationMethod(interpolationMethod.mode)
                    .foregroundStyle(chartColor)
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
            Toggle("Show Gradient", isOn: $showGradient.animation())

            if showGradient {
                HStack {
                    Slider(value: $gradientRange) {
                        Text("Gradient Range")
                    } minimumValueLabel: {
                        Text("Min")
                    } maximumValueLabel: {
                        Text("Max")
                    }
                    Text("\(String(format: "%.1f",gradientRange))")
                }
            }
        }
    }
}

struct AreaChartSimpleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AreaChartSimpleDetailView()
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
                .frame(height: Constants.previewChartHeight)
        }
    }
}

struct AreaChartSimpleOverview2_Previews: PreviewProvider {
    static var previews: some View {
        AreaChartSimpleOverview()
            .padding()
    }
}
