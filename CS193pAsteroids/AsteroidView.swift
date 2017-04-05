//
//  AsteroidView.swift
//  CS193pAsteroids
//
//  Created by zzk on 2017/4/5.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class AsteroidView: UIImageView {

    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        image = UIImage(named: "asteroid\(arc4random_uniform(9) + 1)")
        frame.size = image?.size ?? CGSize.zero
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
