import UIKit

class SettingChatViewController: Abstract {

    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var destinationRoomNumberTextField: UITextField!
    @IBOutlet weak var apiKeyErrorLabel: UILabel!
    @IBOutlet weak var destinationRoomNumberErrorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        super.createHeader(pTitle: "チャット設定画面")
        super.createSideMenu()
        
    }
    

    @IBAction func doneButton(_ sender: Any) {
        
        
        
        userDefault.set(apiKeyTextField.text!, forKey: "apiKey")
        userDefault.set(destinationRoomNumberTextField.text!, forKey: "destinationRoomNumber")
        userDefault.synchronize()
        print("保存しました")
        
    }
    
    @IBAction func clearButton(_ sender: Any) {
    }
    
    func inputCheck() -> Bool {
        
        var ret = true
    
        if !apiKeyTextField.text!.isInput(){
            apiKeyErrorLabel.text = "api key入力欄が空です。"
            ret = false
        } else if(!apiKeyTextField.text!.isAlphanumeric()) {
            apiKeyErrorLabel.text = "半角英数字で入力してください"
            ret = false
        }
        
        
        if !destinationRoomNumberTextField.text!.isInput(){
            destinationRoomNumberErrorLabel.text = "room番号入力欄が空です。"
            ret = false
        } else if(!destinationRoomNumberTextField.text!.isNumber()) {
            destinationRoomNumberErrorLabel.text = "数字で入力してください"
        }
        
        return ret
    }
}
