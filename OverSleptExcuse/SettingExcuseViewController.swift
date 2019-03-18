import UIKit
import RealmSwift

class SettingExcuseViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var mainTextTextField: UITextView!
    @IBOutlet weak var titileErrorMessageLabel: UILabel!
    @IBOutlet weak var mainTextErrorMessageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    @IBAction func settingButton(_ sender: Any) {
        
        //入力値取得
        var inputed_title = titleTextField.text!
        var inputed_main_text = mainTextTextField.text!
        
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
    
    //テスト用参照ボタン
    @IBAction func searchButton(_ sender: Any) {
        
        let realm = try! Realm()
        var saved_excuse_data = realm.objects(Excuse.self)
        // ためしに名前を表示
        for excuse in saved_excuse_data {
            print("titile: \(excuse.title)")
            print("mainText: \(excuse.mainText)")
        }
        
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
    
}
