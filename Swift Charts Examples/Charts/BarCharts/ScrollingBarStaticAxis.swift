//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts
//import Inject


    
struct ScrollingBarStaticAxis: View {
    var isOverview: Bool

    @State private var scrollWidth = 450.0
    @State private var action: WineAction.InOut = .all

//    @ObserveInjection var inject
    
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
                    ZStack {
                        ScrollView(.horizontal) {
                            chart
                        }
                        axisOnly
                    }
                }
                customisation
            }
            .navigationBarTitle(ChartType.scrollingBar.title, displayMode: .inline)
//            .enableInjection()
        }
    }

    private var axisOnly: some View {
        Chart(wineData) { grouping in
            ForEach(grouping.wines) { wine in
                Plot {
                    BarMark (
                        x: .value("Month", wine.month),
                        y: .value("Quantity",  wine.actual)
                    )
                    .foregroundStyle(wine.inOut == .in ? .purple : .green)
                    .opacity(0)
                }
                
                .accessibilityLabel("\(grouping.inOut.title)")
                .accessibilityValue("\(wine.actual)")
            }
        }
        .background(Color.white)
        .chartYAxis {
            AxisMarks(preset: .automatic, position: .leading)
        }
        .chartXAxis {
            AxisMarks(preset: .automatic, position: .bottom)
        }
        .chartYAxis(isOverview ? .hidden : .automatic)
        .chartXAxis(isOverview ? .hidden : .automatic)
        .mask(
            Rectangle()
                .frame(width: 60, height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight + 20)
                .offset(x: -160)
                .offset(y: -20)
        )
        
        .clipped()
        .padding(.vertical)
        .clipShape(Rectangle())
        .frame(width: 310, height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
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
        .chartYAxis(.hidden)
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

struct ScrollingBarStaticAxis_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingBarStaticAxis(isOverview: true)
        ScrollingBarStaticAxis(isOverview: false)
    }
}

