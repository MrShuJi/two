//
//  OneViewController.swift
//  two
//
//  Created by shuji on 2017/10/12.
//  Copyright © 2017年 shuji. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import Alamofire
import DZNEmptyDataSet

class OneViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{

    
    var items:[String]!
    var cell_photos:[String]!
    var cell_title:[String]!
    var cell_data:[String]!
    var cell_url:[String]!
    
    var cell_data2:[String]!
    
    var cell_data3:[String]!
    var tableView:UITableView?
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.title = "主页"
        
        self.view.backgroundColor = UIColor.red;
        
        //随机生成一些初始化数据
        refreshItemData()
          //创建表视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
        self.tableView!.emptyDataSetSource = self
        self.tableView!.emptyDataSetDelegate = self
        
        
        //创建一个重用的单元格
     //   self.tableView!.register(UITableViewCell.self,
      //                           forCellReuseIdentifier: "SwiftCell")
        self.tableView!.register(UINib(nibName:"ImageTableViewCell", bundle:nil),
                                 forCellReuseIdentifier:"myCell")
        
        self.tableView!.estimatedRowHeight = 100
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        
        
        self.view.addSubview(self.tableView!)
        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.none
        //下拉刷新相关设置,使用闭包Block
        self.tableView!.mj_header = RefreshHeder(refreshingBlock: {
            print("下拉刷新.")
            
            //重现生成数据
           // self.refreshItemData()
            self.loadHomeCategoryNewsFeed(tag: 0)            //重现加载表格数据
          
            //结束刷新
           // self.tableView!.mj_header.endRefreshing()
        })
        
        //上刷新相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerLoad))
        //是否自动加载（默认为true，即表格滑到底部就自动加载）
        footer.isAutomaticallyRefresh = false
        self.tableView!.mj_footer = footer

    }
    
    
    //底部上拉加载
@objc func footerLoad(){
         print("上拉加载.")
         self.loadHomeCategoryNewsFeed(tag: 1)            //生成并添加数据
    
         //结束刷新
        // self.tableView!.mj_footer.endRefreshing()
    }
    
    
    //初始化数据
    func refreshItemData() {
        cell_photos=[]
        cell_title=[]
        cell_data=[]
        cell_url=[]
        cell_data2=[]
        cell_data3=[]
        self.loadHomeCategoryNewsFeed(tag: 0)
        
    }
    
    //在本例中，只有一个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cell_url.count
        
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
 
            
            
            let indentifier = "myCell"
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "myCell",
                                                     for: indexPath) as! ImageTableViewCell
            
          
            cell2.dataLabel.text = self.cell_data[indexPath.row] + " " + self.cell_data3[indexPath.row];      //      cell2.dataLabel2.text = self.cell_data2[indexPath.row]
      //      cell2.dataLabel3.text = self.cell_data3[indexPath.row];
            
            cell2.titleLabel.text = self.cell_title[indexPath.row]
            
            //if self.cell_photos[indexPath.row] != "null"
            //{
            cell2.loadImage2(urlString: self.cell_photos[indexPath.row])
           // }
            print(self.cell_photos[indexPath.row] + "xxxxxxxx")
            
            return cell2
    }
    
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do here
        print("You deselected cell #\(indexPath.row)!")
        let secondViewController = webViewController()
        secondViewController.detailURL = self.cell_url[indexPath.row]
      
       // self.navigationController!.pushViewController(secondViewController, animated: true)
        self.loadNewsDetail(article_url: self.cell_url[indexPath.row])
        
    }
 
    
  
    
    func loadHomeCategoryNewsFeed(tag:Int){
        let url = "https://is.snssdk.com/api/news/feed/v58/?"
        let params = ["device_id": "8800803362",
        "category": "",
        "iid": "14486549076",
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
                           // let media_name = dict["source"] as? String
                            let url = dict["url"] as? String
                            let behot_time = dict["behot_time"] as? Int64
                            let publish_time = dict["publish_time"] as?  Int64
                            let comment_count = dict["comment_count"] as?  Int

                           
                            var image_url:String!
                            if let imageList = dict["image_list"] as? [AnyObject] {
                                for item in imageList {
                                    image_url = (item["url"] as? String)
                                    
                                    image_url = image_url.replacingOccurrences(of: ".webp", with: "")
                                    
                                  
                                    
                                    
                                    print(image_url + "------")
                                    break
                                }
                            }
                            
                            var media_name:String!
                            
                            if let headimageList = dict["media_info"] as? [String: AnyObject]{
                               // head_image_url = headimageList["avatar_url"] as? String
                                media_name = headimageList["name"] as? String
                                
                            }
                            
                            if media_name == nil
                            {
                                media_name = "null"
                            }
                            
                            if(tag == 0)
                            {
                                self.cell_title.insert(title!,at: 0)
                                
                                self.cell_data.insert(media_name!,at: 0)
                                
                                self.cell_url.insert(url!,at: 0)
                                
                                let comment_string = String(comment_count!)
                                
                                self.cell_data3.insert(comment_string + "评论 " + self.sayTo(publicTime: behot_time!),at: 0)
                                if image_url == nil
                                {
                                    self.cell_photos.insert("null", at: 0)
                                }else
                                {
                                    self.cell_photos.insert(image_url, at: 0)
                                }
                                
                                
                              
                                
                                
                                
                                
                                
                                
                            }else
                            {
                                self.cell_title.append(title!)
                                
                                self.cell_data.append(media_name!)
                                
                                self.cell_url.append(url!)
                                
                                
                                let comment_string = String(comment_count!)
                                self.cell_data3.append(comment_string + "评论 " + self.sayTo(publicTime: publish_time!))
                                
                               
                                
                                
                                if image_url == nil
                                {
                                    
                                    self.cell_photos.append("null")
                                    
                                }else
                                {
                                    
                                    self.cell_photos.append(image_url)
                                }
                                
                             //    self.cell_photos.append(image_url)
                                
                            }
                           
                            
                        } catch {
                            
                        }
                    }
                }
                self.tableView!.reloadData()
                self.tableView!.mj_footer.endRefreshing()
                self.tableView!.mj_header.endRefreshing()
                
                
            }
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    var behot_time: TimeInterval?
    var create_time: TimeInterval?
    var publish_time: TimeInterval?
    var createTime: String? {
        //创建时间
        var createDate: Date?
        if let publicTime = publish_time {
            createDate = Date(timeIntervalSince1970: publicTime)
        } else if let createTime = create_time {
            createDate = Date(timeIntervalSince1970: createTime)
        } else {
            createDate = Date(timeIntervalSince1970: behot_time!)
        }
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
    
    
    
    /// 获取新闻详情
    private func loadNewsDetail(article_url: String) {
        
        NetworkTool.loadCommenNewDatail(URL: article_url, Handler: {(htmlString,images,abstracts) in
            if images.count > 0 { // 说明是图文详情
               
                
            } else { // 说明是一般的新闻
                let secondViewController = webViewController()
                secondViewController.detailURL = htmlString
                
                self.navigationController!.pushViewController(secondViewController, animated: true)
            }
        })
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "placeholder_tumblr")
    }
    
    
    
    
    
}
        

