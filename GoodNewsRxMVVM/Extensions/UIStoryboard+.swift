//
//  UIStoryboard+.swift
//  GoodNewsRxMVVM
//
//  Created by Iván Galaz Jeria on 27-04-21.
//

import UIKit

extension UIStoryboard {
    var instance: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(function: String = #function,
                                             line: Int = #line,
                                             file: String = #file) -> T {
        
        let storyboardID = "\(T.self)"

        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in Main Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }

        return scene
    }
}

