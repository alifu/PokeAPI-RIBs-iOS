//
//  UIStackView+Extension.swift
//  PokeAPI-RIB
//
//  Created by Alif on 11/09/25.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { allSubviews, subview -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        removedSubviews.forEach { $0.removeFromSuperview() }
    }
}
