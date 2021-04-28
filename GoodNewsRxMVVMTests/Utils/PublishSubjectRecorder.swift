//
//  PublishSubjectRecorder.swift
//  GoodNewsRxMVVMTests
//
//  Created by Iván Galaz Jeria on 28-04-21.
//

import Foundation
import RxSwift

class PublishSubjectRecorder<T> {
    var items = [T]()
    let bag = DisposeBag()

    func on(arraySubject: PublishSubject<[T]>) {
        arraySubject.subscribe(onNext: { value in
            self.items = value
        }).disposed(by: bag)
    }

    func on(valueSubject: PublishSubject<T>) {
        valueSubject.subscribe(onNext: { value in
            self.items.append(value)
        }).disposed(by: bag)
    }
}
