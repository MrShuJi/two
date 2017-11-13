//
//  VideoTopicCell.swift
//  TodayNews-Swift
//
//  Created by 杨蒙 on 17/2/17.
//  Copyright © 2017年 杨蒙. All rights reserved.
//

import UIKit


class VideoTopicCell: UITableViewCell {
   
    /// 标题 label
    @IBOutlet weak var titleLabel: UILabel!
    /// 播放数量
    @IBOutlet weak var playCountLabel: UILabel!
    /// 时间 label
    @IBOutlet weak var timeLabel: UILabel!
    /// 背景图片
    @IBOutlet weak var bgImageButton: UIButton!
    
    
    /// 用户头像
    @IBOutlet weak var headButton: UIButton!
    @IBOutlet weak var headCoverButton: UIButton!
    /// 用户昵称
    @IBOutlet weak var nameLable: UILabel!
    /// 关注数量
    @IBOutlet weak var concernButton: UIButton!
    /// 评论数量
    @IBOutlet weak var commentButton: UIButton!
    /// 更多按钮
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var bottomLineView: UIView!
    
    //内容图片的宽高比约束
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                bgImageButton.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                bgImageButton.addConstraint(aspectConstraint!)
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
        aspectConstraint = NSLayoutConstraint(item: bgImageButton,
                                              attribute: .width, relatedBy: .equal,
                                              toItem: bgImageButton, attribute: .height,
                                              multiplier: 1.6666666, constant: 0.0)
        
        
        
        
        
        bgImageButton.sd_setBackgroundImage(with: URL(string: urlString as! String), for: UIControlState.normal)
    }
}
