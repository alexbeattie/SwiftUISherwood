//
//  ActivityIndicatorView.swift
//  TravelApp
//
//  Created by Alex Beattie on 11/21/20.
//

import SwiftUI


struct ActivityIndicatorView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        aiv.color = .white
        return aiv
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }

    typealias UIViewType = UIActivityIndicatorView
    
    
}

struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView()
    }
}
