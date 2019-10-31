import UIKit

class CorneredShadowView:UIView{
    
    private let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit(){
        
        backgroundColor = .clear
        
        //Corners
        contentView.frame = bounds
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //Shadow
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 10.0
    }
    override func addSubview(_ view: UIView) {
        if subviews.contains(contentView){
            contentView.addSubview(view)
        }else{
            super.addSubview(view)
        }
    }
    override func insertSubview(_ view: UIView, at index: Int) {
        contentView.insertSubview(view, at: index)
    }
    override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        contentView.insertSubview(view, aboveSubview: siblingSubview)
    }
    override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        contentView.insertSubview(view, belowSubview: siblingSubview)
    }
}
