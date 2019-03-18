import UIKit


class ViewController: Abstract {
    
    let userDefault = UserDefaults.standard
    var isExists = false
    
    
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
        
        
        
       
        let time_to_leave_home = userDefault.string(forKey: "timeToLeaveHome")
        let time_to_nearest_station = userDefault.string(forKey: "timeToNearestStation")
        var nearest_station_name = userDefault.string(forKey: "nearestStationName")
        let desitination_station_name = userDefault.string(forKey: "desitinationStationName")
        
        //現在の日時
        let now_date = DateFormatter()
        now_date.dateFormat = "yyyy/MM/dd"
        let now = Date()
        let today = now_date.string(from: now)
        var today_list:[String] = today.components(separatedBy: "/")
        let year = today_list[0]
        let month = today_list[1]
        let day = today_list[2]
        //時間
        let now_time = DateFormatter()
        now_time.dateFormat = "HH:mm"
        let to_time = now_time.string(from: now)
        let to_time_list:[String] = to_time.components(separatedBy: ":")
        var hours = to_time_list[0]
        
        
        //準備時間、最寄り駅までの時間を考慮
        var result_minute:Int = 0
        if let now_minute = Int(to_time_list[1]) {
            if let time_to_leave_home = Int(time_to_leave_home ?? "999") {
                if let time_to_nearest_station = Int(time_to_nearest_station ?? "999") {
                    result_minute = now_minute + time_to_leave_home + time_to_nearest_station
                }
            }
        }
        
        
        //60分を超えている場合hourにプラスしてやる必要がある
        //resultが82だった場合、hour + 1 でresultが22になる
        var over_num:Int = 0
        var add_hour:Int = 0
        
        if result_minute > 60 {
            
            add_hour += 1
            while(result_minute > 60) {
                over_num += 1
                result_minute -= 1
                if over_num == 60 {
                    over_num = 0
                    add_hour += 1
                }
            }
            
            result_minute = over_num
        }
        
        //超過時間を追加
        if add_hour != 0 {
            
            if var convert_hours = Int(hours) {
                convert_hours += add_hour
                hours = String(convert_hours)
                
            }
        }
        
        
        let minutes_first_disit = String(result_minute).prefix(1)
        let minutes_second_disit = String(result_minute).suffix(1)
        
        //String型にしないとOptinal("駅名")ていう値になる。Optinalの部分いらんからStringにしてる
        let convert_string_nearest_station_name:String = nearest_station_name ?? "lol"
        let convert_string_desitination_station_name:String = desitination_station_name ?? "lol"
        
        var text = "https://transit.yahoo.co.jp/search/result?/?flatlon=&fromgid=&from=\(convert_string_nearest_station_name)&tlatlon=&togid=&to=\(convert_string_desitination_station_name)&viacode=&via=&viacode=&via=&viacode=&via=&y=\(year)&m=\(month)&d=\(day)&hh=\(hours)&m2=\(minutes_second_disit)&m1=\(minutes_first_disit)&type=1&ticket=ic&expkind=1&ws=3&s=0&al=1&shin=1&ex=1&hb=1&lb=1&sr=1&kw=\(convert_string_desitination_station_name))"
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
}


