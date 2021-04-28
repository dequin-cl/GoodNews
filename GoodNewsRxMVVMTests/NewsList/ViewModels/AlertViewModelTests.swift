//
//  AlertViewModelTests.swift
//  GoodNewsRxMVVMTests
//
//  Created by Iván Galaz Jeria on 27-04-21.
//

import XCTest
@testable import GoodNewsRxMVVM
import RxSwift

class AlertViewModelTests: XCTestCase {

    func test_AlertViewModel_Show_Creates_AlertModel() throws {
        let expectation = self.expectation(description: #function)
        let recorder = PublishSubjectRecorder<AlertModel>()
        let viewModel = AlertViewModel()
        recorder.on(valueSubject: viewModel.alertModel)
        viewModel.showOkAlert(message: "Test")

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(recorder.items.count, 1)
        XCTAssertEqual(recorder.items.first?.message, "Test")
    }
}
