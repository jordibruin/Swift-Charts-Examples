//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI

// MARK: UIImage / NSImage

#if os(macOS)
typealias XImage = NSImage
#else
typealias XImage = UIImage
#endif

extension Image {
    init(xImage: XImage) {
        #if os(macOS)
        self.init(nsImage: xImage)
        #else
        self.init(uiImage: xImage)
        #endif
    }
}

// MARK: - UIColor / NSColor

#if os(macOS)
typealias XColor = NSColor
#else
typealias XColor = UIColor
#endif

// MARK: - Navigation Bar Title

#if os(macOS)
struct NavigationBarItem {
    enum TitleDisplayMode {
        case automatic
        case inline
        case large
    }
}

extension View {
    func navigationBarTitle(_ title: Text, displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        navigationTitle(title)
    }
    
    func navigationBarTitle(_ titleKey: LocalizedStringKey, displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        navigationTitle(titleKey)
    }
    
    func navigationBarTitle<S: StringProtocol>(_ title: S, displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        navigationTitle(title)
    }
}
#endif
