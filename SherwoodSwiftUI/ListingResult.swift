//
//  ListingResult.swift
//  SherwoodSwiftUI
//
//  Created by Alex Beattie on 12/19/20.
//

import Foundation
struct ListingResult: Decodable, Hashable {
    let id:Int
    let name, thumbnail: String
}
struct HomeModel: Codable {
    var D: listingResultsData
}
struct listingResultsData: Codable {
    var Results: [listingResults]
}


struct listingResults: Codable {
    var Id: String
    var ResourceUri: String
    var StandardFields: standardFields
    //var lastCachedTimestamp: JSONNull?
    //var CustomFields: [CustomField]?
}
struct standardFields: Codable {
    
//    var BedsTotal: String?
//    var BathsFull: String?
    var BuildingAreaTotal: Float
    let Latitude: Double
    let Longitude: Double
//
    var ListingId: String
    var ListAgentName: String
////    var ListAgentStateLicense: String?
//    var ListAgentEmail: String?
    var CoListAgentName: String
    var MlsStatus: String
    var ListOfficePhone: String
//    var ListOfficeFax: String?
    
    var UnparsedFirstLineAddress: String
    var City: String
    var PostalCode: String
    var StateOrProvince: String
//
//    var UnparsedAddress: String?
//
    var CurrentPricePublic: Int
//    var ListPrice: Int?
    var PublicRemarks: String?
    var VirtualTours: [VirtualToursObjs]?
    struct VirtualToursObjs: Codable {
        var Uri: String?
    }
    var Videos: [VideosObjs]?
    struct VideosObjs: Codable {
        var ObjectHtml: String?
    }
    
    var Documents: [DocumentsAvailable]?
    struct DocumentsAvailable: Codable {
        var Id: String
        var ResourceId: String
        var Name: String
    }
    var Photos: [PhotoDictionary]?
    struct PhotoDictionary:Codable {
        var Id: String
        var Name: String
        var Uri300: String
        var Uri640: String
        var Uri800: String
        var Uri1600: String

    }
}
