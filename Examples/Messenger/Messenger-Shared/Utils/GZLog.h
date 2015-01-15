//
//  GZLog.h
//  JAdditions
//
//  Created by dsjang on 13. 5. 15..
//  Copyright (c) 2013년 dsjang. All rights reserved.
//

/** 
 * @brief   Standard Consol을 통해 Logo-out 기능을 지원하는 utility class
 * @remark  출력문 기본 -> [NSLog default] +|-[class_name function_name](line_number)
 *                   -> static function 일 경우 +, 아니면 -
 *          GZLogFunc(@"%@ - %d - %f", @"test", 1, 1.1) -> [NSLog default] +|-[class_name function_name](line_number) test - 1 - 1.1
 *          GZLogFunc0()                                -> [NSLog default] +|-[class_name function_name](line_number)
 *          GZLogFunc1(@"test")                         -> [NSLog default] +|-[class_name function_name](line_number) test
 *          GZLogLine(return ture)                      -> [NSLog default] +|-[class_name function_name](line_number) return true
 *                                                      -> 입력받은 인자를 출력하고, 수행
 *          GZLogReturn(YES)                            -> [NSLog default] +|-[class_name function_name](line_number) return YES: 1
 *                                                      -> BOOL 리턴시 변수명과 값 출력
 * @author  Jang, Dong Sam.
 */

#define GZ_DEBUG

#ifdef GZ_DEBUG
#   define GZLogFunc(format,...)    NSLog(@"%s(%d) " format,__func__,__LINE__,__VA_ARGS__)
#   define GZLogFunc0()             GZLogFunc(@"%@",@"")
#   define GZLogFunc1(a)            GZLogFunc(@"%@",a)
#   define GZLogLine(a)             do{GZLogFunc(@"%s",#a); a;}while(0)
#   define GZLogReturn(a)           do{GZLogFunc(@"return %s: %d", #a, a); return a;}while(0)
#   define GZLogCGRect(rect)        GZLogFunc(@"%s: %@",#rect,NSStringFromCGRect(rect))
#   define GZLogCGSize(size)        GZLogFunc(@"%s: %@",#size,NSStringFromCGSize(size))
#   define GZLogCGPoint(point)      GZLogFunc(@"%s: %@",#point,NSStringFromCGPoint(point))
#   define GZLogUIEdgeInsets(insets)      GZLogFunc(@"%s: %@",#insets,NSStringFromUIEdgeInsets(insets))
#   define GZLogSeperator()         NSLog(@"===================");
#else
#   define GZLogFunc(format,...)
#   define GZLogFunc0()
#   define GZLogFunc1(a)
#   define GZLogLine(a) a
#   define GZLogReturn(a) return a
#   define GZLogCGRect(rect)
#   define GZLogCGSize(size)
#   define GZLogCGPoint(point)
#   define GZLogUIEdgeInsets(insets)
#   define GZLogSeperator()
#endif
