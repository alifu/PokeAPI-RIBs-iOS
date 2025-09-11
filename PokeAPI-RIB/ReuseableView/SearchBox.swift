//
//  SearchBox.swift
//  PokeAPI-RIB
//
//  Created by Alif on 04/09/25.
//

import SnapKit
import RxCocoa
import RxSwift
import UIKit

class SearchBox: UIView {
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let searchField: UITextField = {
        let searchBar = UITextField()
        searchBar.borderStyle = .none
        searchBar.placeholder = "Search"
        searchBar.font = FontUtils.body3
        searchBar.textColor = ColorUtils.grayscaleMedium
        return searchBar
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorUtils.primary
        return imageView
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
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
        [searchIcon, searchField, clearButton].forEach {
            self.container.addSubview($0)
        }
        
        container.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        searchIcon.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        
        clearButton.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        
        searchField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(searchIcon.snp.trailing).offset(8)
            $0.trailing.equalTo(clearButton.snp.leading).offset(-8)
        }
    }
    
    var textChanged: Observable<String?> {
        searchField.rx.text.asObservable()
    }
    
    var clearTapped: Observable<Void> {
        clearButton.rx.tap.asObservable()
    }
    
    func clearText() {
        searchField.text = ""
    }
}
