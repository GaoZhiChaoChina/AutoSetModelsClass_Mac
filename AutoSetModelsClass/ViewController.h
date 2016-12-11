//
//  ViewController.h
//  AutoSetModelsClass
//
//  Created by gaozhichao on 2016/12/8.
//  Copyright © 2016年 gaozhicao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak, readonly) IBOutlet NSTextField *baseClassName;
@property (weak, readonly) IBOutlet NSTextView *h_File;
@property (weak, readonly) IBOutlet NSTextView *m_File;
@property (weak, readonly) IBOutlet NSTextField *urlRequestString;
@property (weak, readonly) IBOutlet NSTextView *jsonStringTextView;
@end

