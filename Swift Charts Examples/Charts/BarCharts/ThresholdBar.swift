//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct ThresholdBarOverview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(ChartType.threshold.title)
                .font(.callout)
                .foregroundStyle(.secondary)
            let filteredDataSegments = filterData()
            Chart {
                ForEach(0..<filteredDataSegments.count, id: \.self) { dataSegment in
                    ForEach(filteredDataSegments[dataSegment], id: \.id) {
                        BarMark(
                            x: .value("Day", $0.day, unit: .day),
                            y: .value("Sales", $0.sales)
                        )
                        .foregroundStyle($0.fillColor) //set the color of each Mark
                        
                    }
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: Constants.previewChartHeight)
        }
    }
}

struct ThresholdBar: View {
    @State private var barWidth = 7.0
    
    var body: some View {
        List {
            Section {
                let filteredDataSegments = filterData()
                Chart {
                    ForEach(0..<filteredDataSegments.count, id: \.self) { dataSegment in
                        ForEach(filteredDataSegments[dataSegment], id: \.id) {
                            BarMark(
                                x: .value("Day", $0.day, unit: .day),
                                y: .value("Sales", $0.sales),
                                width: .fixed(barWidth)
                            )
                            .foregroundStyle($0.fillColor) //set the color of each Mark
                        }
                    }
                }
                .frame(height: Constants.detailChartHeight)
            }
            
            customisation
        }
        .navigationBarTitle(ChartType.singleBar.title, displayMode: .inline)
    }
    
    private var customisation: some View {
        Section {
            Stepper(value: $barWidth, in: 1.0...20.0) {
                HStack {
                    Text("Bar Width")
                    Spacer()
                    Text("\(String(format: "%.0f", barWidth))")
                }
            }
        }
    }
}

struct ThresholdBar_Previews: PreviewProvider {
    static var previews: some View {
        ThresholdBarOverview()
        ThresholdBar()
    }
}

struct segmentedChartData: Identifiable {
    var id = UUID()
    var day: Date
    var sales: Int
    var aboveThreshold: Bool
    var fillColor: Color
}

///Filtering the data into an array of arrays based on a threshold value
let dataFilterThreshold = 150

func filterData() -> [[segmentedChartData]] {
    var lastSales = 0
    var dataSegment = [segmentedChartData]()
    var filteredSegments = [[segmentedChartData]]()
    for salesData in SalesData.last30Days {
        if lastSales < dataFilterThreshold && salesData.sales < dataFilterThreshold { //Below threshold
            let dataSet = segmentedChartData(day: salesData.day, sales: salesData.sales, aboveThreshold: false, fillColor: .blue)
            dataSegment.append(dataSet)
            lastSales = salesData.sales
        }
        
        if lastSales >= dataFilterThreshold && salesData.sales >= dataFilterThreshold { //Above threshold
            let dataSet = segmentedChartData(day: salesData.day, sales: salesData.sales, aboveThreshold: true, fillColor: .orange)
            dataSegment.append(dataSet)
            lastSales = salesData.sales
        }
        
        if lastSales < dataFilterThreshold && salesData.sales >= dataFilterThreshold { //Transition from low to high
            let dataSet = segmentedChartData(day: salesData.day, sales: salesData.sales, aboveThreshold: false, fillColor: .orange)
            filteredSegments.append(dataSegment)
            dataSegment.removeAll()
            dataSegment.append(dataSet)
            lastSales = salesData.sales
        }
        
        if lastSales >= dataFilterThreshold && salesData.sales < dataFilterThreshold { //Transition from high to low
            let dataSet = segmentedChartData(day: salesData.day, sales: salesData.sales, aboveThreshold: false, fillColor: .blue)
            filteredSegments.append(dataSegment)
            dataSegment.removeAll()
            dataSegment.append(dataSet)
            lastSales = salesData.sales
        }
    }
    return filteredSegments
}
