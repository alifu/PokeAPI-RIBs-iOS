//
//  ProgressStats.swift
//  PokeAPI-RIB
//
//  Created by Alif on 11/09/25.
//

import SnapKit
import UIKit

final class ProgressStats: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.headerSubtitle3
        label.textColor = ColorUtils.wireframe
        label.textAlignment = .right
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.grayscaleLight
        return view
    }()
    
    private let statslabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.body3
        label.textColor = ColorUtils.dark
        label.textAlignment = .right
        return label
    }()
    
    private let expectedProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.wireframe
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let actualProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.wireframe
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .clear
        return progressView
    }()
    
    private let title: String
    private let stats: Int
    private let themeColor: UIColor
    private var fillWidthConstraint: Constraint?
    
    init(title: String, stats: Int, themeColor: UIColor) {
        self.title = title
        self.stats = stats
        self.themeColor = themeColor
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [titleLabel, dividerView, statslabel, progressView].forEach { item in
            self.addSubview(item)
        }
//        expectedProgressView.addSubview(actualProgressView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.leading.equalTo(self.snp.leading)
            $0.width.equalTo(32)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.width.equalTo(1)
        }
        
        statslabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.leading.equalTo(dividerView.snp.trailing).offset(8)
            $0.width.equalTo(25)
        }
        
        progressView.snp.makeConstraints {
            $0.leading.equalTo(statslabel.snp.trailing).offset(8)
            $0.trailing.equalTo(self.snp.trailing)
            $0.centerY.equalTo(statslabel.snp.centerY)
            $0.height.equalTo(4)
        }
        
        titleLabel.text = title
        statslabel.text = "\(stats)"
        titleLabel.textColor = themeColor
        progressView.trackTintColor = themeColor.withAlphaComponent(0.2)
        progressView.progressTintColor = themeColor
        progressView.progress = Float(CGFloat(stats)/100)
    }
    
    private func setProgress(_ progress: CGFloat, animated: Bool = true) {
        let clamped = max(0, min(progress, 1))
        fillWidthConstraint?.deactivate()
        
        actualProgressView.snp.updateConstraints { make in
            fillWidthConstraint = make.width.equalToSuperview().multipliedBy(clamped).constraint
        }
        
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
    }
}
