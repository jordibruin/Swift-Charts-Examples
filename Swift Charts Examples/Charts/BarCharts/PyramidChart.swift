//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct PyramidChart: View {
	var isOverview: Bool

    @State var data = PopulationByAgeData.example
    @State var leftColor: Color = .green
    @State var rightColor: Color = .blue
    @State var barHeight: CGFloat = 10.0
    
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
			.navigationBarTitle(ChartType.pyramid.title, displayMode: .inline)
		}
    }

	private var chart: some View {
		Chart(data) { series in
			ForEach(series.population, id: \.percentage) { element in
				BarMark(
					xStart: .value("Percentage", 0),
					xEnd: .value("Percentage", series.sex == "Male" ? element.percentage : element.percentage * -1),
					y: .value("AgeRange", element.ageRange),
                    height: isOverview ? .automatic : .fixed(barHeight)
				)
                .accessibilityLabel("\(series.sex) Ages: \(element.ageRange)")
                .accessibilityValue("\(element.percentage)")
                .accessibilityHidden(isOverview)
			}
			.foregroundStyle(series.sex == "Male" ? rightColor.gradient : leftColor.gradient)
			.interpolationMethod(.catmullRom)
		}
		.chartYAxis {
			AxisMarks(preset: .aligned, position: .automatic) { _ in
				AxisValueLabel(centered: true)
			}
		}
		.chartXAxis {
			AxisMarks(preset: .aligned, position: .automatic) { value in
				let rawValue = value.as(Int.self)!
				let percentage = abs(Double(rawValue) / 100)

				AxisGridLine()
				AxisValueLabel(percentage.formatted(.percent))
			}
		}
		.chartLegend(position: .top, alignment: .center)
		.chartLegend(isOverview ? .hidden : .automatic)
        .accessibilityChartDescriptor(self)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? 200 : 340)
	}
    
    private var customisation: some View {
        Group {
            Section {
                Button("Generate random data") {
                    withAnimation {
                        generateRandomData()
                    }
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Bar Height: \(barHeight, specifier: "%.1f")")
                    Slider(value: $barHeight, in: 1...25) {
                        Text("Bar Height")
                    } minimumValueLabel: {
                        Text("1")
                    } maximumValueLabel: {
                        Text("25")
                    }
                }
                
                ColorPicker("Left Color", selection: $leftColor)
                ColorPicker("Right Color", selection: $rightColor)
            }
        }
    }
    
    func generateRandomData() {
        data = [
            .init(sex: "Male", population: [
                (ageRange: "0-10", percentage: Int.random(in: 0..<100)),
                (ageRange: "11-20", percentage: Int.random(in: 0..<100)),
                (ageRange: "21-30", percentage: Int.random(in: 0..<100)),
                (ageRange: "31-40", percentage: Int.random(in: 0..<100)),
                (ageRange: "41-50", percentage: Int.random(in: 0..<100)),
                (ageRange: "51-60", percentage: Int.random(in: 0..<100)),
                (ageRange: "61-70", percentage: Int.random(in: 0..<100)),
                (ageRange: "71-80", percentage: Int.random(in: 0..<100)),
                (ageRange: "81-90", percentage: Int.random(in: 0..<100)),
                (ageRange: "91+", percentage: Int.random(in: 0..<100))
            ]),
            .init(sex: "Female", population: [
                (ageRange: "0-10", percentage: Int.random(in: 0..<100)),
                (ageRange: "11-20", percentage: Int.random(in: 0..<100)),
                (ageRange: "21-30", percentage: Int.random(in: 0..<100)),
                (ageRange: "31-40", percentage: Int.random(in: 0..<100)),
                (ageRange: "41-50", percentage: Int.random(in: 0..<100)),
                (ageRange: "51-60", percentage: Int.random(in: 0..<100)),
                (ageRange: "61-70", percentage: Int.random(in: 0..<100)),
                (ageRange: "71-80", percentage: Int.random(in: 0..<100)),
                (ageRange: "81-90", percentage: Int.random(in: 0..<100)),
                (ageRange: "91+", percentage: Int.random(in: 0..<100))
            ]),
        ]
    }
}

// MARK: - Accessibility

// TODO: This is virtually the same as TwoBarsOverview's chartDescriptor. Use a protocol?
extension PyramidChart: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {

        // Create a descriptor for each Series object
        // as that allows auditory comparison with VoiceOver
        // much like the chart does visually and allows individual city charts to be played
        let series = data.map {
            AXDataSeriesDescriptor(
                name: "\($0.sex)",
                isContinuous: false,
                dataPoints: $0.population.map { data in
                        .init(x: "\(data.ageRange)",
                              y: Double(data.percentage))
                }
            )
        }

        // Get the minimum/maximum within each series
        // and then the limits of the resulting list
        // to pass in as the Y axis limits
        let limits: [(Int, Int)] = data.map { seriesData in
            let percentages = seriesData.population.map { $0.percentage }
            let localMin = percentages.min() ?? 0
            let localMax = percentages.max() ?? 0
            return (localMin, localMax)
        }

        let min = limits.map { $0.0 }.min() ?? 0
        let max = limits.map { $0.1 }.max() ?? 0

        // Get the unique age ranges to mark the x-axis
        // and then sort them
        let uniqueRanges = Set( data
            .map { $0.population.map { $0.ageRange } }
            .joined() )
        let ranges = Array(uniqueRanges).sorted()

        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Age Ranges",
            categoryOrder: ranges.map { $0 }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Population percentage",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(value)%" }

        return AXChartDescriptor(
            title: "Population by age",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: series
        )
    }
}

// MARK: - Preview

struct PyramidChart_Previews: PreviewProvider {
    static var previews: some View {
        PyramidChart(isOverview: true)
		PyramidChart(isOverview: false)
    }
}
