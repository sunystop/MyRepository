//
//  ViewController.m
//  RTMPTestDemo
//
//  Created by 苏晗 on 2017/8/11.
//  Copyright © 2017年 MapGoo. All rights reserved.
//

#import "ViewController.h"
#import "MGPlayerViewController.h"
#import <Masonry.h>

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"RTMP测试";
    
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.placeholder = @"请输入RTMP地址";
    _textField.font = [UIFont systemFontOfSize:15.f];
    _textField.text = @"rtmp://183.62.138.141/myapp/19695";
    [self.view addSubview:_textField];
    
    //rtmp://183.62.138.141/myapp/19695
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(100);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.height.mas_offset(44);
    }];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.backgroundColor = [UIColor colorWithRed:0.2863 green:0.5490 blue:0.9255 alpha:1];
    playButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playButton setTitle:@"播放" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    playButton.layer.masksToBounds = YES;
    playButton.layer.cornerRadius = 4;
    
    [self.view addSubview:playButton];
    
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textField.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(_textField.mas_left);
        make.right.mas_equalTo(_textField.mas_right);
        make.height.mas_equalTo(_textField.mas_height);
    }];
}

- (void)playButtonAction:(UIButton *)button
{
    MGPlayerViewController *playerVC = [[MGPlayerViewController alloc] initWithRTMPURL:self.textField.text];
    [self presentViewController:playerVC animated:YES completion:nil];
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
