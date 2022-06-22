//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License


import SwiftUI
import Charts

struct AnimatingLineOverview: View {
    @State private var x: Double = -0.4
    
    var body: some View {
        AnimatedChart(x: x, isOverview: true)
            .frame(height: Constants.previewChartHeight)
    }
}

struct AnimatingLine: View {
    @State private var x: Double = -1
    
    var body: some View {
        List {
            Section {
                AnimatedChart(x: x)
                    .aspectRatio(1, contentMode: .fit)
            }
            
            Section {
                Button {
                    withAnimation(.linear(duration: 2)) {
                        x = (x == 1) ? -1 : 1
                    }
                } label: {
                    Text("Animate")
                }
                VStack(alignment: .leading) {
                    Text("X Value: \(x, specifier: "%.2f")")
                        .animation(.none)
                    Slider(value: $x, in: -1...1) {
                        Text("X Value")
                    } minimumValueLabel: {
                        Text("-1")
                    } maximumValueLabel: {
                        Text("1")
                    }
                }
            }
        }
        .navigationBarTitle(ChartType.animatingLine.title, displayMode: .inline)
    }
}

struct AnimatingLine_Previews: PreviewProvider {
    static var previews: some View {
        AnimatingLineOverview()
        AnimatingLine()
    }
}

struct AnimatedChart: View, Animatable {
    var animatableData: Double = 0
    var isOverview = false

    init(x: Double, isOverview: Bool = false) {
        self.animatableData = x
        self.isOverview = isOverview
    }

    let samples = stride(from: -1, through: 1, by: 0.01).map {
        Sample(x: $0, y: pow($0, 3))
    }

    var body: some View {
        Chart {
            // Ideally, there'd be a way to not evaluate this every time.
            ForEach(samples) { sample in
                LineMark(x: .value("x", sample.x), y: .value("y", sample.y))
                    .accessibilityLabel("\(sample.x)")
                    .accessibilityValue("\(sample.y)")
                    .accessibilityHidden(isOverview)
            }

            PointMark(
                x: .value("x", animatableData),
                y: .value("y", pow(animatableData, 3))
            )
        }
        .accessibilityChartDescriptor(self)
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
    }

    struct Sample: Identifiable {
        var x: Double
        var y: Double

        var id: some Hashable { x }
    }
}
