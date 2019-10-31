import UIKit
import StiKitUtilities
import OverlayContainer

class ContainedNavigationController: ContainedViewController {
    let underlyingNavigationController:UINavigationController
    
    init(rootViewController:UIViewController){
        underlyingNavigationController = UINavigationController(rootViewController: rootViewController)
        super.init(closeable: true)
        underlyingNavigationController.delegate = self
        preferredContainerNotch = 1
        lastContainerNotch = 1
    }
    required init?(coder: NSCoder) {fatalError()}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(underlyingNavigationController)
        let nav = underlyingNavigationController.view!
        view.insertSubview(nav, belowSubview: closeButton!)
        nav.frame = view.bounds
        nav.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        underlyingNavigationController.navigationBar.prefersLargeTitles = true
        underlyingNavigationController.didMove(toParent: self)
    }
}

extension ContainedNavigationController:UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        overlayContainer?.drivingScrollView = (viewController as? TableViewController)?.tableView ?? (viewController as? ContainedViewController)?.drivingScrollView
    }
}
