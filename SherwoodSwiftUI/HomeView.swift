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
        
        guard let url = URL(string: "http://127.0.0.1:8000/Desktop/test.json") else { return }
        
        
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
extension Color {
    static let discoverBackground = Color(.init(white: 0, alpha: 1))
    static let defaultBackground = Color("defaultBackground")
    
//    static let discoverBackground = Color.blue
}

struct HomeView: View {
    
    @ObservedObject var vm = HomeViewModel()
    var body: some View {
        NavigationView {
//            ZStack {
//                Color.discoverBackground.offset(y: 400)

//                .foregroundColor(Color.black)
//                Text("alex")
            ScrollView (showsIndicators: false){
                ForEach(vm.listingResults, id: \.self) { listing in
                    NavigationLink(
                        destination:NavigationLazyView( PopDestDetailsView(listing: listing)),
                        label: {
                            HomeRow(listing: listing)
                        })
                        
                }
//                .listStyle(PlainListStyle())

//                    List (vm.listingResults, id: \.self) { listing in
//
//                        Text("alx")
//
//                        HomeRow(listing: listing)
//
//                    }
//                    .edgesIgnoringSafeArea(.all)

//                }
            }
//            .navigationBarHidden(true)
                    .navigationBarTitle(vm.listingResults.first?.StandardFields.CoListOfficeName ?? "", displayMode: .inline)

//            .edgesIgnoringSafeArea([.top, .bottom])
//            }
        }
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
struct HomeRow: View {
    let listing:QueryResult
    var body: some View {
        VStack () {

            KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))
                .resizable()
                .scaledToFill()
                .cornerRadius(6)
                .frame(width:400, height:200)
                .clipped()

            RowData(listing: listing)
                

        }
//        .edgesIgnoringSafeArea(.top)

        .padding(.bottom)
            .asTile()
        .listStyle(PlainListStyle())
        }
    }
struct PopDestDetailsView: View {
    
    let listing:QueryResult
    
    @State var region:MKCoordinateRegion
    init(listing: QueryResult) {
        self.listing = listing
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: listing.StandardFields.Latitude, longitude: listing.StandardFields.Longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }
    
    var body: some View {

     
//            padding(.vertical)

            ScrollView(showsIndicators: false) {
                
                KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))

                    .resizable()
                    .scaledToFill()
                    
                    .frame(width: 400,
                        height:200)
                    .clipped()
                Divider()
                    Text(listing.StandardFields.PublicRemarks ?? "")
                        .lineLimit(nil)
                        .padding(.horizontal)
                    Divider()
                
                    VStack {
                        
                        Text("\(listing.StandardFields.CurrentPricePublic)")
                           
                        
//                        Spacer()
                    }.font(.body)
                
                VStack {
                    Text("Location")
                }.padding()
//                    .padding()
//                Spacer()
                    VStack {
//
//                        Spacer()

                    }
                MapView(listing: listing)
                    .frame(height:200)
                    .edgesIgnoringSafeArea(.bottom)

                    
            }

        .navigationBarTitle(listing.StandardFields.Photos?.first?.Name ?? "", displayMode: .inline)
            .edgesIgnoringSafeArea(.bottom)

//            .edgesIgnoringSafeArea([.bottom, .top])
//            .navigationBarTitle("Editor", displayMode: .inline)

    }

}


struct MapView: UIViewRepresentable {
    
    
    let listing: QueryResult

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
                init(_ parent: MapView) {
                    self.parent = parent
                }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            guard !(annotation is MKUserLocation) else {
//                return nil
//            }
            
            let annotationIdentifier = "AnnotationIdentifier"
            
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annoView.pinTintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            annoView.animatesDrop = true
            annoView.canShowCallout = true
        
            // Add a RIGHT CALLOUT Accessory
            let rightButton = UIButton(type: UIButton.ButtonType.detailDisclosure)
            rightButton.frame = CGRect(x:0, y:0, width:32, height:32)
            rightButton.clipsToBounds = true
            rightButton.setImage(UIImage(named: "small-pin-map-7"), for: UIControl.State())
            annoView.rightCalloutAccessoryView = rightButton
            
            let leftView = UIView()
            
            leftView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            leftView.backgroundColor = .blue
            annoView.leftCalloutAccessoryView = leftView
            //Add a LEFT IMAGE VIEW
//            var leftIconView = UIImageView()
////            leftIconView.contentMode = .scaleAspectFill
////            leftIconView.contentMode = .scaleAspectFill
//            let newBounds = CGRect(x:0.0, y:0.0, width:54.0, height:54.0)
//            leftIconView.bounds = newBounds
//            leftIconView.clipsToBounds = true
//
////            let thumbnailImageUrl =    KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))
//
//            leftIconView = KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))
//
//
//            annoView.leftCalloutAccessoryView = leftIconView
            
            return annoView
            
            }
        
        }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func updateUIView(_ view: MKMapView, context: Context) {
        view.mapType = .hybrid
        view.delegate = context.coordinator

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
        
       

        
//            let coordinateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: 27500.0, longitudinalMeters: 27500.0)
//            mapView.setRegion(coordinateRegion, animated: true)
//
//            let pin = MKPointAnnotation()
//            pin.coordinate = location
            pin.title = listing.StandardFields.UnparsedFirstLineAddress
//
            let listPrice = listing.StandardFields.CurrentPricePublic
            let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal

            let subtitle = "$\(numberFormatter.string(from: NSNumber(value:(UInt64(listPrice) )))!)"
//
            pin.subtitle = subtitle
//            pin.coordinate = pin
//            view.addAnnotation(lat as! MKAnnotation)
//        view.selectAnnotation(pin, animated: true)
        view.addAnnotation(pin)
//        view.addAnnotations(landmarks)

    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
        
        
    }
}



//struct HomeTile:View {
//    let num: QueryResult
//    var body: some View {
//        KFImage(URL(string:num.StandardFields.Photos?.first?.Uri300 ?? ""))
//            .resizable()
//            .frame(width:400, height:200)
//            .scaledToFit()
//            .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color.gray))
//
//        VStack {
//            Text(num.StandardFields.PublicRemarks ?? "")
//                .padding()
//                .font(.system(size: 16, weight: .regular))
//                .foregroundColor(Color(.label))
//            Text(num.Id)
//        }
////        .asTile()
//    }
//}




struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
       
        NavigationView{
          
            HomeView()
        }
        .navigationBarTitle("alex", displayMode: .inline)
    }
}
