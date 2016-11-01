//
//  ViewController.m
//  ReviseAppInfo
//
//  Created by cxh on 16/10/13.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "ViewController.h"
#import <Objective-Zip.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readFile];
//    [self listingFiles];
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)readFile{
    OZZipFile *unzipFile = [[OZZipFile alloc] initWithFileName:@"/Users/cxh/Desktop/AppTest 2016-10-12 17-38-42/AppTest.ipa" mode:OZZipFileModeUnzip];
    [unzipFile goToFirstFileInZip];
//    NSArray *infos= [unzipFile listFileInZipInfos];
    [unzipFile locateFileInZip:@"Payload/AppTest.app/Info.plist"];
    OZFileInZipInfo *info= [unzipFile getCurrentFileInZipInfo];
    NSLog(@"%@",info.name);
    
    OZZipReadStream *read= [unzipFile readCurrentFileInZip];
    NSMutableData *data= [[NSMutableData alloc] initWithLength:info.length];
    [read readDataWithBuffer:data];
    NSData *xmlData = [NSData dataWithData:data];
    
    //
    NSLog(@"%@",[[NSString alloc] initWithData:xmlData encoding:4]);

}

-(void)listingFiles{
    OZZipFile *unzipFile= [[OZZipFile alloc] initWithFileName:@"/Users/cxh/Desktop/AppTest 2016-10-12 17-38-42/AppTest.ipa" mode:OZZipFileModeUnzip];
    
    NSArray *infos= [unzipFile listFileInZipInfos];
    for (OZFileInZipInfo *info in infos) {
        //        NSLog(@"- %@ %@ %llu (%d)", info.name, info.date, info.size, info.level);
        NSLog(@"%@",info.name);
        // Locate the file in the zip
        [unzipFile locateFileInZip:info.name];
        // Expand the file in memory
        OZZipReadStream *read= [unzipFile readCurrentFileInZip];
        NSMutableData *data= [[NSMutableData alloc] initWithLength:info.length];
        int bytesRead= [read readDataWithBuffer:data];
        [read finishedReading];
        
    }
}
@end
