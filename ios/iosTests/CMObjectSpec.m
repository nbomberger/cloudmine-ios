//
//  CMObjectSpec.m
//  cloudmine-iosTests
//
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//  See LICENSE file included with SDK for details.
//

#import "Kiwi.h"

#import "CMObject.h"
#import "CMGenericSerializableObject.h"
#import "SPLowVerbosity.h"

@interface CMGenericSerializableObjectWithAdditionalMethods : CMGenericSerializableObject
- (id)someCalc;
@end

SPEC_BEGIN(CMObjectSpec)

describe(@"CMObject", ^{
    context(@"when encoding itself", ^{
        it(@"serializes all object and primitive properties using NSCoder", ^{
            CMGenericSerializableObject *originalObject = [[CMGenericSerializableObject alloc] init];
            [originalObject fillPropertiesWithDefaults];
            id mockCoder = [NSCoder mock];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.string1, @"string1"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.string2, @"string2"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:$num(originalObject.simpleInt), @"simpleInt"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.arrayOfBooleans, @"arrayOfBooleans"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.nestedObject, @"nestedObject"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.date, @"date"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.objectId, @"__id__"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:[[originalObject class] className], @"__class__"];
            
            [originalObject encodeWithCoder:mockCoder];
        });
        
        it(@"serializes the values of custom methods that are not linked to properties", ^{
            CMGenericSerializableObjectWithAdditionalMethods *originalObject = [[CMGenericSerializableObjectWithAdditionalMethods alloc] init ];
            id mockCoder = [NSCoder mock];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.string1, @"string1"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.string2, @"string2"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:$num(originalObject.simpleInt), @"simpleInt"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.arrayOfBooleans, @"arrayOfBooleans"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.nestedObject, @"nestedObject"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.date, @"date"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:originalObject.objectId, @"__id__"];
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:[[originalObject class] className], @"__class__"];
            
            // why does this not throw an error when the method isn't called?
            [mockCoder expect:@selector(encodeObject:forKey:) withArguments:[originalObject someCalc], @"approximatePi"];
            
            [originalObject encodeWithCoder:mockCoder];
        });
    });
});

SPEC_END

@implementation CMGenericSerializableObjectWithAdditionalMethods
- (id)someCalc {
    return [NSNumber numberWithFloat:3.14];
}
- (NSDictionary *)additionalMethodsForSerialization {
    return $dict(@"approximatePi", @selector(someCalc));
}
@end