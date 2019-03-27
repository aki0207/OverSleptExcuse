import UIKit
import RealmSwift


class SendMessageViewController: Abstract,UIPickerViewDelegate, UIPickerViewDataSource {
    
    let userDefault = UserDefaults.standard
    var isExists = false
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var mainTextField: UITextView!
    
    
    var excuseTitleList: [String] = []
    var db_data_evacuation: Dictionary = [String:String]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //設定されていなければ設定画面へ
        isExists = userDefault.bool(forKey: "isExists")
        
        if !isExists {
            self.performSegue(withIdentifier: "toTimeAndStationName", sender: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.createHeader(pTitle: "メッセージ送信画面")
        super.createSideMenu()
        
        // Delegate設定
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        //URLにセットするパラメータの時間を取得
        var parametersUsedForUrl = TimeToUseForUrl()
        parametersUsedForUrl = parametersUsedForUrl.getCurrentDateAndTime(pTimeInstance: parametersUsedForUrl)
        parametersUsedForUrl = parametersUsedForUrl.addTimeToLeaveHomeAndTimeToNearestStation(pTimeInstance: parametersUsedForUrl)
        
        //URLにセットするパラメータの駅名を取得
        var nearest_station_name:String = ""
        var desitination_station_name = ""
        
        guard (userDefault.string(forKey: "nearestStationName") != nil) else {
            return
        }
        nearest_station_name = userDefault.string(forKey: "nearestStationName")!
        
        guard (userDefault.string(forKey: "desitinationStationName") != nil) else {
            return
        }
        
        desitination_station_name = userDefault.string(forKey: "desitinationStationName")!
        
        var text = "https://transit.yahoo.co.jp/search/result?/?flatlon=&fromgid=&from=\(nearest_station_name)&tlatlon=&togid=&to=\(desitination_station_name)&viacode=&via=&viacode=&via=&viacode=&via=&y=\(parametersUsedForUrl.year)&m=\(parametersUsedForUrl.month)&d=\(parametersUsedForUrl.day)&hh=\(parametersUsedForUrl.hours)&m2=\(parametersUsedForUrl.minutes_second_disit)&m1=\(parametersUsedForUrl.minutes_first_disit)&type=1&ticket=ic&expkind=1&ws=3&s=0&al=1&shin=1&ex=1&hb=1&lb=1&sr=1&kw=\(desitination_station_name))"
        
        //エンコードかます
        text = text.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let url = URL(string: text);
        let session = URLSession.shared
        let condition = NSCondition()
        
        
        let task = session.dataTask(with:url!) { (data, response, error) -> Void in
            if let urlContent = data {
                
                condition.lock()
                let webContent = String(data: urlContent, encoding: String.Encoding.utf8)
                if let test = webContent?.range(of:"→<span class=\"mark\">") {
                    //if let test = webContent?.range(of:"八戸ノ里") {
                    //print("見つかりました。 index: \(webContent?.distance(from: (webContent?.startIndex)!, to: test.lowerBound))")
                    //対象の文字が何文字目か
                    let target_charctor = webContent?.distance(from: (webContent?.startIndex)!, to: test.lowerBound)
                    let arrayval_time = webContent?[(webContent?.index(webContent!.startIndex, offsetBy: target_charctor! + 20))!..<(webContent?.index((webContent?.startIndex)!, offsetBy: target_charctor! + 25))!]
                    
                    
                    let arrayval_hours:String = String(arrayval_time!.prefix(2))
                    let arrayval_minutes:String = String(arrayval_time!.suffix(2))
                    
                    //DBにあるタイトルを選択肢に突っ込む
                    let realm = try! Realm()
                    let saved_excuse_data = realm.objects(Excuse.self)
                    
                    //まずデフォルト文追加
                    self.excuseTitleList.append("寝坊:デフォルト")
                    self.db_data_evacuation["寝坊:デフォルト"] = "おはようございます。\n寝坊をしてしまったため到着が遅れます。\n\(arrayval_hours)時\(arrayval_minutes)分に到着予定です。\n申し訳ございませんがよろしくお願い致します"
                    
                    
                    for excuse in saved_excuse_data {
                        self.excuseTitleList.append(excuse.title)
                        self.db_data_evacuation[excuse.title] = self.insertTime(pMainText: excuse.mainText, pHours: arrayval_hours, pMinutes: arrayval_minutes)
                    }
                    
                    
                    condition.signal()
                    condition.unlock()
                    
                    print(arrayval_time as Any)
                }
            }
        }
        condition.lock()
        task.resume()
        condition.wait()
        condition.unlock()
        //URL叩いて通信処理完了後こいつが呼ばれる
        self.pickerView.reloadAllComponents()
        
    }
    
    
    @IBAction func sendButton(_ sender: Any) {
        
        if !chatDataInformationRegistered() {
            return
        }
        
        let sendMessage = SendMessage()
        guard(userDefault.string(forKey: "apiKey") != nil) else {
            return
        }
        sendMessage.api_key = userDefault.string(forKey: "apiKey")!
        
        guard(userDefault.string(forKey: "destinationRoomNumber") != nil) else {
            return
        }
        
        sendMessage.room_id = userDefault.string(forKey: "destinationRoomNumber")!
        
        sendMessage.message = mainTextField.text
        if sendMessage.hitTheApi(pSendMessageInstance: sendMessage) {
            let alert = Alert()
            alert.generateOkAlert(pTitle: "送信されました",pMessage: "")
            present(alert.alert,animated: true, completion: nil)
        } else {
            let alert = Alert()
            alert.generateOkAlert(pTitle: "送信に失敗しました",pMessage: "api key及びroom番号をご確認ください")
            present(alert.alert,animated: true, completion: nil)
        }
        
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return excuseTitleList.count
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        mainTextField.text = db_data_evacuation[excuseTitleList[row]]
        return excuseTitleList[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        mainTextField.text = db_data_evacuation[excuseTitleList[row]]
        
    }
    
    //本文に到着時間を挿入
    func insertTime(pMainText: String, pHours: String, pMinutes: String) -> String {
        
        //引数をletからvarに変換
        var pMainText = pMainText
        if let range = pMainText.range(of: "◯") {
            pMainText.replaceSubrange(range, with: pHours)
        }
        
        if let range = pMainText.range(of: "△") {
            pMainText.replaceSubrange(range, with: pMinutes)
        }
        return pMainText
    }
    
    
    func chatDataInformationRegistered() -> Bool {
        
        var ret = true
        
        guard(userDefault.string(forKey: "apiKey") != nil) else {
            ret = false
            return ret
        }
        
        guard(userDefault.string(forKey: "destinationRoomNumber") != nil) else {
            ret = false
            return ret
        }

        return ret
    }
}


