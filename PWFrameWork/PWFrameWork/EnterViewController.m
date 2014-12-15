//
//  EnterViewController.m
//
//  Created by 王宏 on 14/11/23.
//  Copyright (c) 2014年 WangHong. All rights reserved.
//


#define roundBtnRadius 35
#define roundBtnBorderWidth 1.8f

#define hollowCircle @"◦"
#define solidCircle @"●"

#define hollowCircleFontSize 60     //◦的字体大小
#define solidCircleFontSize 30   // ● 字体大小



#import "EnterViewController.h"


@interface EnterViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numbers;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *indicators;

@end

@implementation EnterViewController{
    
    //temp
    NSUInteger _numberCount;
    NSString *_secretWords;
    
    //指示器 排序数组
    NSMutableArray *_indicatorsArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _secretWords = [NSMutableString string];
    
    CGColorRef cgColor = [[UIColor whiteColor] CGColor];
    
    for (UIButton *btn in self.numbers) {
        [btn.layer setCornerRadius:roundBtnRadius];
        [btn.layer setBorderWidth:roundBtnBorderWidth];
        [btn.layer setBorderColor:cgColor];
    }
    
    [self resumeAllLabel];
    
    //对指示label排序
    NSArray *result = [_indicators sortedArrayUsingComparator:^NSComparisonResult(UILabel *obj1,UILabel  *obj2) {
        
            return [@(obj1.tag) compare:@(obj2.tag)];
    
    }];
    _indicatorsArray = [NSMutableArray arrayWithArray:result];
}

#pragma mark - 输入4位密码

- (IBAction)inputNumber:(UIButton *)sender
{
    _numberCount ++;
    
    UILabel *label = _indicatorsArray[_numberCount-1];
    [self setIndicatorForLabel:label withText:solidCircle];

    
    _secretWords = [_secretWords stringByAppendingString:[NSString stringWithFormat:@"%ld",sender.tag]];
    
    NSLog(@"%@",_secretWords);
    
    if (_numberCount == 4) {
       //验证密码
       // NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"keyWord"];
       //  1111 for debug
        
        if ([_secretWords isEqualToString:@"1111"]) {
            
            [self showViewController];
            
        }else{
            
            _numberCount = 0;
            _secretWords = @"";
            [self resumeAllLabel];
        }
        
    }
    
}

#pragma mark - 密码正确 判断是否从后台进入, 不是的话跳转到MainStoryBoard
- (void)showViewController
{
    if (_isFromBackgorund) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
    UIStoryboard *stotyb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self.view.window setRootViewController:stotyb.instantiateInitialViewController];
    }
    
}

#pragma mark - 删除上一输入字符
- (IBAction)delLastNumber:(UIButton *)sender
{
    if (_secretWords.length) {

    _secretWords = [_secretWords substringToIndex:_secretWords.length - 1];
    
    UILabel *label = _indicatorsArray[_numberCount-1];
    [self setIndicatorForLabel:label withText:hollowCircle];
        
    _numberCount --;
    }
    
}

- (void)resumeAllLabel
{
    for (UILabel *label in _indicators) {
        
    [self setIndicatorForLabel:label withText:hollowCircle];

    }
}


- (void)setIndicatorForLabel:(UILabel *)label withText:(NSString *)text
{
    if ([text isEqualToString:hollowCircle]) {
        label.font = [UIFont systemFontOfSize:hollowCircleFontSize];
        [label setText:text];
        
    }else if ([text isEqualToString:solidCircle]){
        label.font = [UIFont systemFontOfSize:solidCircleFontSize];
        [label setText:text];
        
    }
}

#pragma mark - 状态栏字体的颜色

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
