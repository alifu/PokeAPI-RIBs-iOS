//
//  PokemonCardCell.swift
//  PokeAPI-RIB
//
//  Created by Alif on 04/09/25.
//

import Nuke
import SnapKit
import UIKit

class PokemonCardCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = ColorUtils.background.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.background
        return view
    }()
    
    private let tagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "tag")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorUtils.grayscaleMedium
        return imageView
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.caption
        label.textColor = ColorUtils.grayscaleMedium
        label.textAlignment = .left
        return label
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "silhouette")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.body3
        label.textColor = ColorUtils.grayscaleDark
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.contentView.addSubview(containerView)
        [bottomView, pokemonImageView, nameLabel, tagImageView, tagLabel].forEach { item in
            self.containerView.addSubview(item)
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(4)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-8)
            $0.height.equalTo(12)
        }
        
        tagImageView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(4)
            $0.width.height.equalTo(12)
            $0.trailing.equalTo(tagLabel.snp.leading)
        }
        
        pokemonImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(72)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(4)
        }
    }
    
    func configContent(with data: Pokedex.Result) {
        tagLabel.text = "\(data.id ?? "")"
        nameLabel.text = data.name
        if let urlString = data.imageURL, let url = URL(string: urlString) {
            let request = ImageRequest(url: url)
            ImagePipeline.shared.loadImage(with: request) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    self.pokemonImageView.image = response.image
                case .failure(_):
                    self.pokemonImageView.image = UIImage(named: "silhouette")
                }
            }
        }
    }
}
