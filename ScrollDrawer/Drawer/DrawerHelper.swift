import UIKit
import OverlayContainer

struct DrawerHelper{
    private init(){}
    static func add(contained:ContainedViewController, asDrawerIn hostingViewController:UIViewController){
        let container = OverlayContainerViewController()
        container.delegate = contained
        container.viewControllers = [PassthroughViewController(), contained]
        
        hostingViewController.addChild(container)
        hostingViewController.view.addSubview(container.view)
        container.view.translatesAutoresizingMaskIntoConstraints = false
        container.view.leadingAnchor.constraint(equalTo: hostingViewController.view.leadingAnchor).isActive = true
        container.view.trailingAnchor.constraint(equalTo: hostingViewController.view.trailingAnchor).isActive = true
        container.view.topAnchor.constraint(equalTo: hostingViewController.view.topAnchor).isActive = true
        container.view.bottomAnchor.constraint(equalTo: hostingViewController.view.bottomAnchor).isActive = true
        container.didMove(toParent: hostingViewController)
        
        container.moveOverlay(toNotchAt: -1, animated: false)
        hostingViewController.view.setNeedsLayout()
        hostingViewController.view.layoutIfNeeded()
        container.drivingScrollView = contained.drivingScrollView
    }
}
