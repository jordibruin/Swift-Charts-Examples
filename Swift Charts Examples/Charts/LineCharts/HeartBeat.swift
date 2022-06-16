//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct HeartBeatOverview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(ChartType.heartBeat.title)
                .font(.callout)
                .foregroundStyle(.secondary)
            
            Chart {
                ForEach(Array(HealthData.ecgSample.enumerated()), id: \.element) { index, element in
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Unit", element)
                    )
                    .foregroundStyle(.pink.gradient)
                    .interpolationMethod(.cardinal)
                    .accessibilityLabel("Index")
                    .accessibilityValue("\(element)")
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: Constants.previewChartHeight)
        }
    }
}

struct HeartBeat: View {
    @State private var lineWidth = 2.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var chartColor: Color = .pink
    @State private var showSymbols = false
    
    var body: some View {
        List {
            Section {
                Chart {
                    ForEach(Array(HealthData.ecgSample.enumerated()), id: \.element) { index, element in
                        LineMark(
                            x: .value("Index", index),
                            y: .value("Unit", element)
                        )
                        .lineStyle(StrokeStyle(lineWidth: lineWidth))
                        .foregroundStyle(chartColor.gradient)
                        .interpolationMethod(interpolationMethod.mode)
                        .accessibilityLabel("Index")
                        .accessibilityValue("\(element)")
                    }
                }
                .chartYAxis {
                    AxisMarks(preset: .aligned, position: .automatic) { value in
                        let rawValue = value.as(Double.self)! / 100
                        let formattedValue = rawValue.formatted()
                        
                        AxisGridLine()
                        AxisValueLabel(formattedValue)
                    }
                }
                .chartXAxis {
                    AxisMarks(preset: .aligned, position: .automatic) { value in
                        let rawValue = value.as(Int.self)! / 100
                        let formattedValue = rawValue.formatted()
                        
                        AxisGridLine()
                        AxisValueLabel(formattedValue)
                    }
                }
                .frame(height: Constants.detailChartHeight)
            }
            
            customisation
        }
        .navigationBarTitle(ChartType.heartBeat.title, displayMode: .inline)
    }
    
    private var customisation: some View {
        Section {
            Stepper(value: $lineWidth, in: 1.0...10.0) {
                HStack {
                    Text("Line Width")
                    Spacer()
                    Text("\(String(format: "%.0f", lineWidth))")
                }
            }
            
            Picker("Interpolation Method", selection: $interpolationMethod) {
                ForEach(ChartInterpolationMethod.allCases) { Text($0.mode.description).tag($0) }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
        }
    }
}

struct HeartBeat_Previews: PreviewProvider {
    static var previews: some View {
        HeartBeatOverview()
        HeartBeat()
    }
}

