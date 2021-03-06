import UIKit

class SettingViewController: Abstract {
    
    let userDefault = UserDefaults.standard
    
    
    
    @IBOutlet weak var error_message_label: UILabel!
    @IBOutlet weak var time_to_leave_home: UITextField!
    @IBOutlet weak var time_to_nearest_station: UITextField!
    @IBOutlet weak var nearest_station_name: UITextField!
    @IBOutlet weak var desitination_station_name: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.createHeader(pTitle: "時間・駅設定画面")
        super.createSideMenu()
        
        time_to_leave_home.text = userDefault.string(forKey: "timeToLeaveHome")
        time_to_nearest_station.text = userDefault.string(forKey: "timeToNearestStation")
        nearest_station_name.text = userDefault.string(forKey: "nearestStationName")
        desitination_station_name.text = userDefault.string(forKey: "desitinationStationName")
        
    }
    
    


    
    @IBAction func doneButton(_ sender: Any) {
        
        if inputCheck() {
            
            //入力された値を保存
            userDefault.set(true, forKey: "isExists")
            userDefault.set(time_to_leave_home.text!, forKey: "timeToLeaveHome")
            userDefault.set(time_to_nearest_station.text!, forKey: "timeToNearestStation")
            userDefault.set(nearest_station_name.text!, forKey: "nearestStationName")
            userDefault.set(desitination_station_name.text!, forKey: "desitinationStationName")
            userDefault.synchronize()
            
            //アラート表示
            let alert = Alert()
            alert.generateOkAlert(pTitle: "登録されました",pMessage: "")
            present(alert.alert,animated: true, completion: nil)
            print("保存しました")
            

    }
        

    }
    
    @IBAction func clearButton(_ sender: Any) {
        
        time_to_leave_home.text! = ""
        time_to_nearest_station.text! = ""
        nearest_station_name.text! = ""
        desitination_station_name.text! = ""
        //フォーカスを先頭のフォームに持っていく
        time_to_leave_home.becomeFirstResponder()
        print("クリアしました")
        
    }
    
    
    func inputCheck() -> (Bool) {
        
        var ret = true
        error_message_label.text = ""
        
        //家からの所要時間
        //空文字か判断
        if !time_to_leave_home.text!.isInput(){
            error_message_label.text = "家を出るまでの所要時間欄が空欄です\n"
            ret = false
        } else {
            if !time_to_leave_home.text!.isNumber() {
                error_message_label.text = "家を出るまでの所要時間欄は数字で入力してください\n"
                ret = false
            }
        }
        
        
        //最寄り駅までの所要時間
        //空文字か判断
        if !time_to_nearest_station.text!.isInput() {
            error_message_label.text = error_message_label.text! + "最寄り駅までの所要時間欄が空欄です\n"
            ret = false
        } else {
            //数字じゃなければだめ
            if !time_to_leave_home.text!.isNumber() {
                error_message_label.text = error_message_label.text! + "家を出るまでの所要時間欄は数字で入力してください\n"
                ret = false
            }
        }
        
        
        //最寄り駅名
        //空文字か判断
        if !nearest_station_name.text!.isInput() {
            error_message_label.text = error_message_label.text! + "最寄り駅名が空欄です\n"
            ret = false
        } else {
            //日本語じゃなければだめ
            if !nearest_station_name.text!.isJapanese() {
                error_message_label.text = error_message_label.text! + "日本語で入力してください\n"
                ret = false
            }
            
        }
        
        //目的地駅名
        //空文字か判断
        if !desitination_station_name.text!.isInput() {
            error_message_label.text = error_message_label.text! + "目的地駅名が空欄です\n"
            ret = false
        } else {
            if !desitination_station_name.text!.isJapanese() {
                error_message_label.text = error_message_label.text! + "日本語で入力してください"
                ret = false
            }
        }
        return ret
    }
}
