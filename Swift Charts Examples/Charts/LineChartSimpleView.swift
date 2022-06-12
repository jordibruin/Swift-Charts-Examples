//
//  LineChartSimpleView.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import SwiftUI
import Charts

struct LineChartData {
    let index: Int
    let value: Int
}
struct LineChartSimpleView: View {
    
    @State var fakeData: [LineChartData] = [
        LineChartData(index: 0, value: 3),
        LineChartData(index: 1, value: 3),
        LineChartData(index: 2, value: 18),
        LineChartData(index: 3, value: 22),
        LineChartData(index: 4, value: 53),
        LineChartData(index: 5, value: 31),
        LineChartData(index: 6, value: 13),
        LineChartData(index: 7, value: 3),
        LineChartData(index: 8, value: 3),
        LineChartData(index: 9, value: 5),
        LineChartData(index: 10, value: 3),
    ]
    var body: some View {
        VStack {
            Chart(fakeData, id: \.index) { data in
                LineMark(
                    x: .value("Date", data.index),
                    y: .value("High Cover", data.value)
                )
                .lineStyle(StrokeStyle(lineWidth: 2))
                .foregroundStyle(Color.yellow)
            }
            .frame(height: 260)
        }
    }
}

struct LineChartSimpleView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartSimpleView()
    }
}
