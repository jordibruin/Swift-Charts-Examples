//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation

struct WineAction: Identifiable {
    enum InOut: Int, CaseIterable, Identifiable {
        case all, `in`, out
        var title: String {
            switch self {
            case .all:
                return "All Wines"
            case .in:
                return "Wine In "
            case .out:
                return "Wine Out"
            }
        }
        var id: Int {
            self.rawValue
        }
    }
    let month: String
    let inOut: InOut
    let qty: Int
    var id = UUID()
    var actual: Int {
        inOut == .out ? -qty : qty
    }
    
    static var allActions: [WineAction] {
        [
            .init(month: "Jan", inOut: .in, qty: 15),
            .init(month: "Jan", inOut: .out, qty: 20),
            .init(month: "Feb", inOut: .in, qty: 22),
            .init(month: "Feb", inOut: .out, qty: 18),
            .init(month: "Mar", inOut: .in, qty: 12),
            .init(month: "Mar", inOut: .out, qty: 26),
            .init(month: "Apr", inOut: .in, qty: 3),
            .init(month: "Apr", inOut: .out, qty: 18),
            .init(month: "May", inOut: .in, qty: 6),
            .init(month: "May", inOut: .out, qty: 20),
            .init(month: "Jun", inOut: .in, qty: 18),
            .init(month: "Jun", inOut: .out, qty: 15),
            .init(month: "Jul", inOut: .in, qty: 24),
            .init(month: "Jul", inOut: .out, qty: 18),
            .init(month: "Aug", inOut: .in, qty: 6),
            .init(month: "Aug", inOut: .out, qty: 22),
            .init(month: "Sep", inOut: .in, qty: 28),
            .init(month: "Sep", inOut: .out, qty: 12),
            .init(month: "Oct", inOut: .in, qty: 12),
            .init(month: "Oct", inOut: .out, qty: 27),
            .init(month: "Nov", inOut: .in, qty: 20),
            .init(month: "Nov", inOut: .out, qty: 19),
            .init(month: "Dec", inOut: .in, qty: 7),
            .init(month: "Dec", inOut: .out, qty: 21)
        ]
    }
    static var winesIn: [WineAction] {
        allActions.filter { $0.inOut == .in }
    }
    
    static var winesOut: [WineAction] {
        allActions.filter { $0.inOut == .out }
    }
}

enum WineData {
    struct Grouping: Identifiable {
        let inOut: WineAction.InOut
        let wines: [WineAction]
        var id: Int {
            inOut.rawValue
        }
    }
    static let allActions: [Grouping] = [
        .init(inOut: .in, wines: WineAction.winesIn),
        .init(inOut: .out, wines: WineAction.winesOut)
    ]
    static let wineIn: [Grouping] = [
        .init(inOut: .in, wines: WineAction.winesIn)
    ]
    static let wineOut: [Grouping] = [
        .init(inOut: .in, wines: WineAction.winesOut)
    ]
}
