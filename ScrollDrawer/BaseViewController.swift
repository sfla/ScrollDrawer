import UIKit
import StiKitUtilities

class BaseViewController: UIViewController {

    var lifetimeDisposeBag:DisposeBag! = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
