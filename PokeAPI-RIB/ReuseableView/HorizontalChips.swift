//
//  HorizontalChips.swift
//  PokeAPI-RIB
//
//  Created by Alif on 10/09/25.
//

import SnapKit
import UIKit

final class HorizontalChips: UIView {
    
    private let chipLabelBuilder: (UIColor, String) -> UILabel = { (color: UIColor, text: String) in
        let label = UILabel()
        label.font = FontUtils.headerSubtitle3
        label.textColor = .white
        label.backgroundColor = color
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "    \(text.capitalized)    "
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.trailing.equalTo(self.snp.trailing)
            $0.leading.equalTo(self.snp.leading)
            $0.height.equalTo(20)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.greaterThanOrEqualTo(scrollView.snp.leading)
            $0.centerY.equalTo(scrollView.snp.centerY)
            $0.centerX.equalTo(scrollView.snp.centerX)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.height.equalTo(scrollView.snp.height)
        }
    }
    
    func generateChips(with chips: [String]) {
        stackView.removeAllArrangedSubviews()
        for chip in chips {
            let chipLabel = chipLabelBuilder(colorStringToType(chip), chip)
            stackView.addArrangedSubview(chipLabel)
        }
    }
}
