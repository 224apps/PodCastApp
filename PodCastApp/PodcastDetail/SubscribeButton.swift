//
//  SuscribeButton.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/16/21.
//

import UIKit

@IBDesignable class SubscribeButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonSetup()
    }
    
    private var borderColor: UIColor {
        return isSelected ? Theme.Colors.purpleBright : Theme.Colors.purple
    }
    private func commonSetup() {
        tintColor = Theme.Colors.purple
        layer.cornerRadius = 12
        layer.borderWidth = 3
        layer.borderColor = Theme.Colors.purple.cgColor
        layer.masksToBounds = true
        
        let highlightColor = Theme.Colors.purple.withAlphaComponent(0.85)
        setBackgroundImage(UIImage.with(color: highlightColor), for: .highlighted)
        
        let selectedColor  = Theme.Colors.purpleBright
        setBackgroundImage(UIImage.with(color: selectedColor), for: .selected)
        let bundle = Bundle(for: SubscribeButton.self)
        let icon  = UIImage(named: "icon-check", in: bundle, compatibleWith: nil)
        setImage(icon, for: .selected)
        
        imageEdgeInsets.left = -20
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 170, height: 45)
    }
}
