//
//  NSString+SCategory.h
//  
//
//  Created by TFT_SuHan on 15/4/21.
//  Copyright (c) 2015年 MapGoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SCategory)

/** 直接传入精度丢失有问题的Double类型*/
+ (NSString *)decimalNumberWithDouble:(double)conversionValue;


/**
 *  计算字符串宽度
 *
 *  @param contentSize CGSzie
 *  @param font 字体
 *
 *  @return 返回一个CGSzie
 */
- (CGSize)boundingRectWithSize:(CGSize)contentSize andFont:(UIFont *)font;

/**
 *  检测字符串中是否有空白符和换行符
 *
 *  @return BOOL
 */
- (BOOL)isWhitespaceAndNewlines;

/**
 *  URL Encode
 *
 *  @return NSString
 */
- (NSString *)urlEncoded;

/**
 *  移除string中所有的HTML标签
 *
 *  @return NSString
 */
- (NSString *)stringByRemovingHTMLTags;

/**
 *  验证字符串是否为空 为空返回NO 不为空为YES
 *
 *  @return BOOL
 */
- (BOOL)isNotNil;

/**
 *去掉字符串两头的空格
 *
 *
 */
-(NSString *)TrimString;
/*
 *把带有中文字符的转换格式
 *
 */
+(NSString *)MGStringFormatURLEncode:(NSString *)pStr, ...;

/** 
 隐藏手机号中间4位
 */
+ (NSString *)numberSuitScan:(NSString*)number;

// 检查是否是URL
- (BOOL)isValidUrl;

- (NSString *)URLEncodedString;
@end
