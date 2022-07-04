//
//  UIViewExtension.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 26.06.2022.
//

import UIKit

extension UIView {
    @discardableResult func topAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, priority: ConstaintPriority = .high) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority =  UILayoutPriority(priority.rawValue)
        constraint.isActive = true
        return self
    }
    
    @discardableResult func bottomAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, priority: ConstaintPriority = .high) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority =  UILayoutPriority(priority.rawValue)
        constraint.isActive = true
        return self
    }
    
    @discardableResult func leadingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, priority: ConstaintPriority = .high) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
         let constraint = leadingAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority =  UILayoutPriority(priority.rawValue)
        constraint.isActive = true
        return self
    }
    
    @discardableResult func trailingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, priority: ConstaintPriority = .high) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
         let constraint = trailingAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority =  UILayoutPriority(priority.rawValue)
        constraint.isActive = true
        return self
    }
    
    @discardableResult func trailingAnchor(lessThanOrEqualTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, priority: ConstaintPriority = .high) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
        constraint.priority =  UILayoutPriority(priority.rawValue)
        constraint.isActive = true
        return self
    }
    
    @discardableResult func heightAnchor(equalTo height: CGFloat, priority: ConstaintPriority = .high) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.priority =  UILayoutPriority(priority.rawValue)
        constraint.isActive = true
        return self
    }
    
    @discardableResult func heightAnchor(equalTo anchor: NSLayoutDimension, constant: CGFloat = 0, priority: ConstaintPriority = .high) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority =  UILayoutPriority(priority.rawValue)
        constraint.isActive = true
        return self
    }
    
    @discardableResult func widthAnchor(equalTo width: CGFloat, priority: ConstaintPriority = .high) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.priority =  UILayoutPriority(priority.rawValue)
        constraint.isActive = true
        return self
    }
    
    @discardableResult func centerXAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func centerYAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}

enum ConstaintPriority: Float {
    case high = 1000
    case medium = 755
    case low = 255
}
