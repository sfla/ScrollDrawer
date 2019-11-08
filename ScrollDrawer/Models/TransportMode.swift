import UIKit
import StiKitExtensions

enum TransportMode{
    case bus, water, lift, rail, metro, tram, air, cableway, funicular, unknown
}

extension Sequence where Iterator.Element == TransportMode{
    func icon(tint:UIColor)->UIImage{
        return TransportMode.icon(for: (self as! [TransportMode]), with: tint)
    }
}

extension TransportMode{
    func icon(tint:UIColor, large:Bool = false)->UIImage{
        let image:UIImage
        switch self {
        case .bus: image = #imageLiteral(resourceName: "icon-bus")
        case .water: image = #imageLiteral(resourceName: "icon-boat")
        case .tram: image = #imageLiteral(resourceName: "icon-tram")
        case .rail: image = #imageLiteral(resourceName: "icon-train")
        case .metro: image = #imageLiteral(resourceName: "icon-tbane")
            /*
        case .lift: return nil
        case .funicular: return nil
        case .cableway: return nil
        case .unknown: return nil
        case .air: return nil*/
        default: image = #imageLiteral(resourceName: "icon-stop")
        }
        return image.imageWithColor(tint)
    }
    func defaultColor()->UIColor{
        let color:UIColor?
        switch self {
        case .bus: color = UIColor(hex: "E60000")
        case .water: color = UIColor(hex: "682C88")
        case .tram: color = UIColor(hex: "0B91EF")
        case .rail: color = UIColor(hex: "003087")
        case .metro: color = UIColor(hex: "EC700C")
        default:
            color = UIColor(hex: "757575")
        }
        return color ?? .gray
    }
    func plattformText()->String{
        switch self {
        case .rail, .metro: return "TRACK"//.localized
        default:
            return "PLATFORM"//.localized
        }
    }
    
    static func icon(for transportModes:[TransportMode]?, with tint:UIColor, large:Bool = false)->UIImage{
        guard let modes = transportModes else { return UIImage() }
        let orderedModes = ordered(modes: modes)
        if(orderedModes.count > 0) {
            if orderedModes.count == 1 {
                return orderedModes.first!.icon(tint: tint, large: large)
            }
            else {
                // Get all UIImages:
                let icons = Array(orderedModes).map({$0.icon(tint:tint)}).filter({$0.size.width > 0})
                
                // Get combined width:
                let paddingWidth = (5.0 * (CGFloat(icons.count) - 1))
                let width = icons.reduce(0, {$0 + $1.size.width}) + paddingWidth
                
                // Get highest height:
                let height = icons.reduce(0, {$1.size.height > $0 ? $1.size.height : $0})
                
                // Start graphics context:
                let size = CGSize(width: width, height: height)
                
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
                
                
                // Draw each icon next to each other:
                var x:CGFloat = 0.0
                for image in icons {
                    let y = (size.height - image.size.height) / 2
                    let rect = CGRect(x: x, y: y, width: image.size.width, height: image.size.height)
                    image.draw(in: rect)
                    x += image.size.width + 5
                }
                
                // Create UIImage:
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return image ?? #imageLiteral(resourceName: "icon-stop")
            }
        }
        return #imageLiteral(resourceName: "icon-stop")
    }
    
    static func ordered(modes: [TransportMode]) ->  [TransportMode] {
        
        var filteredModes:[TransportMode] = []
        modes.forEach({if !filteredModes.contains($0){filteredModes.append($0)}})
        
        // Sort the types such that we always have them in the same (and correct) order
        filteredModes.sort { (t1:TransportMode, t2:TransportMode) -> Bool in
            return self.modeOrder(mode: t1) < self.modeOrder(mode: t2)
        }
        
        return filteredModes
    }
    private static func modeOrder(mode: TransportMode) -> Int {
        switch mode {
        case .metro: return 1
        case .tram: return 2
        case.bus: return 3
        case .water: return 4
        case .rail: return 5
        case .air: return 6
        case .cableway: return 7
        case .funicular: return 8
        case .lift: return 9
        default:
            return 10
        }
    }
    
}
