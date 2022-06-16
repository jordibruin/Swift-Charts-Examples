//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI

import Charts

struct SingleBarThresholdOverview: View {
    @State private var threshold = 150.0

    var body: some View {
        VStack(alignment: .leading) {
            Text(ChartType.singleBarThreshold.title)
                .font(.callout)
                .foregroundStyle(.secondary)

            Chart(SalesData.last30Days, id: \.day) {
                BarMark(
                    x: .value("Date", $0.day),
                    y: .value("Sales", $0.sales)
                )
                .foregroundStyle($0.sales > Int(threshold) ? .orange : .blue)
                RuleMark(
                    y: .value("Threshold", threshold)
                )
                .lineStyle(StrokeStyle(lineWidth: 2))
                .foregroundStyle(.red)
                .annotation(position: .top, alignment: .leading) {
                    Text("\(threshold, specifier: "%.0f")")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.background)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.quaternary.opacity(0.7))
                            }
                            .padding(.horizontal, -8)
                            .padding(.vertical, -4)
                        }
                        .padding(.bottom, 4)
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: Constants.previewChartHeight)
        }
    }
}

struct SingleBarThreshold: View {
    @State private var threshold = 150.0

    var body: some View {
        List {
            Section {
                Chart(SalesData.last30Days, id: \.day) {
                    BarMark(
                        x: .value("Date", $0.day),
                        y: .value("Sales", $0.sales)
                    )
                    .foregroundStyle($0.sales > Int(threshold) ? .orange : .blue)
                    RuleMark(
                        y: .value("Threshold", threshold)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    .foregroundStyle(.red)
                    .annotation(position: .top, alignment: .leading) {
                        Text("\(threshold, specifier: "%.0f")")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                            .background {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.background)
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.quaternary.opacity(0.7))
                                }
                                .padding(.horizontal, -8)
                                .padding(.vertical, -4)
                            }
                            .padding(.bottom, 4)
                    }
                }
                .frame(height: Constants.detailChartHeight)
            }

            customisation
        }
        .navigationBarTitle(ChartType.singleBarThreshold.title, displayMode: .inline)
    }

    private var customisation: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Threshold: \(threshold, specifier: "%.0f")")
                Slider(value: $threshold, in: 0...275) {
                    Text("Threshold")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("275")
                }
            }
        }
    }
}

struct SingleBarThreshold_Previews: PreviewProvider {
    static var previews: some View {
        SingleBarThresholdOverview()
        SingleBarThreshold()
    }
}
