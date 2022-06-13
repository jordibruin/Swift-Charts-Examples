//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct LineChartSimpleOverview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Line Chart")
                .font(.callout)
                .foregroundStyle(.secondary)

            Chart(SalesData.last30Days, id: \.day) {
                LineMark(
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

struct SalesOverview_Previews: PreviewProvider {
    static var previews: some View {
        LineChartSimpleOverview()
            .padding()
    }
}

struct LineChartSimpleDetailView: View {
    @State private var lineWidth = 2.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var chartColor: Color = .blue
    @State private var showSymbols = false

    @State private var selectedElement: (day: Date, sales: Int)? = nil

    var body: some View {
        List {
            Section {
                Chart(SalesData.last30Days, id: \.day) {
                    LineMark(
                        x: .value("Date", $0.day),
                        y: .value("Sales", $0.sales)
                    )
                    .lineStyle(StrokeStyle(lineWidth: lineWidth))
                    .foregroundStyle(chartColor)
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
                .frame(height: Constants.detailChartHeight)
                .chartBackground { proxy in
                    ZStack(alignment: .topLeading) {
                        GeometryReader { geo in
                            if let selectedElement = selectedElement {
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
                                .frame(width: boxWidth, alignment: .leading)
                                .background {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.background)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.quaternary.opacity(0.7))
                                    }
                                    .padding([.leading, .trailing], -8)
                                    .padding([.top, .bottom], -4)
                                }
                                .offset(x: boxOffset)
                            }
                        }
                    }
                }
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

            Toggle("Show Symbols", isOn: $showSymbols)
        }
    }

    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> (day: Date, sales: Int)? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for salesDataIndex in SalesData.last30Days.indices {
                let nthSalesDataDistance = SalesData.last30Days[salesDataIndex].day.distance(to: date)
                if abs(nthSalesDataDistance) < minDistance {
                    minDistance = abs(nthSalesDataDistance)
                    index = salesDataIndex
                }
            }
            if let index = index {
                return SalesData.last30Days[index]
            }
        }
        return nil
    }
}

struct LineChartSimpleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartSimpleDetailView()
    }
}
