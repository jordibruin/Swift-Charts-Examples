//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct OneDimensionalBarOverview: View {
    var body: some View {
        Chart(DataUsageData.example, id: \.category) { element in
            BarMark(
                x: .value("Data Size", element.size)
            )
            .foregroundStyle(by: .value("Data Category", element.category))
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(Color(.systemFill))
                .cornerRadius(8)
        }
        .chartXScale(range: 0...128)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
        .frame(height: 32)
    }
}

struct OneDimensionalBar: View {
    @State private var showLegend = true
    
    private var totalSize: Double {
        DataUsageData
            .example
            .reduce(0) { $0 + $1.size }
    }

    var body: some View {
        List {
            Section {
                VStack {
                    HStack {
                        Text("iPhone")
                        Spacer()
                        Text("\(totalSize, specifier: "%.1f") GB of 128 GB Used")
                            .foregroundColor(.secondary)
                    }

                    Chart(DataUsageData.example, id: \.category) { element in
                        BarMark(
                            x: .value("Data Size", element.size)
                        )
                        .foregroundStyle(by: .value("Data Category", element.category))
                        .accessibilityLabel(element.category)
                        .accessibilityValue("\(element.size, specifier: "%.1f")")
                    }
                    .chartPlotStyle { plotArea in
                        plotArea
                            .background(Color(.systemFill))
                            .cornerRadius(8)
                    }
                    .chartXScale(range: 0...128)
                    .chartYScale(range: .plotDimension(endPadding: -8))
                    .chartLegend(showLegend ? .visible : .hidden)
                    .chartLegend(position: .bottom, spacing: -8)
                    .frame(height: 64)
                }
            }
            
            customisation
        }
        .navigationBarTitle(ChartType.oneDimensionalBar.title, displayMode: .inline)
    }
    
    private var customisation: some View {
        Section {
            Toggle("Show Chart Legend", isOn: $showLegend)
        }
    }
}

struct OneDimensionalBar_Previews: PreviewProvider {
    static var previews: some View {
        OneDimensionalBarOverview()
        OneDimensionalBar()
    }
}
