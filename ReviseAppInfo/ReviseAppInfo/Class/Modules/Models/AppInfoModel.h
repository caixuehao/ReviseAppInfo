//
//  appInfoModel.h
//  ReviseAppInfo
//
//  Created by cxh on 16/10/14.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppInfoModel : NSObject

@property(nonatomic,strong)NSString* path;

@property(nonatomic,strong,readonly)NSString* infoPath;

@property(nonatomic,strong,readonly)NSString* unzipPath;

@property(nonatomic,strong,readonly)NSImage* iconImage;

@property(nonatomic,strong)NSString* name;

@property(nonatomic,strong)NSString* bundleId;

@property(nonatomic,strong)NSString* version;

@property(nonatomic,strong)NSString* build;



-(void)UnZip;

-(void)CreateZip;

@end
