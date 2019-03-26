import UIKit
import RealmSwift

class SettingExcuseViewController: Abstract,UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var mainTextTextField: UITextView!
    @IBOutlet weak var titileErrorMessageLabel: UILabel!
    @IBOutlet weak var mainTextErrorMessageLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    //@IBOutlet weak var placeholderLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.createHeader(pTitle: "言い訳設定画面")
        super.createSideMenu()
        mainTextTextField.delegate = self
        
    }
    
    
    
    @IBAction func settingButton(_ sender: Any) {
        
        //入力値取得
        let inputed_title = titleTextField.text!
        let inputed_main_text = mainTextTextField.text!
        
        //入力値チェック
        if !checkInput(pTitle: inputed_title, pMainText: inputed_main_text) {
            return
        }
        
        
        let realm = try! Realm()
        var saved_excuse_data = realm.objects(Excuse.self)
        

        let excuse = Excuse()
        excuse.title = inputed_title
        excuse.mainText = inputed_main_text
        
        // 追加
        try! realm.write {
            realm.add(excuse)
        }
        
        print("追加しました")
        
    }
    

    @IBAction func clearButton(_ sender: Any) {
        
        titleTextField.text = ""
        mainTextTextField.text = ""
        titleTextField.becomeFirstResponder()
        print("クリアしました")
        
    }
    
    func checkInput(pTitle :String, pMainText :String) -> Bool {
        
        var ret = true
        titileErrorMessageLabel.text = ""
        mainTextErrorMessageLabel.text = ""
        
        if !pTitle.isInput() {
            
            titileErrorMessageLabel.text = "タイトルが空欄です"
            ret = false
            
        } else if pTitle.count > 20 {
            
            titileErrorMessageLabel.text = "タイトルは20文字以下で入力してください"
            ret = false
            
        }
        
        if !pMainText.isInput() {
            
            mainTextErrorMessageLabel.text = "本文が空欄です"
            ret = false
            
        } else if pMainText.count > 150 {
            
            mainTextErrorMessageLabel.text = "本文は150文字以下で入力してください"
            ret = false
            
        }
        
        return ret
        
    }
    
    //フォーカスが当たったときはプレースホルダー非表示
    func textViewDidBeginEditing(_ mainTextTextField: UITextView) {
        placeholderLabel.isHidden = true
    }


    //textviewからフォーカスが外れて、TextViewが空だったらLabelを再び表示
    func textViewDidEndEditing(_ mainTextTextField: UITextView) {
        if(mainTextTextField.text.isEmpty){
            placeholderLabel.isHidden = false
        }
    }
    
}
