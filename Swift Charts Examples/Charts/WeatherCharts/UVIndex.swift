//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct UVIndex: View {
    
    @State var isOverview = false
    @State private var selectedDate: Date?
    
    @State var data = WeatherData.hourlyUVIndex
    
    var body: some View {
        if isOverview {
            chart
                .accessibilityChartDescriptor(self)
        } else {
            List {
                chart
                    .accessibilityChartDescriptor(self)
            }
            .navigationTitle(ChartType.uvIndex.title)
        }
    }
    
    var chart: some View {
        Section {
            Chart {
                RectangleMark(
                    xStart: .value("hour", Calendar.current.startOfDay(for: Date())),
                    xEnd: .value("hour", Calendar.current.startOfDay(for: Date()).addingTimeInterval(60*60*23))
                )
                .foregroundStyle(.linearGradient(stops: [
                    Gradient.Stop(color: .green, location: 0),
                    Gradient.Stop(color: .green, location: 2/14),
                    Gradient.Stop(color: .yellow, location: 5/14),
                    Gradient.Stop(color: .orange, location: 8/14),
                    Gradient.Stop(color: .red, location: 10/14),
                    Gradient.Stop(color: .purple, location: 14/14),
                ], startPoint: .bottom, endPoint: .top))
                .mask {
                    if let max = data.max(by: { $0.uvIndex < $1.uvIndex }) {
                        ForEach(data, id: \.date) { hour in
                            AreaMark(
                                x: .value("hour", hour.date),
                                y: .value("uvIndex", hour.uvIndex)
                            )
                            .interpolationMethod(.cardinal)
                            .foregroundStyle(.black.opacity(0.2))
                            
                            LineMark(
                                x: .value("hour", hour.date),
                                y: .value("uvIndex", hour.uvIndex)
                            )
                            .interpolationMethod(.cardinal)
                            .lineStyle(StrokeStyle(lineWidth: 4))
                            .symbol(Circle().strokeBorder(style: StrokeStyle(lineWidth: 0)))
                            .symbolSize(hour.date == max.date ? CGSize(width: 10, height: 10) : .zero)
                        }
                        
                        PointMark(
                            x: .value("hour", max.date),
                            y: .value("uvIndex", max.uvIndex)
                        )
                        .symbolSize(CGSize(width: 5, height: 5))
                        .foregroundStyle(.green)
                        .annotation(spacing: 0) {
                            Text("\(max.uvIndex)")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if let selectedDate, let uvIndex = data.first(where: { $0.date == selectedDate })?.uvIndex {
                    RuleMark(x: .value("hour", selectedDate))
                        .foregroundStyle(Color(.label))
                    PointMark(
                        x: .value("hour", selectedDate),
                        y: .value("uvIndex", uvIndex)
                    )
                    .symbolSize(CGSize(width: 15, height: 15))
                    .foregroundStyle(Color(.label))
                }
            }
            .chartYScale(domain: 0...14)
            .chartYAxis {
                AxisMarks(position: .trailing, values: .automatic(desiredCount: 14)) { axisValue in
                    if axisValue.index % 2 == 0 {
                        AxisValueLabel()
                    }
                    AxisGridLine()
                }
                
                AxisMarks(preset: .inset, position: .leading, values: .automatic(desiredCount: 14)) { axisValue in
                    switch axisValue.index {
                    case 1:
                        AxisValueLabel("Low", anchor: .topLeading)
                    case 3:
                        AxisValueLabel("Moderate", anchor: .topLeading)
                    case 6:
                        AxisValueLabel("High", anchor: .topLeading)
                    case 8:
                        AxisValueLabel("Very high", anchor: .topLeading)
                    case 11:
                        AxisValueLabel("Extreme", anchor: .topLeading)
                    default:
                        EmptyAxisMark()
                    }
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom, values: .automatic) { _ in
                    AxisValueLabel()
                    AxisGridLine()
                    AxisTick()
                }
                
                AxisMarks(position: .top, values: .automatic(desiredCount: 24)) { value in
                    if value.index % 2 != 0 {
                        AxisValueLabel("\(data[value.index].uvIndex)", anchor: .bottom)
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { g in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let x = value.location.x - g[proxy.plotAreaFrame].origin.x
                                    if let date: Date = proxy.value(atX: x), let roundedHour = date.nearestHour() {
                                        self.selectedDate = roundedHour
                                    }
                                }
                                .onEnded { value in
                                    self.selectedDate = nil
                                }
                        )
                }
            }
            .chartYAxis(isOverview ? .hidden : .visible)
            .chartXAxis(isOverview ? .hidden : .visible)
            .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
            .accessibilityRepresentation {
                Chart(data, id: \.date) { hour in
                    Plot {
                        BarMark(
                            x: .value("hour", hour.date),
                            y: .value("uvIndex", hour.uvIndex)
                        )
                    }
                    .accessibilityLabel(hour.date.formatted(date: .omitted, time: .complete))
                    .accessibilityValue("\(hour.uvIndex)")
                }
                .accessibilityHidden(isOverview)
            }
        }
    }
}

struct UVIndex_Previews: PreviewProvider {
    static var previews: some View {
        UVIndex()
    }
}
