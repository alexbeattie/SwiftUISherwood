//
//  Listing.swift
//  SherwoodSwiftUI
//
//  Created by Alex Beattie on 12/28/20.
//

import Foundation

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

    struct Fields: Decodable, Hashable {
        let CoListOfficeName: String
        var BuildingAreaTotal: Float
        let BedsTotal: Int
        let BathsTotal: Int
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

}
