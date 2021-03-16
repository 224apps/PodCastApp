//
//  GradientView.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/16/21.
//

import UIKit

@IBDesignable class GradientBackgroundView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonSetup()
    }
    
    private func commonSetup(){
        backgroundColor = .clear
        isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return  }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [ UIColor.clear.cgColor, Theme.Colors.gray5.cgColor ] as CFArray
        let locations : [CGFloat] = [ 0.0 , 0.25]
        guard let gradient =  CGGradient(colorsSpace: colorSpace,colors: colors, locations: locations) else {
            UIColor.red.setFill()
            context.fill(rect)
            return
        }
        
        let start = CGPoint(x: 0, y: 0)
        let end  = CGPoint(x: 0, y: rect.height)
        context.drawLinearGradient(gradient, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation ])
        
    }
    
    
}
