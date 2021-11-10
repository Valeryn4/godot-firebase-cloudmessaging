//
//  godot_plugin_implementation.m
//  godot_plugin
//
//  Created by Sergey Minakov on 14.08.2020.
//  Copyright © 2020 Godot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <FirebaseMessaging/FirebaseMessaging.h>

#include "core/project_settings.h"
#include "core/class_db.h"
#include "godot_plugin_class.h"
#include "firebase_cloud_messaging_utils"

static String FirebaseCloudMessaging::token;
static Dictionary FirebaseCloudMessaging::message;
static FirebaseCloudMessaging* FirebaseCloudMessaging::instance = NULL;

/*
 *  Types conversion methods CPP<->ObjC
 */
using 

/*
 *  Delegate
 */

@interface MyDelegate : NSObject <FIRMessagingDelegate, UNUserNotificationCenterDelegate>

@end

@implementation MyDelegate

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(nullable NSString *)fcmToken
{
    _instance->token_received(from_nsstring(fcmToken));
}

// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;

    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
    _instance->message_received(from_nsdictionary(userInfo));
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;

    completionHandler();
    _instance->message_received(from_nsdictionary(userInfo));
}

@end


static MyDelegate* _delegate = nil;

/*
 * Bind plugin's public interface
 */
void FirebaseCloudMessaging::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_message"), &FirebaseCloudMessaging::get_message);
    ClassDB::bind_method(D_METHOD("get_token"), &FirebaseCloudMessaging::get_token);
    
    ADD_SIGNAL(MethodInfo("token"));
    ADD_SIGNAL(MethodInfo("message"));
}

FirebaseCloudMessaging::FirebaseCloudMessaging() {
    NSLog(@"Initialize FirebaseCloudMessaging");
    _instance = this;
    _delegate = [MyDelegate new];
    [FIRMessaging messaging].delegate = _delegate;
    
    UIApplication *application = UIApplication.sharedApplication;
    
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = _delegate;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
    }
    
    [application registerForRemoteNotifications];
    
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
        if (error != nil) {
            NSLog(@"Error getting FCM registration token: %@", error);
        } else {
            NSLog(@"FCM registration token: %@", token);
            _token = from_nsstring(token);
            emit_signal("token");
        }
    }];
}

FirebaseCloudMessaging::~FirebaseCloudMessaging() {
    NSLog(@"Deinitialize FirebaseCloudMessaging");
}

String FirebaseCloudMessaging::get_token() {
    return _token;
}

Dictionary FirebaseCloudMessaging::get_message() {
    return _message;
}

void FirebaseCloudMessaging::token_received(String t) {
    _token = t;
    emit_signal("token");
}

void FirebaseCloudMessaging::message_received(Dictionary m) {
    _message = m;
    emit_signal("message");
}
