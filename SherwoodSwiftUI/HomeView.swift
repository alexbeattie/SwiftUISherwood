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
//        guard let url = URL(string: "http://artisanbranding.com/test.json") else { return }
        
        guard let url = URL(string: "http://localhost:8000/test.json") else { return }
        
        
//        http://localhost:8000/test.json
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
        }
        .navigationBarTitle(vm.listingResults.first?.StandardFields.CoListOfficeName ?? "", displayMode: .inline)
    }
}

struct HomeRow: View {
    let listing:QueryResult
    var body: some View {
        VStack (alignment:.leading, spacing: 0) {
            
            KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))
                .resizable()
                .scaledToFill()
//                .cornerRadius(6)
                .frame(width:400, height:200)
                .clipped()

            RowData(listing: listing)
                
        }.padding()
            .asTile()
        
        }
    
       
    }
struct PopDestDetailsView: View {
    let listing:QueryResult
//    @State var region = MKCoordinateRegion(center: .init(latitude: 34.132131, longitude: -118.884572), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @State var region:MKCoordinateRegion
    init(listing: QueryResult) {
        self.listing = listing
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: listing.StandardFields.Latitude, longitude: listing.StandardFields.Longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }

    var body: some View {
        
        ScrollView  {
            KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))
                
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 200)
            VStack (alignment: .leading) {
                
                Text("About This Home")
                    .font(.headline).bold()
                    .padding(.top)
                    .padding(.bottom)
                
                Text(listing.StandardFields.PublicRemarks ?? "")
                    
                    .font(.system(size: 16, weight: .light))
                HStack {
                    Text("\(listing.StandardFields.CurrentPricePublic)")
                }
                
                HStack {
                    Text(listing.StandardFields.CoListAgentName)
                }
                
                
                HStack {
                    Text("Location")
                    Spacer()
                    
                }.padding()
                
                
                .padding(.horizontal)
                
                MapView(listing: listing)
//                Map(coordinateRegion: $region)
                
            }
            
            
            
            .padding(.horizontal)
        }.navigationBarTitle(listing.StandardFields.Photos?.first?.Name ?? "", displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
        
    }
//    let attractions: [Attraction] = [ .init(name: "alex", latitude: 34.131694, longitude: -118.89586)]
    


}
//struct City: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//}
class ListingAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
init(title: String?,
     subtitle: String?,
     coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
struct MapView: UIViewRepresentable {
    let listing: QueryResult
    func updateUIView(_ view: MKMapView, context: Context) {
        view.mapType = .hybrid
//        view.mapView.delegate = self

        let coordinate = CLLocationCoordinate2D(
            latitude: listing.StandardFields.Latitude, longitude: listing.StandardFields.Longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        let lat = listing.StandardFields.Latitude
        let lng = listing.StandardFields.Longitude
            
        let pinDrop = CLLocationCoordinate2DMake(lat, lng)
        let pin = MKPointAnnotation()
        pin.coordinate = pinDrop
        
        view.addAnnotation(pin)

        
//            let coordinateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: 27500.0, longitudinalMeters: 27500.0)
//            mapView.setRegion(coordinateRegion, animated: true)
            
//            let pin = MKPointAnnotation()
//            pin.coordinate = location
//            pin.title = listing.StandardFields.UnparsedFirstLineAddress
//
//            let listPrice = listing.StandardFields.CurrentPricePublic
//            let numberFormatter = NumberFormatter()
//                numberFormatter.numberStyle = .decimal
//
//            let subtitle = "$\(numberFormatter.string(from: NSNumber(value:(UInt64(listPrice) )))!)"
//
//            pin.subtitle = subtitle
//            pin.coordinate = location
//            view.addAnnotation(lat as! MKAnnotation)
            
            
//        view.addAnnotations(landmarks)

    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
        
    }
}



struct HomeTile:View {
    let num: QueryResult
    var body: some View {
        KFImage(URL(string:num.StandardFields.Photos?.first?.Uri300 ?? ""))
            .resizable()
            .frame(width:400, height:200)
            .scaledToFit()
            .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color.gray))
        
        VStack {
            Text(num.StandardFields.PublicRemarks ?? "")
                .padding()
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(.label))
            Text(num.Id)
        }
        .asTile()
    }
}




struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
       
        NavigationView{
            HomeView()

        }
    }
}
