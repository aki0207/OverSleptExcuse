import UIKit

class TimeToUseForUrl {

    var userDefault = UserDefaults.standard
    var year = ""
    var month = ""
    var day = ""
    var hours = ""
    var minutes_second_disit = ""
    var minutes_first_disit = ""
    var to_time_list:[String] = []
    

    func getCurrentDateAndTime(pTimeInstance:TimeToUseForUrl) -> TimeToUseForUrl {
        
        let now_date = DateFormatter()
        now_date.dateFormat = "yyyy/MM/dd"
        let now = Date()
        let today = now_date.string(from: now)
        var today_list:[String] = today.components(separatedBy: "/")
        
        pTimeInstance.year = today_list[0]
        pTimeInstance.month = today_list[1]
        pTimeInstance.day = today_list[2]
        //時間
        let now_time = DateFormatter()
        now_time.dateFormat = "HH:mm"
        let to_time = now_time.string(from: now)
        pTimeInstance.to_time_list = to_time.components(separatedBy: ":")
        pTimeInstance.hours = to_time_list[0]
        
        return pTimeInstance
        
    }
    
    
    func addTimeToLeaveHomeAndTimeToNearestStation(pTimeInstance:TimeToUseForUrl) -> TimeToUseForUrl {
        
        //設定された時間を取得
        let time_to_leave_home = userDefault.string(forKey: "timeToLeaveHome")
        let time_to_nearest_station = userDefault.string(forKey: "timeToNearestStation")
       
 
        var result_minute:Int = 0
        
        if let now_minute = Int(pTimeInstance.to_time_list[1]) {
            if let time_to_leave_home = Int(time_to_leave_home ?? "999") {
                if let time_to_nearest_station = Int(time_to_nearest_station ?? "999") {
                    //なんか冗長やけど、要はここで足し算しとるだけ
                    result_minute = now_minute + time_to_leave_home + time_to_nearest_station
                }
            }
        }
        
        
        //60分を超えている場合hourにプラスしてやる必要がある
        //例えばresult_timeが82だった場合、hour + 1 でresult_timeが22になる
        var over_num = 0
        var add_hour = 0
        
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
            if var convert_hours = Int(pTimeInstance.hours) {
                convert_hours += add_hour
                pTimeInstance.hours = String(convert_hours)
            }
        }
        
        
        pTimeInstance.minutes_first_disit = String(String(result_minute).prefix(1))
        pTimeInstance.minutes_second_disit = String(String(result_minute).suffix(1))
        
        return pTimeInstance
        
    }
    
}
