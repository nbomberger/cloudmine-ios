//
//  CMFile.h
//  cloudmine-ios
//
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//  See LICENSE file included with SDK for details.
//

#import "CMSerializable.h"

@class CMUser;

@interface CMFile : NSObject <CMSerializable>

@property (atomic, strong, readonly) NSData *fileData;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, readonly) NSURL *cacheLocation;
@property (nonatomic, strong) CMUser *user;
@property (nonatomic, strong) NSString *mimeType;

- (id)initWithData:(NSData *)theFileData named:(NSString *)theName;
- (id)initWithData:(NSData *)theFileData named:(NSString *)theName belongingToUser:(CMUser *)theUser mimeType:(NSString *)theMimeType;

- (BOOL)isUserLevel;
- (BOOL)writeToLocation:(NSURL *)url options:(NSFileWrapperWritingOptions)options;
- (BOOL)writeToCache;

@end
