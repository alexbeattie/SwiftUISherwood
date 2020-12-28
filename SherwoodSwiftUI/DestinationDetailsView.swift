//
//  DestinationDetailsView.swift
//  SherwoodSwiftUI
//
//  Created by Alex Beattie on 12/25/20.
//

import SwiftUI
import MapKit
import KingfisherSwiftUI

struct DestinationDetailsView: View {

//    @ObservedObject var vm = HomeViewModel()
//    @Published var listingResults = [QueryResult]()
    @ObservedObject var vm = HomeViewModel()
//    @ObservedObject var vm:HomeViewModel
//    let listing: Listings
    
//    let fields:Fields

//    let listing: Listings
//    let listing: HomeViewModel
    var body: some View {
        ScrollView {
            VStack {
                
//                KFImage(URL(string: listingResults.first?.StandardFields.CoListAgentName ?? ""))
//                    .resizable().frame(height:200)
                Text(vm.listingResults.first?.StandardFields.CoListAgentName ?? "")
                Text(vm.listingResults.first?.StandardFields.City ?? "")
                Text("\(vm.listingResults.first?.StandardFields.CurrentPricePublic ?? 0)")
                Text(vm.listingResults.first?.StandardFields.PublicRemarks ?? "")

            }.padding(.horizontal)
        }
    }

}
#if DEBUG
struct DestinationDetailsView_Previews: PreviewProvider {
    static var listing:   Listings?
    
    static var previews: some View {
        NavigationView {
//            HomeView()
            DestinationDetailsView()
        }
    }
}
#endif
