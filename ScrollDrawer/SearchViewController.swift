import UIKit
import OverlayContainer
import StiKitTableView
import StiKitUtilities
import CoreLocation


protocol SearchViewDelegate{
    func searchWillShow(search:SearchViewController)
    func searchDidShow(search:SearchViewController)
    func searchWillHide(search:SearchViewController)
    func searchDidHide(search:SearchViewController)
    func searchTextChanged(search:SearchViewController, searchText:String)
    func search(search:SearchViewController, didSelect cellViewModel:CellViewModel)
}
extension SearchViewDelegate{
    func searchWillShow(search:SearchViewController){}
    func searchDidShow(search:SearchViewController){}
    func searchWillHide(search:SearchViewController){}
    func searchDidHide(search:SearchViewController){}
}

class SearchField:UITextField{
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.x -= 10
        return rect
    }
}

class SearchViewController: UIViewController {

    
    private let searchField = SearchField(frame: .zero)
    private var leadingConstraint:NSLayoutConstraint!
    private var backButtonHiddenTrailingConstraint:NSLayoutConstraint!
    
    private var topBackground = UIView(frame: .zero)
    
    private static let searchLeadingBackHiddenPriority = UILayoutPriority(902)
    private static let searchLeadingBackVisiblePriority = UILayoutPriority(900)
    
    private let tableView = TableView()
    
    var searchDelegate:SearchViewDelegate?
    
    private var debounce:Debounce!
    private var dataTask:URLSessionTask?
    
    override func loadView() {
        view = PassThroughView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debounce = Debounce(delay: 0.2, callback: { [weak self] in
            self?.enturSearch(text: self?.searchField.text ?? "")
        })
        
        setupTopBackground()
        setupSearchField()
        setupBackButton()
        setupTableView()
    }
    
    private func setupTopBackground(){
        view.addSubview(topBackground)
        topBackground.translatesAutoresizingMaskIntoConstraints = false
        topBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topBackground.backgroundColor = .clear
    }
    private func setupSearchField(){
        searchField.borderStyle = .none
        searchField.translatesAutoresizingMaskIntoConstraints = false
        topBackground.addSubview(searchField)
        leadingConstraint = searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        leadingConstraint.priority = SearchViewController.searchLeadingBackHiddenPriority
        leadingConstraint.isActive = true
        searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        searchField.bottomAnchor.constraint(equalTo: topBackground.bottomAnchor, constant: -16).isActive = true
        searchField.clearButtonMode = .always
        
        searchField.backgroundColor = .white
        searchField.layer.cornerRadius = 8
        searchField.layer.borderColor = UIColor(hex: "#E2E2E5")?.cgColor
        searchField.layer.borderWidth = 1/UIScreen.main.scale
        
        searchField.placeholder = "Search..."
        searchField.autocorrectionType = .no
        
        searchField.font = UIFont.systemFont(ofSize: 20)
        searchField.leftViewMode = .always
        let iv = UIImageView(image: UIImage(named: "search"))
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: 52).isActive = true
        searchField.leftView = iv
        searchField.delegate = self
        searchField.layoutMargins.right = 50
        searchField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    @objc private func searchTextChanged(){
        searchDelegate?.searchTextChanged(search: self, searchText: searchField.text ?? "")
        
        if (searchField.text?.isEmpty ?? true){
            debounce.timer?.invalidate()
            showResults(places: [])
        }else{
            debounce.call()
        }
    }


    private func setupBackButton(){
        let backButton = UIButton(frame: .zero)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        topBackground.addSubview(backButton)
        backButton.heightAnchor.constraint(equalTo: searchField.heightAnchor).isActive = true
        backButton.widthAnchor.constraint(equalTo: searchField.heightAnchor).isActive = true
        let trailingShown = backButton.trailingAnchor.constraint(equalTo: searchField.leadingAnchor)
        trailingShown.priority = UILayoutPriority(901)
        trailingShown.isActive = true
        backButtonHiddenTrailingConstraint = backButton.trailingAnchor.constraint(equalTo: topBackground.leadingAnchor)
        backButtonHiddenTrailingConstraint.priority = SearchViewController.searchLeadingBackHiddenPriority
        backButtonHiddenTrailingConstraint.isActive = true
        backButton.topAnchor.constraint(equalTo: searchField.topAnchor).isActive = true
        backButton.setImage(UIImage(named: "chevron-left"), for: .normal)
        let leading = backButton.leadingAnchor.constraint(equalTo: topBackground.leadingAnchor)
        leading.priority = UILayoutPriority(901)
        leading.isActive = true
        backButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
    }
    @objc private func didTapCancel(){
        hideSearch(animated: true)
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topBackground.bottomAnchor).isActive = true
        tableView.keyboardDismissMode = .onDrag
        tableView.alpha = 0.0
    }

    func showSearch(animated:Bool){
        if !searchField.isFirstResponder{
            searchField.becomeFirstResponder()
        }
        searchDelegate?.searchWillShow(search: self)
        leadingConstraint.priority = SearchViewController.searchLeadingBackVisiblePriority
        backButtonHiddenTrailingConstraint.priority = SearchViewController.searchLeadingBackVisiblePriority
        commitLayoutChanges(animated: animated, show: true)
    }
    func hideSearch(animated:Bool){
        searchDelegate?.searchWillHide(search: self)
        leadingConstraint.priority = SearchViewController.searchLeadingBackHiddenPriority
        backButtonHiddenTrailingConstraint.priority = SearchViewController.searchLeadingBackHiddenPriority
        searchField.resignFirstResponder()
        commitLayoutChanges(animated: animated, show: false)
        searchField.text = ""
    }
    
    private func commitLayoutChanges(animated:Bool, show:Bool){
        UIView.animate(withDuration: animated ? 0.3 : 0.0, delay: 0.0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.5, options: .curveEaseInOut, animations: { [weak self] in
            self?.topBackground.backgroundColor = show ? .white : .clear
            self?.searchField.backgroundColor = show ? UIColor(hex: "#F3F3F3") : .white
            self?.tableView.alpha = show ? 1.0 : 0.0
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] (completed) in
            guard let strongSelf = self else { return }
            if show{
                self?.searchDelegate?.searchDidShow(search: strongSelf)
            }else{
                self?.searchDelegate?.searchDidHide(search: strongSelf)
            }
        })
    }
    
    private func enturSearch(text:String){
        if text.count < 2{
            showResults(places: [])
            return
        }
        dataTask?.cancel()
        dataTask = EnturAPI.shared.searchForPlaces(with: text, with: CLLocation(latitude: 59.91, longitude: 10.75), completion: { [weak self] (data) in
            DispatchQueue.main.async {
                self?.showResults(places: data.features ?? [])
            }
        }, failure: { [weak self] () in
            DispatchQueue.main.async {
                self?.showResults(places: [])
            }
        })
    }
    private func showResults(places:[EnturSearchPlace]){
        var vms:[CellViewModel] = []
        for place in places{
            let vm = PlaceCellViewModel(place: place)
            vms.append(vm)
        }
        
        let sec = Section(headerViewModel: SpaceHeader(0), viewModels: vms, footerViewModel: SpaceHeader(0)) { [weak self] (sec, row) in
            guard let strongSelf = self else { return }
            self?.searchDelegate?.search(search: strongSelf, didSelect: sec.viewModels[row])
            self?.enturSearch(text: "")
        }
        
        self.tableView.updateData(sections: [sec])
    }
}

extension SearchViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showSearch(animated: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
