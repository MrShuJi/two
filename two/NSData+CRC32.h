//
//  NSData+CRC32.h
//  CRC32_iOS
//
//  Created by
//  Copyright (c) 2017年 舒吉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <zlib.h>

@interface NSData (CRC32)

-(int32_t) crc_32;

-(uLong)getCRC32;

@end
