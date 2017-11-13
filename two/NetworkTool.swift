//
//  NetworkTool.swift
//  two
//
//  Created by shuji on 2017/10/23.
//  Copyright © 2017年 shuji. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsDetailImage {
    
    var url: String?
    
    var width: Int?
    
    var height: Int?
    
    var rate: CGFloat = 1
    
    init(dict: [String: AnyObject]) {
        url = dict["url"] as? String
        height = dict["height"] as? Int
        width = dict["width"] as? Int
        rate = CGFloat(width!) / CGFloat(height!)
    }
}

class RealVideo {
    
    var status: Int?
    
    var user_id: String?
    
    var video_id: String?
    
    var validate: Int?
    
    var enable_ssl: Bool?
    
    var video_duration: Float?
    
    var video_list: [String: AnyObject]?
    
    var video_1: Video?  // 360p
    var video_2: Video?  // 480p
    var video_3: Video?  // 720p
    
    init(dict: [String: AnyObject]) {
        status = dict["status"]  as? Int
        user_id = dict["user_id"] as? String
        video_id = dict["video_id"] as? String
        validate = dict["validate"] as? Int
        enable_ssl = dict["enable_ssl"] as? Bool
        video_duration = dict["video_duration"] as? Float
        video_list = dict["video_list"] as? [String: AnyObject]
        if let viddeo1 = video_list!["video_1"] {
            video_1 = Video(dict: viddeo1 as! [String: AnyObject])
        }
        if let viddeo2 = video_list!["video_2"] {
            video_2 = Video(dict: viddeo2 as! [String: AnyObject])
        }
        if let viddeo3 = video_list!["video_3"] {
            video_3 = Video(dict: viddeo3 as! [String: AnyObject])
        }
    }
    
}

class Video {
    
    var preload_interval: Int?
    
    var preload_max_step: Int?
    
    var preload_min_step: Int?
    
    var preload_size: Int?
    
    var socket_buffer: Int?
    
    var user_video_proxy: Int?
    
    var vheight: Int?
    var vwidth: Int?
    
    var size: Int?
    
    var vtype: String?
    
    var main_url: String? /// 用 base 64 加密的视频真实地址
    var backup_url_1: String?
    
    init(dict: [String: AnyObject]) {
        preload_interval = dict["preload_interval"] as? Int
        preload_max_step = dict["preload_max_step"] as? Int
        preload_min_step = dict["preload_min_step"] as? Int
        preload_size = dict["preload_size"] as? Int
        socket_buffer = dict["socket_buffer"] as? Int
        user_video_proxy = dict["user_video_proxy"] as? Int
        socket_buffer = dict["socket_buffer"] as? Int
        vheight = dict["vheight"] as? Int
        vwidth = dict["vwidth"] as? Int
        size = dict["size"] as? Int
        vtype = dict["vtype"] as? String
        
        if let mainURL = dict["main_url"] {
            let decodeData = NSData(base64Encoded:mainURL as! String, options:NSData.Base64DecodingOptions(rawValue: 0))
            main_url = NSString(data: decodeData! as Data, encoding: String.Encoding.utf8.rawValue) as String?
        }
    }
}


protocol NetworkToolProtocol {
    static func loadCommenNewDatail(URL: String , Handler:@escaping(_ htmlString:String,_ images:[NewsDetailImage],_ adstracts: [String])->())
    
    static  func parseVideoRealURL(video_id: String, completionHandler:@escaping (_ realVideo: RealVideo)->())
    
    
}

class NetworkTool:NetworkToolProtocol
{
    class func loadCommenNewDatail(URL: String , Handler:@escaping(_ htmlString:String,_ images:[NewsDetailImage],_ adstracts: [String])->())
    {
        // 测试数据
        Alamofire.request(URL).responseString { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                var images = [NewsDetailImage]()
                var abstracts = [String]()
                var htmlString = String()
                if value.contains("BASE_DATA.galleryInfo =") { // 则是图文详情
                    // 获取 图片链接数组
                    let startIndex = value.range(of: "\"sub_images\":")!.upperBound
                    let endIndex = value.range(of: ",\"max_img_width\"")!.lowerBound
                    let range = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
                    let BASE_DATA = value.substring(with: range)
                    let data = BASE_DATA.data(using: String.Encoding.utf8)! as Data
                    let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [AnyObject]
                    for image in dict! {
                        let img = NewsDetailImage(dict: image as! [String: AnyObject])
                        images.append(img)
                    }
                    // 获取 子标题
                    let titleStartIndex = value.range(of: "\"sub_abstracts\":")!.upperBound
                    let titlEndIndex = value.range(of: ",\"sub_titles\"")!.lowerBound
                    let titleRange = Range(uncheckedBounds: (lower: titleStartIndex, upper: titlEndIndex))
                    let sub_abstracts = value.substring(with: titleRange)
                    let titleData = sub_abstracts.data(using: String.Encoding.utf8)! as Data
                    let subAbstracts = try? JSONSerialization.jsonObject(with: titleData, options: .mutableContainers) as! [String]
                    for string in subAbstracts! {
                        abstracts.append(string)
                    }
                } else if value.contains("articleInfo: ") { // 一般的新闻
                    // 获取 新闻内容
                    let startIndex = value.range(of: "content: '")!.upperBound
                    let endIndex = value.range(of: "'.replace")!.lowerBound
                    let range = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
                    let content = value.substring(with: range)
                    let contentDecode = NetworkTool.htmlDecode(content: content)
                    /// 创建 html
                    var html = "<!DOCTYPE html>"
                    html += "<html>"
                    html += "<head>"
                    html += "<meta charset=utf-8>"
                    html += "<meta content='width=device-wdith,initial-scale=1.0,maximum-scale=3.0,user-scalabel=0;' name='viewport' />"
                    html += "<link rel=\"stylesheet\" type=\"text/css\" href=\"news.css\" />\n"
                    html += "</head>"
                    html += "<body>"
                    html +=  contentDecode
                    html += "</body>"
                    html += "<div></div>"
                    html += "</html>"
                    htmlString = html
                } else { // 第三方的新闻内容
                    /// 这部分显示还有问题
                    htmlString = value
                }
                Handler(htmlString, images, abstracts)
            }
        }
        
    }
    
    
    
    /// 解析视频的真实链接
    class func parseVideoRealURL(video_id: String, completionHandler:@escaping (_ realVideo: RealVideo)->()) {
        let r = arc4random() // 随机数
        let url: NSString = "/video/urls/v/1/toutiao/mp4/\(video_id)?r=\(r)" as NSString
        let data: NSData = url.data(using: String.Encoding.utf8.rawValue)! as NSData
        var crc32: UInt64 = UInt64(data.getCRC32()) // 使用 crc32 校验
        if crc32 < 0 { // crc32 的值可能为负数
            crc32 += 0x100000000
        }
        // 拼接
        let realURL = "http://i.snssdk.com/video/urls/v/1/toutiao/mp4/\(video_id)?r=\(r)&s=\(crc32)"
        Alamofire.request(realURL).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                
                let videos = VideoBean.init(json: json)
                
                print(videos.data?.videoList?.video1?.mainUrl as! String)
                let dict = json["data"].dictionaryObject
                let video = RealVideo(dict: dict! as [String : AnyObject])
                completionHandler(video)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    /// 转义字符
    class func htmlDecode(content: String) -> String {
        var s = String()
        s = content.replacingOccurrences(of: "&amp;", with: "&")
        s = s.replacingOccurrences(of: "&lt;", with: "<")
        s = s.replacingOccurrences(of: "&gt;", with: ">")
        s = s.replacingOccurrences(of: "&nbsp;", with: " ")
        s = s.replacingOccurrences(of: "&#39;", with: "\'")
        s = s.replacingOccurrences(of: "&quot;", with: "\"")
        s = s.replacingOccurrences(of: "<br>", with: "\n")
        return s
    }
    
}


