//
//  ViewController.swift
//  TwoWayBindingSwift
//
//  Created by Amit Chakradhari on 21/12/18.
//

import UIKit
struct User {
    var name: Observable<String>
}
class ViewController: UIViewController {

    @IBOutlet weak var userName: BoundTextField!
    var user = User(name: Observable("Paul Hudson"))
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userName.bind(to: user.name)
    }


}
class Observable<ObservedType>{
    fileprivate var _value: ObservedType?
    var valueChanged: ((ObservedType?) -> ())?
    public var value: ObservedType?{
        get{
            return _value
        }
        set{
            _value = newValue
            valueChanged?(_value)
        }
    }
    init(_ value: ObservedType){
        _value = value
    }
    func bindingChanged(to newValue: ObservedType){
        _value = newValue
        print("Value is now \(newValue)")
    }
}
class BoundTextField: UITextField{
    var changedClosure: (() -> ())?
    @objc func valueChanged(){
        changedClosure?()
    }
    func bind(to observable: Observable<String>){
        addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        changedClosure = { [weak self] in
            observable.bindingChanged(to: self?.text ?? "")
        }
        observable.valueChanged = { [weak self] newValue in
            self?.text = newValue
        }
    }
}
