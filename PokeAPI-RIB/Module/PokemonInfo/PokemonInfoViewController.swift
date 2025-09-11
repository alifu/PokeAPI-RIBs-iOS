//
//  PokemonInfoViewController.swift
//  PokeAPI-RIB
//
//  Created by Alif on 10/09/25.
//

import RIBs
import RxSwift
import SnapKit
import UIKit

protocol PokemonInfoPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class PokemonInfoViewController: UIViewController, PokemonInfoPresentable, PokemonInfoViewControllable {

    weak var listener: PokemonInfoPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private
    
    private let disposeBag = DisposeBag()
    
    private let chipsView: HorizontalChips = {
        let view = HorizontalChips()
        view.backgroundColor = .white
        return view
    }()
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = FontUtils.headerSubtitle1
        label.textColor = ColorUtils.wireframe
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = FontUtils.body3
        label.textColor = ColorUtils.dark
        return label
    }()
    
    private let baseStatsLabel: UILabel = {
        let label = UILabel()
        label.text = "Base Stats"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = FontUtils.headerSubtitle1
        label.textColor = ColorUtils.wireframe
        return label
    }()
    
    private let infoImageViewBuilder: (UIImage?, UIColor) -> UIImageView = { (image: UIImage?, color: UIColor) in
        let imageView = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = color
        return imageView
    }
    
    private let contentInfoLabelBuilder: (String) -> UILabel = { (text: String) in
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = FontUtils.body3
        label.textColor = ColorUtils.dark
        return label
    }
    
    private let titleInfoLabelBuilder: (String) -> UILabel = { (text: String) in
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = FontUtils.caption
        label.textColor = ColorUtils.grayscaleMedium
        return label
    }
    
    private let separatorInfoViewBuilder: () -> UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.grayscaleLight
        return view
    }
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private var weightLabel = UILabel()
    private var heightLabel = UILabel()
    private var abilitiesLabel = UILabel()
    
    private func setupView() {
        let weightImageView = infoImageViewBuilder(UIImage(named: "weight"), ColorUtils.dark)
        weightLabel = contentInfoLabelBuilder("123")
        let weightTitleLabel = titleInfoLabelBuilder("Weight")
        let heightImageView = infoImageViewBuilder(UIImage(named: "straighten"), ColorUtils.dark)
        heightLabel = contentInfoLabelBuilder("123")
        let heightTitleLabel = titleInfoLabelBuilder("Height")
        abilitiesLabel = contentInfoLabelBuilder("123")
        let abilitiesTitleLabel = titleInfoLabelBuilder("Abilities")
        let separatorOneView = separatorInfoViewBuilder()
        let separatorTwoView = separatorInfoViewBuilder()
        [
            chipsView,
            aboutLabel,
            weightImageView,
            weightLabel,
            weightTitleLabel,
            separatorOneView,
            heightImageView,
            heightLabel,
            heightTitleLabel,
            separatorTwoView,
            abilitiesLabel,
            abilitiesTitleLabel,
            descriptionLabel,
            baseStatsLabel,
            statsStackView
        ].forEach { item in
            self.view.addSubview(item)
        }
        
        chipsView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(75)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
        
        aboutLabel.snp.makeConstraints {
            $0.top.equalTo(chipsView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        separatorOneView.snp.makeConstraints {
            $0.top.equalTo(aboutLabel.snp.bottom).offset(16)
            $0.width.equalTo(1)
            $0.height.equalTo(48)
            $0.centerX.equalTo(aboutLabel.snp.centerX).offset(-51)
        }
        
        separatorTwoView.snp.makeConstraints {
            $0.top.equalTo(aboutLabel.snp.bottom).offset(16)
            $0.width.equalTo(1)
            $0.height.equalTo(48)
            $0.centerX.equalTo(aboutLabel.snp.centerX).offset(51)
        }
        
        weightTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(separatorOneView.snp.bottom)
            $0.trailing.equalTo(separatorOneView.snp.leading)
            $0.width.equalTo(103)
        }
        
        heightTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(separatorOneView.snp.trailing)
            $0.bottom.equalTo(separatorOneView.snp.bottom)
            $0.trailing.equalTo(separatorTwoView.snp.leading)
        }
        
        abilitiesTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(separatorTwoView.snp.bottom)
            $0.leading.equalTo(separatorTwoView.snp.trailing)
            $0.width.equalTo(103)
        }
        
        abilitiesLabel.snp.makeConstraints {
            $0.bottom.equalTo(abilitiesTitleLabel.snp.top).offset(-8)
            $0.centerX.equalTo(abilitiesTitleLabel.snp.centerX)
        }
        
        heightLabel.snp.makeConstraints {
            $0.bottom.equalTo(heightTitleLabel.snp.top).offset(-16)
            $0.centerX.equalTo(heightTitleLabel.snp.centerX)
        }
        
        heightImageView.snp.makeConstraints {
            $0.trailing.equalTo(heightLabel.snp.leading)
            $0.centerY.equalTo(heightLabel.snp.centerY)
            $0.height.width.equalTo(16)
        }
        
        weightLabel.snp.makeConstraints {
            $0.bottom.equalTo(weightTitleLabel.snp.top).offset(-16)
            $0.centerX.equalTo(weightTitleLabel.snp.centerX)
        }
        
        weightImageView.snp.makeConstraints {
            $0.trailing.equalTo(weightLabel.snp.leading)
            $0.centerY.equalTo(weightLabel.snp.centerY)
            $0.height.width.equalTo(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(separatorOneView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        baseStatsLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        statsStackView.snp.makeConstraints {
            $0.top.equalTo(baseStatsLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

extension PokemonInfoViewController {
   
    func loadPokemonInfo(abilities: [String], stats: [Pokemon.Stats], types: [String], height: Double, weight: Double) {
        abilitiesLabel.text = abilities.joined(separator: "\n")
        statsStackView.removeAllArrangedSubviews()
        stats.forEach { item in
            let stat = ProgressStats(
                title: item.stat.displayName(),
                stats: item.baseStat,
                themeColor: colorStringToType(types.first ?? ""))
            statsStackView.addArrangedSubview(stat)
            stat.snp.makeConstraints {
                $0.height.equalTo(16)
            }
        }
        chipsView.generateChips(with: types)
        weightLabel.text = weight.toKg
        heightLabel.text = height.toMeters
        aboutLabel.textColor = colorStringToType(types.first ?? "")
        baseStatsLabel.textColor = colorStringToType(types.first ?? "")
    }
    
    func loadPokemonDescription(_ description: String) {
        self.descriptionLabel.text = description
    }
}
