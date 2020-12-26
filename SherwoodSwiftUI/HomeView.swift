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
//        var PublicRemarks: String?
  
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
//    @Published var items = 0..<5
    @Published var listingResults = [QueryResult]()
//    @Published var listingFields = [QueryResult.Fields]()
//    @Published var fields = [Fields]()
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
                    
//                    }
                } catch {
                    print("Failed to decode \(error)")
//                    self.errorMessage = error.localizedDescription

                }
//                print(data)
            }
        }.resume()
    }
}
struct NavigationLazyView<Content: View>: View {
    
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
struct HomeView: View {
    @ObservedObject var vm = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView (showsIndicators: false) {
                ForEach(vm.listingResults, id: \.self) { num in
                    
                    
                    NavigationLink(
                        destination: NavigationLazyView(DestinationDetailsView()),
                        label: {
                            
                            
                            VStack (alignment:.leading, spacing: 4) {
                                
                                KFImage(URL(string:num.StandardFields.Photos?.first?.Uri300 ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .cornerRadius(6)
                                    .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color.gray))
                                    .shadow(radius: 2)

                                    .frame(minWidth:200, minHeight:200)
                                    .clipped()
                                    .shadow(radius: 10)
                                    .padding(.bottom)
//                                    .background(Color.blue)
                                
                                VStack (alignment:.leading, spacing: 2) {
                                Text(num.StandardFields.UnparsedFirstLineAddress)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(Color(.label))
                                Text("\(num.StandardFields.CurrentPricePublic)")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(Color(.label))
                                Text(num.StandardFields.MlsStatus)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(.label))
                                
                                Spacer()
                                    .edgesIgnoringSafeArea(.top)
                                }.padding(.horizontal)
                                
                            }
                            .cornerRadius(4)
                            .shadow(radius: 2)
//                            .border
//                            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
//                            .background(Color.yellow)
                            
                            
                        })
                    
                }.padding()
                
            }
            .navigationBarTitle("Listings", displayMode: .inline)

//            .padding(.horizontal)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationView {
            HomeView()
//        }
    }
}
