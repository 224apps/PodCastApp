//
//  UIImage+Color.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/16/21.
//

import UIKit

extension UIImage {
    static func with(color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
