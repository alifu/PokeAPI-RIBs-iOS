//
//  SortButton.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 04/09/25.
//

import SnapKit
import UIKit

class SortButton: UIView {
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let sortButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "sort")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = ColorUtils.primary
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        self.addSubview(container)
        self.container.addSubview(sortButton)
        
        container.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.width.equalTo(32)
        }
        
        sortButton.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
}
