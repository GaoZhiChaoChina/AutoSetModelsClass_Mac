//
//  ViewController.m
//  AutoSetModelsClass
//
//  Created by gaozhichao on 2016/12/8.
//  Copyright © 2016年 gaozhicao. All rights reserved.
//

#import "ViewController.h"
#import "FFUtility.h"
#import <AddressBook/AddressBook.h>

@interface ViewController ()

@property (weak, readwrite) IBOutlet NSTextField *baseClassName;
@property (weak, readwrite) IBOutlet NSTextView *h_File;
@property (weak, readwrite) IBOutlet NSTextView *m_File;
@property (weak, readwrite) IBOutlet NSTextField *urlRequestString;
@property (weak, readwrite) IBOutlet NSTextView *jsonStringTextView;
@property (strong) FFUtility *utility;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.utility = [FFUtility new];
    ABAddressBook *ha = [ABAddressBook  sharedAddressBook];
    
    ABPerson *haha = [ha me];
    NSArray *hahhahah = haha.parentGroups;
    
    // Do any additional setup after loading the view.
}



//override func appendCopyrights()
//{
//    if let me = ABAddressBook.shared()?.me(){
//        fileContent += "//\n//\t\(self.className).\(lang.headerFileData.headerFileExtension!)\n"
//        if let firstName = me.value(forProperty: kABFirstNameProperty as String) as? String{
//            fileContent += "//\n//\tCreate by \(firstName)"
//            if let lastName = me.value(forProperty: kABLastNameProperty as String) as? String{
//                fileContent += " \(lastName)"
//            }
//        }
//        
//        
//        fileContent += " on \(getTodayFormattedDay())\n//\tCopyright © \(getYear())"
//        
//        if let organization = me.value(forProperty: kABOrganizationProperty as String) as? String{
//            fileContent += " \(organization)"
//        }
//        
//        fileContent += ". All rights reserved.\n//\n\n"
//        fileContent += "//\tModel file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport\n\n"
//    }
//    
//    
//


- (IBAction)ButtonClick:(id)sender {
    
//    NSArray *array  = [[FFUtility sharedFFUtility] setbaseClassName:self.baseClassName.stringValue  setJsonData:self.jsonStringTextView.string setJsonUrl:self.urlRequestString.stringValue];
    
    [self.utility setbaseClassName:self];

//    self.h_File.string = array[0];
//    self.m_File.string = array[1];
}
- (IBAction)saveFile:(id)sender {
    
    [self.utility mac_writeDataModeToFile];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
