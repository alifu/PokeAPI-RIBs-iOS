//
//  PokemonViewController.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 09/09/25.
//

import RIBs
import RxSwift
import SnapKit
import UIKit

protocol PokemonPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func goback()
}

final class PokemonViewController: UIViewController, PokemonPresentable, PokemonViewControllable {

    weak var listener: PokemonPresentableListener?
    
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "arrow_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = ColorUtils.white
        return button
    }()
    
    private let tagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "tag")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorUtils.white
        return imageView
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.headerSubtitle2
        label.textColor = ColorUtils.white
        label.textAlignment = .left
        label.text = "0"
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.headerHeadline
        label.textColor = ColorUtils.white
        label.textAlignment = .left
        label.text = "Pokémon Name"
        return label
    }()
    
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "pokeball")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorUtils.white.withAlphaComponent(0.1)
        return imageView
    }()
    
    private let bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private func setupViews() {
        self.view.backgroundColor = ColorUtils.wireframe
        [pokeImageView, infoView, headerView, bannerView].forEach { item in
            self.view.addSubview(item)
        }
        [backButton, nameLabel, tagImageView, tagLabel].forEach { item in
            headerView.addSubview(item)
        }
        
        pokeImageView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(208)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(pokeImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(75)
        }
        
        bannerView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(infoView.snp.top)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(headerView.snp.centerY)
            $0.leading.equalTo(headerView.snp.leading).offset(16)
            $0.width.height.equalTo(32)
        }
        
        tagLabel.snp.makeConstraints {
            $0.centerY.equalTo(headerView.snp.centerY)
            $0.trailing.equalTo(headerView.snp.trailing).offset(-16)
        }
        
        tagImageView.snp.makeConstraints {
            $0.centerY.equalTo(tagLabel.snp.centerY)
            $0.trailing.equalTo(tagLabel.snp.leading).offset(0)
            $0.width.height.equalTo(16)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.width.greaterThanOrEqualTo(10)
            $0.trailing.equalTo(tagImageView.snp.leading).offset(-8)
        }
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
                self.listener?.goback()
            })
            .disposed(by: disposeBag)
    }
}

extension PokemonViewController {
    
    func attachPokemonBannerView(viewController: ViewControllable?) {
        if let viewController {
            self.addChild(viewController.uiviewController)
            self.bannerView.addSubview(viewController.uiviewController.view)
            viewController.uiviewController.view.translatesAutoresizingMaskIntoConstraints = false
            viewController.uiviewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            viewController.uiviewController.didMove(toParent: self)
        }
    }
    
    func attachPokemonInfoView(viewController: ViewControllable?) {
        if let viewController {
            self.addChild(viewController.uiviewController)
            self.infoView.addSubview(viewController.uiviewController.view)
            viewController.uiviewController.view.translatesAutoresizingMaskIntoConstraints = false
            viewController.uiviewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            viewController.uiviewController.didMove(toParent: self)
        }
    }
    
    func loading(_ isLoading: Observable<Bool>) {
        isLoading
            .bind(to: self.view.rx.hudVisible)
            .disposed(by: disposeBag)
    }
    
    func changeHeader(with data: Observable<Pokedex.Result?>) {
        data
            .subscribe { [weak self] result in
                guard let `self` = self else { return }
                self.nameLabel.text = result.element??.name.capitalized
                self.tagLabel.text = result.element??.id
            }
            .disposed(by: disposeBag)
    }
    
    func changeBackground(with data: Observable<[String]>) {
        data
            .subscribe { [weak self] types in
                guard let `self` = self else { return }
                self.view.backgroundColor = colorStringToType(types.first ?? "")
            }
            .disposed(by: disposeBag)
    }
}
