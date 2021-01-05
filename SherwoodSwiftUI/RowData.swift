//
//  RowData.swift
//  SherwoodSwiftUI
//
//  Created by Alex Beattie on 1/1/21.
//

import SwiftUI

struct RowData: View {
    
    var listing: QueryResult
    var body: some View {
        
        ZStack {
            VStack (alignment: .leading, spacing: 12) {
                
                HStack (alignment: .bottom, spacing: 20){
                    
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
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct RowData_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
//        RowData()
    }
}
