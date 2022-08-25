//
//  CustomNavigationViewController.swift
//  Word Collector
//
//  Created by Dawid Herman on 25/08/2022.
//
//  Created following stackoverflow.com/a/62183616/4995249
//

import UIKit

protocol CustomNavigationViewControllerDelegate {
    func shouldPop() -> Bool
}

class CustomNavigationViewController: UINavigationController, UINavigationBarDelegate {

    var backDelegate: CustomNavigationViewControllerDelegate?

    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        return backDelegate?.shouldPop() ?? true
    }
}
