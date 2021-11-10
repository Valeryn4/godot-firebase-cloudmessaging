//
//  godot_plugin_implementation.h
//  godot_plugin
//
//  Created by Sergey Minakov on 14.08.2020.
//  Copyright © 2020 Godot. All rights reserved.
//

#pragma once

#include "core/object.h"
#include "firebase_cloud_messaging_delegate.h"

class FirebaseCloudMessaging : public Object {
    GDCLASS(FirebaseCloudMessaging, Object);
    
    static void _bind_methods();

    String token;
    Dictionary message;

    static FirebaseCloudMessaging* instance;
    static FCMDelegate* fcm_delegate;
public:
    String get_token();
    Dictionary get_message();

    FirebaseCloudMessaging();
    ~FirebaseCloudMessaging();
    
    void token_received(String t);
    void message_received(Dictionary m);

    static FirebaseCloudMessaging* get_instance();
};




