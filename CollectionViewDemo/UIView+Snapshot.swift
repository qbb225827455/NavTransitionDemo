//
//  UIView+Snapshot.swift
//  CollectionViewDemo
//
//  Created by 陳鈺翔 on 2022/8/16.
//

import UIKit

extension UIView {
    
    var snapshot: UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
        return image
    }
}
