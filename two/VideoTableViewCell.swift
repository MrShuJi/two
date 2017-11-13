//
//  VideoTableViewCell.swift
//  two
//
//  Created by shuji on 2017/10/20.
//  Copyright © 2017年 shuji. All rights reserved.
//

import UIKit
import BMPlayer
class VideoTableViewCell: UITableViewCell {

    fileprivate lazy var player = BMPlayer()
    
    @IBOutlet weak var contentImageView: UIButton!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var label: UILabel!
    //内容图片的宽高比约束
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                contentImageView.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                contentImageView.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //清除内容图片的宽高比约束
        aspectConstraint = nil
    }
    
    
    
    
    
    func loadImage2(urlString: String) {
        aspectConstraint = NSLayoutConstraint(item: contentImageView,
                                              attribute: .width, relatedBy: .equal,
                                              toItem: contentImageView, attribute: .height,
                                              multiplier: 1.6666666, constant: 0.0)
 
       
        
        
        
        contentImageView.sd_setBackgroundImage(with: URL(string: urlString as! String), for: UIControlState.normal)
    }
    
}
