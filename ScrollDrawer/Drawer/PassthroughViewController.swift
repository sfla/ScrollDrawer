import UIKit
import OverlayContainer

class PassthroughViewController:UIViewController{
    override func loadView() {
        view = PassThroughView()
    }
}
