import UIKit
import OverlayContainer
import MapKit
import StiKitTableView

class MainViewController: MapViewController {
    
    //The content of the main drawer
    private lazy var mainContent = MainContentViewController(closeable: false)
    
    private lazy var searchViewController = SearchViewController()
    
    private var containedViewControllers:[ContainedViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchViewController()
        
        DrawerHelper.add(contained: mainContent, asDrawerIn: self)
        mainContent.showDrawer(animated: true)
        updateMapWithContainedDrawerHeight(contained: mainContent)
    }
    
    private func updateMapWithContainedDrawerHeight(contained:ContainedViewController){
        contained.currentDrawerHeight.observe { [weak self] (height) in
            if (self?.containedViewControllers.last ?? self?.mainContent) == contained{
                self?.updateMapPadding(edgeInsets: self?.mapPadding(for: height) ?? .zero)
            }
        }.disposed(by: lifetimeDisposeBag)
        
        contained.animateAlongsideDrawer = { [weak self] (context) in
            if (self?.containedViewControllers.last ?? self?.mainContent) == contained{
                self?.updateMapPadding(edgeInsets: self?.mapPadding(for: context.targetTranslationHeight) ?? .zero)
            }
        }
    }
    private func updateMapPadding(edgeInsets:UIEdgeInsets){
        mapView.layoutMargins = edgeInsets
        
    }
    
    private func setupSearchViewController(){
        addChild(searchViewController)
        searchViewController.searchDelegate = self
        if let v = searchViewController.view{
            view.addSubview(v)
            v.frame = view.bounds
            v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        searchViewController.didMove(toParent: self)
    }
    
    private func show(contained:ContainedViewController){
        let drawerToHide = containedViewControllers.last ?? mainContent
        drawerToHide.hideDrawer(animated: true)
        containedViewControllers.append(contained)
        if contained.overlayContainer == nil{
            DrawerHelper.add(contained: contained, asDrawerIn: self)
        }
        contained.showDrawer(animated: true)
    }
    private func close(containedViewController:ContainedViewController){
        if containedViewControllers.last == containedViewController{
            containedViewControllers.removeLast()
            containedViewController.closeDrawer(animated: true)
            let drawerToShow = containedViewControllers.last ?? mainContent
            drawerToShow.showDrawer(animated: true)
        }
    }
    
    private func showStopPlace(place:EnturSearchPlace){
        
        let vc = StopPlaceViewController(place: place)
        let nav = ContainedNavigationController(rootViewController: vc)
        nav.containedDelegate = self
        show(contained: nav)
        updateMapWithContainedDrawerHeight(contained: nav)
        
        if let c = place.coordinates(){
            let anno = PlaceAnnotation(place: place)
            anno.title = place.properties?.name
            anno.coordinate = c
            mapView.addAnnotation(anno)
            mapView.showAnnotations([anno], animated: true)
        }
    }
    
    private func mapPadding(for drawerHeight:CGFloat)->UIEdgeInsets{
        if drawerHeight < view.bounds.size.height/2{
            return UIEdgeInsets(top: 0, left: 0, bottom: drawerHeight - view.safeAreaInsets.bottom, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: (view.bounds.size.height/2) - view.safeAreaInsets.bottom, right: 0)
        }
    }
    
    
    
    //MARK: - Map Delegate
    class PlaceAnnotation:MKPointAnnotation{
        let place:EnturSearchPlace
        init(place:EnturSearchPlace){
            self.place = place
            super.init()
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if !containedViewControllers.isEmpty { return }
        if let anno = view.annotation as? PlaceAnnotation{
            showStopPlace(place: anno.place)
        }
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let last = containedViewControllers.last{
            close(containedViewController: last)
        }
    }
}

extension MainViewController:SearchViewDelegate{
    func searchWillShow(search: SearchViewController) {
        view.addSubview(search.view)
    }
    func searchDidHide(search: SearchViewController) {
        view.insertSubview(search.view, aboveSubview: mapView)
    }
    func searchTextChanged(search: SearchViewController, searchText: String) {
        
    }
    func search(search: SearchViewController, didSelect cellViewModel: CellViewModel) {
        if let place = (cellViewModel as? PlaceCellViewModel)?.place{
            search.hideSearch(animated: true)
            showStopPlace(place: place)
        }
    }
}

extension MainViewController:ContainedDelegate{
    func containedViewControllerClose(containedViewController: ContainedViewController) {
        close(containedViewController: containedViewController)
    }
}
