//
//  MegFaceIDActionLiveManager.h
//  MegLive
//
//  Created by MegviiDev on 2017/8/17.
//  Copyright © 2017年 megvii. All rights reserved.
//

#ifndef MegFaceIDActionLiveManager_hpp
#define MegFaceIDActionLiveManager_hpp

#include <stdio.h>
#include "MegFaceIDActionLiveConfig.h"
#include "MGFaceIDQualityConfig.h"
#include "MegFaceIDConfig.h"
#include "MegFaceIDActionLiveActionManager.h"
#include "MegFaceIDSelectedImageItem.h"
#include "json.hpp"

namespace MegFaceIDActionLive {
    class FaceIDActionLiveManager {
        void* actionlive_worker;
    public:
        FaceIDActionLiveManagerStep _current_step;
        MGFaceIDQualityErrorType _quality_error_type;
        MegFaceIDActionLiveActionFailedType _failed_type;
        ~FaceIDActionLiveManager();
        FaceIDActionLiveManager(std::string biz_token, FaceIDActionLiveActionManager action_manager);
        bool load_model_data(const void* face_data, const void* face_landmark_data, const void* attr_data, int attr_len);
        void start_action_live_detect();
        void stop_action_live_detect();
        void reset_detect();
        void action_live_detect_image(const void* face_image, MegFaceIDImageType image_type, int image_width, int image_height);
        
        unsigned int get_current_action_index();
        MegFaceIDActionLiveActionType get_selected_action();
        float  get_detect_time();
        unsigned int get_action_count();
        unsigned int get_action_timeout();
        MegFaceIDImage get_image_best();
        
        std::vector<MegFaceIDSelectedImageItem> get_image_data(bool is_success);
        nlohmann::json get_log();
    private:
        bool _is_start_detect;
        void default_setting();
        unsigned char* create_bgr_image(const void* face_image, MegFaceIDImageType image_type, int image_width, int image_height);
        void detect_face_lookmirror(const void* face_image, MegFaceIDImageType image_type, int image_width, int image_height);
        void start_face_action(const void* face_image, MegFaceIDImageType image_type, int image_width, int image_height);
        void detect_face_action(const void* face_image, MegFaceIDImageType image_type, int image_width, int image_height);
    };
};

#endif /* MegFaceIDActionLiveManager_hpp */
