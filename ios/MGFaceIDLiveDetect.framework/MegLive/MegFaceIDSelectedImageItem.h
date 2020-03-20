//
//  MegFaceIDSelectedImageItem.h
//  MegLive
//
//  Created by MegviiDev on 2017/8/30.
//  Copyright © 2017年 megvii. All rights reserved.
//

#ifndef MegFaceIDSelectedImageItem_h
#define MegFaceIDSelectedImageItem_h
#include <stdio.h>
#include <string>
#include <vector>
#include "MGFaceIDQualityFrameRectItem.h"
#include "MegFaceIDConfig.h"

typedef struct MegFaceIDImageItem {
    int image_width;
    int image_height;
    std::vector<char> jpeg;
    std::vector<std::string> image_names;
    std::string image_sha1;
} MegFaceIDImageItem;

typedef struct MegFaceIDSelectedImageDetailItem {
    float face_quality;
    RelativeRect face_rect;
    int image_width;
    int image_height;
    std::vector<std::string> image_names;
    MegFaceIDImageType image_type;
    std::vector<unsigned char> image_info;
} MegFaceIDSelectedImageDetailItem;

typedef struct MegFaceIDSelectedImageItem {
    float face_quality;
    RelativeRect face_rect;
    MegFaceIDImageItem face_image;
} MegFaceIDSelectedImageItem;

typedef struct MegFaceIDImage{
    int image_width;
    int image_height;
    const char* image_data;
    int image_size;
    MegFaceIDImageType image_type;
} MegFaceIDImage;

#endif /* MegFaceIDSelectedImageItem_h */
