import UIKit
import StiKitTableView
import StiKitUtilities

class PlaceAdditionalInfoCellViewModel:CellViewModel{
    
    let distanceString:Observable<String>
    let icon:UIImage?
    
    init(distanceString:String, icon:UIImage?){
        self.distanceString = Observable(distanceString)
        self.icon = icon
        super.init()
    }
}


class PlaceAdditionalInfoCell: TableViewCell {

    @IBOutlet weak var labInfo: UILabel!
    @IBOutlet weak var imgTransport: UIImageView!
    
    override func bind(viewModel: ViewModel) {
        if let vm = viewModel as? PlaceAdditionalInfoCellViewModel{
            
            self.imgTransport.image = vm.icon
            
            vm.distanceString.observe { [weak self] (distanceString) in
                self?.labInfo.text = distanceString
            }.disposed(by: boundDisposeBag)
        }
    }
    
}
