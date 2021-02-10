
import UIKit

class RoundView:UIView {
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.bounds.width/2
        self.layer.masksToBounds = true
  
    }
}
