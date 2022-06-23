//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct CandleStickChartOverview: View {
    let currentPrices: [StockData.StockPrice] = StockData.appleFirst7Months
    
    var body: some View {
        Chart(currentPrices) { (price: StockData.StockPrice) in
            BarMark(
                x: .value("Date", price.timestamp),
                yStart: .value("Open", price.open),
                yEnd: .value("Close", price.close),
                width: 8
            )
            .foregroundStyle(price.open < price.close ? .blue : .red)
            BarMark(
                x: .value("Date", price.timestamp),
                yStart: .value("High", price.high),
                yEnd: .value("Low", price.low),
                width: 2
            )
            .foregroundStyle(price.open < price.close ? .blue : .red)
        }
        .accessibilityChartDescriptor(self)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: 35...45)
        .frame(height: Constants.previewChartHeight)
    }
}

struct CandleStickChart: View {
    private let currentPrices: [StockData.StockPrice] = StockData.apple
    private var dateBins: DateBins {
        .init(
            unit: .month,
            range: currentPrices[0].timestamp...currentPrices[currentPrices.count - 1].timestamp
        )
    }
    @State private var selectedPrice: StockData.StockPrice?
    @State private var annotationOffset: CGFloat = 0
    
    var body: some View {
        List {
            Section {
                Chart(currentPrices) { (price: StockData.StockPrice) in
                    CandleStickMark(
                        timestamp: .value("Date", price.timestamp),
                        open: .value("Open", price.open),
                        high: .value("High", price.high),
                        low: .value("Low", price.low),
                        close: .value("Close", price.close)
                    )
                    .accessibilityLabel("\(price.timestamp.formatted(date: .complete, time: .omitted)): \(price.accessibilityTrendSummary)")
                    .accessibilityValue(price.accessibilityDescription)
                    .foregroundStyle(price.isClosingHigher ? .blue : .red)
                    
                    if let selectedPrice {
                        RuleMark(x: .value("Selected Date", selectedPrice.timestamp))
                            .foregroundStyle(.gray.opacity(0.3))
                            .annotation(position: .top, alignment: .center, spacing: -100) {
                                PriceAnnotation(for: selectedPrice)
                                    .offset(x: annotationOffset)
                            }
                    }
                }
                .frame(height: Constants.detailChartHeight)
                .chartYAxis { AxisMarks(preset: .extended) }
                .chartOverlay { proxy in
                    GeometryReader { g in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let xCurrent = value.location.x - g[proxy.plotAreaFrame].origin.x
                                        let plotWidth = proxy.plotAreaSize.width
                                        let upperBound = plotWidth * 0.7
                                        let lowerBound = plotWidth * 0.4
                                        
                                        if (upperBound...plotWidth).contains(xCurrent) {
                                            annotationOffset = upperBound - xCurrent
                                        } else if (0...lowerBound).contains(xCurrent) {
                                            annotationOffset = lowerBound - xCurrent
                                        } else {
                                            annotationOffset = 0
                                        }
                                        
                                        if let currentDate: Date = proxy.value(atX: xCurrent) {
                                            let index = dateBins.index(for: currentDate)
                                            
                                            if currentPrices.indices.contains(index) {
                                                selectedPrice = currentPrices[index]
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        selectedPrice = nil
                                        annotationOffset = 0
                                    }
                            )
                    }
                }
            }
            Section {
                Text("**Hold and drag** over the chart to view and move the lollipop")
                    .font(.callout)
            }
        }
        .navigationTitle(ChartType.candleStick.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CandleStickMark: ChartContent {
    let timestamp: PlottableValue<Date>
    let open: PlottableValue<Decimal>
    let high: PlottableValue<Decimal>
    let low: PlottableValue<Decimal>
    let close: PlottableValue<Decimal>
    
    var body: some ChartContent {
        // Composite ChartContent MUST be grouped into a plot for accessibility to work
        Plot {
            BarMark(
                x: timestamp,
                yStart: open,
                yEnd: close,
                width: 4
            )
            
            BarMark(
                x: timestamp,
                yStart: high,
                yEnd: low,
                width: 1
            )
        }
        
    }
}

struct PriceAnnotation: View {
    private var price: StockData.StockPrice
    
    init(for price: StockData.StockPrice) {
        self.price = price
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(price.timestamp.formatted(date: .abbreviated, time: .omitted))
                .foregroundColor(.secondary)
            
            HStack {
                Text("O:").foregroundColor(.secondary)
                Text(price.open.formatted(.currency(code: "USD")))
                
                Text("C:").foregroundColor(.secondary)
                Text(price.close.formatted(.currency(code: "USD")))
            }
            
            HStack {
                Text("H:").foregroundColor(.secondary)
                Text(price.high.formatted(.currency(code: "USD")))
                
                Text("L:").foregroundColor(.secondary)
                Text(price.low.formatted(.currency(code: "USD")))
            }
        }
        .lineLimit(1)
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 13)
                .foregroundStyle(.thickMaterial)
        )
    }
}

struct CandleStickChart_Previews: PreviewProvider {
    static var previews: some View {
        CandleStickChartOverview()
        CandleStickChart()
    }
}
