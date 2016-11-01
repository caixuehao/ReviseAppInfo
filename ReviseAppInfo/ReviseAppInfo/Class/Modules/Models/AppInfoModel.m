//
//  appInfoModel.m
//  ReviseAppInfo
//
//  Created by cxh on 16/10/14.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "AppInfoModel.h"
#import <Objective-Zip.h>
#import <ZipArchive.h>

@implementation AppInfoModel{
    NSString* appPath;
}

-(instancetype)init{
    if (self = [super init]) {
        _unzipPath  =[[self getSavePath] stringByAppendingPathComponent:@"unzip"];
        BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:_unzipPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        if (!bo) NSLog(@"文件夹创建失败！");
    }
    return self;
}

-(void)setPath:(NSString *)path{
    _path = path;
    NSLog(@"%@",path);
    [self readFile];
}


    



-(void)readFile{
    OZZipFile *unzipFile = [[OZZipFile alloc] initWithFileName:_path mode:OZZipFileModeUnzip];
    [unzipFile goToFirstFileInZip];
    [unzipFile goToNextFileInZip];
    //读取info.plist
    
    NSString* path = [unzipFile getCurrentFileInZipInfo].name;
    
    NSRange range = [path rangeOfString:@"/"];
    appPath = [path substringToIndex:range.location+1];
    NSString* substr = [path substringFromIndex:range.location+1];
    range = [substr rangeOfString:@"/"];
    appPath =[appPath stringByAppendingString:[substr substringToIndex:range.location]];
 
    
    path = [appPath stringByAppendingPathComponent:@"Info.plist"];
    [unzipFile locateFileInZip:path];
    
    OZFileInZipInfo *info= [unzipFile getCurrentFileInZipInfo];
    OZZipReadStream *read= [unzipFile readCurrentFileInZip];
    NSMutableData *data= [[NSMutableData alloc] initWithLength:info.length];
    [read readDataWithBuffer:data];
    
    _infoPath = [self getSavePath];
     _infoPath = [_infoPath stringByAppendingPathComponent:@"info.plist"];
    [data writeToFile:_infoPath atomically:YES];
    NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:_infoPath];
    
    _name = [dic objectForKey:@"CFBundleDisplayName"]?[dic objectForKey:@"CFBundleDisplayName"]:[dic objectForKey:@"CFBundleName"];
    _bundleId = [dic objectForKey:@"CFBundleIdentifier"];
    _version = [dic objectForKey:@"CFBundleShortVersionString"];
    _build = [dic objectForKey:@"CFBundleVersion"];

    
    //读取icon
    NSString* iconFilePath = @"";
    NSInteger maxSize = 0;
    NSArray *infos= [unzipFile listFileInZipInfos];
    for (OZFileInZipInfo *info in infos) {
        NSInteger size = [self isAppIconFile:info.name];
        if(size>maxSize){
            maxSize = size;
            iconFilePath = info.name;
        }
    }
    
    [unzipFile locateFileInZip:iconFilePath];
    info= [unzipFile getCurrentFileInZipInfo];
    read= [unzipFile readCurrentFileInZip];
    data= [[NSMutableData alloc] initWithLength:info.length];
    [read readDataWithBuffer:data];
    _iconImage = [[NSImage alloc] initWithData:data];
    //关闭zip文件
    [unzipFile close];
}



-(void)UnZip{
    [SSZipArchive unzipFileAtPath:_path toDestination:_unzipPath];
}

-(void)CreateZip{
    NSString* path  = [_unzipPath stringByAppendingPathComponent:appPath];
    path = [path stringByAppendingPathComponent:@"Info.plist"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];

    [dic setValue:_name forKey:@"CFBundleDisplayName"];
    [dic setValue:_bundleId forKey:@"CFBundleIdentifier"];
    [dic setValue:_version forKey:@"CFBundleShortVersionString"];
    [dic setValue:_build forKey:@"CFBundleVersion"];
    [dic writeToFile:path atomically:YES];

    path = [_unzipPath stringByAppendingPathComponent:@"Payload"];
    [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:@".DS_Store"] error:nil];
    
    [SSZipArchive createZipFileAtPath: _path withContentsOfDirectory:path keepParentDirectory:YES];
    
}




//判断是否是图标
-(NSInteger)isAppIconFile:(NSString*)filePath{
    NSString* fileName = [filePath lastPathComponent];
    if (fileName.length>12&&[[fileName substringToIndex:7] isEqualToString:@"AppIcon"]&&[[fileName substringFromIndex:fileName.length-4] isEqualToString:@".png"]) {
        NSRange range = [fileName rangeOfString:@"x"];
        NSString* str = [fileName substringWithRange:NSMakeRange(7, range.location-7)];
        NSInteger size = [str integerValue];
        NSInteger scale = 1;
        range = [fileName rangeOfString:@"@"];
        if (range.location!=NSNotFound) {
            scale = [[fileName substringWithRange:NSMakeRange(range.location+1, 1)] integerValue];
        }
        
//        NSLog(@"%lu",size*scale);
        return size*scale;
    }
    return 0;
}


-(NSString*)getSavePath{
    //百度QQ的用户信息都放在这里所以我参考了一下/Users/cxh/Library/Containers
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Containers"];
    path = [path stringByAppendingPathComponent:@"ReviseAppInfo"];
    return path;
}

@end
