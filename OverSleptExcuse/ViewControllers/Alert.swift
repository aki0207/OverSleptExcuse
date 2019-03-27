import UIKit

class Alert:UIViewController  {
    
    var alert = UIAlertController()

    
    func generateOkAlert(pTitle: String,pMessage: String) {
        
        let title = pTitle
        let message = pMessage
        let text = "ok"
        
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        
    }
}
