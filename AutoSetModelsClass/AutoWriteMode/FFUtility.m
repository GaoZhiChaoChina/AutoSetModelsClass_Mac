//
//  FFUtility.m
//  Cloud
//
//  Created by gaozhichao on 16/8/5.
//  Copyright © 2016年 gaozhichao. All rights reserved.
//

#import "FFUtility.h"
#import "AFNetworking.h"
#import <Cocoa/Cocoa.h>


#define MODE_CLASS_Foundation_Heade_h_FileName    @"#import <Foundation/Foundation.h>"
#define MODE_CLASS_Foundation_Heade_m_FileName    @"#import "

#define MODE_CLASS_H       @("\n@interface %@ :NSObject\n%@\n%@\n\n@end\n\n")
#define MODE_CLASS_M       @("@implementation %@\n\n- (instancetype)initWithDict:(NSDictionary *)dict{\n    if (self = [super init]){\n    %@\n    }\n    return self; \n}  \n\n@end\n\n")

#define MODE_PROPERTY_STRONG   @("@property (nonatomic, strong) %@ *%@;\n")
#define MODE_PROPERTY_COPY     @("@property (nonatomic,   copy) %@ *%@;\n")
#define MODE_PROPERTY_ASSIGN   @("@property (nonatomic, assign) %@ %@;\n")

//可以安全取值
//#define MODE_INITWITHDICT_UNASSIGN   @("\n      self.%@ = [NSString safeStringFromObject:[dict objectForKey:\"%@\]];\n")
//#define MODE_INITWITHDICT_ASSIGN   @("\n      self.%@ = [NSString safeStringFromObject:[dict objectForKey:\"%@\]].integerValue;\n")

#define MODE_INITWITHDICT_UNASSIGN   @("\n      self.%@ = [dict objectForKey:\"%@\"];\n")
#define MODE_INITWITHDICT_ASSIGN     @("\n      self.%@ = [dict objectForKey:\"%@\"].integerValue;\n")

#define MODE_INITWITHDICT_H   @("- (instancetype)initWithDict:(NSDictionary *)dict;")

@interface FFUtility ()
// 拼接属性字符串代码
@property (nonatomic, strong) NSMutableString *string_h;
@property (nonatomic, strong) NSMutableString *string_m;
@property (nonatomic, copy)   NSString *className;
@property (nonatomic, strong)  NSAlert *alert;
@property (nonatomic, strong)  ViewController  *viewController;



@end

@implementation FFUtility

+ (instancetype)sharedFFUtility{
    
    static FFUtility* sharedFFUtility= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFFUtility = [[self alloc] init];
    });
    return sharedFFUtility;
}

- (void)showAlertString:(NSString *)string{
    
    if (!self.alert) {
        self.alert  = [NSAlert new];
        [self.alert addButtonWithTitle:@"确定"];
        [self.alert setMessageText:@"友情提示:"];
        [self.alert setInformativeText:string];
        [self.alert setAlertStyle:NSAlertStyleInformational];
        
        [self.alert beginSheetModalForWindow:[[[NSWindow new] contentView] window] completionHandler:^(NSModalResponse returnCode) {
            if(returnCode == NSAlertFirstButtonReturn){
                NSLog(@"确定");
            }else if(returnCode == NSAlertSecondButtonReturn){
                NSLog(@"删除");
            }
        }];
    }
    return;

}

- (NSArray *)setbaseClassName:(id )classFile{
    
    self.viewController = (ViewController *)classFile;
    return  [self setbaseClassName:self.viewController.baseClassName.stringValue  setJsonData:self.viewController.jsonStringTextView.string setJsonUrl:self.viewController.urlRequestString.stringValue];
}


- (NSArray *)setbaseClassName:(NSString *)classNameString setJsonData:(NSString *)jsonDataString setJsonUrl:(NSString *)jsonUrl{
   
    self.className = classNameString;
    if (self.className == nil || self.className.length == 0) {
        [self showAlertString:@"默认基类名不能为空，请输入......"];
        return nil;
    }
    
    self.string_h = [NSMutableString new];
    self.string_m = [NSMutableString new];
    
    [self.string_m appendFormat:@"\n%@\"%@.h\"\n\n",MODE_CLASS_Foundation_Heade_m_FileName,[self.className capitalizedString]];
    
    NSArray *array = @[];
    
    if (jsonUrl.length > 0) {
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"]; // 设置content-Type为text/html
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        
//        weakObj(self);
//        [manager GET:jsonUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            strongObj(self);
//            //.h文件默认处理
//                [self.string_h appendFormat:@"\n%@\n",MODE_CLASS_Foundation_Heade_h_FileName];
//                [self.string_h appendFormat:MODE_CLASS_H,self.className,[self handleDataEngine:responseObject key:@""],MODE_INITWITHDICT_H];
//                [self.string_m appendFormat:MODE_CLASS_M,self.className,@""];
//                self.viewController.h_File.string = self.string_h;
//                self.viewController.m_File.string = self.string_m;
//            
//    //            array = @[self.string_h,self.string_m];
//    //            return array;
//         
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"%@",error);
//        }];
//
        
    }else if (jsonUrl.length == 0 && jsonDataString.length >0){
        
        NSDictionary  * dict = nil;
        if([jsonDataString hasPrefix:@"{"] && [jsonDataString hasSuffix:@"}"]){
            
            //json
            NSData  * jsonData = [jsonDataString dataUsingEncoding:NSUTF8StringEncoding];
            dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:NULL];
            
            //.h文件默认处理
            [self.string_h appendFormat:@"\n%@\n",MODE_CLASS_Foundation_Heade_h_FileName];
            [self.string_h appendFormat:MODE_CLASS_H,self.className,[self handleDataEngine:dict key:@""],MODE_INITWITHDICT_H];
            [self.string_m appendFormat:MODE_CLASS_M,self.className,@""];
                                    
        }else{
            [self showAlertString:@"json格式错误，检查一下吧"];
            return nil;

        }
        
    }else{
        [self showAlertString:@"URL 和 json 数据不能同时为空"];
        return nil;

    }
    
    self.viewController.h_File.string = self.string_h;
    self.viewController.m_File.string = self.string_m;

    array = @[self.string_h,self.string_m];
    return array;

}



- (NSString *)handleDataEngine:(id)object key:(NSString*)key{
    
    if(object){
       
        NSMutableString  * property = [NSMutableString new];
        
        if([object isKindOfClass:[NSDictionary class]]){
           
            NSDictionary  * dict = object;
            NSInteger  count = dict.count;
            NSArray  * keyArr = [dict allKeys];
            
            for (NSInteger i = 0; i < count; i++) {
                
                NSString *keyString = [keyArr[i] isEqualToString:@"id"] == YES ? @"ID":keyArr[i];
                
                id subObject = dict[keyString];
                
                if([subObject isKindOfClass:[NSDictionary class]]){
                    
                    NSString * classContent = [self handleDataEngine:subObject key:keyString];
                    //字典会新增一个mode类
                    [property appendFormat:MODE_PROPERTY_STRONG,keyString,keyString];
                    
                    [self.string_h appendFormat:MODE_CLASS_H,keyString,classContent,MODE_INITWITHDICT_H];
                    [self.string_m appendFormat:MODE_CLASS_M,keyString,@""];
                    
                }else if ([subObject isKindOfClass:[NSArray class]]){
                    
                    NSString * classContent = [self handleDataEngine:subObject key:keyString];

                    [property appendFormat:MODE_PROPERTY_STRONG,@"NSArray",keyString];

                    [self.string_h appendFormat:MODE_CLASS_H,keyString,classContent,MODE_INITWITHDICT_H];
                    [self.string_m appendFormat:MODE_CLASS_M,keyString,@""];
                    
                }else if ([subObject isKindOfClass:[NSString class]]){
                    
                    [property appendFormat:MODE_PROPERTY_COPY,@"NSString",keyString];
                    
                }else if ([subObject isKindOfClass:[NSNumber class]]){
                    
                    [property appendFormat:MODE_PROPERTY_ASSIGN,@"NSInteger",keyString];

                }else{
                    if(subObject == nil){
                        [property appendFormat:MODE_PROPERTY_COPY,@"NSString",keyString];
                        
                    }else if([subObject isKindOfClass:[NSNull class]]){
                        [property appendFormat:MODE_PROPERTY_COPY,@"NSString",keyString];

                    }
                }
            }
        }else if ([object isKindOfClass:[NSArray class]]){
            
            NSArray  * dictArr = object;
            
            NSUInteger  count = dictArr.count;
            
            if(count){
                NSObject  * tempObject = dictArr[0];
                
                for (NSInteger i = 0; i < dictArr.count; i++) {
                    NSObject * subObject = dictArr[i];
                    if([subObject isKindOfClass:[NSDictionary class]]){
                        if(((NSDictionary *)subObject).count > ((NSDictionary *)tempObject).count){
                            tempObject = subObject;
                        }
                    }
                    if([subObject isKindOfClass:[NSDictionary class]]){
                        if(((NSArray *)subObject).count > ((NSArray *)tempObject).count){
                            tempObject = subObject;
                        }
                    }
                }
                [property appendString:[self handleDataEngine:tempObject key:key]];
            }
        }else{
            NSLog(@"key = %@",key);
        }
 
        return property;
    }
    return @"";
}

- (void)mac_writeDataModeToFile{
    
    if (self.className.length == 0 || self.string_h.length == 0 || self.string_m.length == 0) {
        [self showAlertString:@"信息不全，请检查输入的必要内容"];
        return;
    }
  
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    openPanel.allowsOtherFileTypes = false;
    openPanel.treatsFilePackagesAsDirectories = false;
    openPanel.canChooseFiles = false;
    openPanel.canChooseDirectories = true;
    openPanel.canCreateDirectories = true;
    openPanel.prompt = @"Choose";
//    [openPanel beginSheetModalForWindow:[ns ] .window completionHandler:^(NSInteger result) {
//        
//        if button == NSFileHandlingPanelOKButton{
//            
//            self.saveToPath(openPanel.url!.path)
//            
//            self.showDoneSuccessfully()
//        }
//
//        
//    }];
    
    NSString *path_all;
    NSInteger result = [openPanel runModal];
    if (result == NSFileHandlingPanelOKButton)
    {
        path_all = [[openPanel URL] path];
       
        
        NSLog(@"提示===> 写入的沙盒的文件路径=:\n%@",path_all);
        //    h文件生成
        NSString *path_h =[path_all stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",[self.className capitalizedString]]];
        //创建数据缓冲
        NSMutableData *writer_h = [[NSMutableData alloc] init];
        //将字符串添加到缓冲中
        
        [writer_h appendData:[self.string_h dataUsingEncoding:NSUTF8StringEncoding]];
        [writer_h writeToFile:path_h atomically:YES];
        
        //    m文件生成
        NSString *path_m =[path_all stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",[self.className capitalizedString]]];
        NSMutableData *writer_m = [[NSMutableData alloc] init];
        [writer_m appendData:[self.string_m dataUsingEncoding:NSUTF8StringEncoding]];
        [writer_m writeToFile:path_m atomically:YES];
    }
}


//- (void)mac_writeDataModeToFile{
//    
//    // File : no 扩展名
//    // NSSavePanel *savePanel = [NSSavePanel savePanel];
//    // [savePanel runModal];
//    
//    NSSavePanel*    panel = [NSSavePanel savePanel];
//    
//    NSView *viewExt = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 180, 40)];
//    
//    NSTextField *labExt = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 10, 80, 20)];
//    
//    [labExt setBordered:NO];
//    
//    [labExt setDrawsBackground:NO];
//    
//    labExt.stringValue = @"File type: ";
//    
//    NSComboBox *cbExt = [[NSComboBox alloc] initWithFrame:NSMakeRect(80, 8, 100, 25)];
//    //[cbExt addItemsWithObjectValues:@[@".bmp", @".jpg", @".png", @".tif"]];
//    [cbExt addItemsWithObjectValues:@[@".txt"]];
//    cbExt.stringValue = @".txt";
//    
//    [viewExt addSubview:labExt];
//    
//    [viewExt addSubview:cbExt];
//    
//    [panel setAccessoryView:viewExt];
//    
//    NSInteger result = [panel runModal];
//    if (result == NSFileHandlingPanelOKButton)
//    {
//        NSString *path = [[panel URL] path];
//        
//        NSLog(@"提示===> 写入的沙盒的文件路径=:\n%@",path);
//        //    h文件生成
//        NSString *path_h =[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",[self.className capitalizedString]]];
//        //创建数据缓冲
//        NSMutableData *writer_h = [[NSMutableData alloc] init];
//        //将字符串添加到缓冲中
//        
//        [writer_h appendData:[self.string_h dataUsingEncoding:NSUTF8StringEncoding]];
//        [writer_h writeToFile:path_h atomically:YES];
//        
//        //    m文件生成
//        NSString *path_m =[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",[self.className capitalizedString]]];
//        NSMutableData *writer_m = [[NSMutableData alloc] init];
//        [writer_m appendData:[self.string_m dataUsingEncoding:NSUTF8StringEncoding]];
//        [writer_m writeToFile:path_m atomically:YES];
//        
//        
//
//    }
//   
//    
//}

- (void)ios_writeDataModeToFile{
    
    NSString *basePath=[FFUtility getMacHomeDirectorInIOS];
    basePath=[basePath stringByAppendingPathComponent:@"Desktop"];
    
    if ([FFUtility fileExistsAtPath:basePath]==NO) {
        return;
    }
    
    NSLog(@"提示===> 写入的沙盒的文件路径=:\n%@",basePath);
    //    h文件生成
    NSString *path_h =[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",[self.className capitalizedString]]];
    //创建数据缓冲
    NSMutableData *writer_h = [[NSMutableData alloc] init];
    //将字符串添加到缓冲中
    
    [writer_h appendData:[self.string_h dataUsingEncoding:NSUTF8StringEncoding]];
    [writer_h writeToFile:path_h atomically:YES];

    //    m文件生成
    NSString *path_m =[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",[self.className capitalizedString]]];
    NSMutableData *writer_m = [[NSMutableData alloc] init];
    [writer_m appendData:[self.string_m dataUsingEncoding:NSUTF8StringEncoding]];
    [writer_m writeToFile:path_m atomically:YES];
}

/**判断某文件或者文件夹是否存在*/
+ (BOOL)fileExistsAtPath:(NSString *)path{
    return [[NSFileManager defaultManager]fileExistsAtPath:path];
}

+ (NSString *)getMacHomeDirectorInIOS{
    
    if ([NSHomeDirectory() rangeOfString:@"Library/Developer"].location!=NSNotFound) {
        NSString *path=[NSHomeDirectory() substringToIndex:[NSHomeDirectory() rangeOfString:@"Library/Developer"].location];
        return [path substringToIndex:path.length-1];
    }else{
        return @"";
    }
}

- (id)yc_jsonValue:(NSString *)object {
    //把字符串转化为二进制数据
    NSData *data = [object dataUsingEncoding:NSUTF8StringEncoding];
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    return result;
}

@end
