//
//  CMFile.h
//  cloudmine-ios
//
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//  See LICENSE file included with SDK for details.
//

#import "CMSerializable.h"
#import "CMObjectOwnershipLevel.h"
#import "CMStoreCallbacks.h"

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

/**
 * Saves this file to CloudMine using its current store.
 * If this file does not belong to a store, the default store will be used. It will be added at the app-level. If you need to
 * associate this file with a user, see CMObject#saveWithUser:callback:.
 *
 * If this file already belongs to a store, it will be saved to the app- or user-level, whichever it was added as. For example, if it was
 * originally added to a store using CMStore#addFile: or CMStore#saveFile:: (i.e. at the app-level) it will be saved at the app-level. If it was
 * originally added using CMStore#addUserFile:callback:, CMStore#saveUserFile:callback:, or CMFile#saveWithUser:callback: (i.e. at the user-level) it will be saved
 * at the user-level.
 
 * @param callback The callback block to be invoked after the save operation has completed.
 *
 * @see CMStore#defaultStore
 */
- (void)save:(CMStoreFileUploadCallback)callback;

/**
 * Saves this file to CloudMine at the user-level associated with the given user.
 * If this file does not belong to a store, the default store will be used.
 *
 * <b>Note:</b> If this file has already been added to a store at the app-level, it cannot be later
 * saved at the user-level. You must duplicate the file, change its CMFile#objectId, and then add it
 * at the user-level.
 *
 * @param user The user to associate this file with.
 * @param callback The callback block to be invoked after the save operation has completed.
 */
- (void)saveWithUser:(CMUser *)user callback:(CMStoreFileUploadCallback)callback;

@end
