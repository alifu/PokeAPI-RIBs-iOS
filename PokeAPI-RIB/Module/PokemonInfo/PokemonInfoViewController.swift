//
//  PokemonInfoViewController.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 10/09/25.
//

import RIBs
import RxSwift
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
        
    }
}
