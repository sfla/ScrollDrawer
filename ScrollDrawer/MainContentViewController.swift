import UIKit
import OverlayContainer
import StiKitTableView

class MainContentViewController: ContainedTableViewController {
    
    var welcomeHeader:WelcomeHeaderViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContainerNotch = 1
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        effectView.frame = view.bounds
        view.insertSubview(effectView, at: 0)
        effectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.backgroundColor = .clear
        
        setupBaseContent()
        setDummySections()
    }
    
    private func setupBaseContent(){
        welcomeHeader = WelcomeHeaderViewModel(title: "Velkommen, Stian", buttonText: "Din konto") {
            print("Did account!")
        }
        let topSection = Section(headerViewModel: welcomeHeader, viewModels: [])
        self.tableView.updateData(sections: [topSection])
    }
    
    private func setDummySections(){
        let header = UnderlinedHeaderViewModel(title: "Your tickets", badge: "1")
        let section = Section(headerViewModel: header, viewModels: [])
        setContent(sections: [section])
    }
    
    private func welcomeSection()->Section{
        return Section(headerViewModel: welcomeHeader, viewModels: [])
    }
    
    private func setContent(sections:[Section]){
        var sec = sections
        sec.insert(welcomeSection(), at: 0)
        tableView.updateData(sections: sec)
    }
    
    
}
