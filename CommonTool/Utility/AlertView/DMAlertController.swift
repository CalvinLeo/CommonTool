//
//  DMAlertController.swift
//  QdamaECMall
//
//  Created by Calvin Gao on 2021/5/31.
//  Copyright © 2021 Qdama. All rights reserved.
//

import UIKit

// MARK: - 布局变量
let kContentPaddingTopBottom    = CGFloat(8~)      // 内容区上下padding
let kContentPaddingLeftRight    = CGFloat(24.0)      // 内容区左右padding

var kDMAlertViewPaddingLeftRight = CGFloat(32.0~)      // 内容区左右边距
var kDMAlertViewWidth   = CGFloat(SystemDesign.screenWidth - kDMAlertViewPaddingLeftRight * 2) // 视图容器宽度
let kDMAlertContentViewWidth     = CGFloat(kDMAlertViewWidth - kContentPaddingLeftRight * 2)     // 内容宽度
let kDMAlertContentMaxHeight    = CGFloat(244~)      // 内容最大高度 （定高）

/// .alert
let kDefaultHeaderViewPaddingTop = CGFloat(24~)     // header距离顶部高度
let kDefaultHeaderViewHeight    = CGFloat(24~)      // header高度
let kDefaultFooterViewHeight    = CGFloat(48~)      // footer高度
let kDefaultContentPaddingTop   = CGFloat(8~)       // 内容区距离header底边的paddingTop
let kDefaultContentPaddingBottom = CGFloat(19~)     // 内容区距离footer上边的paddingBottom
let kDefaultHeaderIconWidth     = CGFloat(62~)      // 头部icon宽度
let kkDefaultHeaderIconHeight   = CGFloat(62~)      // 头部icon高度

/// .active
let kActiveHeaderPaddingTop     = CGFloat(24~)      // header距离头部高度
let kActiveHeaderViewHeight     = CGFloat(24~)      // header高度
let kActiveFooterViewHeight     = CGFloat(60~)      // footer高度
let kActiveHeaderIconWidth      = CGFloat(120~)     // icon宽度
let kActiveHeaderIconHeight     = CGFloat(120~)     // icon高度
let kActiveIconPaddingTop       = CGFloat(25~)      // icon距离上边距
let kActiveIconPaddingBottom    = CGFloat(15~)      // icon距离下边距
let kActiveContentPaddingTop    = CGFloat(8~)       // 内容距离上边距
let kActiveContentPaddingBottom = CGFloat(4~)       // 内容距离下边距
let kActiveButtonHeight         = CGFloat(36.0~)    // 按钮高度
let kActiveButtonMargin         = CGFloat(8.0~)     // 按钮间间距
/// . tips
let kTipsHeaderViewHeight       = CGFloat(48~)      // header高度
let kTipsCloseButtonHeight      = CGFloat(25~)      // 关闭按钮尺寸

extension DMAlertController {
    // 枚举
    enum DMAlertControllerStyle {
        case alert          // 警告框
        case tips           // 提示框
        case active         // 运营框
    }
}

class DMAlertController: UIViewController {
    
    // MARK: - 私有属性
    private var _contentView: UIView?                // 内容视图
    private var _contentHeight: CGFloat?             // 内容高度
    private var _message: String?                    // 消息
    private var _textAlignment: NSTextAlignment! = .center
    
    private var mutableActions: [DMAlertAction] = []  // 按钮数组
    
    // 对外属性
    var alertStyle = DMAlertControllerStyle.alert
    var icon: UIImage?
    
    // MARK: - Init
    init(title: String?, message: String?, style: DMAlertControllerStyle) {
        super.init(nibName: nil, bundle: nil)
        
        self.headerText = title
        self.message = message
        self.alertStyle = style
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    func initSubViews() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(alertView)
//        self.view.addSubview(iconView)
        self.view.addSubview(closeButton)
        self.alertView.addSubview(headerLabel)
        self.alertView.addSubview(bodyView)
        self.alertView.addSubview(footerView)
        
        updateViewConstraints()
    }
    
    // 添加按钮
    func addActions(action: DMAlertAction) {
        mutableActions.append(action)
    }
    
    func makeButtons() {
        for subs in footerView.subviews {
            subs.removeFromSuperview()
        }
        
        let isActive = self.alertStyle == .active
        
        let count = self.mutableActions.count
        let buttonCount = max(count, 1)
        
        var buttonWidth: CGFloat = 0.0
        var buttonHeight: CGFloat = 0.0
        var offsetTop: CGFloat = 0.0
        var offsetLeft: CGFloat = 0.0
        
        if isActive {
            offsetLeft = 10
            buttonWidth = kDMAlertContentViewWidth
            buttonHeight = kActiveButtonHeight
            offsetTop = 8
        } else {
            buttonWidth = kDMAlertViewWidth / CGFloat(buttonCount)
            buttonHeight = kDefaultFooterViewHeight
        }
        
        if count > 0 {
            var lastBtn: UIButton?
            for index in 0..<mutableActions.count {
                let action = mutableActions[index] as DMAlertAction
                let button = UIButton()
                button.tag = 1000 + index
                button.setTitle(action.title, for: .normal)
                button.setTitle(action.title, for: .highlighted)
                button.setTitleColor(action.titleColor, for: .normal)
                button.setTitleColor(action.titleColor, for: .highlighted)
                button.backgroundColor = action.bgColor
                button.titleLabel?.font = FontDesign.r14
                button.addTarget(self, action: #selector(footerButtonClick(sender:)), for: .touchUpInside)
                button.layer.cornerRadius = isActive ? kActiveButtonHeight * 0.5 : 0
                self.footerView.addSubview(button)
                
                if isActive {
                    button.snp.makeConstraints { make in
                        make.top.equalTo((lastBtn == nil) ? self.footerView : lastBtn!.snp.bottom).offset(offsetTop)
                        make.left.equalTo(self.footerView.snp.left).offset(kContentPaddingLeftRight)
                        make.right.equalTo(self.footerView.snp.right).offset(-kContentPaddingLeftRight)
                        make.size.equalTo(CGSize(width: buttonWidth, height: buttonHeight))
                    }
                } else {
                    let leftMargin = lastBtn == nil ? offsetLeft : offsetLeft * 2
                    button.snp.makeConstraints { (make) in
                        make.top.equalTo(self.footerView.snp.top).offset(offsetTop)
                        make.left.equalTo((lastBtn == nil) ? self.footerView : lastBtn!.snp.right).offset(leftMargin)
                        make.size.equalTo(CGSize(width: buttonWidth, height: buttonHeight))
                    }
                    
                    let line = UIView()
                    line.backgroundColor = .lineColor
                    button.addSubview(line)
                    line.snp.makeConstraints { make in
                        make.top.equalToSuperview()
                        make.right.equalTo(-0.5)
                        make.width.equalTo(0.5)
                        make.height.equalTo(buttonHeight)
                    }
                }
                
                lastBtn = button
            }
        } else {
            let button = UIButton()
            button.setTitle("确定", for: .normal)
            button.setTitle("确定", for: .highlighted)
            button.titleLabel?.font = FontDesign.r14
            
            var textColor: UIColor
            if (isActive) {
                textColor = .white
                button.layer.borderWidth = 0.5
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.cornerRadius = buttonHeight / 2
                button.backgroundColor = .mainRedColor
                button.clipsToBounds = true
            } else {
                textColor = .mainRedColor
            }
            
            button.setTitleColor(textColor, for: .normal)
            button.setTitleColor(textColor, for: .highlighted)
            button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
            
            self.footerView.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.top.equalTo(self.footerView).offset(offsetTop)
                make.left.equalTo(self.footerView).offset(offsetLeft)
                make.size.equalTo(CGSize(width: buttonWidth, height: buttonHeight))
            }
        }
    }
    
    // MARK: - Action
    @objc func footerButtonClick(sender: UIButton) {
        let action = self.mutableActions[sender.tag - 1000]
        
        if action.dismiss == true {
            self.dismiss(animated: true) {
                if (action.handler != nil) {
                    action.handler!()
                }
            }
        } else {
            if (action.handler != nil) {
                action.handler!()
            }
        }
    }
    
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    override func updateViewConstraints() {
        
        let emptyTitle = self.headerText?.isEmpty ?? true
        let existIcon = self.icon?.isKind(of: UIImage.self) ?? false
        
        var headerHeight: CGFloat = 0.0              // 标题高度
        var headerTopMargin: CGFloat = 0.0           // 标题距离顶部
        var bodyTop = kContentPaddingTopBottom       // 内容视图距离header距离
        var bodyBottom = kContentPaddingTopBottom    // 内容视图距离footer距离
        var alertViewOffset: CGFloat = 0.0
        var iconOffsetTop: CGFloat = 0.0
        var iconSize = CGSize.zero                   // 图片大小
        let maxContentHeight = contentMaxHeight(height: _contentHeight ?? 30)   // 内容高度
        var footerHeight: CGFloat = 0.0              // footer高度
        var alertViewHeight: CGFloat = 0.0           // 提示框高度
        
        if self.alertStyle == .tips {
            
            headerHeight = kTipsCloseButtonHeight
            footerHeight = 0
            
            self.footerView.isHidden = true
            self.iconView.isHidden = true
            self.closeButton.isHidden = false
            self.headerLabel.isHidden = false
            self.headerLabel.backgroundColor = UIColor(hex: 0xf0f0f0)
            self.headerLabel.textColor = .mainRedColor
            
            alertViewHeight = maxContentHeight + kContentPaddingTopBottom * 2 + headerHeight + footerHeight
            
//        } else if (self.alertStyle == .active && existIcon) { // MMAlertControllerStyleActive必须提供图片,否则当MMAlertControllerStyleDefault处理
        } else if (self.alertStyle == .active) {
            
            footerHeight = CGFloat(self.mutableActions.count) * kActiveButtonHeight + CGFloat(self.mutableActions.count + 1) * kActiveButtonMargin
            bodyBottom = kActiveContentPaddingBottom
            iconOffsetTop = (kActiveIconPaddingTop + kActiveHeaderIconHeight)
            iconSize = CGSize(width: kActiveHeaderIconWidth, height: kActiveHeaderIconHeight)
            headerTopMargin = kActiveHeaderPaddingTop
            self.iconView.image = self.icon
            
            var contentTop: CGFloat = 0.0
            if !emptyTitle {
                headerHeight = kActiveHeaderViewHeight
                bodyTop = kActiveContentPaddingTop
                contentTop = kActiveContentPaddingTop
                
                self.headerLabel.isHidden = false
                self.headerLabel.backgroundColor = .white
                self.headerLabel.textColor = .black21
            } else {
                bodyTop = 0
                self.headerLabel.isHidden = true
            }
            
            self.footerView.isHidden = false
            self.iconView.isHidden = !existIcon
            self.closeButton.isHidden = true
            
            alertViewHeight = headerTopMargin + headerHeight + contentTop + maxContentHeight + kActiveContentPaddingBottom + footerHeight + kActiveButtonMargin
            
        } else {
            
            footerHeight = kDefaultFooterViewHeight
            bodyBottom = kDefaultContentPaddingBottom
            
            if !emptyTitle {
                headerHeight = kDefaultHeaderViewHeight
                headerTopMargin = kDefaultHeaderViewPaddingTop
                bodyTop = kDefaultContentPaddingTop
                
                self.headerLabel.isHidden = false
                self.headerLabel.backgroundColor = .white
                self.headerLabel.textColor = .black21
                
                alertViewHeight = headerTopMargin + headerHeight + maxContentHeight + bodyTop + bodyBottom + footerHeight
                
            } else {
                self.headerLabel.isHidden = true
            }
            
            self.footerView.isHidden = false
            self.footerView.layer.borderWidth = 0.5
            self.footerView.layer.borderColor = UIColor.lineColor.cgColor
            self.iconView.isHidden = true
            self.closeButton.isHidden = true
        }
        
        self.bodyView.contentSize = CGSize(width: kDMAlertContentViewWidth, height: _contentHeight!)
        if self.alertStyle == .tips {
            alertViewOffset = -(SystemDesign.screenHeight + alertViewHeight) / 2;
        }
                
        self.alertView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(alertViewOffset)
            make.size.equalTo(CGSize(width: kDMAlertViewWidth, height: alertViewHeight))
        }
        
        self.headerLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self.alertView.snp.top).offset(headerTopMargin)
            make.left.equalTo(self.alertView.snp.left)
            make.right.equalTo(self.alertView.snp.right)
            make.height.equalTo(headerHeight)
        }
        
        self.footerView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.alertView.snp.left).offset(-0.5)
            make.bottom.equalTo(self.alertView.snp.bottom).offset(0.5)
            make.right.equalTo(self.alertView.snp.right).offset(0.5)
            make.height.equalTo(footerHeight)
        }
        
        self.bodyView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.headerLabel.snp.bottom).offset(bodyTop)
            make.left.equalTo(self.alertView.snp.left).offset(kContentPaddingLeftRight)
            make.right.equalTo(self.alertView.snp.right).offset(-kContentPaddingLeftRight)
            make.bottom.equalTo(self.footerView.snp.top).offset(-bodyBottom)
        }
        
//        self.iconView.snp.remakeConstraints { (make) in
//            make.bottom.equalTo(self.alertView.snp.top).offset(iconOffsetTop)
//            make.centerX.equalTo(self.alertView)
//            make.size.equalTo(iconSize)
//        }
        
        self.closeButton.snp.remakeConstraints { (make) in
            make.top.equalTo(self.alertView.snp.top).offset(-7)
            make.right.equalTo(self.alertView.snp.right).offset(3)
            make.size.equalTo(CGSize(width: kTipsCloseButtonHeight, height: kTipsCloseButtonHeight))
        }
        
        if self.alertStyle != .tips {
            makeButtons()
        }
        
        super.updateViewConstraints()
    }
    
    
    /// 内容区高度最大值
    /// - Parameter height: 文本高
    /// - Returns: 高度
    private func contentMaxHeight(height: CGFloat) -> CGFloat {
        let emptyTitle = self.headerText?.isEmpty ?? true       // 是否没有标题
        var maxHeight = kDMAlertContentMaxHeight                // 内容最大高度
        
        if self.alertStyle == .alert {
            maxHeight -= CGFloat(kContentPaddingTopBottom * 2)
            maxHeight -= CGFloat(kDefaultFooterViewHeight)
            
            if !emptyTitle {
                maxHeight -= CGFloat(kDefaultHeaderViewHeight + kDefaultContentPaddingTop)
            }
        }
        return min(height, maxHeight)
    }
    
    // MARK: - Property
    var headerText: String? {
        get { return self.headerLabel.text }
        set {
            self.headerLabel.text = newValue
        }
    }
    
    /// 消息
    var message: String? {
        get { return _message }
        set {
            if newValue != nil {
                // 赋值
                _message = newValue
                
                // 文本格式
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .byWordWrapping
                paragraphStyle.lineSpacing = 3~
                
                let font = FontDesign.r14
                let attributeStr = NSMutableAttributedString(string: _message!)
                let attributeDict = [NSAttributedString.Key.font : font,
                                     NSAttributedString.Key.paragraphStyle : paragraphStyle]
                
                attributeStr.addAttributes(attributeDict, range: NSRange(location: 0, length: _message!.count))
                
                // 高度计算
                let text = _message! as NSString
                let rect = text.boundingRect(with: CGSize(width: kDMAlertContentViewWidth,
                                                          height: CGFloat.greatestFiniteMagnitude),
                                             options: .usesLineFragmentOrigin,
                                             attributes: attributeDict,
                                             context: nil)
                let contentLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kDMAlertContentViewWidth, height: rect.height))
                
                contentLabel.attributedText = attributeStr
                contentLabel.font = font
                contentLabel.numberOfLines = 0
                contentLabel.textColor = .black98
                contentLabel.textAlignment = self.textAlignment
                self.contentView = contentLabel
            }
        }
    }
    
    /// 对其方式
    var textAlignment: NSTextAlignment {
        get { return _textAlignment }
        set {
            _textAlignment = newValue
            if let label = self.contentView as? UILabel {
                label.textAlignment = _textAlignment
            }
        }
    }
    
    /// 内容视图
    var contentView: UIView? {
        get {return _contentView}
        set {
            guard newValue != nil else {
                return
            }
            _contentView = newValue
            _contentHeight = (_contentView?.frame.size.height)!
            self.bodyView.addSubview(_contentView!)
        }
    }
    
    // MARK: - Lazy
    lazy var alertView: UIView = {
        let alertView = UIView()
        alertView.backgroundColor = .white
        alertView.clipsToBounds = true
        alertView.layer.cornerRadius = 15
        return alertView
    }()
    
    lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = FontDesign.r18
        headerLabel.textAlignment = .center
        headerLabel.isHidden = true
        return headerLabel
    }()
    
    lazy var bodyView: UIScrollView = {
        let body = UIScrollView()
        body.clipsToBounds = true
        body.showsVerticalScrollIndicator = false
        return body
    }()
    
    lazy var footerView: UIView = {
        let footerView = UIView()
//        footerView.layer.borderWidth = 0.5
//        footerView.layer.borderColor = UIColor.lineColor.cgColor
        footerView.isHidden = true
        return footerView
    }()
    
    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        return iconView
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        return closeButton
    }()
}

// MARK: - DMAlertController 专场动画拓展
extension DMAlertController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DMAlertAnimationController(type: .presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DMAlertAnimationController(type: .dismissing)
    }
}
