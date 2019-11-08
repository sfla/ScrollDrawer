import UIKit

extension UIImage{
    func imageWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func imageForVehicleModes(vehicleModes: [TransportMode]?, tintColor: UIColor, showAll:Bool = false) -> UIImage {
        guard let vehicleModes = vehicleModes else { return UIImage() }
        let cleanVehicleModes = cleanIconSetAccordingToRules(icons: vehicleModes, showAll: showAll)
        if(cleanVehicleModes.count > 0) {
            if cleanVehicleModes.count == 1 {
                return cleanVehicleModes.first?.icon(tint: tintColor) ?? UIImage()
            }
            else {
                // Get all UIImages:
                let vehicleIcons = cleanVehicleModes.map({$0.icon(tint: tintColor)}).filter({$0.size.width > 0})
                
                // Get combined width:
                let paddingWidth = (5.0 * (CGFloat(vehicleIcons.count) - 1))
                let width = vehicleIcons.reduce(0, {$0 + $1.size.width}) + paddingWidth
                
                // Get highest height:
                let height = vehicleIcons.reduce(0, {$1.size.height > $0 ? $1.size.height : $0})
                
                // Start graphics context:
                let size = CGSize(width: width, height: height)
                
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
                
                
                // Draw each icon next to each other:
                var x:CGFloat = 0.0
                for image in vehicleIcons {
                    let y = (size.height - image.size.height) / 2
                    let rect = CGRect(x: x, y: y, width: image.size.width, height: image.size.height)
                    image.draw(in: rect)
                    x += image.size.width + 5
                }
                
                // Create UIImage:
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return image!
            }
        }
        return #imageLiteral(resourceName: "icon-stop")
    }
    private static func cleanIconSetAccordingToRules(icons: [TransportMode], showAll:Bool = false) ->  [TransportMode] {
        
        var cleanSet:[TransportMode] = []
        
//        // Clean up "airport duplicates"
//        for iconType in icons {
//            var type = iconType
//            if type == VehicleMode.airportBus {
//                type = VehicleMode.bus
//            }
//            else if type == VehicleMode.airportTrain {
//                type = VehicleMode.train
//            }
//            if !cleanSet.contains(type){
//                cleanSet.append(type)
//            }
//        }
        
        // Sort the types such that we always have them in the same (and correct) order
        cleanSet.sort { (t1:TransportMode, t2:TransportMode) -> Bool in
            return self.typeOrder(type: t1) < self.typeOrder(type: t2)
        }
        
        // If bus and train, show only train
        if !showAll {
            if cleanSet.contains(TransportMode.bus) && cleanSet.contains(TransportMode.rail){
                return [.rail]
            }
        }
        
        return cleanSet
    }
    private static func typeOrder(type: TransportMode) -> Int {
        switch type {
        case .metro:
            return 1
        case .tram:
            return 2
        case .bus:
            return 3
        case .water:
            return 4
        case .rail:
            return 5
        default:
            return 0
        }
    }
}
