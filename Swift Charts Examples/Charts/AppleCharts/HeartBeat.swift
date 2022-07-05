//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct HeartBeat: View {
    var isOverview: Bool
    
    @State private var data = HealthData.ecgSample
    @State private var lineWidth = 2.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var chartColor: Color = .pink
    
    var body: some View {
        if isOverview {
            chartAndLabels
        } else {
            List {
                Section {
                    chartAndLabels
                }
                customisation
            }
            .navigationBarTitle(ChartType.heartBeat.title, displayMode: .inline)
        }
    }
    
    private var chartAndLabels: some View {
        VStack(alignment: .leading) {
            Text("Sinus Rhythm")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
            Group {
                Text(Date(), style: .date) +
                Text(" at ") +
                Text(Date(), style: .time)
            }
            .foregroundColor(.secondary)
            chart
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
                Text("68 BPM Average")
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: Constants.detailChartHeight)
    }
    
    private var chart: some View {
        Chart {
            ForEach(Array(data.enumerated()), id: \.element) { index, element in
                LineMark(
                    x: .value("Seconds", Double(index)/400.0),
                    y: .value("Unit", element)
                )
                .lineStyle(StrokeStyle(lineWidth: lineWidth))
                .foregroundStyle(chartColor)
                .interpolationMethod(interpolationMethod.mode)
                .accessibilityLabel("\(index)s")
                .accessibilityValue("\(element) mV")
                .accessibilityHidden(isOverview)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 12)) { value in
                if let doubleValue = value.as(Double.self),
                   let intValue = value.as(Int.self) {
                    if doubleValue - Double(intValue) == 0 {
                        AxisTick(stroke: .init(lineWidth: 1))
                            .foregroundStyle(.gray)
                        AxisValueLabel() {
                            Text("\(intValue)s")
                        }
                        AxisGridLine(stroke: .init(lineWidth: 1))
                            .foregroundStyle(.gray)
                    } else {
                        AxisGridLine(stroke: .init(lineWidth: 1))
                            .foregroundStyle(.gray.opacity(0.25))
                    }
                }
            }
        }
        .chartYScale(domain: -400...800)
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 14)) { value in
                AxisGridLine(stroke: .init(lineWidth: 1))
                    .foregroundStyle(.gray.opacity(0.25))
            }
        }
        .chartPlotStyle {
            $0.border(Color.gray)
        }
        .accessibilityChartDescriptor(self)
    }
    
    private var customisation: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Line Width: \(lineWidth, specifier: "%.1f")")
                Slider(value: $lineWidth, in: 1...10) {
                    Text("Line Width")
                } minimumValueLabel: {
                    Text("1")
                } maximumValueLabel: {
                    Text("10")
                }
            }
            
            Picker("Interpolation Method", selection: $interpolationMethod) {
                ForEach(ChartInterpolationMethod.allCases) { Text($0.mode.description).tag($0) }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
        }
    }
}

// MARK: - Accessibility

extension HeartBeat: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let min = data.min() ?? 0.0
        let max = data.max() ?? 0.0
        
        // Set the units when creating the axes
        // so users can scrub and pause to narrow on a data point
        let xAxis = AXNumericDataAxisDescriptor(
            title: "Time",
            range: Double(0)...Double(data.count),
            gridlinePositions: []
        ) { value in "\(value)s" }
        
        
        let yAxis = AXNumericDataAxisDescriptor(
            title: "Millivolts",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(value) mV" }
        
        let series = AXDataSeriesDescriptor(
            name: "ECG data",
            isContinuous: true,
            dataPoints: data.enumerated().map {
                .init(x: Double($0), y: $1)
            }
        )
        
        return AXChartDescriptor(
            title: "ElectroCardiogram (ECG)",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}

// MARK: - Preview

struct HeartBeat_Previews: PreviewProvider {
    static var previews: some View {
        HeartBeat(isOverview: true)
        HeartBeat(isOverview: false)
    }
}

