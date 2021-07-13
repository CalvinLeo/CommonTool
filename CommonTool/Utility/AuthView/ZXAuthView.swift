//
//  ZXAuthView.swift
//  验证码
//
//  Created by zx on 2021/7/12.
//

import Foundation
import UIKit
import SnapKit

typealias AuthCodeFillClosure = ((String) -> Void)

let authCodeViewHeight = 52.0
let cursorHeight = 30.0

let textColor = UIColor.black
let cursorColor = UIColor.red
let lineColorHighlight = UIColor.init(red: 33.0 / 255, green: 33.0 / 255, blue: 33.0 / 255, alpha: 1)
let lineColorNormal = UIColor.init(red: 204.0 / 255, green: 204.0 / 255, blue: 204.0 / 255, alpha: 1)
let fieldBgColor = UIColor.gray

// model
struct ZXAuthItem {
    var number: String?
    var lineHighlight: Bool! = false
    var cursorHidden: Bool! = true
}

// MARK: - AuthView
class ZXAuthView: UIView {
    
    private var itemsArray = [ZXAuthItem]()

    var codeNumbers: Int! = 4 {
        didSet {
            updateItems()
        }
    }  // 验证码个数
    
    var codeFillClosure: AuthCodeFillClosure?    // 完成输入的事件
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(textfield)
        self.addSubview(numbersView)
        
        textfield.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        numbersView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        numbersView.reloadData()
    }
    
    /// 更新items
    func updateItems() {
        itemsArray.removeAll()
        for _ in 0..<codeNumbers {
            var item = ZXAuthItem()
            item.number = ""
            item.lineHighlight = false
            itemsArray.append(item)
        }
        
        let itemWidth = (self.frame.size.width - 16 * CGFloat(codeNumbers - 1)) / CGFloat(codeNumbers)
        flowLayout.itemSize = CGSize(width: itemWidth, height: authCodeViewHeight)
        numbersView.reloadData()
    }
    
    /// addAction
    func addCodeFillClosure(closure: AuthCodeFillClosure?) {
        self.codeFillClosure = closure
    }
    
    @objc func becomeFirstRegister() {
        self.textfield.becomeFirstResponder()

        let text = textfield.text! as NSString
        
        for i in 0..<codeNumbers {
            var item = itemsArray[i]
            if i < text.length {
                item.number = text.substring(with: NSRange(location: i, length: 1))
                item.cursorHidden = true
                item.lineHighlight = true
            } else {
                item.cursorHidden = i == text.length ? false : true
                item.lineHighlight = i == text.length ? true : false
                item.number = ""
            }
            itemsArray[i] = item
        }
        numbersView.reloadData()
    }
    
    func removeFirstRegister() {
        for i in 0..<itemsArray.count {
            self.changeCursorIndex(i, isHidden: true)
            
            if i < textfield.text!.count {
                self.changeLineIndex(i, isHighlight: true)
            } else {
                self.changeLineIndex(i, isHighlight: false)
            }
        }
        
        self.layoutIfNeeded()
    }
    
    // 光标的状态
    func changeCursorIndex(_ index: Int, isHidden: Bool) {
        
        var item = itemsArray[index]
        item.cursorHidden = isHidden
        itemsArray[index] = item
        
        numbersView.reloadData()
    }
    
    // 下划线高亮状态
    func changeLineIndex(_ index: Int, isHighlight: Bool) {
        
        var item = itemsArray[index]
        item.lineHighlight = isHighlight
        itemsArray[index] = item
        
        numbersView.reloadData()
    }
    
    // MARK: - Lazy
    
    lazy var textfield: UITextField = {
        let field = UITextField()
        field.textColor = .white
        field.keyboardType = .numberPad
        field.delegate = self
        field.addTarget(self, action: #selector(textFieldValueChanged(textfield:)), for: .editingChanged)
        return field
    }()
    
    lazy var numbersView: UICollectionView = {
        
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.delegate = self
        collection.register(ZXAuthViewCell.self, forCellWithReuseIdentifier: "ZXAuthViewCell")
        collection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstRegister)))
        return collection
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
}

// MARK: -
/// TextField代理
extension ZXAuthView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn
                   range: NSRange, replacementString
                   string: String) -> Bool {
        if string == "" {
            return true
        }
        if textField.text!.count >= codeNumbers {
            return false
        }
        return true
    }
    
    ///
    @objc func textFieldValueChanged(textfield: UITextField) {
        let text = textfield.text! as NSString
        
        for i in 0..<codeNumbers {
            var item = itemsArray[i]
            if i < text.length {
                item.number = text.substring(with: NSRange(location: i, length: 1))
                item.cursorHidden = true
                item.lineHighlight = true
            } else {
                item.cursorHidden = i == text.length ? false : true
                item.lineHighlight = i == text.length ? true : false
                item.number = ""
            }
            itemsArray[i] = item
        }
        numbersView.reloadData()
        
        if text.length >= codeNumbers {
            textfield.endEditing(true)
            if self.codeFillClosure != nil {
                self.codeFillClosure!(textfield.text!)
            }
        }
    }
}

// MARK: - CollectionViewDelegate, DataSource
extension ZXAuthView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return codeNumbers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZXAuthViewCell", for: indexPath) as! ZXAuthViewCell
        
        if itemsArray.count > 0 {
            let item = itemsArray[indexPath.item]
            cell.number.text = item.number
            cell.bottomline.backgroundColor = item.lineHighlight ? lineColorHighlight : lineColorNormal
            cell.changeCursor(isHidden: item.cursorHidden)
        }
        return cell
    }
}

// CollectionCell
class ZXAuthViewCell: UICollectionViewCell {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func setupCellViews() {
        self.addSubview(number)
        number.addSubview(bottomline)
        number.addSubview(cursor)
        
        number.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomline.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(number.snp.bottom).offset(-1)
            make.height.equalTo(1)
        }
        
        let topMargin = (authCodeViewHeight - cursorHeight) * 0.5
        cursor.snp.makeConstraints { (make) in
            make.top.equalTo(topMargin)
            make.centerX.equalTo(number.snp.centerX)
            make.height.equalTo(cursorHeight)
            make.width.equalTo(1)
        }
        
        cursor.isHidden = true
    }
    
    /// cursor's state
    func changeCursor(isHidden: Bool) {
        if isHidden {
            cursor.layer.removeAnimation(forKey: "kOpacityAnimation")
        } else {
            cursor.layer.add(customAnimation(), forKey: "kOpacityAnimation")
        }
        UIView.animate(withDuration: 0.2) {
            self.cursor.isHidden = isHidden
        }
    }
    
    /// animate
    func customAnimation() -> CAAnimation {
        let opacityAnimation = CABasicAnimation.init(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 0.9
        opacityAnimation.repeatCount = HUGE
        opacityAnimation.fillMode = CAMediaTimingFillMode.forwards
        opacityAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn)
        return opacityAnimation
    }
    
    // MARK: - Lazy
    /// number
    lazy var number: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    /// line
    lazy var bottomline: UIView = {
        let view = UIView()
        view.backgroundColor = lineColorNormal
        return view
    }()
    
    /// cursor
    lazy var cursor: UIView = {
        let cursor = UIView()
        cursor.backgroundColor = cursorColor
        cursor.isHidden = true
        return cursor
    }()
}
