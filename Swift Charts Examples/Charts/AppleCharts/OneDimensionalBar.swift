//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct OneDimensionalBar: View {
	var isOverview: Bool

    @State var data = DataUsageData.example

    @State private var showLegend = true
    
    private var totalSize: Double {
        data
            .reduce(0) { $0 + $1.size }
    }

    var body: some View {
		if isOverview {
            VStack {
                HStack {
                    Text("iPhone")
                    Spacer()
                    Text("\(totalSize, specifier: "%.1f") GB of 128 GB Used")
                        .foregroundColor(.secondary)
                }
                chart
            }
		} else {
			List {
				Section {
					VStack {
						HStack {
							Text("iPhone")
							Spacer()
							Text("\(totalSize, specifier: "%.1f") GB of 128 GB Used")
								.foregroundColor(.secondary)
						}
						chart
					}
				}

				customisation
			}
			.navigationBarTitle(ChartType.oneDimensionalBar.title, displayMode: .inline)
		}

    }

	private var chart: some View {
        Chart(data, id: \.category) { element in
            Plot {
                BarMark(
                    x: .value("Data Size", element.size)
                )
                .foregroundStyle(by: .value("Data Category", element.category))
            }
            .accessibilityLabel(element.category)
            .accessibilityValue("\(element.size, specifier: "%.1f") GB")
            .accessibilityHidden(isOverview)
        }
		.chartPlotStyle { plotArea in
			plotArea
                #if os(macOS)
                .background(Color.gray.opacity(0.2))
                #else
                .background(Color(.systemFill))
                #endif
				.cornerRadius(8)
		}
        .accessibilityChartDescriptor(self)
		.chartXScale(range: 0...128)
		.chartYScale(range: .plotDimension(endPadding: -8))
		.chartLegend(position: .bottom, spacing: -8)
		.chartLegend(showLegend ? .visible : .hidden)
		.frame(height: 50)
	}
    
    private var customisation: some View {
        Section {
            Toggle("Show Chart Legend", isOn: $showLegend)
        }
    }
}

// MARK: - Accessibility

extension OneDimensionalBar: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let min = data.map(\.size).min() ?? 0
        let max = data.map(\.size).max() ?? 0

        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Category",
            categoryOrder: data.map { $0.category }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Size",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(String(format:"%.2f", value)) GB" }

        let series = AXDataSeriesDescriptor(
            name: "Data Usage Example",
            isContinuous: false,
            dataPoints: data.map {
                .init(x: $0.category, y: $0.size)
            }
        )

        return AXChartDescriptor(
            title: "Data Usage by category",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}

// MARK: - Preview

struct OneDimensionalBar_Previews: PreviewProvider {
    static var previews: some View {
        OneDimensionalBar(isOverview: true)
		OneDimensionalBar(isOverview: false)
    }
}
