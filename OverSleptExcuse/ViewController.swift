import UIKit
import RealmSwift


class ViewController: Abstract,UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        super.createHeader(pTitle: "結果画面")
        super.createSideMenu()
        
        // Delegate設定
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //DBにあるタイトルを選択肢に突っ込む
        let realm = try! Realm()
        let saved_excuse_data = realm.objects(Excuse.self)
        
        for excuse in saved_excuse_data {
            excuseTitleList.append(excuse.title)
            db_data_evacuation[excuse.title] = excuse.mainText
        }
        

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
        let task = session.dataTask(with:url!) { (data, response, error) -> Void in
            if let urlContent = data {
                let webContent = String(data: urlContent, encoding: String.Encoding.utf8)
                if let test = webContent?.range(of:"→<span class=\"mark\">") {
                    //if let test = webContent?.range(of:"八戸ノ里") {
                    //print("見つかりました。 index: \(webContent?.distance(from: (webContent?.startIndex)!, to: test.lowerBound))")
                    //対象の文字が何文字目か
                    let target_charctor = webContent?.distance(from: (webContent?.startIndex)!, to: test.lowerBound)
                    let arrayval_time = webContent?[(webContent?.index(webContent!.startIndex, offsetBy: target_charctor! + 20))!..<(webContent?.index((webContent?.startIndex)!, offsetBy: target_charctor! + 25))!]
                    
                    print(arrayval_time as Any)
                }
            }
        }
        task.resume()
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
}


