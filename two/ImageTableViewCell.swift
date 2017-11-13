//
//  ImageTableViewCell.swift
//  hangge_1343
//
//  Created by hangge on 2016/11/21.
//  Copyright © 2016年 hangge. All rights reserved.
//

import UIKit
import SDWebImage

class ImageTableViewCell: UITableViewCell {
    
    //标题文本标签
    @IBOutlet weak var titleLabel: UILabel!
    
    //内容图片
    @IBOutlet weak var contentImageView: UIImageView!
   
    
    @IBOutlet weak var dataLabel: UILabel!
    
   
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
    
    
    //加载内容图片（并设置高度约束）
    func loadImage(urlString: String) {
        //定义NSURL对象
        let url = URL(string: urlString)
        let data = try? Data(contentsOf: url!)
        //从网络获取数据流,再通过数据流初始化图片
        if let imageData = data, let image = UIImage(data: imageData) {
            //计算原始图片的宽高比
            let aspect = image.size.width / image.size.height
            //设置imageView宽高比约束
            aspectConstraint = NSLayoutConstraint(item: contentImageView,
                                                  attribute: .width, relatedBy: .equal,
                                                  toItem: contentImageView, attribute: .height,
                                                  multiplier: aspect, constant: 0.0)
            //加载图片
            contentImageView.image = image
        }else{
            //去除imageView里的图片和宽高比约束
            aspectConstraint = nil
            contentImageView.image = nil
        }
    }
    
    
    func loadImage2(urlString: String) {
        aspectConstraint = NSLayoutConstraint(item: contentImageView,
                                              attribute: .width, relatedBy: .equal,
                                              toItem: contentImageView, attribute: .height,
                                              multiplier: 1.6666666, constant: 0.0)
        contentImageView.sd_setImage(with: URL(string: urlString as! String), placeholderImage: UIImage(named: "loading.png"), options: .retryFailed, completed: { (image, error, cacheType, imageURL) in
            
        })
        
        
    }
    
    
}
