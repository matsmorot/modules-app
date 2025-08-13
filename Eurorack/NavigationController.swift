//
//  NavigationController.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-08.
//

import UIKit

class NavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
    }
    
    func setupAppearance() {
            // Sets up appearance for navigation bar
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont(name: "DIN Condensed", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
            ]
            
        UINavigationBar.appearance().tintColor = UIColor.black

            // Sets up appearance for navigation bar button items
            let attrs = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont(name: "DIN Condensed", size: 16) ?? UIFont.systemFont(ofSize: 16)
            ]

            UIBarButtonItem.appearance().setTitleTextAttributes(attrs, for: UIControl.State())
            UIBarButtonItem.appearance().setTitleTextAttributes(attrs, for: .highlighted)
        }
}
