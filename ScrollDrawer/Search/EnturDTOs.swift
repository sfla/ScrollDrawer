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
    func transportModes()->[TransportMode]{
        guard let categories = properties?.category else { return [] }
        
        var transportModes:[TransportMode] = []
        
        for category in categories{
            let transportMode:TransportMode?
            switch category {
            case "metroStation": transportMode = .metro
            case "onstreetTram": transportMode = .tram
            case "tramStation" : transportMode = .tram
            case "onstreetBus" : transportMode = .bus
            case "busStation"  : transportMode = .bus
            case "railStation" : transportMode = .rail
            case "ferryStop"   : transportMode = .water
            case "harbourPort" : transportMode = .water
            case "ferryPort"   : transportMode = .water
            default: transportMode = nil
            }
            
            if let t = transportMode, !transportModes.contains(t){
                transportModes.append(t)
            }
        }
        return transportModes
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
