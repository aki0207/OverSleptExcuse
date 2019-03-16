import UIKit
import AVFoundation


class SideMenuViewController: Abstract {

    @IBOutlet weak var menuView: UIView!
    var headerTitle: String = ""
    var closeViewRandomTag = 0
    var fromReadViewSession: AVCaptureSession! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // HEADER追加
        super.createHeader(pTitle: "メニュー画面")
        view.backgroundColor = UIColor.gray
        menuView.backgroundColor = UIColor.white
        closeViewRandomTag = Int.random(in: 0 ... 100000000)
        self.view.tag = closeViewRandomTag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // メニュー画面の位置
        let menuPosition = self.menuView.layer.position
        // 初期位置設定
        self.menuView.layer.position.x = -self.menuView.frame.width
        // 表示アニメーション
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.menuView.layer.position.x = menuPosition.x
        },
            completion: { bool in
        })
        
    }
    
    // メニュー外をタップした場合に非表示にする
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == closeViewRandomTag {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.menuView.layer.position.x = -self.menuView.frame.width
                },
                    completion: { bool in
                        if self.fromReadViewSession == nil {
                            self.dismiss(animated: false, completion: nil)
                        } else {
                            self.dismiss(animated: false, completion:{
                                self.fromReadViewSession.startRunning()
                            })
                        }
                }
                )
            }
        }
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func toSettingButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
}
