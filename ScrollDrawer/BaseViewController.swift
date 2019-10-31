import UIKit
import StiKitUtilities

class BaseViewController: UIViewController {

    let lifetimeDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
