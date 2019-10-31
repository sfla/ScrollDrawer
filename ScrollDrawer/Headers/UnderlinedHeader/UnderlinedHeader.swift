import UIKit
import StiKitTableView
import StiKitUtilities

class UnderlinedHeaderViewModel:HeaderViewModel{
    let title:Observable<String>
    let badge:Observable<String?>
    
    init(title:String, badge:String? = nil){
        self.title = Observable(title)
        self.badge = Observable(badge)
        super.init()
    }
}

class UnderlinedHeader: TableViewHeaderFooterView {
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labBadge: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labBadge.backgroundColor = UIColor(hex: "#DFE2E5")
        labBadge.clipsToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if labBadge != nil{
            labBadge.layer.cornerRadius = labBadge.bounds.size.height/2
        }
    }
    
    override func bind(viewModel: ViewModel) {
        if let vm = viewModel as? UnderlinedHeaderViewModel{
            vm.title.observe { [weak self] (title) in
                self?.labTitle.text = title
            }.disposed(by: boundDisposeBag)
            
            vm.badge.observe { [weak self] (badge) in
                self?.labBadge.isHighlighted = badge == nil
                self?.labBadge.text = badge
            }.disposed(by: boundDisposeBag)
        }
    }
}
