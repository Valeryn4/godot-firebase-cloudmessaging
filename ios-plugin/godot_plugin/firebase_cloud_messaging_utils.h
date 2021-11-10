#pragma once

#include <Foundation/Foundation.h>
#include "core/class_db.h"

namespace FCM 
{
    namespace Utils
    {
        static NSString* string_to_nsstring(String str);
        static String nsstring_to_string(NSString* str);

        static NSArray* array_to_nsarray(Array arr);
        static Array nsarray_to_array(NSArray* array);

        static NSDictionary* dictionary_to_nsdictionary(Dictionary dic);
        static Dictionary nsdictionary_to_dictionary(NSDictionary* dic);

        static Variant nsobject_to_variant(NSObject *object);
        static NSObject *variant_to_nsobject(Variant v);
    };
};