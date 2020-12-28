//
//  ContentView.swift
//  SherwoodSwiftUI
//
//  Created by Alex Beattie on 12/14/20.
//

import SwiftUI
import KingfisherSwiftUI

struct Listings: Decodable {
    let D: d
}
struct d: Decodable {
    let Results: [QueryResult]
}
struct QueryResult: Decodable, Hashable {
    var Id: String
    var ResourceUri: String
    var StandardFields: Fields

    

}
struct Fields: Decodable, Hashable {
    var BuildingAreaTotal: Float
    let Latitude: Double
    let Longitude: Double
    var ListingId: String
    var ListAgentName: String
    var CoListAgentName: String
    var MlsStatus: String
    var ListOfficePhone: String
    
    var UnparsedFirstLineAddress: String
    var City: String
    var PostalCode: String
    var StateOrProvince: String
    
    var CurrentPricePublic: Int
    var PublicRemarks: String?
  
    var VirtualTours: [VirtualToursObjs]?
    struct VirtualToursObjs: Codable, Hashable {
        var Uri: String?
    }
    var Videos: [VideosObjs]?
    struct VideosObjs: Codable, Hashable {
        var ObjectHtml: String?
    }
//
    var Documents: [DocumentsAvailable]?
    struct DocumentsAvailable: Codable, Hashable {
        var Id: String
        var ResourceId: String
        var Name: String
    }
    var Photos: [PhotoDictionary]?
    struct PhotoDictionary: Codable, Hashable {
        var Id: String
        var Name: String
        var Uri300: String

    }
}
class HomeViewModel: ObservableObject {

    @Published var listingResults = [QueryResult]()
//    @Published var listingFields = [Fields]()
    @Published var listingFields = [Listings]()

    init() {
        guard let url = URL(string: "http://artisanbranding.com/test.json") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, url, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do  {
//                    if let homeModel = try? JSONDecoder().decode(Listings.self, from: data) {
                    let homeModel = try JSONDecoder().decode(Listings.self, from: data)
                    print(homeModel)
                    
                    self.listingResults = homeModel.D.Results
                    
                    
                } catch {
                    print("Failed to decode \(error)")

                }
            }
        }.resume()
    }
}

struct HomeView: View {
    @ObservedObject var vm = HomeViewModel()
    
    
    var body: some View {
        
//        NavigationView {
            ZStack {
                ScrollView {
                    ForEach(vm.listingResults, id: \.self) { listing in
                            NavigationLink(
                                destination: Card(),
                                label: {
                                    VStack (alignment:.leading, spacing: 0) {

                                    KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        .cornerRadius(6)
                                        .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color.gray))
                                        .shadow(radius: 2)
                                        
                                        .frame(width:350, height:200)
                                        .clipped()
                                        .shadow(radius: 10)
//                                        .padding(.bottom)
                                    
                                        VStack (alignment: .leading, spacing: 0) {
                                            
                                            Text(listing.StandardFields.UnparsedFirstLineAddress)
                                                .font(.system(size: 16, weight: .regular))
                                                .foregroundColor(Color(.label))
                                            Text("\(listing.StandardFields.CurrentPricePublic)")
                                                .font(.system(size: 12, weight: .regular))
                                                .foregroundColor(Color(.label))
                                            Text(listing.StandardFields.MlsStatus)
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(Color(.label))
                                            
                                        }.padding()
//                                        Spacer()
                                            
                                            .edgesIgnoringSafeArea(.top)
                                    }.asTile().padding(.horizontal)
                                    
                                    
                                    
                                })
                    }
                }.navigationBarTitle("alex", displayMode: .inline)
            }
    }
}

class HomeViewDetailViewModel: ObservableObject {
    @Published var isLoading = true
//    @Published var listings = [Int]()
//    @Published var listingResults = [QueryResult]()

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
}
struct Card: View {
    
    @ObservedObject var am = HomeViewDetailViewModel()
//    @State var isLoading = false
    @ObservedObject var vm = HomeViewModel()
    
    var body: some View {
        ZStack {
            if am.isLoading {
                Text("Currently Loading")
            } else {
                NavigationView {
                    ScrollView {
                        ForEach(vm.listingResults, id:\.self) { num in
                            VStack(alignment: .leading, spacing: 2) {
                                KFImage(URL(string:num.StandardFields.Photos?.first?.Uri300 ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .cornerRadius(6)
                                    .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color.gray))
                                    .shadow(radius: 2)
                                    
                                    .frame(width:350, height:.infinity)
                                    .clipped()
                                    .shadow(radius: 10)

                                Text(num.Id)
                                Text(num.StandardFields.PublicRemarks ?? "")
//                                Text(num.StandardFields.Photos?.first?.Uri300 ?? "")
                                
//                                Text(vm.StandardFields.Photos?.first?.Uri300 ?? "")
//                                Text(vm.listingResults.first?.StandardFields.ListingId ?? "")
                            }.asTile().frame(width:350,height: 200).padding(.bottom).background(Color.gray)
                        }
                    }.navigationBarTitle("details", displayMode: .inline)
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
//    var listing:Listings
    static var previews: some View {
        
        NavigationView{
//            Card()
            HomeView()
        
        
            

        }
        
    }
}
