//
//  FFUtility.h
//  Cloud
//
//  Created by gaozhichao on 16/8/5.
//  Copyright © 2016年 gaozhichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

/**
 Synthsize a weak or strong reference.
 
 Example:
 weakObj(self)
 [self doSomething^{
 strongObj(self)
 ...
 }];
 
 */
#ifndef weakObj
#if __has_feature(objc_arc)
#define weakObj(object)  __weak __typeof__(object) weak##_##object = object;
#else
#define weakObj(object)  __block __typeof__(object) block##_##object = object;
#endif
#endif

#ifndef strongObj
#if __has_feature(objc_arc)
#define strongObj(object)  __typeof__(object) object = weak##_##object; if(!object) return;
#else
#define strongObj(object)  __typeof__(object) object = block##_##object; if(!object) return;
#endif
#endif


@interface FFUtility : NSObject
+ (instancetype)sharedFFUtility;

/**
 *  直接传入对象，方便取值
 */
- (NSArray *)setbaseClassName:(id)classFile;

/**
 *  /自动生成mode文件（有返回值）
 *
 *  @param classNameString 文件类名
 *  @param jsonData   json数据
 *  @param jsonUrl    请求的Url
 *  @return 输出的 .h .m文件内容
 */
- (NSArray *)setbaseClassName:(NSString *)classNameString setJsonData:(NSString *)jsonData setJsonUrl:(NSString *)jsonUrl;

/**
 *  获取mac桌面地址（IOS应用）
 *
 *  @return mac主机地址
 */
/***/
+ (NSString *)getMacHomeDirectorInIOS;

/**
  mac 应用保存文件到电脑桌面
**/
- (void)mac_writeDataModeToFile;
/**
  iOS 应用保存文件到电脑桌面
**/
- (void)ios_writeDataModeToFile;
@end
