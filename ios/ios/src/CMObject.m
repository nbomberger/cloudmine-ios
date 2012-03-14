//
//  CMObject.m
//  cloudmine-ios
//
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//  See LICENSE file included with SDK for details.
//

#import "CMObject.h"
#import "NSString+UUID.h"
#import "MARTNSObject.h"
#import "RTProperty.h"

@interface CMObject (Private)
- (void)_encodeSelfWithCoder:(NSCoder *)coder;
- (void)_decodeSelfFromCoder:(NSCoder *)coder;
- (id)_serializableRepresentationOfProperty:(RTProperty *)prop;
@end

@implementation CMObject
@synthesize objectId;
@synthesize store;

#pragma mark - Initializers

- (id)init {
    return [self initWithObjectId:[NSString stringWithUUID]];
}

- (id)initWithObjectId:(NSString *)theObjectId {
    if (self = [super init]) {
        objectId = theObjectId;
        store = nil;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        objectId = [aDecoder decodeObjectForKey:CMInternalObjectIdKey];
        [self _decodeSelfFromCoder:aDecoder];
    }
    return self;
}

#pragma mark - Serialization

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.objectId forKey:CMInternalObjectIdKey];
    [self _encodeSelfWithCoder:aCoder];
}

- (NSSet *)propertySerializationOverrides {
    return [NSSet set];
}

- (NSDictionary *)additionalMethodsForSerialization {
    return [NSDictionary dictionary];
}

- (void)_encodeSelfWithCoder:(NSCoder *)coder {
    // First encode all the properties of this instance that haven't had
    // serialization disabled.
    NSArray *properties = [[self class] rt_properties];
    NSSet *propertiesWithSerializationDisabled = [self propertySerializationOverrides];
    for (RTProperty *prop in properties) {
        if (![propertiesWithSerializationDisabled containsObject:[prop name]]) {
            [coder encodeObject:[self valueForKey:[prop name]] forKey:[prop name]];
#if DEBUG
            NSLog(@"Encoding property %@ of %@.", prop, [self description]);
#endif
        }
    }
    
    // Finally encode the custom methods with the given key names.
    
}

- (void)_decodeSelfFromCoder:(NSCoder *)coder {
    NSArray *properties = [[self class] rt_properties];
    NSSet *propertiesWithSerializationDisabled = [self propertySerializationOverrides];
    for (RTProperty *prop in properties) {
        if (![propertiesWithSerializationDisabled containsObject:[prop name]]) {
            
        }
    }
}

- (id)_serializableRepresentationOfProperty:(RTProperty *)prop {
    char typeCode = [[prop typeEncoding] characterAtIndex:0];
    id serializableRepresentation = [NSNull null];
    switch (typeCode) {
        case 'c':
        case 'C':
        case 'i':
        case 's':
        case 'l':
        case 'q':
            break;
            
            // unsigned ints and shorts
        case 'I':
        case 'S':
            break;
            
            // unsigned longs
        case 'L':
        case 'Q':
            break;
            
            // floats and doubles
        case 'f':
        case 'd':
            break;
            
            // objects
        case '@':
            break;
            
            // unknown type
        default:
            break;
    }
    
    return serializableRepresentation;
}

#pragma mark - CMStore interactions

- (void)save:(CMStoreObjectUploadCallback)callback {
    NSAssert([self belongsToStore], @"You cannot save an object (%@) that doesn't belong to a CMStore.", self);
    [store saveObject:self callback:callback];
}

- (BOOL)belongsToStore {
    return (store != nil);
}

- (CMStore *)store {
    if (store && [store objectOwnershipLevel:self] == CMObjectOwnershipUndefinedLevel) {
        store = nil;
    }
    return store;
}

#pragma mark - Accessors

+ (NSString *)className {
    return NSStringFromClass(self);
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[CMObject class]] && [self.objectId isEqualToString:[object objectId]];
}

- (CMObjectOwnershipLevel)ownershipLevel {
    if (self.store != nil) {
        return [self.store objectOwnershipLevel:self];
    } else {
        return CMObjectOwnershipUndefinedLevel;
    }
}

@end
