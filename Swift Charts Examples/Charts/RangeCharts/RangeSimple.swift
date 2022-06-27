//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct RangeSimple: View {
	var isOverview: Bool

    @State var data = SalesData.last12Months

    @State private var barWidth = 10.0
    @State private var chartColor: Color = .blue
    @State private var isShowingPoints = false
    
    var body: some View {
		if isOverview {
			chart
		} else {
			List {
				Section {
					chart
				}

				customisation
			}
			.navigationBarTitle(ChartType.rangeSimple.title, displayMode: .inline)
		}
    }

	private var chart: some View {
		Chart(data, id: \.month) {
			BarMark(
				x: .value("Month", $0.month, unit: .month),
				yStart: .value("Sales Min", $0.dailyMin),
				yEnd: .value("Sales Max", $0.dailyMax),
                width: .fixed(isOverview ? 10 : barWidth)
			)
            .accessibilityLabel("\($0.month.formatted(.dateTime.month(.wide)))")
            .accessibilityValue("Sales: \($0.sales), Min: \($0.dailyMin), Max: \($0.dailyMax)")
            .accessibilityHidden(isOverview)
			.clipShape(Capsule())
			.foregroundStyle(chartColor.gradient)

			if isShowingPoints {
				PointMark(
					x: .value("Month", $0.month, unit: .month),
					y: .value("Sales Min", $0.dailyMin)
				)
				.offset(y: -(barWidth / 2))
				.foregroundStyle(.yellow.gradient)
				.symbolSize(CGSize(width: barWidth * 2/3, height: barWidth * 2/3))

				PointMark(
					x: .value("Month", $0.month, unit: .month),
					y: .value("Sales Max", $0.dailyMax)
				)
				.offset(y: barWidth / 2)
				.foregroundStyle(.yellow.gradient)
				.symbolSize(CGSize(width: barWidth * 2/3, height: barWidth * 2/3))
			}
		}
        .accessibilityChartDescriptor(self)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}

    private var customisation: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Bar Width: \(barWidth, specifier: "%.1f")")
                Slider(value: $barWidth, in: 5...20) {
                    Text("Bar Width")
                } minimumValueLabel: {
                    Text("5")
                } maximumValueLabel: {
                    Text("20")
                }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
            Toggle("Show Min & Max Points", isOn: $isShowingPoints.animation())
        }
    }
}

// MARK: - Accessibility

extension RangeSimple: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        
        let dateStringConverter: ((Date) -> (String)) = { date in
            date.formatted(.dateTime.month(.wide))
        }
        
        let min = data.map(\.dailyMin).min() ?? 0
        let max = data.map(\.dailyMax).max() ?? 0
        let salesMin = data.map(\.sales).min() ?? 0
        let salesMax = data.map(\.sales).max() ?? 0

        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Month",
            categoryOrder: data.map { dateStringConverter($0.month) }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Sales Average",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(Int(value)) sales per day average" }

        // Create axes for the daily min/max and sales
        // and use the standard X/Y axes for month vs daily average
        let salesAxis = AXNumericDataAxisDescriptor(
            title: "Total Sales",
            range: Double(salesMin)...Double(salesMax),
            gridlinePositions: []
        ) { value in "\(Int(value)) total sales" }

        let minAxis = AXNumericDataAxisDescriptor(
            title: "Daily Minimum Sales",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(Int(value)) sales min" }

        let maxAxis = AXNumericDataAxisDescriptor(
            title: "Daily Maximum Sales",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(Int(value)) sales max" }

        let series = AXDataSeriesDescriptor(
            name: "Daily sales ranges per month",
            isContinuous: false,
            dataPoints: data.map {
                .init(x: dateStringConverter($0.month),
                      y: Double($0.dailyAverage),
                      additionalValues: [.number(Double($0.sales)),
                                         .number(Double($0.dailyMin)),
                                         .number(Double($0.dailyMax))])
            }
        )

        return AXChartDescriptor(
            title: "Sales per day",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [salesAxis, minAxis, maxAxis],
            series: [series]
        )
    }
}

// MARK: - Preview

struct RangeSimple_Previews: PreviewProvider {
    static var previews: some View {
        RangeSimple(isOverview: true)
		RangeSimple(isOverview: false)
    }
}
