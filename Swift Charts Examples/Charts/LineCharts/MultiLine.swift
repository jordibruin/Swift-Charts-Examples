//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct MultiLine: View {
    var isOverview: Bool

    let data = LocationData.last30Days
    
    var body: some View {
        if isOverview {
            chart
        } else {
            List {
                Section {
                    chart
                }
            }
            .navigationBarTitle(ChartType.multiLine.title, displayMode: .inline)
        }
    }

    private var chart: some View {
        Chart(data) { series in
            ForEach(series.sales, id: \.weekday) { element in
                LineMark(
                    x: .value("Date", element.weekday),
                    y: .value("Sales", element.sales)
                )
                .accessibilityLabel("\(series.city) \(element.weekday.formatted(date: .abbreviated, time: .standard))")
                .accessibilityValue("\(element.sales) sold")
                .accessibilityHidden(isOverview)
                .interpolationMethod(.cardinal)
                .foregroundStyle(by: .value("City", series.city))
            }
        }
        .accessibilityChartDescriptor(self)
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
        .chartLegend(isOverview ? .hidden : .automatic)
        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
    }
}

// MARK: - Accessibility

extension MultiLine: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forLocationSeries: data)
    }
}

// MARK: - Preview

struct MultiLine_Previews: PreviewProvider {
    static var previews: some View {
        MultiLine(isOverview: true)
        MultiLine(isOverview: false)
    }
}
