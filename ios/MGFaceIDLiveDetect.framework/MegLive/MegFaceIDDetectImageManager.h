//
//  MegFaceIDDetectImageManager.hpp
//  MegLive
//
//  Created by MegviiDev on 2017/9/18.
//  Copyright © 2017年 megvii. All rights reserved.
//

#ifndef MegFaceIDDetectImageManager_h
#define MegFaceIDDetectImageManager_h

#include <stdio.h>
#include <vector>
#include "megface-c/image.h"
#include "MegFaceIDConfig.h"
#include "MGFaceIDQualityFrameRectItem.h"

typedef std::vector<unsigned char> bufferVct;

class MGFaceIDDetectImageManager {
    
public:
    MGFImage create_MGFImag(const void* face_image, MegFaceIDImageType image_type, int image_width, int image_height);
    unsigned char* image_transform(unsigned char* image, MegFaceIDImageType current_type, MegFaceIDImageType expect_type, int image_width, int image_height);
    int image_size(int image_width, int image_height, MegFaceIDImageType image_type);
    
    unsigned char* image_tailoring(unsigned char* image, MegFaceIDImageType image_type, int image_width, int image_height, RelativeRect face_rect, int image_expect_width, int image_expect_height);
    RelativeRect face_rect_shear(RelativeRect face_rect);
    RelativeRect face_rect_shear_zero(RelativeRect face_rect);
    RelativeRect face_rect_with_cutout(RelativeRect face_rect);
    std::string face_rect_str(RelativeRect face_rect, int image_width, int image_height);
};

#endif /* MegFaceIDDetectImageManager_h */
