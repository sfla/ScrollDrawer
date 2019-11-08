import UIKit
import StiKitTableView

class PlaceCellViewModel:CellViewModel{
    
    let place:EnturSearchPlace
    
    init(place:EnturSearchPlace){
        self.place = place
        super.init()
    }
}

class PlaceCell: TableViewCell {
    
    @IBOutlet weak var labPlaceName: UILabel!
    @IBOutlet weak var labCounty: UILabel!
    
    
    override func bind(viewModel: ViewModel) {
        if let vm = viewModel as? PlaceCellViewModel{
            labPlaceName.text = vm.place.properties?.name
            labCounty.text = vm.place.properties?.county
        }
    }
    
}
