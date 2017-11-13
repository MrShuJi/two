//
//  Video2.swift
//
//  Created by 舒吉 on 2017/11/7
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Video2: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let socketBuffer = "socket_buffer"
    static let definition = "definition"
    static let vtype = "vtype"
    static let preloadMaxStep = "preload_max_step"
    static let userVideoProxy = "user_video_proxy"
    static let size = "size"
    static let vwidth = "vwidth"
    static let bitrate = "bitrate"
    static let preloadInterval = "preload_interval"
    static let logoType = "logo_type"
    static let preloadSize = "preload_size"
    static let mainUrl = "main_url"
    static let codecType = "codec_type"
    static let vheight = "vheight"
    static let backupUrl1 = "backup_url_1"
    static let preloadMinStep = "preload_min_step"
  }

  // MARK: Properties
  public var socketBuffer: Int?
  public var definition: String?
  public var vtype: String?
  public var preloadMaxStep: Int?
  public var userVideoProxy: Int?
  public var size: Int?
  public var vwidth: Int?
  public var bitrate: Int?
  public var preloadInterval: Int?
  public var logoType: String?
  public var preloadSize: Int?
  public var mainUrl: String?
  public var codecType: String?
  public var vheight: Int?
  public var backupUrl1: String?
  public var preloadMinStep: Int?

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
    socketBuffer = json[SerializationKeys.socketBuffer].int
    definition = json[SerializationKeys.definition].string
    vtype = json[SerializationKeys.vtype].string
    preloadMaxStep = json[SerializationKeys.preloadMaxStep].int
    userVideoProxy = json[SerializationKeys.userVideoProxy].int
    size = json[SerializationKeys.size].int
    vwidth = json[SerializationKeys.vwidth].int
    bitrate = json[SerializationKeys.bitrate].int
    preloadInterval = json[SerializationKeys.preloadInterval].int
    logoType = json[SerializationKeys.logoType].string
    preloadSize = json[SerializationKeys.preloadSize].int
    mainUrl = json[SerializationKeys.mainUrl].string
    codecType = json[SerializationKeys.codecType].string
    vheight = json[SerializationKeys.vheight].int
    backupUrl1 = json[SerializationKeys.backupUrl1].string
    preloadMinStep = json[SerializationKeys.preloadMinStep].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = socketBuffer { dictionary[SerializationKeys.socketBuffer] = value }
    if let value = definition { dictionary[SerializationKeys.definition] = value }
    if let value = vtype { dictionary[SerializationKeys.vtype] = value }
    if let value = preloadMaxStep { dictionary[SerializationKeys.preloadMaxStep] = value }
    if let value = userVideoProxy { dictionary[SerializationKeys.userVideoProxy] = value }
    if let value = size { dictionary[SerializationKeys.size] = value }
    if let value = vwidth { dictionary[SerializationKeys.vwidth] = value }
    if let value = bitrate { dictionary[SerializationKeys.bitrate] = value }
    if let value = preloadInterval { dictionary[SerializationKeys.preloadInterval] = value }
    if let value = logoType { dictionary[SerializationKeys.logoType] = value }
    if let value = preloadSize { dictionary[SerializationKeys.preloadSize] = value }
    if let value = mainUrl { dictionary[SerializationKeys.mainUrl] = value }
    if let value = codecType { dictionary[SerializationKeys.codecType] = value }
    if let value = vheight { dictionary[SerializationKeys.vheight] = value }
    if let value = backupUrl1 { dictionary[SerializationKeys.backupUrl1] = value }
    if let value = preloadMinStep { dictionary[SerializationKeys.preloadMinStep] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.socketBuffer = aDecoder.decodeObject(forKey: SerializationKeys.socketBuffer) as? Int
    self.definition = aDecoder.decodeObject(forKey: SerializationKeys.definition) as? String
    self.vtype = aDecoder.decodeObject(forKey: SerializationKeys.vtype) as? String
    self.preloadMaxStep = aDecoder.decodeObject(forKey: SerializationKeys.preloadMaxStep) as? Int
    self.userVideoProxy = aDecoder.decodeObject(forKey: SerializationKeys.userVideoProxy) as? Int
    self.size = aDecoder.decodeObject(forKey: SerializationKeys.size) as? Int
    self.vwidth = aDecoder.decodeObject(forKey: SerializationKeys.vwidth) as? Int
    self.bitrate = aDecoder.decodeObject(forKey: SerializationKeys.bitrate) as? Int
    self.preloadInterval = aDecoder.decodeObject(forKey: SerializationKeys.preloadInterval) as? Int
    self.logoType = aDecoder.decodeObject(forKey: SerializationKeys.logoType) as? String
    self.preloadSize = aDecoder.decodeObject(forKey: SerializationKeys.preloadSize) as? Int
    self.mainUrl = aDecoder.decodeObject(forKey: SerializationKeys.mainUrl) as? String
    self.codecType = aDecoder.decodeObject(forKey: SerializationKeys.codecType) as? String
    self.vheight = aDecoder.decodeObject(forKey: SerializationKeys.vheight) as? Int
    self.backupUrl1 = aDecoder.decodeObject(forKey: SerializationKeys.backupUrl1) as? String
    self.preloadMinStep = aDecoder.decodeObject(forKey: SerializationKeys.preloadMinStep) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(socketBuffer, forKey: SerializationKeys.socketBuffer)
    aCoder.encode(definition, forKey: SerializationKeys.definition)
    aCoder.encode(vtype, forKey: SerializationKeys.vtype)
    aCoder.encode(preloadMaxStep, forKey: SerializationKeys.preloadMaxStep)
    aCoder.encode(userVideoProxy, forKey: SerializationKeys.userVideoProxy)
    aCoder.encode(size, forKey: SerializationKeys.size)
    aCoder.encode(vwidth, forKey: SerializationKeys.vwidth)
    aCoder.encode(bitrate, forKey: SerializationKeys.bitrate)
    aCoder.encode(preloadInterval, forKey: SerializationKeys.preloadInterval)
    aCoder.encode(logoType, forKey: SerializationKeys.logoType)
    aCoder.encode(preloadSize, forKey: SerializationKeys.preloadSize)
    aCoder.encode(mainUrl, forKey: SerializationKeys.mainUrl)
    aCoder.encode(codecType, forKey: SerializationKeys.codecType)
    aCoder.encode(vheight, forKey: SerializationKeys.vheight)
    aCoder.encode(backupUrl1, forKey: SerializationKeys.backupUrl1)
    aCoder.encode(preloadMinStep, forKey: SerializationKeys.preloadMinStep)
  }

}
