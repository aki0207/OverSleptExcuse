import UIKit

class SendMessage {

    var api_key = "my api key"
    var url = "https://api.chatwork.com/v2"
    var room_id = "my room id"
    var message = "メッセージ"


    func hitTheApi(pSendMessageInstance: SendMessage) {
        
        var urlString = "https://api.chatwork.com/v2"
        urlString = "\(urlString)/rooms/\(pSendMessageInstance.room_id)/messages"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        
        //set the method(HTTP-POST)
        request.httpMethod = "POST"
        //set the header(s)
        request.addValue(pSendMessageInstance.api_key, forHTTPHeaderField: "X-ChatWorkToken")
        
        //set the request-body(JSON)
        let params = "body=\(pSendMessageInstance.message)"
        
        
        do {
            request.httpBody = params.data(using: .utf8)
        } catch {
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
            if (error == nil) {
                let result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                print("大成功")
                print(result)
            } else {
                print("oh my god")
                print(error as Any)
            }
        })
        task.resume()
    }
}
