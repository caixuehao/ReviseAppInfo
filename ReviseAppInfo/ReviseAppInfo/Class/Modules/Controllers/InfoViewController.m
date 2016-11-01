//
//  InfoViewController.m
//  ReviseAppInfo
//
//  Created by cxh on 16/10/13.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "InfoViewController.h"

#import "NSLabel.h"
#import "DragDropView.h"

#import <Masonry.h>
#import "Macro.h"

#import "AppInfoModel.h"

@interface InfoViewController ()<DragDropViewDelegate>

@end

@implementation InfoViewController{
    AppInfoModel* appInfoModel;
    
    DragDropView* dragDropView;
    
    NSLabel* iconLabel;
    NSImageView *iconImageView;
    
    NSLabel* nameLabel;
    NSTextField *nameTextField;
    
    NSLabel* bundleIdLabel;
    NSTextField *bundleIdTextField;
    
    NSLabel* versionLabel;
    NSTextField *versionTextField;
    
    NSLabel* buildLabel;
    NSTextField *buildTextField;
    
    NSButton* moreInfoButton;
    NSButton* unzipPathButton;
    NSButton* reviseButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    appInfoModel = [[AppInfoModel alloc] init];
    
    [self loadSubViews];
    [self loadActions];
}

//loadActions
-(void)loadActions{
    reviseButton.enabled = NO;
    unzipPathButton.enabled = NO;
    moreInfoButton.enabled = NO;
    
    dragDropView.delegate = self;
    [reviseButton setTarget:self];
    [unzipPathButton setTarget:self];
    [moreInfoButton setTarget:self];
    
    [moreInfoButton setAction:@selector(moreInfo)];
    [unzipPathButton setAction:@selector(unzipPath)];
    [reviseButton setAction:@selector(startRevise)];
}

-(void)moreInfo{
    [[NSWorkspace sharedWorkspace] openFile:appInfoModel.infoPath];
//    [[NSWorkspace sharedWorkspace] selectFile:fileName inFileViewerRootedAtPath:path];  // 如果只打开目录不需要选中具体文件，fileName可为nil。
}
-(void)unzipPath{
    [[NSWorkspace sharedWorkspace] openFile:appInfoModel.unzipPath];
}

-(void)startRevise{
    [appInfoModel UnZip];
    
    [reviseButton setTitle:@"压缩打包"];
    [reviseButton setAction:@selector(CreateZip)];
    
    unzipPathButton.enabled = YES;
    nameTextField.editable = YES;
    bundleIdTextField.editable = YES;
    versionTextField.editable = YES;
    buildTextField.editable = YES;
}
-(void)CreateZip{
    appInfoModel.name = nameTextField.stringValue;
    appInfoModel.bundleId = bundleIdTextField.stringValue;
    appInfoModel.version = versionTextField.stringValue;
    appInfoModel.build = buildTextField.stringValue;
    [appInfoModel CreateZip];
}
#pragma DragDropViewDelegate---
//获取的所有文件地址
-(void)dragDropViewFileList:(NSArray *)fileList sender:(DragDropView*)sender{
    appInfoModel.path = fileList[0];
    
    reviseButton.enabled = YES;
    moreInfoButton.enabled = YES;
    unzipPathButton.enabled = NO;
    
    nameTextField.editable = NO;
    bundleIdTextField.editable = NO;
    versionTextField.editable = NO;
    buildTextField.editable = NO;
    
    [reviseButton setTitle:@"解压修改"];
    [reviseButton setAction:@selector(startRevise)];
    
    
    nameTextField.stringValue = appInfoModel.name;
    bundleIdTextField.stringValue = appInfoModel.bundleId;
    versionTextField.stringValue = appInfoModel.version;
    buildTextField.stringValue = appInfoModel.build;
    iconImageView.image = appInfoModel.iconImage;
}

//loadsubViews
-(void)loadSubViews{
    dragDropView = ({
        DragDropView* drag= [[DragDropView alloc] initWithFrame:NSMakeRect(40 , 220, 140, 140)];
        [self.view addSubview:drag];
        drag;
    });
    
    iconLabel = ({
        NSLabel* label = [[NSLabel alloc] init];
        label.textAlignment = NSRightTextAlignment;
        label.backgroundColor = [NSColor clearColor];
        label.text = @"图标：";
        [self.view addSubview:label];
        label;
    });
    iconImageView = ({
        NSImageView *image = [[NSImageView alloc] init];
        image.wantsLayer = YES;
        image.layer.backgroundColor = CColor(230, 173, 20, 1).CGColor;
        image.layer.cornerRadius = 5.0;
        [self.view addSubview:image];
        image;
    });
    
    nameLabel = ({
        NSLabel* label = [[NSLabel alloc] init];
        label.textAlignment = NSRightTextAlignment;
        label.backgroundColor = [NSColor clearColor];
        label.text = @"标题：";
        [self.view addSubview:label];
        label;
    });
    nameTextField = ({
        NSTextField* textFiled = [[NSTextField alloc] init];
        textFiled.wantsLayer = YES;
        textFiled.editable = NO;
        textFiled.layer.cornerRadius = 3.0;
        [self.view addSubview:textFiled];
        textFiled;
    });
    
    
    bundleIdLabel = ({
        NSLabel* label = [[NSLabel alloc] init];
        label.textAlignment = NSRightTextAlignment;
        label.backgroundColor = [NSColor clearColor];
        label.text = @"Bundle Id：";
        [self.view addSubview:label];
        label;
    });
    bundleIdTextField = ({
        NSTextField* textFiled = [[NSTextField alloc] init];
        textFiled.wantsLayer = YES;
        textFiled.editable = NO;
        textFiled.layer.cornerRadius = 3.0;
        [self.view addSubview:textFiled];
        textFiled;
    });
    
    
    
    
    versionLabel = ({
        NSLabel* label = [[NSLabel alloc] init];
        label.textAlignment = NSRightTextAlignment;
        label.backgroundColor = [NSColor clearColor];
        label.text = @"version：";
        [self.view addSubview:label];
        label;
    });
    versionTextField = ({
        NSTextField* textFiled = [[NSTextField alloc] init];
        textFiled.wantsLayer = YES;
        textFiled.editable = NO;
        textFiled.layer.cornerRadius = 3.0;
        [self.view addSubview:textFiled];
        textFiled;
    });
    
    
    
    buildLabel = ({
        NSLabel* label = [[NSLabel alloc] init];
        label.textAlignment = NSRightTextAlignment;
        label.backgroundColor = [NSColor clearColor];
        label.text = @"build：";
        [self.view addSubview:label];
        label;
    });
    buildTextField = ({
        NSTextField* textFiled = [[NSTextField alloc] init];
        textFiled.wantsLayer = YES;
        textFiled.editable = NO;
        textFiled.layer.cornerRadius = 3.0;
        [self.view addSubview:textFiled];
        textFiled;
    });
    
    moreInfoButton = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"查看更多"];
        [self.view addSubview:btn];
        btn;
    });
    unzipPathButton = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"解压地址"];
        [self.view addSubview:btn];
        btn;
    });;
    reviseButton = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"解压修改"];
        [self.view addSubview:btn];
        btn;
    });
    
    
    //layout
    [dragDropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(@100);
        make.centerY.equalTo(iconImageView);
    }];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view).offset(100);
        make.size.mas_equalTo(NSMakeSize(100, 100));
    }];
    
    
    
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(@100);
        make.centerY.equalTo(nameTextField);
    }];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(100);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@25);
    }];
    
    
    
    [bundleIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(@100);
        make.centerY.equalTo(bundleIdTextField);
    }];
    [bundleIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(100);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@25);
    }];
    
    
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(@100);
        make.centerY.equalTo(versionTextField);
    }];
    [versionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bundleIdTextField.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(100);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@25);
    }];
    
    
    
    [buildLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(@100);
        make.centerY.equalTo(buildTextField);
    }];
    [buildTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionTextField.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(100);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@25);
    }];
    
    [moreInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(10);
        make.size.mas_equalTo(NSMakeSize(70, 20));
    }];
    [unzipPathButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(moreInfoButton.mas_bottom).offset(10);
        make.size.mas_equalTo(NSMakeSize(70, 20));
    }];
    
    [reviseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buildTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(NSMakeSize(100, 30));
    }];
}
@end
