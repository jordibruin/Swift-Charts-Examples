//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct SingleLineLollipop: View {
	var isOverview: Bool

    @State private var lineWidth = 2.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var chartColor: Color = .blue
    @State private var showSymbols = true
    @State private var selectedElement: Sale? = SalesData.last30Days[10]

    var data = SalesData.last30Days

    var body: some View {
        if isOverview {
            chart
                .allowsHitTesting(false)
        } else {
            List {
                Section {
                    chart
                }

                Section {
                    Text("**Hold and drag** over the chart to view and move the lollipop")
                        .font(.callout)
                }
            }
            .navigationBarTitle(ChartType.singleLineLollipop.title, displayMode: .inline)
        }
    }

    private var chart: some View {
        Chart(data, id: \.day) {
            LineMark(
                x: .value("Date", $0.day),
                y: .value("Sales", $0.sales)
            )
            .accessibilityLabel($0.day.formatted(date: .complete, time: .omitted))
            .accessibilityValue("\($0.sales) sold")
            .lineStyle(StrokeStyle(lineWidth: lineWidth))
            .foregroundStyle(chartColor.gradient)
            .interpolationMethod(interpolationMethod.mode)
            .symbol(Circle().strokeBorder(lineWidth: lineWidth))
            .symbolSize(showSymbols ? 60 : 0)
        }
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = findElement(location: value.location, proxy: proxy, geometry: geo)
                                if selectedElement?.day == element?.day {
                                    // If tapping the same element, clear the selection.
                                    selectedElement = nil
                                } else {
                                    selectedElement = element
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElement = findElement(location: value.location, proxy: proxy, geometry: geo)
                                    }
                            )
                    )
            }
        }
        .chartBackground { proxy in
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    if let selectedElement {
                        let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedElement.day)!
                        let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0

                        let lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
                        let lineHeight = geo[proxy.plotAreaFrame].maxY
                        let boxWidth: CGFloat = 100
                        let boxOffset = max(0, min(geo.size.width - boxWidth, lineX - boxWidth / 2))

                        Rectangle()
                            .fill(.red)
                            .frame(width: 2, height: lineHeight)
                            .position(x: lineX, y: lineHeight / 2)

                        VStack(alignment: .center) {
                            Text("\(selectedElement.day, format: .dateTime.year().month().day())")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text("\(selectedElement.sales, format: .number)")
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityHidden(isOverview)
                        .frame(width: boxWidth, alignment: .leading)
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
                        .offset(x: boxOffset)
                    }
                }
            }
        }
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
        .accessibilityChartDescriptor(self)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
    }

    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> Sale? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for salesDataIndex in data.indices {
                let nthSalesDataDistance = data[salesDataIndex].day.distance(to: date)
                if abs(nthSalesDataDistance) < minDistance {
                    minDistance = abs(nthSalesDataDistance)
                    index = salesDataIndex
                }
            }
            if let index {
                return data[index]
            }
        }
        return nil
    }
}

// MARK: - Accessibility

extension SingleLineLollipop: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        return chartDescriptor(forSalesSeries: data)
    }
}

// MARK: - Preview

struct SingleLineLollipop_Previews: PreviewProvider {
    static var previews: some View {
        SingleLineLollipop(isOverview: true)
        SingleLineLollipop(isOverview: false)
    }
}
