//
//  TileModifier.swift
//  SherwoodSwiftUI
//
//  Created by Alex Beattie on 12/28/20.
//

import SwiftUI

extension View {
    func asTile() -> some View {
        modifier(TileModifier())
    }
}
struct TileModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(5)
            .shadow(color: .init(.sRGB, white:0.8, opacity:1), radius: 4, x: 0.0, y: 2)
    }
}



//struct HiddenNavigationBar: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//        .navigationBarTitle("", displayMode: .inline)
//        .navigationBarHidden(true)
//    }
//}
//
//extension View {
//    func hiddenNavigationBarStyle() -> some View {
//        modifier( HiddenNavigationBar() )
//    }
//}
