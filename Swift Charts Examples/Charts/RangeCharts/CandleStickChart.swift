//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct CandleStickChart: View {
	var isOverview: Bool

    var currentPrices: [StockData.StockPrice]
    @State private var selectedPrice: StockData.StockPrice?

	init(isOverview: Bool) {
		self.isOverview = isOverview
		self.currentPrices = isOverview ? StockData.appleFirst7Months : StockData.apple
	}

    var body: some View {
		if isOverview {
			chart
				.chartYScale(domain: 35...45)
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
			.navigationTitle(ChartType.candleStick.title)
		}

    }

	private var chart: some View {
		Chart(currentPrices) { (price: StockData.StockPrice) in
			CandleStickMark(
				isOverview: isOverview,
				timestamp: .value("Date", price.timestamp),
				open: .value("Open", price.open),
				high: .value("High", price.high),
				low: .value("Low", price.low),
				close: .value("Close", price.close)
			)
            .accessibilityLabel("\(price.timestamp.formatted(date: .complete, time: .omitted)): \(price.accessibilityTrendSummary)")
            .accessibilityValue(price.accessibilityDescription)
            .accessibilityHidden(isOverview)
			.foregroundStyle(price.open < price.close ? .blue : .red)
		}
		.chartYAxis { AxisMarks(preset: .extended) }
		.chartOverlay { proxy in
			GeometryReader { geo in
				Rectangle().fill(.clear).contentShape(Rectangle())
					.gesture(
						SpatialTapGesture()
							.onEnded { value in
								let element = findElement(location: value.location, proxy: proxy, geometry: geo)
								if selectedPrice?.timestamp == element?.timestamp {
									// If tapping the same element, clear the selection.
									selectedPrice = nil
								} else {
									selectedPrice = element
								}
							}
							.exclusively(
								before: DragGesture()
									.onChanged { value in
										selectedPrice = findElement(location: value.location, proxy: proxy, geometry: geo)
									}
							)
					)
			}
		}
		.chartOverlay { proxy in
			ZStack(alignment: .topLeading) {
				GeometryReader { geo in
					if let selectedPrice {
						let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedPrice.timestamp)!
						let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0

						let lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
						let lineHeight = geo[proxy.plotAreaFrame].maxY
						let boxWidth: CGFloat = 220
						let boxOffset = max(0, min(geo.size.width - boxWidth, lineX - boxWidth / 2))

						Rectangle()
							.fill(.gray.opacity(0.5))
							.frame(width: 2, height: lineHeight)
							.position(x: lineX, y: lineHeight / 2)

						PriceAnnotation(for: selectedPrice)
							.frame(width: boxWidth, alignment: .leading)
							.background {
								RoundedRectangle(cornerRadius: 13)
									.foregroundStyle(.thickMaterial)
									.padding(.horizontal, -8)
									.padding(.vertical, -4)
							}
							.offset(x: boxOffset)
					}
				}
			}
		}
        .accessibilityChartDescriptor(self)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}

    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> StockData.StockPrice? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in currentPrices.indices {
                let nthSalesDataDistance = currentPrices[dataIndex].timestamp.distance(to: date)
                if abs(nthSalesDataDistance) < minDistance {
                    minDistance = abs(nthSalesDataDistance)
                    index = dataIndex
                }
            }
            if let index {
                return currentPrices[index]
            }
        }
        return nil
    }
}

struct CandleStickMark: ChartContent {
	let isOverview: Bool
    let timestamp: PlottableValue<Date>
    let open: PlottableValue<Decimal>
    let high: PlottableValue<Decimal>
    let low: PlottableValue<Decimal>
    let close: PlottableValue<Decimal>
    
    var body: some ChartContent {
        Plot {
            // Composite ChartContent MUST be grouped into a plot for accessibility to work
            BarMark(
                x: timestamp,
                yStart: open,
                yEnd: close,
                width: isOverview ? 8 : 4
            )
            BarMark(
                x: timestamp,
                yStart: high,
                yEnd: low,
                width: isOverview ? 2 : 1
            )
        }
    }
}

// MARK: - Accessibility

extension CandleStickChart: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        
        let dateStringConverter: ((Date) -> (String)) = { date in
            date.formatted(date: .abbreviated, time: .omitted)
        }
        
        // These closures help find the min/max for each axis
        let lowestValue: ((KeyPath<StockData.StockPrice, Decimal>) -> (Double)) = { path in
            return currentPrices.map { $0[keyPath: path]} .min()?.asDouble ?? 0
        }
        let highestValue: ((KeyPath<StockData.StockPrice, Decimal>) -> (Double)) = { path in
            return currentPrices.map { $0[keyPath: path]} .max()?.asDouble ?? 0
        }
        
        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Date",
            categoryOrder: currentPrices.map { dateStringConverter($0.timestamp) }
        )
        
        // Add axes for each data point captured in the candlestick
        let closeAxis = AXNumericDataAxisDescriptor(
            title: "Closing Price",
            range: 0...highestValue(\.close),
            gridlinePositions: []
        ) { value in "Closing: \(value.formatted(.currency(code: "USD")))" }
        
        let openAxis = AXNumericDataAxisDescriptor(
            title: "Opening Price",
            range: lowestValue(\.open)...highestValue(\.open),
            gridlinePositions: []
        ) { value in "Opening: \(value.formatted(.currency(code: "USD")))" }
        
        let highAxis = AXNumericDataAxisDescriptor(
            title: "Highest Price",
            range: lowestValue(\.high)...highestValue(\.high),
            gridlinePositions: []
        ) { value in "High: \(value.formatted(.currency(code: "USD")))" }
        
        let lowAxis = AXNumericDataAxisDescriptor(
            title: "Lowest Price",
            range: lowestValue(\.low)...highestValue(\.low),
            gridlinePositions: []
        ) { value in "Low: \(value.formatted(.currency(code: "USD")))" }
        
        let series = AXDataSeriesDescriptor(
            name: "Apple Stock Price",
            isContinuous: false,
            dataPoints: currentPrices.map {
                .init(x: dateStringConverter($0.timestamp),
                      y: $0.close.asDouble,
                      additionalValues: [.number($0.open.asDouble),
                                         .number($0.high.asDouble),
                                         .number($0.low.asDouble)])
            }
        )
        
        return AXChartDescriptor(
            title: "Apple Stock Price",
            summary: nil,
            xAxis: xAxis,
            yAxis: closeAxis,
            additionalAxes: [openAxis, highAxis, lowAxis],
            series: [series]
        )
    }
}

// MARK: - Preview

struct PriceAnnotation: View {
    private var price: StockData.StockPrice
    
    init(for price: StockData.StockPrice) {
        self.price = price
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(price.timestamp.formatted(date: .abbreviated, time: .omitted))
                .foregroundColor(.secondary)
            
            HStack {
                Spacer()
                Text("O:").foregroundColor(.secondary)
                Text(price.open.formatted(.currency(code: "USD")))
                
                Text("C:").foregroundColor(.secondary)
                Text(price.close.formatted(.currency(code: "USD")))
                Spacer()
            }
            
            HStack {
                Spacer()
                Text("H:").foregroundColor(.secondary)
                Text(price.high.formatted(.currency(code: "USD")))
                
                Text("L:").foregroundColor(.secondary)
                Text(price.low.formatted(.currency(code: "USD")))
                Spacer()
            }
        }
        .lineLimit(1)
        .font(.headline)
        .padding(.vertical)
    }
}

struct CandleStickChart_Previews: PreviewProvider {
    static var previews: some View {
		CandleStickChart(isOverview: true)
        CandleStickChart(isOverview: false)
    }
}
