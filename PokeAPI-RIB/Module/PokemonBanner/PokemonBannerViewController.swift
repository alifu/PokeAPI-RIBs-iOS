//
//  PokemonBannerViewController.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 10/09/25.
//

import Nuke
import RIBs
import RxSwift
import SnapKit
import UIKit

protocol PokemonBannerPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func previousButtonTapped()
    func nextButtonTapped()
}

final class PokemonBannerViewController: UIViewController, PokemonBannerPresentable, PokemonBannerViewControllable {

    weak var listener: PokemonBannerPresentableListener?
    
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
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "silhouette")
        return imageView
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "chevron_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "chevron_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private func setupView() {
        [previousButton, pokemonImageView, nextButton].forEach { item in
            self.view.addSubview(item)
        }
        
        pokemonImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.height.equalTo(200)
            $0.centerX.equalTo(self.view.snp.centerX)
        }
        
        previousButton.snp.makeConstraints {
            $0.trailing.equalTo(pokemonImageView.snp.leading).offset(-16)
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(pokemonImageView.snp.centerY)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.equalTo(pokemonImageView.snp.trailing).offset(16)
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(pokemonImageView.snp.centerY)
        }
        
        previousButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.listener?.previousButtonTapped()
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.listener?.nextButtonTapped()
            })
            .disposed(by: disposeBag)
    }
}

extension PokemonBannerViewController {
    
    func loadPokemonImage(with urlString: String?) {
        if let urlString, let url = URL(string: urlString) {
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
