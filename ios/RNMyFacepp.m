
#import "RNMyFacepp.h"
#import <React/RCTLog.h>
#import <MGFaceIDBaseKit/MGFaceIDBaseKit.h>
#import <MGFaceIDLiveDetect/MGFaceIDLiveDetect.h>
#import <MGFaceIDIDCardKit/MGFaceIDIDCardKit.h>
#import <MGFaceIDIDCardKernelKit/MGFaceIDIDCardKernelKit.h>
#import "MBProgressHUD.h"

@interface RNMyFacepp ()

@property (nonatomic,copy) RCTResponseSenderBlock callBackCopy;

@end

@implementation RNMyFacepp


static RNMyFacepp* _instance = nil;

#pragma mark -- init net check
-(void) checkMyFaceLicense{
    
}


+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}


RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initFaceIDCardLicense)
{
    RCTLogInfo(@"Test initFaceSdk");

    NSLog(@"version:%@", [MGFaceIDIDCardManager getSDKVersion]);
    if (![MGFaceIDLicenseManager isLicense:[MGFaceIDIDCardManager getSDKLicenseVersion]]) {
        [MGFaceIDLicenseManager licenseForNetworkWithVersion:[MGFaceIDIDCardManager getSDKLicenseVersion]
                                                      result:^(BOOL isLicense) {
                                                          NSLog(@"FaceID身份证检测授权:%@", isLicense ? @"成功" : @"失败");
                                                      }];
    }
}

//身份证检测
RCT_EXPORT_METHOD(startIdCardDetectShootPage:(NSUInteger)page CallBack:(RCTResponseSenderBlock)callback){
    [[RNMyFacepp shareInstance] setCallBackCopy:callback];
    NSString* sdkVersion = [MGFaceIDIDCardManager getSDKVersion];
    NSLog(@"version:%@",sdkVersion);
    if (![MGFaceIDLicenseManager isLicense:[MGFaceIDIDCardManager getSDKLicenseVersion]]) {
    [MGFaceIDLicenseManager licenseForNetworkWithVersion:[MGFaceIDIDCardManager getSDKLicenseVersion] result:^(BOOL isLicense) {
        NSLog(@"FaceID身份证检测授权:%@", isLicense ? @"成功" : @"失败");
        if(isLicense){
            [[RNMyFacepp shareInstance] startIDCardSthootPage:page];
        }
        
    }];
    }else{
        [[RNMyFacepp shareInstance] startIDCardSthootPage:page];
    }
}

-(void)startIDCardSthootPage:(NSInteger)page{
    MGFaceIDIDCardErrorItem* errorItem;
    MGFaceIDIDCardManager* idcardManager = [[MGFaceIDIDCardManager alloc] initMGFaceIDIDCardManagerWithExtraData:nil error:&errorItem];
    if (errorItem && !idcardManager) {
//        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[[[RNMyFacepp shareInstance] rootViewController]view] animated:YES];
//        [hud setMode:MBProgressHUDModeText];
        NSString* errorMessageStr = [NSString stringWithFormat:@"身份证检测启动失败\n失败原因:%@", errorItem.errorMessage];
//        [hud.label setText:errorMessageStr];
//        [hud.label setNumberOfLines:2];
//        [hud hideAnimated:YES afterDelay:2];
        
        [[RNMyFacepp shareInstance] showCheckMessage:errorMessageStr];
        return;
    }
    MGFaceIDIDCardConfigItem* configItem = [[MGFaceIDIDCardConfigItem alloc] init];
    [idcardManager startMGFaceIDIDCardDetect:[RNMyFacepp shareInstance].rootViewController
                           screenOrientation:MGFaceIDIDCardScreenOrientationVertical
                                   shootPage:page
                                detectConfig:configItem
                                    callback:^(MGFaceIDIDCardErrorItem *errorItem, MGFaceIDIDCardDetectItem *detectItem, NSDictionary *extraOutDataDict) {
                                        if (!errorItem || errorItem.errorType == MGFaceIDIDCardErrorNone) {
                                            
                                                NSData *data = UIImageJPEGRepresentation(detectItem.idcardImageItem.idcardImage,90);
                                                NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//                                                encodedImageStr = [@"data:image/jpeg;base64," stringByAppendingString:encodedImageStr];
                                                [RNMyFacepp shareInstance].callBackCopy(@[[NSNull null],encodedImageStr]);
                                        }
                                    }];
}


//活体识别
RCT_EXPORT_METHOD(startLiveDetect:(NSString*)bizToken detectResolver:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)
{
    MGFaceIDLiveDetectError* error;
    MGFaceIDLiveDetectManager* detectManager = [[MGFaceIDLiveDetectManager alloc] initMGFaceIDLiveDetectManagerWithBizToken:bizToken
                                                                                                                   language:MGFaceIDLiveDetectLanguageCh
                                                                                                                networkHost:@"https://api.megvii.com"
                                                                                                                  extraData:nil
                                                                                                                      error:&error];
    if (error || !detectManager) {
        [self showCheckMessage:error.errorMessageStr];
    }
    //  可选方法-当前使用默认值
    {
        MGFaceIDLiveDetectCustomConfigItem* customConfigItem = [[MGFaceIDLiveDetectCustomConfigItem alloc] init];
        [detectManager setMGFaceIDLiveDetectCustomUIConfig:customConfigItem];
        [detectManager setMGFaceIDLiveDetectPhoneVertical:MGFaceIDLiveDetectPhoneVerticalFront];
    }
    
    [detectManager startMGFaceIDLiveDetectWithCurrentController:[RNMyFacepp shareInstance].rootViewController
                                                       callback:^(MGFaceIDLiveDetectError *error, NSData *deltaData, NSString *bizTokenStr, NSDictionary *extraOutDataDict) {
        
        if(error.errorType == MGFaceIDLiveDetectErrorNone){
            NSString * str  =[[NSString alloc] initWithData:deltaData encoding:NSUTF8StringEncoding];
            resolve(str);
        }else{
            reject(@"err",error.errorMessageStr,[NSError errorWithDomain:@"faceIDLive" code:error.errorType userInfo:nil]);
            [[RNMyFacepp shareInstance] showCheckMessage:error.errorMessageStr];
        }
    
//        NSString *blobstr =[deltaData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        NSString * str  =[[NSString alloc] initWithData:deltaData encoding:NSUTF8StringEncoding];
//                                                            [RNMyFacepp shareInstance].callBackCopy(@[[NSNull null],str]);
                                                           
                                                       }];
}

#pragma mark - showCheckMessage
- (void)showCheckMessage:(NSString *)checkMessage {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[[[RNMyFacepp shareInstance] rootViewController]view] animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = checkMessage;
        [hud hideAnimated:YES afterDelay:2];
    });
}

@end
