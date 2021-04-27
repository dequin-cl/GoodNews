//
//  AppDelegateTests.swift
//  GoodNewsRxMVVMTests
//
//  Created by Iván Galaz Jeria on 27-04-21.
//

import XCTest
@testable import GoodNewsRxMVVM

class AppDelegateTests: XCTestCase {

    func test_didFinishLaunchingWithOptions_setsWindowWithRootNavigationController() {
        let sut = AppDelegate()
        
        _ = sut.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        
        processAppearance(appearance: UINavigationBar.appearance().standardAppearance)
        processAppearance(appearance: UINavigationBar.appearance().scrollEdgeAppearance)
        processAppearance(appearance: UINavigationBar.appearance().compactAppearance)
    }

    //MARK:- Helpers
    
    func processAppearance(appearance: UINavigationBarAppearance?, file: StaticString = #filePath, line: UInt = #line) {
        guard let appearance = appearance else {
            XCTFail("Appearance should have been setted")
            return
        }
        XCTAssertEqual(appearance.backgroundColor, .orange)
        
        guard let largeTitleTextColor = appearance.largeTitleTextAttributes[NSAttributedString.Key.foregroundColor] as? UIColor else {
            XCTFail("NSAttributedString.Key.foregroundColor should be configured")
            return
        }
        
        guard let titleTextColor = appearance.titleTextAttributes[NSAttributedString.Key.foregroundColor] as? UIColor else {
            XCTFail("NSAttributedString.Key.foregroundColor should be configured")
            return
        }
        
        XCTAssertEqual(largeTitleTextColor, UIColor.white)
        XCTAssertEqual(titleTextColor, UIColor.white)
    }
}

private extension UIWindow {
    var topViewController: UIViewController? {
        (rootViewController as? UINavigationController)?.topViewController
    }
}
