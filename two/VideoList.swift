//
//  VideoList.swift
//
//  Created by 舒吉 on 2017/11/7
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class VideoList: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let video2 = "video_2"
    static let video1 = "video_1"
  }

  // MARK: Properties
  public var video2: Video2?
  public var video1: Video1?

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
    video2 = Video2(json: json[SerializationKeys.video2])
    video1 = Video1(json: json[SerializationKeys.video1])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = video2 { dictionary[SerializationKeys.video2] = value.dictionaryRepresentation() }
    if let value = video1 { dictionary[SerializationKeys.video1] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.video2 = aDecoder.decodeObject(forKey: SerializationKeys.video2) as? Video2
    self.video1 = aDecoder.decodeObject(forKey: SerializationKeys.video1) as? Video1
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(video2, forKey: SerializationKeys.video2)
    aCoder.encode(video1, forKey: SerializationKeys.video1)
  }

}
