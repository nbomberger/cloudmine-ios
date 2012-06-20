//
//  CMFile.h
//  cloudmine-ios
//
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//  See LICENSE file included with SDK for details.
//

#import "CMSerializable.h"
#import "CMObjectOwnershipLevel.h"

@class CMUser;
@class CMStore;

@interface CMFile : NSObject <CMSerializable>

@property (atomic, strong, readonly) NSData *fileData;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, readonly) NSURL *cacheLocation;
@property (nonatomic, strong) CMUser *user;
@property (nonatomic, strong) NSString *mimeType;

/**
 * The store that the file belongs to. If you have not explicitly assigned this file to a store, it
 * will automatically belong to CMStore#defaultStore.
 *
 * If you manually change the store yourself, this file will automatically remove itself from the old
 * store and add it to the new store. <b>This operation is thread-safe.</b>
 */
@property (nonatomic, unsafe_unretained) CMStore *store;

/**
 * The ownership level of this object. This reflects whether the object is app-level, user-level, or unknown.
 * @see CMObjectOwnershipLevel
 */
@property (nonatomic, readonly) CMObjectOwnershipLevel ownershipLevel;

- (id)initWithData:(NSData *)theFileData named:(NSString *)theName;
- (id)initWithData:(NSData *)theFileData named:(NSString *)theName belongingToUser:(CMUser *)theUser mimeType:(NSString *)theMimeType;

- (BOOL)isUserLevel;
- (BOOL)writeToLocation:(NSURL *)url options:(NSFileWrapperWritingOptions)options;
- (BOOL)writeToCache;

@end
