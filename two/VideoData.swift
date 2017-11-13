//
//  Data.swift
//
//  Created by 舒吉 on 2017/11/7
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class VideoData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let validate = "validate"
    static let status = "status"
    static let videoId = "video_id"
    static let videoDuration = "video_duration"
    static let enableSsl = "enable_ssl"
    static let userId = "user_id"
    static let posterUrl = "poster_url"
    static let videoList = "video_list"
  }

  // MARK: Properties
  public var validate: String?
  public var status: Int?
  public var videoId: String?
  public var videoDuration: Float?
  public var enableSsl: Bool? = false
  public var userId: String?
  public var posterUrl: String?
  public var videoList: VideoList?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    validate = json[SerializationKeys.validate].string
    status = json[SerializationKeys.status].int
    videoId = json[SerializationKeys.videoId].string
    videoDuration = json[SerializationKeys.videoDuration].float
    enableSsl = json[SerializationKeys.enableSsl].boolValue
    userId = json[SerializationKeys.userId].string
    posterUrl = json[SerializationKeys.posterUrl].string
    videoList = VideoList(json: json[SerializationKeys.videoList])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = validate { dictionary[SerializationKeys.validate] = value }
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = videoId { dictionary[SerializationKeys.videoId] = value }
    if let value = videoDuration { dictionary[SerializationKeys.videoDuration] = value }
    dictionary[SerializationKeys.enableSsl] = enableSsl
    if let value = userId { dictionary[SerializationKeys.userId] = value }
    if let value = posterUrl { dictionary[SerializationKeys.posterUrl] = value }
    if let value = videoList { dictionary[SerializationKeys.videoList] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.validate = aDecoder.decodeObject(forKey: SerializationKeys.validate) as? String
    self.status = aDecoder.decodeObject(forKey: SerializationKeys.status) as? Int
    self.videoId = aDecoder.decodeObject(forKey: SerializationKeys.videoId) as? String
    self.videoDuration = aDecoder.decodeObject(forKey: SerializationKeys.videoDuration) as? Float
    self.enableSsl = aDecoder.decodeBool(forKey: SerializationKeys.enableSsl)
    self.userId = aDecoder.decodeObject(forKey: SerializationKeys.userId) as? String
    self.posterUrl = aDecoder.decodeObject(forKey: SerializationKeys.posterUrl) as? String
    self.videoList = aDecoder.decodeObject(forKey: SerializationKeys.videoList) as? VideoList
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(validate, forKey: SerializationKeys.validate)
    aCoder.encode(status, forKey: SerializationKeys.status)
    aCoder.encode(videoId, forKey: SerializationKeys.videoId)
    aCoder.encode(videoDuration, forKey: SerializationKeys.videoDuration)
    aCoder.encode(enableSsl, forKey: SerializationKeys.enableSsl)
    aCoder.encode(userId, forKey: SerializationKeys.userId)
    aCoder.encode(posterUrl, forKey: SerializationKeys.posterUrl)
    aCoder.encode(videoList, forKey: SerializationKeys.videoList)
  }

}
