//
//  NSString+SCategory.m
//  
//
//  Created by TFT_SuHan on 15/4/21.
//  Copyright (c) 2015年 MapGoo. All rights reserved.
//

#import "NSString+SCategory.h"

@implementation NSString (SCategory)

/** 直接传入精度丢失有问题的Double类型*/
+ (NSString *)decimalNumberWithDouble:(double)conversionValue
{
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}


// 计算字符串宽度
- (CGSize)boundingRectWithSize:(CGSize)contentSize andFont:(UIFont *)font
{
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [self boundingRectWithSize:contentSize
                                      options: NSStringDrawingTruncatesLastVisibleLine |
                                               NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingUsesFontLeading
                                   attributes:attribute
                                      context:nil].size;
    return size;
}


// 检测字符串中是否有空白符和换行符
- (BOOL)isWhitespaceAndNewlines
{
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

// URL 编码
- (id)urlEncoded
{
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (CFStringRef)self,NULL,
                                                                             (CFStringRef)@"!#$%&'()*+,/:;=?@[]",kCFStringEncodingUTF8);
    
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString *)cfUrlEncodedString];
    CFRelease(cfUrlEncodedString);
    return urlEncoded;
}

// 移除string中所有的HTML标签
- (NSString*)stringByRemovingHTMLTags
{
    NSString *regexStr =@"<[^>]+>";
    
    NSError* error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSString *result = [regex stringByReplacingMatchesInString:self
                                                       options:0
                                                         range:NSMakeRange(0, self.length)
                                                  withTemplate:@""];
    
    return result;
}

// 验证字符串是否为空
- (BOOL)isNotNil
{
    if (self == nil || (id)self == [NSNull null] || [self isEqualToString:@""] || [self isEqualToString:@" "])
        return NO;
    
    return YES;
}

//去掉两边空格
-(NSString *)TrimString
{
    if (self == nil || [self isEqual:[NSNull null]])
    {
        return  @"";
    }
    
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

//把带有中文字符的转换格式
+(NSString *)MGStringFormatURLEncode:(NSString *)pStr, ...
{
    va_list ap;
    va_start(ap, pStr);
    NSString *title = [[NSString alloc]initWithFormat:pStr arguments:ap];
    va_end(ap);
    
    return [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)numberSuitScan:(NSString*)number
{
    //首先验证是不是手机号码
    NSString *MOBILE = @"^[0-9]*$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    BOOL isOk = [regextestmobile evaluateWithObject:number];
    
    if (isOk && number.length == 11) {//如果是手机号码的话
        
        NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        
        return numberString;
    }
    
    return number;
    
}

// 检查是否是URL
- (BOOL)isValidUrl
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)self,
                                                                                                    (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                                    NULL,
                                                                                                    kCFStringEncodingUTF8));
    return encodedString;
}
@end


