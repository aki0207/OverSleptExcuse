import UIKit
extension String {
    func isNumber() -> Bool {
        return NSPredicate(format: "SELF MATCHES %@","[0-9]+" ).evaluate(with:self)
    }
    
    func isJapanese() -> Bool {
        return NSPredicate(format: "SELF MATCHES %@","^[ぁ-ゞァ-ヾ\u{3005}\u{3007}\u{303b}\u{3400}-\u{9fff}\u{f900}-\u{faff}\u{20000}-\u{2ffff}]+$" ).evaluate(with:self)
    }
    
    // 値が入っているか確認する
    func isInput() -> Bool {
        
        // 文字列退避
        var w_str = self
        
        // 半角スペース置換
        if let range = w_str.range(of: " ") {
            // 置換する(変数を直接操作できます)
            w_str.replaceSubrange(range, with: "")
        }
        
        // 全角スペース置換
        if let range = w_str.range(of: "　") {
            // 置換する(変数を直接操作できます)
            w_str.replaceSubrange(range, with: "")
        }
        
        // タブ置換
        if let range = w_str.range(of: "\t") {
            // 置換する(変数を直接操作できます)
            w_str.replaceSubrange(range, with: "")
        }
        
        if w_str.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    
    
}
