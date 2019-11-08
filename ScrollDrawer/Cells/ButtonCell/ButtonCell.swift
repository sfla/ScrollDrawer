import UIKit
import StiKitTableView
import StiKitExtensions
import StiKitUtilities

class ButtonCellViewModel:CellViewModel{
    let buttonTitle:Observable<String>
    let buttonStyle:Observable<ButtonCell.ButtonStyle>
    let buttonAction:Observable<(()->())?>
    
    init(buttonTitle:String, buttonStyle:ButtonCell.ButtonStyle = .default, buttonAction:(()->())?){
        self.buttonTitle = Observable(buttonTitle)
        self.buttonStyle = Observable(buttonStyle)
        self.buttonAction = Observable(buttonAction)
        super.init()
    }
}


class ButtonCell: TableViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    var buttonAction:(()->())?
    
    enum ButtonStyle{
        case `default`
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    @objc private func didTapButton(){
        buttonAction?()
    }
    
    override func bind(viewModel: ViewModel) {
        if let vm = viewModel as? ButtonCellViewModel{
            vm.buttonTitle.observe { [weak self] (title) in
                self?.button.setTitle(title, for: .normal)
            }.disposed(by: boundDisposeBag)
            
            vm.buttonStyle.observe { [weak self] (style) in
                self?.setButtonStyle(style: style)
            }.disposed(by: boundDisposeBag)
            
            vm.buttonAction.observe { [weak self] (action) in
                self?.buttonAction = action
            }.disposed(by: boundDisposeBag)
        }
    }
    
    private func setButtonStyle(style:ButtonStyle){
        
        let backgroundColor:UIColor
        let foregroundColor:UIColor
        
        switch style {
        case .default:
            backgroundColor = UIColor(hex: "#0A0A39")!
            foregroundColor = .white
        }
        
        button.backgroundColor = backgroundColor
        button.setTitleColor(foregroundColor, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
}
