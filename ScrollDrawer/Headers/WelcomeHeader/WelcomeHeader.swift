import UIKit
import StiKitTableView
import StiKitUtilities

class WelcomeHeaderViewModel:HeaderViewModel{
    let title:Observable<String>
    let buttonText:Observable<String>
    let buttonAction:Observable<(()->())>
    
    init(title:String, buttonText:String, buttonAction:@escaping(()->())){
        self.title = Observable(title)
        self.buttonText = Observable(buttonText)
        self.buttonAction = Observable(buttonAction)
        super.init()
    }
    
}

class WelcomeHeader: TableViewHeaderFooterView {
    @IBOutlet weak var labWelcome: UILabel!
    @IBOutlet weak var btnAccount: UIButton!
    
    var buttonAction:(()->())? = nil
    
    @IBAction func tapButton(_ sender: Any) {
        buttonAction?()
    }
    
    override func bind(viewModel: ViewModel) {
        if let vm = viewModel as? WelcomeHeaderViewModel{
            vm.title.observe { [weak self] (title) in
                self?.labWelcome.text = title
            }.disposed(by: boundDisposeBag)
            vm.buttonText.observe { [weak self] (buttonText) in
                self?.btnAccount.setTitle(buttonText, for: .normal)
            }.disposed(by: boundDisposeBag)
            
            vm.buttonAction.observe { [weak self](action) in
                self?.buttonAction = action
            }.disposed(by: boundDisposeBag)
        }
    }
    
}
