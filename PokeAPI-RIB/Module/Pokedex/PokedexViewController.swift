//
//  PokedexViewController.swift
//  PokeAPI-RIB
//
//  Created by Alif on 03/09/25.
//

import RIBs
import RxCocoa
import RxSwift
import SnapKit
import UIKit

protocol PokedexPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didUpdateSearchQuery(_ query: String)
    func didClearSearch()
}

final class PokedexViewController: UIViewController, PokedexPresentable, PokedexViewControllable {

    weak var listener: PokedexPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Method is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorUtils.primary
        self.setupHeader()
    }
    
    // MARK: Private
    
    private let disposeBag = DisposeBag()
    
    private let imageHeader: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "pokeball")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()
    
    private let labelHeader: UILabel = {
        let label = UILabel()
        label.font = FontUtils.headerHeadline
        label.textColor = .white
        label.textAlignment = .left
        label.text = "Pokédex"
        return label
    }()
    
    private let searchBox: SearchBox = {
        let searchBox = SearchBox()
        searchBox.translatesAutoresizingMaskIntoConstraints = false
        return searchBox
    }()
    
    private let sortButton: SortButton = {
        let sortButton = SortButton()
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        return sortButton
    }()
    
    private let container: UIView = {
        let container: UIView = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        return container
    }()
    
    private func setupHeader() {
        [imageHeader, labelHeader, searchBox, sortButton, container].forEach { item in
            self.view.addSubview(item)
        }
        
        imageHeader.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.layoutFrame.minX + 16)
            make.width.height.equalTo(32)
        }
        
        labelHeader.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(imageHeader.snp.trailing).offset(8)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.layoutFrame.maxX - 16)
            make.centerY.equalTo(imageHeader.snp.centerY)
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(imageHeader.snp.bottom).offset(8)
            make.width.height.equalTo(32)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        searchBox.snp.makeConstraints { make in
            make.top.equalTo(imageHeader.snp.bottom).offset(8)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(sortButton.snp.leading).offset(-8)
            make.height.equalTo(32)
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(searchBox.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        
        searchBox.textChanged
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [weak self] query in
                guard let `self` = self else { return }
                self.listener?.didUpdateSearchQuery(query ?? "")
            }
            .disposed(by: disposeBag)
        
        searchBox.clearTapped
            .bind { [weak self] in
                guard let `self` = self else { return }
                self.searchBox.clearText()
                self.listener?.didClearSearch()
            }
            .disposed(by: disposeBag)
    }
}

extension PokedexViewController {
    
    func loading(_ isLoading: Observable<Bool>) {
        isLoading
            .bind(to: self.view.rx.hudVisible)
            .disposed(by: disposeBag)
    }
    
    func attachPokedexListView(viewController: ViewControllable?) {
        if let viewController {
            self.addChild(viewController.uiviewController)
            self.container.addSubview(viewController.uiviewController.view)
            viewController.uiviewController.view.translatesAutoresizingMaskIntoConstraints = false
            viewController.uiviewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            viewController.uiviewController.didMove(toParent: self)
        }
    }
    
    func openPokemonPage(viewController: (any ViewControllable)?) {
        if let viewController {
            self.navigationController?.pushViewController(viewController.uiviewController, animated: true)
        }
    }
}
