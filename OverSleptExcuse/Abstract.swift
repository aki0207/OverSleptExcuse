import UIKit

class Abstract: UIViewController {
    
    
    var swipeFlg = true
    // Headerを作成するメソッド
    func createHeader(pTitle: String) {
        // Headerの作成(Label)
        let header = UILabel()
        
        
        // タイトルの挿入
        header.text = pTitle
        
        // 文字色の設定
        header.textColor = UIColor.white
        
        // 背景色の設定
        header.backgroundColor = UIColor.cyan
        
        // 中央寄せ
        header.textAlignment = .center
        
        // 文字サイズ
        header.font = UIFont.systemFont(ofSize: 30)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(header)
        
        // オートレイアウトの作成
        //header.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        header.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: self.view!.widthAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    // SideMenuを作成するメソッド
    func createSideMenu() {
        
        let side = UIButton()
        
        
        // 背景色の設定
        side.setBackgroundImage(UIImage(named: "side_menu_open_icon.png"), for: .normal)
        
        // タップイベントの追加
        side.addTarget(self, action: #selector(self.tapped), for: .touchUpInside)
        
        if swipeFlg {
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe(sender:)))
            rightSwipe.direction = .right
            view.addGestureRecognizer(rightSwipe)
        }
        
        side.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(side)
        
        // オートレイアウトの作成
        side.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        side.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        side.widthAnchor.constraint(equalToConstant: 35).isActive = true
        side.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc func didSwipe(sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            self.performSegue(withIdentifier: "toSideMenu", sender: nil)
        }
    }
    
    // ハンバーガーメニュータップ時
    @objc func tapped() {
        self.performSegue(withIdentifier: "toSideMenu", sender: nil)
    }
    
    
}
