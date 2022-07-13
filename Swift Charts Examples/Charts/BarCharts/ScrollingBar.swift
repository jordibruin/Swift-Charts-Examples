//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Charts
import SwiftUI

struct ScrollingBar: View {
    var isOverview: Bool

    @State private var scrollWidth = 450.0
    @State private var action: WineAction.InOut = .all

    private var wineData: [WineData.Grouping] {
        switch action {
        case .all:
            return WineData.allActions
        case .in:
            return WineData.wineIn
        default:
            return WineData.wineOut
        }
    }

    var body: some View {
        if isOverview {
            chart
        } else {
            List {
                Section {
                    ScrollView(.horizontal) {
                        chart
                    }
                }
                customisation
            }
            .navigationBarTitle(ChartType.scrollingBar.title, displayMode: .inline)
        }
    }

    private var chart: some View {
        Chart(wineData) { grouping in
            ForEach(grouping.wines) { wine in
                Plot {
                    BarMark (
                        x: .value("Month", wine.month),
                        y: .value("Quantity",  wine.actual)
                    )
                    .foregroundStyle(wine.inOut == .in ? .purple : .green)
                }
                .accessibilityLabel("\(grouping.inOut.title)")
                .accessibilityValue("\(wine.actual)")
            }
        }
        .chartYAxis {
            AxisMarks(preset: .automatic, position: .leading)
        }
        .chartYAxis(isOverview ? .hidden : .automatic)
        .chartXAxis(isOverview ? .hidden : .automatic)
        .padding()
        .frame(width: scrollWidth, height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
    }

    private var customisation: some View {
        Section {
            Picker("Type", selection: $action.animation(.easeInOut)) {
                ForEach(WineAction.InOut.allCases) { inOut in
                    Text(inOut.title).tag(inOut)
                }
            }
            .pickerStyle(.segmented)
            .padding(.vertical)
            VStack(alignment: .leading) {
                Text("ScrollView Width: \(scrollWidth, specifier: "%.0f")")
                Slider(value: $scrollWidth, in: 450...1600) {
                    Text("ScrollView Width")
                } minimumValueLabel: {
                    Text("450")
                } maximumValueLabel: {
                    Text("1600")
                }
            }
        }
    }
}

struct ScrollingBar_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingBar(isOverview: true)
        ScrollingBar(isOverview: false)
    }
}
