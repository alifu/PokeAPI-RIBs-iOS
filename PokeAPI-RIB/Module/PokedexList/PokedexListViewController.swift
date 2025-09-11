//
//  PokedexListViewController.swift
//  PokeAPI-RIB
//
//  Created by Alif on 04/09/25.
//

import RIBs
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit

protocol PokedexListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didLoadMore()
    func selectedPokedex(at index: Int, data: Pokedex.Result)
}

final class PokedexListViewController: UIViewController, PokedexListPresentable, PokedexListViewControllable {
    
    weak var listener: PokedexListPresentableListener?
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfPokedex>(
        configureCell: { _, collectionView, indexPath, item in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PokemonCardCell {
                cell.configContent(with: item)
                return cell
            }
            return UICollectionViewCell()
        }
    )
    
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
    
    func bindPokedexList(_ pokedexList: Observable<[Pokedex.Result]>) {
        pokedexList
            .map { [SectionOfPokedex(header: "pokedex", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: Private
    
    private let disposeBag = DisposeBag()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 104, height: 108)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCardCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private func setupView() {
        self.view.backgroundColor = ColorUtils.white
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        collectionView.rx.contentOffset
            .observe(on: MainScheduler.instance)
            .flatMapLatest { [weak self] offset -> Observable<Void> in
                guard let `self` = self else { return .empty() }
                
                let visibleHeight = self.collectionView.frame.height
                let contentHeight = self.collectionView.contentSize.height
                let yOffset = offset.y
                let threshold = max(0.0, contentHeight - visibleHeight - 100)
                
                if yOffset > threshold {
                    return Observable.just(())
                }
                
                return Observable.empty()
            }
        //            .withLatestFrom(isSearching)
        //            .filter { !$0 }
            .map { _ in () }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.listener?.didLoadMore()
            })
            .disposed(by: disposeBag)
        
        Observable.zip(
            collectionView.rx.itemSelected,
            collectionView.rx.modelSelected(Pokedex.Result.self)
        )
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] indexPath, selectedPokemon in
            guard let `self` = self else { return }
            self.listener?.selectedPokedex(at: indexPath.item, data: selectedPokemon)
        })
        .disposed(by: disposeBag)
    }
}
