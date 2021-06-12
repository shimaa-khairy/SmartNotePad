//
//  Extensions.swift
//  E7gzly
//
//  Created by shimaa khairy on 2/17/19.
//  Copyright © 2019 EPLHouse. All rights reserved.
//

import Foundation
import UIKit
import DGActivityIndicatorView
var loadingView = DGActivityIndicatorView.init(type: .ballClipRotate , tintColor: .gray , size: 40)
let frameSize: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width/2,y: UIScreen.main.bounds.size.height/2)
extension NSLayoutConstraint {
    override public var description: String {
        let id = identifier ?? "NO ID"
        return "id: \(id), constant: \(constant)"
    }
}
extension UIView
{
    func showLoader() -> Void {
        loadingView?.center = frameSize
        self.addSubview(loadingView!)
        loadingView?.startAnimating()
    }

    func hideLoader () -> Void {
        loadingView?.stopAnimating()
    }

    
    func setBottomBorder(borderColor: UIColor) -> Void {
        
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        
    }
    
    func setBorderToView(cornerValue: CGFloat , borderColor : UIColor) -> Void {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerValue
        self.clipsToBounds = true
    }
    
    func setCircleBorderView(borderColor : UIColor) -> Void {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
    func addTapGesture(target: Any , action : Selector) {
        
        let tap = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        
    }
    
    static func createInstance<T: UIView>(ofType type: T.Type) -> T {
        let className = NSStringFromClass(type).components(separatedBy: ".").last
        return Bundle.main.loadNibNamed(className!, owner: self, options: nil)![0] as! T
    }
    
    func hideViewWithAnimation(objectView: UIView){
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseOut,
                       animations: {
                        objectView.alpha = 0
        }, completion: { finished in
            objectView.isHidden = true
        })
    }
    func showViewWithAnimation(objectView: UIView){
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseIn,
                       animations: {
                        objectView.alpha = 1
        }, completion: { finished in
            objectView.isHidden = false
        })
    }
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
private var kAssociationKeyMaxLength: Int = 0

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
extension UITextField
{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    
    func setPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
//    func setTextDirection(){
//        if Language.language == .arabic {
//            self.textAlignment = .right
//        }else {
//            self.textAlignment = .left
//        }
//    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    @IBInspectable var paddingValue: CGFloat{
        //var insets: UIEdgeInsets {
        get{
            return 5.5
        }
        set {
            //  self. = UIEdgeInsets(top: 0, left: newValue, bottom: 0, right: newValue)
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue , height: self.frame.height))
            self.leftView = paddingView
            self.rightView = paddingView
            self.leftViewMode = .always
            //paddingValue = newValue
        }
    }
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
}


extension UIColor
{
    func greenColor() -> UIColor {
        return UIColor (red: 148/255, green: 174/255, blue: 54/255, alpha: 1)
    }
    //Marwa from Aya's color code:
    func lightGreen()-> UIColor{
        return UIColor (red: 178/255, green: 210/255, blue: 53/255, alpha: 1)
    }
    func darkGreen()-> UIColor{
        return UIColor (red: 115/255, green: 139/255, blue: 54/255, alpha: 1)
    }
    func mainGreenColor()-> UIColor{
        return UIColor(red: 1/255, green: 154/255, blue: 150/255, alpha: 1)
    }
    
}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}


//extension UIApplication
//{
//    class func topViewController(_ base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController?
//    {
//        if let nav = base as? UINavigationController
//        {
//            return topViewController(nav.visibleViewController)
//        }
//        if let tab = base as? UITabBarController
//        {
//            if let selected = tab.selectedViewController
//            {
//                return topViewController(selected)
//            }
//        }
//        if let presented = base?.presentedViewController
//        {
//            return topViewController(presented)
//        }
//        return base
//    }
//}

extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}


extension String
{
    func stringByAppendingPathComponent(_ path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func trimmedText()->String
    {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
    func isValidLibyaPhoneNumber() -> Bool {
        let phoneRegEX = "^(?=(?:[9]){1})(?=[0-9]{8}).*"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEX)
        return phoneTest.evaluate(with:self)
    }
    
    func isValidEmail() -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func strikeThroughText()->NSMutableAttributedString{
    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    var capitalizeFirst: String
    {
        if isEmpty { return "" }
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).uppercased())
        return result
    }
    func toDouble() -> Double? {
           return NumberFormatter().number(from: self)?.doubleValue
       }
}


extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

extension Array  {
    var indexedDictionary: [Int: Element] {
        var result: [Int: Element] = [:]
        enumerated().forEach({ result[$0.offset] = $0.element })
        return result
    }
}

@IBDesignable extension UIView {
    @IBInspectable
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}
extension UITextView: UITextViewDelegate {
    @IBInspectable var pholderLangKey: String? {
        get { return nil }
        set(key) {
            self.placeholder = key
        }
    }
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
//    func setTextDirection(){
//        if Language.language == .arabic {
//            self.textAlignment = .right
//        }else {
//            self.textAlignment = .left
//        }
//    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}
extension UICollectionView {
    func setEmptyView(message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            messageLabel.text = message
            messageLabel.textColor = .darkGray
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "beINBlack", size: 17)
            messageLabel.sizeToFit()
            self.backgroundView = messageLabel
        }
    func restore() {
        self.backgroundView = nil
    }
}
extension UITableView {

    func setEmptyMessage(message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "beINBlack", size: 17)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
