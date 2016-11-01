//
//  InfoWindowController.m
//  ReviseAppInfo
//
//  Created by cxh on 16/10/13.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "InfoWindowController.h"

@interface InfoWindowController ()

@end

@implementation InfoWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.title = @"ipa改包";
    
    self.window.acceptsMouseMovedEvents = YES;//鼠标拖拽
    [self.window setReleasedWhenClosed:NO];//设置关闭时不释放
    NSSize size = NSMakeSize(400, 330);
    self.window.maxSize = size;
    self.window.minSize = size;
    [self.window setContentSize:size];
    [self.window center];
    
}

@end
