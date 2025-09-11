//
//  RootViewController.swift
//  PokeAPI-RIB
//
//  Created by Alif on 03/09/25.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Method is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorUtils.primary
    }
    
    func attachPokedexView(viewController: ViewControllable?) {
        if let viewController {
            self.addChild(viewController.uiviewController)
            self.view.addSubview(viewController.uiviewController.view)
            viewController.uiviewController.didMove(toParent: self)
        }
    }
}
