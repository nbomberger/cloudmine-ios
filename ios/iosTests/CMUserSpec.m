//
//  CMUserSpec.m
//  cloudmine-iosTests
//
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//  See LICENSE file included with SDK for details.
//

#import "Kiwi.h"
#import "SPLowVerbosity.h"

#import "CMUser.h"
#import "CMWebService.h"
#import "CMAPICredentials.h"
#import "CMObjectEncoder.h"

@interface CustomUser : CMUser
@property (strong) NSString *name;
@property (assign) int age;
@end

@implementation CustomUser
@synthesize name, age;
@end

SPEC_BEGIN(CMUserSpec)

describe(@"CMUser", ^{
    [[CMAPICredentials sharedInstance] setAppSecret:@"appSecret"];
    [[CMAPICredentials sharedInstance] setAppIdentifier:@"appIdentifier"];

    context(@"given a username and password", ^{
        it(@"should record both in memory and return them when the getters are accessed", ^{
            CMUser *user = [[CMUser alloc] initWithUserId:@"someone@domain.com" andPassword:@"pass"];
            [[user.userId should] equal:@"someone@domain.com"];
            [[user.password should] equal:@"pass"];
            [user.token shouldBeNil];
        });
    });

    context(@"given a session token", ^{
        it(@"should no longer maintain a copy of the password", ^{
            CMUser *user = [[CMUser alloc] initWithUserId:@"someone@domain.com" andPassword:@"pass"];
            user.token = @"token";
            
            [[user.userId should] equal:@"someone@domain.com"];
            [user.password shouldBeNil];
            [[user.token should] equal:@"token"];
        });
    });

    context(@"given a clean instance of a CMUser subclass", ^{
        __block CustomUser *user = [[CustomUser alloc] initWithUserId:@"marc@cloudmine.me" andPassword:@"pass"];

        beforeEach(^{
            [user setValue:[CMWebService nullMock] forKey:@"webService"];
            
            // Setting these two values should not make the object dirty because it hasn't been persisted remotely yet.
            user.name = @"Marc";
            user.age = 24;
        });

        it(@"should not be dirty", ^{
            [[theValue(user.isDirty) should] beNo];
        });
        
        it(@"should become dirty if properties are changed after a save and no other object changes have occured server-side", ^{
            KWMock *mockWebService = [user valueForKey:@"webService"];
            KWCaptureSpy *callbackBlockSpy = [mockWebService captureArgument:@selector(saveUser:callback:) atIndex:1];
            [[mockWebService should] receive:@selector(saveUser:callback:)];
            
            [user save:^(CMUserAccountResult resultCode, NSArray *messages) {
                [user setValue:@"1234" forKey:@"objectId"];
            }];
            
            CMWebServiceUserAccountOperationCallback callback = callbackBlockSpy.argument;
            NSDictionary *userState = [[CMObjectEncoder encodeObjects:$set(user)] objectForKey:user.objectId];
            callback(CMUserAccountProfileUpdateSucceeded, userState);
            
            // Object has just been saved, so it should not be dirty.
            [[theValue(user.isDirty) should] beNo];
            
            // Make a change to the object.
            user.name = @"Derek";
            
            // It should be dirty.
            [[theValue(user.isDirty) should] beYes];
        });
    });
});

SPEC_END
