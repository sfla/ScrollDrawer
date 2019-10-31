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
        self.tableView.updateData(sections: [Section(headerViewModel: WelcomeHeaderViewModel(title: place.properties?.name ?? "", buttonText: "Departures", buttonAction: {
            print("Whatever")
        }), viewModels: [])])
    }
}
