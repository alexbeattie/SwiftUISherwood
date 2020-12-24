//
//  ContentView.swift
//  SherwoodSwiftUI
//
//  Created by Alex Beattie on 12/14/20.
//

import SwiftUI
import KingfisherSwiftUI


class HomeViewModel: ObservableObject {
    @Published var items = 0..<5
    @Published var listingResults = [ListingResult]()
    
    init() {
        guard let url = URL(string: "http://artisanbranding.com/test.json") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, url, error) in
            DispatchQueue.main.async {  
                guard let data = data else { return }
                do  {
                    if let homeModel = try? JSONDecoder().decode(HomeModel.self, from: data) {
                        print(homeModel.D.Results)
//                        print(homeModel.id)
                    }
//                    self.homeModel standardFields= try JSON Decoder().decode(HomeModel.self, from: data)
//                    print(homeModel ??"")
                } catch let jsonError {
                    print("decoding failed for UserDetails", jsonError)
//                    self.errorMessage = error.localizedDescription

                }
                print(data)
            }
        }.resume()
    }
}
struct HomeView: View {
    @ObservedObject var vm = HomeViewModel()
    var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns:
                            [
                                GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                                GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                                GridItem(.flexible(minimum: 100, maximum: 200))
                                
                            ], spacing:12, content: {
                                ForEach(vm.items, id: \.self) { num in
                                    VStack (alignment: .leading) {
                                    Spacer().frame(width: 100, height: 100).background(Color.blue)
                                    
                                    Text("Willow")
                                    Text("4,300,000")
                                    Text("Sale Pending")
                                    }
                                }
                                
                            }).background(Color.gray)
                
                
                VStack(spacing: 0) {
                    GeometryReader { geo in
                        KFImage(URL(string: "https://cdn.resize.sparkplatform.com/vc/1600x1200/true/20200729003019512986000000-o.jpg"))
                                .resizable()
                                .scaledToFill()
                    }
                }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(vm: .init())
        }
    }
}
