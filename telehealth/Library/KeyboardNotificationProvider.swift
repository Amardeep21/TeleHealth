

import UIKit

protocol KeyboardNotificationProvider: class {
    var showNotification: NSObjectProtocol? { get set }
    var hideNotification: NSObjectProtocol? { get set }
    
    func registerKeyboardNotification()
    func deRegisterKeyboardNotification()
    
    func keyboardWillShow(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions)
    func keyboardWillHide(duration: TimeInterval, options: UIView.AnimationOptions)
}

extension KeyboardNotificationProvider where Self: UIResponder {
    
    func registerKeyboardNotification() {
        showNotification = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillShow(notification: notification)
        }
        
        hideNotification = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillHide(notification: notification)
        }
    }
    
    func deRegisterKeyboardNotification() {
        guard let showNotification = showNotification, let hideNotification = hideNotification else { return }
      
        NotificationCenter.default.removeObserver(showNotification)
        NotificationCenter.default.removeObserver(hideNotification)
    }
    
    private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
      
        let height = keyboardHeight(from: userInfo)
        let duration = keyboardAnimationDuration(from: userInfo)
        let options = keyboardAnimationOptions(from: userInfo)
        keyboardWillShow(height: height, duration: duration, options: options)
    }
    
    private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let duration = keyboardAnimationDuration(from: userInfo)
        let options = keyboardAnimationOptions(from: userInfo)
        keyboardWillHide(duration: duration, options: options)
    }
    
    private func keyboardHeight(from userInfo: [AnyHashable: Any]) -> CGFloat {
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return 0.0 }
        return keyboardSize.height
    }
    
    private func keyboardAnimationDuration(from userInfo: [AnyHashable: Any]) -> TimeInterval {
        guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return 0.35 }
        return TimeInterval(animationDuration)
    }
    
    private func keyboardAnimationOptions(from userInfo: [AnyHashable: Any]) -> UIView.AnimationOptions {
        guard let animationCurveInt = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            return .curveEaseInOut
        }
        return UIView.AnimationOptions(rawValue: animationCurveInt << 16)
    }
    
}
