import Foundation
import CoreLocation

struct EnturSearchResponse:Codable{
    let features:[EnturSearchPlace]?
}

struct EnturSearchPlace:Codable{
    let type:String?
    let geometry:EnturSearchGeometry?
    let properties:EnturSearchPlaceProperties?
    
    func coordinates()->CLLocationCoordinate2D?{
        if let geo = self.geometry?.coordinates{
            if geo.count == 2{
                return CLLocationCoordinate2D(latitude: geo[1], longitude: geo[0])
            }
        }
        return nil
    }
}
struct EnturSearchGeometry:Codable{
    let type:String?
    let coordinates:[Double]?
}
struct EnturSearchPlaceProperties:Codable{
    let id:String?
    let gid:String?
    let layer:String?
    let source:String?
    let source_id:String?
    let name:String?
    let housenumber:String?
    let street:String?
    let distance:Double?
    let accuracy:String?
    let country_gid:String?
    let county:String?
    let county_gid:String?
    let locality:String?
    let locality_gid:String?
    let borough:String?
    let borough_gid:String?
    let label:String?
    let category:[String]?
    let tariff_zones:[String]?
    let description:[[String:String]]?
}
