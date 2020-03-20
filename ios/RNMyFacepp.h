
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

@interface RNMyFacepp : NSObject <RCTBridgeModule>

@property (nonatomic, weak) UIViewController* rootViewController;    //  引导页提示文本颜色

+(instancetype) shareInstance ;

-(void)checkMyFaceLicense;

-(void)showCheckMessage;

@end
  
