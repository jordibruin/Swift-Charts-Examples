//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License


import SwiftUI
import Charts

struct AnimatingLineOverview: View {
    
    @State var x: Double = -0.4
    
    var body: some View {
        AnimatedChart(x: x)
//        .aspectRatio(1, contentMode: .fit)
        .frame(height: Constants.previewChartHeight)
    }
}

struct AnimatingLine: View {
    
    @State var x: Double = -1
    
    var body: some View {
        List {
            Section {
                AnimatedChart(x: x)
                .aspectRatio(1, contentMode: .fit)
                .padding()
            }
            
            Section {
                Button {
                    withAnimation(.linear(duration: 2)) {
                        x = 1
                    }
                } label: {
                    Text("Animate")
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

import Charts
import SwiftUI

struct Sample: Identifiable {
    var x: Double
    var y: Double
    
    var id: some Hashable { x }
}

struct AnimatedChart: View, Animatable {
    var animatableData: Double  = 0

    init(x: Double) {
        self.animatableData = x
    }

    let samples = stride(from: -1, through: 1, by: 0.01).map {
        Sample(x: $0, y: pow($0, 3))
    }

//    @State var x: Double = -1

    var body: some View {
        VStack {
            Chart {
                // Ideally, there'd be a way to not evaluate this every time.
                ForEach(samples) { sample in
                    LineMark(x: .value("x", sample.x), y: .value("y", sample.y))
                }

                PointMark(
                    x: .value("x", animatableData),
                    y: .value("y", pow(animatableData, 3))
                )
            }
        }

    }
}
//
//struct AnimatedChart_Previews: PreviewProvider {
//    struct Preview: View {
//        @State
//        var x: Double = -1
//
//        var body: some View {
//            VStack {
//                AnimatedChart(x: x)
//                    .aspectRatio(1, contentMode: .fit)
//                    .padding()
//
//                Spacer()
//            }
//            .contentShape(Rectangle())
//            .onTapGesture {
//                withAnimation(.linear(duration: 2)) {
//                    x = 1
//                }
//            }
//        }
//    }
//
//    static var previews: some View {
//        Preview()
//    }
//}
