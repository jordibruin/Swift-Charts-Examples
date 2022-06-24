//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation
import Charts

enum ChartInterpolationMethod: Identifiable, CaseIterable {
    case linear
    case monotone
    case catmullRom
    case cardinal
    case stepStart
    case stepCenter
    case stepEnd
    
    var id: String { mode.description }
    
    var mode: InterpolationMethod {
        switch self {
        case .linear:
            return .linear
        case .monotone:
            return .monotone
        case .stepStart:
            return .stepStart
        case .stepCenter:
            return .stepCenter
        case .stepEnd:
            return .stepEnd
        case .catmullRom:
            return .catmullRom
        case .cardinal:
            return .cardinal
        }
    }
}
