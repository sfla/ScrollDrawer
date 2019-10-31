import UIKit
import OverlayContainer
import StiKitUtilities

protocol Contained{
    var preferredContainerNotch:Int {get set}
    var lastContainerNotch:Int {get set}
    var currentDrawerHeight:Observable<CGFloat> {get}
    var animateAlongsideDrawer:((OverlayContainerTransitionCoordinatorContext)->())? {get set}
    var containedDelegate:ContainedDelegate? {get set}
    var drivingScrollView:UIScrollView? {get set}

    //Has defaults
    var overlayContainer:OverlayContainerViewController? { get }
    func showDrawer(animated:Bool)
    func hideDrawer(animated:Bool)
    func closeDrawer(animated:Bool)
    func removeDrawer()
}
func == (lhs: Contained?, rhs: Contained?)->Bool{
    return lhs?.overlayContainer == rhs?.overlayContainer && rhs?.overlayContainer != nil
}
extension Contained{
    var overlayContainer:OverlayContainerViewController? { get {
    return (self as? UIViewController)?.parent as? OverlayContainerViewController
    }}
    
    func showDrawer(animated:Bool){
        let containerNotch = lastContainerNotch >= 0 ? lastContainerNotch : preferredContainerNotch
        overlayContainer?.moveOverlay(toNotchAt: containerNotch, animated: animated)
    }
    func hideDrawer(animated:Bool){
        overlayContainer?.moveOverlay(toNotchAt: -1, animated: animated)
    }
    func closeDrawer(animated:Bool){
        overlayContainer?.moveOverlay(toNotchAt: -1, animated: animated, completion: {
            self.removeDrawer()
        })
    }
    func removeDrawer(){
        let overlay = self.overlayContainer
        overlay?.removeFromParent()
        if let vcs = overlay?.viewControllers{
            vcs.forEach({$0.removeFromParent()})
        }
        overlay?.drivingScrollView = nil
        overlay?.view.removeFromSuperview()
        (self as? UIViewController)?.view.removeFromSuperview()
        overlay?.viewControllers.removeAll()
        overlay?.delegate = nil
        (self as? UIViewController)?.removeFromParent()
    }
}

protocol ContainedDelegate{
    func containedViewControllerClose(containedViewController:Contained)
}

class ContainedViewController:BaseViewController, Contained{
    
    var drivingScrollView: UIScrollView? = nil
    var preferredContainerNotch:Int = 0
    var lastContainerNotch:Int = -1
    var currentDrawerHeight = Observable(CGFloat(0))
    var animateAlongsideDrawer:((OverlayContainerTransitionCoordinatorContext)->())?
    let closeable:Bool
    var closeButton:UIButton?
    
    var containedDelegate:ContainedDelegate?
    
    init(closeable:Bool){
        self.closeable = closeable
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) {fatalError()}
    
    var overlayContainer:OverlayContainerViewController? { get {
        return self.parent as? OverlayContainerViewController
        }}
    
    override func loadView() {
        view = CorneredShadowView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        if closeable{
            addCloseableButton()
        }
    }
    
    func addCloseableButton(){
        closeButton = UIButton(frame: .zero)
        closeButton!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton!)
        closeButton!.setImage(UIImage(named: "close"), for: .normal)
        closeButton!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        closeButton!.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        closeButton!.widthAnchor.constraint(equalToConstant: 28).isActive = true
        closeButton!.heightAnchor.constraint(equalToConstant: 28).isActive = true
        closeButton!.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    @objc func close(){
        containedDelegate?.containedViewControllerClose(containedViewController: self)
    }
    
    deinit {
        print("Deinit contained")
    }
}

extension ContainedViewController:OverlayContainerViewControllerDelegate{

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, didMoveOverlay overlayViewController: UIViewController, toNotchAt index: Int) {
        if index >= 0{
            lastContainerNotch = index
        }
    }
    
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        return 3
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        heightForNotchAt index: Int,
                                        availableSpace: CGFloat) -> CGFloat {
        if index == 0{
            return 150
        }else if index == 1{
            return availableSpace / 2
        }else if index == 2{
            return availableSpace - 60
        }else{
            return 0
        }
    }
    
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, willTranslateOverlay overlayViewController: UIViewController, transitionCoordinator: OverlayContainerTransitionCoordinator) {
        if transitionCoordinator.isAnimated{
            transitionCoordinator.animate(alongsideTransition: { (context) in
                self.animateAlongsideDrawer?(context)
            }) { (context) in
                
            }
        }else{
            self.currentDrawerHeight.value = transitionCoordinator.overlayTranslationHeight
        }
    }
}
