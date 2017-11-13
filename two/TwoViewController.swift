//
//  TwoViewController.swift
//  two
//
//  Created by shuji on 2017/10/12.
//  Copyright © 2017年 shuji. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import Alamofire
import BMPlayer
import NVActivityIndicatorView
class TwoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var tableView:UITableView?
    
    var cell_photos:[String]!
    var cell_title:[String]!
 
    var video_id:[String]!
    
    
    /// 播放数量
    var playCount: [String]!
    /// 时间 label
    var time:[String]!
   
    /// 用户头像
    var head: [String]!
    var headCover: [String]!
    /// 用户昵称
    var name: [String]!
    /// 关注数量
    var concern: [String]!
    /// pingluncishu
    var comment:[String]!
    
    var head_images:[String]!
    
    
    
    
    fileprivate lazy var player = BMPlayer()
    
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         
                self.title = "视频"
                self.view.backgroundColor = UIColor.black
        
                self.tableView = UITableView(frame: self.view.frame, style:.plain)
                self.tableView!.delegate = self
                self.tableView!.dataSource = self
        
        
        
                self.tableView!.estimatedRowHeight = 100
                self.tableView!.rowHeight = UITableViewAutomaticDimension
        
                self.tableView!.register(UINib(nibName:"VideoTopicCell", bundle:nil),
                                 forCellReuseIdentifier:"myCell")
        
        
        
                self.view.addSubview(self.tableView!)
        
                // 下拉刷新
                header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
                // 现在的版本要用mj_header
                self.tableView!.mj_header = header
                 
        
                // 上拉刷新
                footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh))
                self.tableView!.mj_footer = footer
        
                refreshItemData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 顶部刷新
   @objc func headerRefresh(){
        print("下拉刷新")
    
    if self.player.isPlaying {
        self.player.removeFromSuperview()
        
    }
        self.loadHomeCategoryNewsFeed(tag: 0)
    
    
    }
    
    // 底部刷新
    
   @objc func footerRefresh(){
        print("上拉刷新")
    
    if self.player.isPlaying {
        self.player.removeFromSuperview()
    }
        self.loadHomeCategoryNewsFeed(tag: 1)
    }
    

    //在本例中，只有一个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cell_title.count
        
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
         
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell",
                                                      for: indexPath) as! VideoTopicCell
            cell.titleLabel.text = self.cell_title[indexPath.row]
           
            cell.loadImage2(urlString: self.cell_photos[indexPath.row])
            
            cell.nameLable.text = self.name[indexPath.row]
            
            cell.playCountLabel.text = self.playCount[indexPath.row]
            
          
            cell.commentButton.setTitle(String(describing: self.comment[indexPath.row]), for: .normal)
          
            cell.timeLabel.text = self.time[indexPath.row]
            
            cell.bgImageButton.addTarget(self, action:#selector(tapped(_:)), for:.touchUpInside)
            
            cell.headButton.sd_setBackgroundImage(with: URL(string: self.head_images[indexPath.row] as! String), for: UIControlState.normal)
            
            cell.headButton.layer.cornerRadius = 15
            
            cell.headButton.layer.masksToBounds = true
            
            
            return cell
    }
    
    
    
    @objc func tapped(_ button:UIButton){
        let btn = button as! UIButton
        let cell = superUITableViewCell(of: btn)!
        let indexPath = self.tableView!.indexPath(for: cell)
        
        
        if self.player.isPlaying {
            self.player.removeFromSuperview()
           
        }
        
        
        self.player = BMPlayer(customControlView: BMPlayerCustomControlView())
        button.addSubview(self.player)
        BMPlayerConf.allowLog = false
        BMPlayerConf.tintColor = UIColor.white
        BMPlayerConf.topBarShowInCase = .none
        BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
        self.player.snp.makeConstraints { (make) in
            make.edges.equalTo(button)
        }
        /// 获取视频的真实链接
        NetworkTool.parseVideoRealURL(video_id: self.video_id[indexPath!.row]) { (realVideo) in
            self.player.backBlock = { (isFullScreen) in
                if isFullScreen == true {
                    return
                }
            }
            
            cell.titleLabel.isHidden = true
            cell.timeLabel.isHidden = true
            cell.playCountLabel.isHidden = true
            
            let asset = BMPlayerResource(url: URL(string: realVideo.video_1!.main_url!)!, name: self.cell_title[indexPath!.row])
            
            self.player.setVideo(resource: asset)
            
        }
       
    
    }
    
 
    func superUITableViewCell(of: UIButton) -> VideoTopicCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? VideoTopicCell {
                return cell
            }
        }
        return nil
    }
    
    /// 重置播放器
    fileprivate func resetPlayerManager() {
        BMPlayerConf.allowLog = false
        BMPlayerConf.shouldAutoPlay = true
        BMPlayerConf.tintColor = UIColor.white
        BMPlayerConf.topBarShowInCase = .always
        BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
    }
    
    
    func loadHomeCategoryNewsFeed(tag:Int){
        let url = "https://is.snssdk.com/api/news/feed/v58/?"
        let params = ["device_id": "6096495334",
                      "category": "video",
                      "iid": "5034850950",
                      "device_platform": "iphone",
                      "version_code": "6.2.7"]
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard let dataJSONs = json["data"].array else {
                    return
                }
                for data in dataJSONs {
                    if let content = data["content"].string {
                        let contentData: NSData = content.data(using: String.Encoding.utf8)! as NSData
                        do {
                            let dict = try JSONSerialization.jsonObject(with: contentData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                            print(dict)
                            
                            let title = dict["title"] as? String
                            
                            let video_id = dict["video_id"] as? String
                            let behot_time = dict["behot_time"] as? Int64
                            let publish_time = dict["publish_time"] as?  Int64
                            let comment_count = dict["comment_count"] as?  Int
                            let read_count = dict["read_count"] as? Int
                            let time = dict["video_duration"] as? Int
                            
                            
                            var media_name:String!
                            var head_image_url:String!
                            var image_url:String!
                            if let imageList = dict["large_image_list"] as? [AnyObject] {
                                for item in imageList {
                                    image_url = (item["url"] as? String)
                                    
                                    image_url = image_url.replacingOccurrences(of: ".webp", with: "")
                                    
                                    break
                                }
                            }
                            
                            if let headimageList = dict["media_info"] as? [String: AnyObject]{
                                head_image_url = headimageList["avatar_url"] as? String
                                media_name = headimageList["name"] as? String
                                
                            }
                            
                            if(tag == 0)
                            {
                                self.cell_title.insert(title!,at: 0)
                                
                                self.name.insert(media_name!,at: 0)
                                
                                self.video_id.insert(video_id!,at: 0)
                                
                                let comment_string = String(comment_count!)
                                
                                let read_count = String(read_count!)
                                
                                self.playCount.insert(read_count + "次播放 ", at: 0)
                                
                                self.comment.insert(comment_string + "评论 ", at: 0)
                                
                                self.time.insert(self.video_duration(time: time!), at: 0)
                                
                                self.head_images.insert(head_image_url, at: 0)
                                
                                self.cell_photos.insert(image_url, at: 0)
                            }else
                            {
                                self.cell_title.append(title!)
                                self.name.append(media_name!)
                                self.video_id.append(video_id!)
                                let comment_string = String(comment_count!)
                                self.cell_photos.append(image_url)
                                
                                
                                let read_count = String(read_count!)
                                
                                self.playCount.append(read_count + "次播放 ")
                                
                                self.comment.append(comment_string + "评论 ")
                                
                                
                                self.time.append(self.video_duration(time: time!))
                                
                                self.head_images.append(head_image_url)
                                
                               
                                

                            }
                            
                        
                            
                            
                        } catch {
                            
                        }
                    }
                }
                
                self.tableView!.mj_header.endRefreshing()
                self.tableView!.mj_footer.endRefreshing()
                self.tableView!.reloadData()
            }
            
        }
        
        
        
        
    }
    
    //初始化数据
    func refreshItemData() {
        cell_photos=[]
        cell_title=[]
        video_id=[]
        playCount=[]
        time=[]
        head=[]
        headCover=[]
        name=[]
        concern=[]
        comment=[]
        head_images=[]
        
        self.loadHomeCategoryNewsFeed(tag: 0)
        
    }
    
    
    func sayTo(publicTime:Int64) -> String{
        
        //创建时间
        var createDate: Date?
        let timeStamp = publicTime
        print("时间戳：\(timeStamp)")
        
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        
        
        createDate = Date(timeIntervalSince1970: timeInterval)
        
        
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "zh_CN")
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //当前时间
        let now = Date()
        //日历
        let calender = Calendar.current
        let comps: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: createDate!, to: now)
        
        guard (createDate?.isThisYear())! else { // 今年
            fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return fmt.string(from: createDate!)
        }
        if (createDate?.isYesterday())! { // 昨天
            fmt.dateFormat = "昨天 HH:mm";
            return fmt.string(from: createDate!)
        } else if (createDate?.isToday())! {
            if comps.hour! >= 1 {
                return String(format: "%.d小时前", comps.hour!)
            } else if comps.minute! >= 1 {
                return String(format: "%d分钟前", comps.minute!)
            } else {
                return "刚刚";
            }
        } else {
            fmt.dateFormat = "MM-dd HH:mm";
            return fmt.string(from: createDate!)
        }
    }
    var videoDuration: Int?
    func video_duration(time: Int )->String {
        /// 格式化时间
      
        let hour = time / 3600
        let minute = (time / 60) % 60
        let second = time % 60
        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        return String(format: "%02d:%02d", minute, second)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do here
        print("You deselected cell #\(indexPath.row)!")
        print(self.cell_title[indexPath.row] + "---")
      
        
        
    }
    
    
    
    
}

