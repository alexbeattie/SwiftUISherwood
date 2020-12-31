//
//  ContentView.swift
//  SherwoodSwiftUI
//
//  Created by Alex Beattie on 12/14/20.
//

import SwiftUI
import KingfisherSwiftUI
import MapKit

class HomeViewModel: ObservableObject {

    @Published var listingResults = [QueryResult]()

    init() {
        guard let url = URL(string: "http://artisanbranding.com/test.json") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, url, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do  {
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

//    @State private var showingDetail = false

    @ObservedObject var vm = HomeViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                
                ForEach(vm.listingResults, id: \.self) { listing in
                    
                    NavigationLink(
                        destination: PopDestDetailsView(listing: listing),
                        
                        label: {
                            
                            HomeRow(listing: listing)
                           
                        })
                    
                }
            }
//            Spacer()
        }.navigationBarTitle(vm.listingResults.first?.StandardFields.CoListOfficeName ?? "", displayMode: .inline)

        
    }
}
struct HomeRow: View {
    let listing:QueryResult
    var body: some View {
        VStack (alignment:.leading, spacing: 0) {
            
            KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))
                .resizable()
                .scaledToFill()
                .cornerRadius(6)
//                .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color.gray))
//                .shadow(radius: 2)
                .frame(width:400, height:200)
                .clipped()
//                .shadow(radius: 10)
            
            RowData(listing: listing)
            
            
            
        }.padding()
            .asTile()
        
        }
    
       
    }
//class HomeViewDetailViewModel: ObservableObject {
//    @Published var isLoading = true
//    init() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.isLoading = false
//        }
//    }
//}
struct PopDestDetailsView: View {
    let listing:QueryResult
//    @State var region = MKCoordinateRegion(center: .init(latitude: 34.132131, longitude: -118.884572), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @State var region:MKCoordinateRegion
    init(listing: QueryResult) {
        self.listing = listing
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: listing.StandardFields.Latitude, longitude: listing.StandardFields.Longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
//        self.region = MKCoordinateRegion(center: .init(latitude: listing.StandardFields.Latitude, longitude: listing.StandardFields.Longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }

    var body: some View {

        ScrollView  {
                KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))
                    
                    .resizable()
                    .scaledToFill()
                    .frame(width: 400, height: 200)
                    .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color.gray))
                    .clipped()
            
            //                .cornerRadius(6)
            //                .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color.gray))
            
            //                .shadow(radius: 10)
            VStack (alignment: .leading) {
                
                Text("About This Home")
                    .font(.headline).bold()
                    .padding(.top)
                    .padding(.bottom)
                
                Text(listing.StandardFields.PublicRemarks ?? "")
                    
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color(.label))
                //                    .frame(idealHeight:200)
                
                HStack {
                    Spacer()
                    Text("\(listing.StandardFields.CurrentPricePublic)")
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text(listing.StandardFields.CoListAgentName)
                    Spacer()
                }
                
                
                HStack {
                    Text("Location")
                    Spacer()
                    
                }.padding()
                
                
                //                .padding(.horizontal)
                HStack {
                    
                    Map(coordinateRegion: $region)
                }

                
            }
            .padding(.top, 20).padding(.horizontal)
        }.navigationBarTitle(listing.StandardFields.Photos?.first?.Name ?? "", displayMode: .inline)
        
        
        .edgesIgnoringSafeArea(.bottom)
//        .padding(.horizontal)
    }

}
struct HomeTile:View {
    let num: QueryResult
    var body: some View {
        
            KFImage(URL(string:num.StandardFields.Photos?.first?.Uri300 ?? ""))
                .resizable()
                .frame(width:400, height:200)
                .scaledToFit()
//                .cornerRadius(6)
                .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color.gray))
//                .shadow(radius: 10)
            VStack {
                Text(num.StandardFields.PublicRemarks ?? "")
                    .padding()
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(.label))
                Text(num.Id)
                
                    
                
            }.asTile()
            
        }
    }
struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
//        ScrollView {
        
        NavigationView{
            HomeView()
            Spacer()

        }
        
        

    }
}

struct RowData: View {
//    typealias Body = <#type#>
    
    var listing: QueryResult
    var body: some View {
    
        ZStack {
        VStack (alignment: .leading, spacing: 12) {
            
            HStack (alignment: .bottom, spacing: 10){
                
                VStack (alignment: .leading) {
                    Text("$\(listing.StandardFields.CurrentPricePublic)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(.label))
                    Text("Price")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                VStack (alignment: .leading) {
                    Text("\(listing.StandardFields.BedsTotal)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(.label))
                    Text("Beds")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                VStack (alignment: .leading) {
                    Text("\(listing.StandardFields.BathsTotal)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(.label))
                    Text("Baths")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack (alignment: .leading) {
                    Spacer()
                    Text("\(listing.StandardFields.BuildingAreaTotal, specifier: "%.0f")")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(.label))
                    
                    Text("Sq Feet")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    
                }
            }.padding(.horizontal)
            
            HStack (alignment: .lastTextBaseline, spacing: 0){
                
                VStack (alignment:.center) {
                    HStack {
                        //Spacer()
                        VStack (alignment: .leading){
                            Text(listing.StandardFields.UnparsedFirstLineAddress)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(.gray))
                            HStack {
                                Text("\(listing.StandardFields.City),")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color(.gray))
                                Text("\(listing.StandardFields.StateOrProvince),")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color(.gray))
                                Text(listing.StandardFields.PostalCode)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color(.gray))
                            }
                            
                        }
                    }
                    
                }.padding(.horizontal)
            }
        }
    }
    }
}
