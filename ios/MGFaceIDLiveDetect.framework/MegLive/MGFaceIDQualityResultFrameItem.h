//
//  MGFaceIDQualityResultFrameItem.h
//  MegLive
//
//  Created by MegviiDev on 2017/9/4.
//  Copyright © 2017年 megvii. All rights reserved.
//

#ifndef MGFaceIDQualityResultFrameItem_h
#define MGFaceIDQualityResultFrameItem_h
#include "MGFaceIDQualityFrameRectItem.h"

class MGFaceIDQualityResultFrameItem {
public:
    ///  综合图片质量
    float face_quality;
    ///  人脸位置
    RelativeRect face_rect;
    MGFaceIDQualityResultFrameItem(){};
    MGFaceIDQualityResultFrameItem(float quality, RelativeRect rect):face_quality(quality), face_rect(rect) {};
};

#endif /* MGFaceIDQualityResultFrameItem_h */
