//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts
import DataFactory

struct OneDimensionalBarSimpleOverview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("One Dimensional Bar")
                .font(.callout)
                .foregroundStyle(.secondary)

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
            .frame(height: Constants.previewChartHeight)
        }
    }
}

struct OneDimensionalBarOverview_Previews: PreviewProvider {
    static var previews: some View {
        OneDimensionalBarSimpleOverview()
            .padding()
    }
}

struct OneDimensionalBarSimpleDetailView: View {
    @State private var showLegend = true
    
    var totalSize: Double {
        return DataUsageData
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

        .navigationBarTitle("One Dimensional Bar", displayMode: .inline)
    }
    
    
    private var customisation: some View {
        Section {
            Toggle("Show Chart Legend", isOn: $showLegend)
        }
    }
}

struct OneDimensionalBarDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OneDimensionalBarSimpleDetailView()
    }
}
