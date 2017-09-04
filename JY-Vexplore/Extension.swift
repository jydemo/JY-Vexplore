//
//  Extension.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import SharedKit

extension UIColor {
    class var offWhite: UIColor { return .colorWithWhite(0xf8) }
    class var middlegray: UIColor { return .colorWithWhite(0x66)}
    class var borderGray: UIColor { return .colorWithWhite(0xCD) }
    fileprivate class func colorWithWhite(_ white: UInt) -> UIColor {
        return UIColor(white: CGFloat(white) / 255.0, alpha: 1.0)
    }
    fileprivate static let normalPalette = [
        "#FFFFFF", // background
        "#F8F8F8", // subBackground
        "#CDCDCD", // border
        "#999999", // note
        "#666666", // desc
        "#333333", // body
        "#C56FD5", // highlight
        "#00314F", // href
        "#FFFFF8"  // refBackground
    ]
    
    fileprivate static let nightPalette = [
        "#142634",
        "#172B44",
        "#38547A",
        "#50667B",
        "#7E8889",
        "#8FA9BC",
        "#D48872",
        "#EAC5A0",
        "#333333"
    ]
    
    fileprivate class func colorWithHexString(_ hex: String, alpha: CGFloat) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            let startIndex = cString.characters.index(cString.startIndex, offsetBy: 1)
            cString = cString.substring(from: startIndex)
        }
        if (cString.length != 6) {
            return .background
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: alpha)
    }
    
    fileprivate class func colorWithHexString(_ hex: String) -> UIColor {
        return .colorWithHexString(hex, alpha: 1.0)
    }
    
    fileprivate  class var currentViewPalette: [String] {
        return UserDefaults.isNightModeEnable ? nightPalette : normalPalette
    }
    class var background: UIColor {
        let colorString = currentViewPalette[0]
        return .colorWithHexString(colorString)
    }
    class var desc: UIColor {
        let colorString = currentViewPalette[4]
        return .colorWithHexString(colorString)
    }
    class var body: UIColor {
        let colorString = currentViewPalette[5]
        return .colorWithHexString(colorString)
    }
    
    class var highlight: UIColor {
        let colorString = currentViewPalette[6]
        return .colorWithHexString(colorString)
    }
    class var href: UIColor {
        let colorString = currentViewPalette[7]
        return .colorWithHexString(colorString)
    }
    class var subBackground: UIColor {
        let colorstring = currentViewPalette[1]
        return .colorWithHexString(colorstring)
    }
    
    class var note: UIColor {
        let colorString = currentViewPalette[3]
        return .colorWithHexString(colorString)
    }
    class var border: UIColor {
        let colorString = currentViewPalette[2]
        return .colorWithHexString(colorString)
    }
}

extension UserDefaults {
    
    subscript(key: String) -> String? {
        get {
            return UserDefaults.standard.object(forKey: key) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    class var fontScaleString: String {
        get {
            return UserDefaults.standard.string(forKey: R.Key.DynamicTitleFontScale) ?? "1.0"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: R.Key.DynamicTitleFontScale)
        }
    }
    class var isPullReplyEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: R.Key.EnablePullReply)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: R.Key.EnablePullReply)
        }
    }
    class var isHightlightOwnerrepliesEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: R.Key.EnableHighlightOwnerReplies)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: R.Key.EnableHighlightOwnerReplies)
        }
    }
    class var isShakeEnabled: Bool {
        get {
            if let isShakeEnabled = UserDefaults.standard.object(forKey: R.Key.EnableShake) as? NSNumber {
                return isShakeEnabled.boolValue
            }
            return false
        }
        set {
            UserDefaults.standard.set(NSNumber(value: newValue as Bool), forKey: R.Key.EnableShake)
        }
    }
    
    class var isTabBarHiddenEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: R.Key.EnableTabBarHidden)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: R.Key.EnableTabBarHidden)
        }
    }
    
    class var isNightModeEnable: Bool {
        get {
            return UserDefaults.standard.bool(forKey: R.Key.EnableNightMode)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: R.Key.EnableNightMode)
        }
    }
}

extension String {
    var length: Int {
    
        get {
            return characters.count
        }
    }
    var floatValue: Float {
        get {
            return (self as NSString).floatValue
        }
    }
    var  doubleValue: Double {
        get {
            return (self as NSString).doubleValue
        }
    }
    func stringbyRemoveingNewLinesAndWhitespace() -> String {
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = nil
        var result = R.String.Empty
        var temp: NSString? = nil
        let whitespaceCharacters = CharacterSet.whitespacesAndNewlines
        while scanner.isAtEnd == false {
            scanner.scanUpToCharacters(from: whitespaceCharacters, into: &temp)
            if temp != nil {
                result.append(temp! as String)
            }
            if scanner.scanCharacters(from: whitespaceCharacters, into: nil) {
                if result.isEmpty == false && scanner.isAtEnd == false {
                    result.append(" ")
                }
            }
        }
        return result
    }
    
    func getUppercaseLatinString() -> String {
        if let str1 = applyingTransform(.mandarinToLatin, reverse: false), let str2 = str1.applyingTransform(.stripCombiningMarks, reverse: false) {
            return str2.uppercased()
        }
        return uppercased()
    }
    
    func replace(_ string: String, with replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    func removeWhitespace() -> String {
        return replace(" ", with: R.String.Empty)
    }
    func stringByRemoveingWhitespaceAtbeginAndEnd() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func  isValidImgURL() -> Bool {
        return R.Array.ValidImgUrls.filter { return self.contains($0)}.count > 0
    }
    func extractID() -> String? {
        var  result: String?
        if let startRange = range(of: "/t/"), let endRange = range(of: "#") {
            result = substring(with: Range(startRange.upperBound..<endRange.lowerBound))
        }
        return result
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
}
extension UIImage {
    func roundCornerImage() -> UIImage {
        let w = size.width
        let h = size.height
        let cornerRadius = max(min(w * 0.5, h * 0.5), 12)
        let imageframe = CGRect(x: w * 0.5 - cornerRadius, y: h * 0.5 - cornerRadius, width: cornerRadius * 2, height: cornerRadius * 2)
        UIGraphicsBeginImageContextWithOptions(imageframe.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: -imageframe.origin.x, y: -imageframe.origin.y)
        UIBezierPath(roundedRect: imageframe, cornerRadius: cornerRadius).addClip()
        draw(in: imageframe)
        
        UIColor.border.setStroke()
        context?.strokeEllipse(in: imageframe)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    class func drawImage(_ size: CGSize, color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
extension Notification.Name {
    struct Setting {
        static let FontsizeDidChange = Notification.Name(rawValue: "vexplore.notification.name.setting.fontsizeDidChange")
        static let NightModeDidChange = Notification.Name(rawValue: "vexplore.notification.name.setting.nightModeDidChange")
    }
    struct Profile {
        static let NeedRefresh = Notification.Name(rawValue: "vexplore.notification.name.profile.needRefresh")
        static let Refresh = Notification.Name(rawValue: "vexplore.notification.name.profile.refresh")
    }
    struct Topic {
        static let ComentAdded = Notification.Name(rawValue: "vexplore.notification.name.topic.commentAdded")
    }
    struct User {
        static let DidLogin = Notification.Name(rawValue: "vexplore.notification.name.user.didLogin")
        static let DidLogout = Notification.Name("vexplore.notification.name.user.didLogout")
    }
}
extension UINavigationBar {
    func setupNavigationbar() {
        isTranslucent = false
        barTintColor = .background
        tintColor = .desc
        titleTextAttributes = [NSForegroundColorAttributeName: UIColor.body]
        shadowImage = UIImage.drawImage(CGSize(width: frame.width, height: 1), color: .border)
        setBackgroundImage(UIImage(), for: .default)
    }
}

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension UIViewController {
    
    func presentContentModalViewController(_ viewController: UIViewController, animated: Bool, completion: ((Void) -> Void)?) {
        viewController.view.frame = view.bounds
        addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        view.addSubview(viewController.view)
        viewController.view.transform = CGAffineTransform(translationX: 0, y: viewController.view.bounds.height)
        
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: { 
            viewController.view.transform = .identity
        }) { (_) in
            completion?()
        }
    }
    
    func dismissContentModalViewController(_ viewController: UIViewController, animated: Bool, complletion: ((Void) -> Void)?) {
    
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: { 
            viewController.view.transform = CGAffineTransform(translationX: 0, y: viewController.view.bounds.height)
        }) { (_) in
            viewController.view.removeFromSuperview()
            viewController.willMove(toParentViewController: self)
            viewController.removeFromParentViewController()
            viewController.view.transform = .identity
            complletion?()
        }
    }
    func bouncePresent(_ viewController: SwipeTransitionViewController, completion: (() -> Void)?) {
        viewController.transitioningDelegate = viewController
        present(viewController, animated: true, completion: completion)
    }
    
    func bouncePresent(navigationVCWith viewController: SwipeTransitionViewController, completion: (() -> Void)?) {
        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationVC.transitioningDelegate = viewController
        present(navigationVC, animated: true, completion: completion)
    }
}

extension UITableViewCell {
    func tableView() -> UITableView? {
        var superview = self.superview
        var tableView: UITableView?
        while superview != nil {
            if superview!.isKind(of: UITableView.self) {
                tableView = superview as? UITableView
                break
            }
            superview = superview!.superview
        }
        return tableView
    }
}

extension NSRange {
    init(with cfRange: CFRange) {
        self.location = cfRange.location
        self.length = cfRange.length
    }
}

extension CFRange {
    init(with nsRange: NSRange) {
        self.location = nsRange.location
        self.length = nsRange.length
    }
}

extension CGPoint {
    func pixelRound() -> CGPoint {
        let scale = UIScreen.main.scale
        return CGPoint(x: round(x * scale) / scale, y: round(y * scale) / scale)
    }
}
extension CGRect {
    func pixelRound() -> CGRect {
        let scale = UIScreen.main.scale
        return CGRect(x: round(origin.x * scale) / scale, y: round(origin.y * scale) / scale, width: round(width * scale) / scale, height: round(height * scale) / scale)
    }
}

extension UIApplication {
    class func topviewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topviewController(presented)
        }
        return base
    }
}

extension UITabBar {
    func setuptabBar() {
        for tabbarItem in items! {
            tabbarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }
        tintColor = .highlight
        isTranslucent = false
        barTintColor = .background
        shadowImage = UIImage.drawImage(CGSize(width: frame.width, height: 1), color: .border)
        backgroundImage = UIImage()
    }
}
extension Array {
    func shift(withDistance disance: Int = 1) -> Array<Element> {
        let index = disance >= 0 ?
            self.index(startIndex, offsetBy: disance, limitedBy: endIndex) :
            self.index(endIndex, offsetBy: disance, limitedBy: startIndex)
        guard index != nil else {
            return self
        }
        return Array(self[index! ..< endIndex] + self[startIndex ..< index!])
    }
    
    mutating func shiftInPlace(withDistance distance: Index = 1) {
        self = shift(withDistance: distance)
    }
}
extension Request {
    @discardableResult func responseParsableHTML(completion completionHandler: @escaping (DataResponse<HTMLDoc>) -> Void) -> Self {
        return response(htmlResponseSerizlizer(), completionHandler: completionHandler)
        }
    }
    fileprivate func htmlResponseSerizlizer() -> DataResponseSerializer<HTMLDoc> {
        enum VeXploRerror: Int {
            case requestError = 10004
            case serverError = 10005
            case invalidDataError = 10006
            case dataSerializationError = 10007
        }
        return DataResponseSerializer { request, response, data, error in
            if let statusCode = response?.statusCode {
                if statusCode % 100 == 4 {
                    let error = NSError(domain: R.String.ErrorDomain, code: VeXploRerror.serverError.rawValue, userInfo: nil)
                    return .failure(error)
                }
            }
            guard error == nil else {
                return .failure(error!)
            }
            guard  let validData = data else {
                let error = NSError(domain: R.String.ErrorDomain, code: VeXploRerror.invalidDataError.rawValue, userInfo: nil)
                return .failure(error)
            }
            if let htmlDoc = HTMLDoc(htmlData: validData) {
                return .success(htmlDoc)
            }
            let error = NSError(domain: R.String.ErrorDomain, code: VeXploRerror.dataSerializationError.rawValue, userInfo: nil)
            return .failure(error)
        }
    }

















