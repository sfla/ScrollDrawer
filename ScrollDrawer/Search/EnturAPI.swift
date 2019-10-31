import Foundation
import CoreLocation

class EnturAPI{
    static let shared = EnturAPI()
    static let searchURL:String = "https://api.entur.io/geocoder/v1/autocomplete"
    let session:URLSession
    
    
    private init(){
        let config = URLSessionConfiguration.ephemeral
        config.httpAdditionalHeaders = ["ET-Client-Name": "RuterNY"]
        session = URLSession(configuration: config)
    }
    
    
    func searchForPlaces(with text:String, with location:CLLocation?, completion:((EnturSearchResponse)->())?, failure:(()->())?)->URLSessionTask?{
        guard let searchString = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { failure?(); return nil }
        var urlString = "\(EnturAPI.searchURL)?text=\(searchString)"
        urlString += "&categories=NO_FILTER&lang=nb&boundary.county_ids=01,02,03,04,05,06,07,08"
        if let location = location{
            urlString += "&focus.point.lat=\(location.coordinate.latitude)&focus.point.lon=\(location.coordinate.longitude)"
        }

        guard let url = URL(string: urlString) else { failure?(); return nil }
        let date = Date()
        let task = session.dataTask(with: url) { (data, response, error) in
            print("EnturSearch: \(Int(Double(Date().timeIntervalSince(date))*1000))ms")
            if let data = data{
                do{
                    let enturSearchResponse = try JSONDecoder().decode(EnturSearchResponse.self, from: data)
                    if enturSearchResponse.features == nil{
                        failure?() //Even with empty result, the array should exist.
                    }else if enturSearchResponse.features?.isEmpty == true{
                        failure?()
                    }else{
                        completion?(enturSearchResponse)
                    }
                }catch let err{
                    print("Err: ", err)
                    failure?()
                }
            }else if let _ = error{
                failure?()
            }else{
                print("Unkown searchError.")
                failure?()
            }
        }
        task.resume()
        return task
    }
    
    
}
