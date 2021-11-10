
#import <Foundation/Foundation.h>
#include "firebase_cloud_messaging_plugin"
#include "firebase_cloud_messaging.h"
#include "core/engine.h"


void firebase_cloud_messaging_init() {
    FirebaseCloudMessaging *instance = memnew(FirebaseCloudMessaging);
    Engine::get_singleton()->add_singleton(Engine::Singleton("FirebaseCloudMessaging", instance));
}

void firebase_cloud_messaging_deinit() {
    FirebaseCloudMessaging* instance = FirebaseCloudMessaging.get_instance();
    if (instance) {
        memdelete(instance);
    }
}
