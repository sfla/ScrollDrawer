import UIKit
import StiKitTableView

class StopPlaceViewController: TableViewController {

    let place:EnturSearchPlace
    
    init(place:EnturSearchPlace){
        self.place = place
        super.init(nibName: nil, bundle: nil)
        self.title = place.properties?.name
    }
    required init?(coder: NSCoder) {fatalError()}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlaceContent()
    }
    
    private func setupPlaceContent(){
        
        let image = place.transportModes().icon(tint: .gray)
        let additionalInfoVM = PlaceAdditionalInfoCellViewModel(distanceString: "90m", icon: image)
        let travelHereButtonVM = ButtonCellViewModel(buttonTitle: "Travel here") { [weak self] in
            self?.didTapSomething()
        }
        self.tableView.updateData(sections: [Section(viewModels: [additionalInfoVM, travelHereButtonVM])])
    }
    
    private func didTapSomething(){
        let sp = StopPlaceViewController(place: place)
        self.navigationController?.pushViewController(sp, animated: true)
    }
    
    deinit {
        print("Deinit stopPlaceDrawerContent")
    }
}
