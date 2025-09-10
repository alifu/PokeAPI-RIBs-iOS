//
//  NavigationControllerViewControllable.swift
//  PokeAPI-RIB
//
//  Created by Alif Phincon on 09/09/25.
//

import RIBs
import UIKit

final class NavigationControllerViewControllable: ViewControllable {
    let uiviewController: UIViewController
    
    init(_ navController: UINavigationController) {
        navController.navigationBar.isHidden = true
        self.uiviewController = navController
    }
}

