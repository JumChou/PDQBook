//
//  NSDictionary+NullHandled.h
//  Softphone
//
//  Created by Mr.Chou on 14/12/9.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullHandled)


/**
 *  NSNull处理 替换为@""
 *
 *  @param dictionary 需处理的字典
 *
 *  @return 处理后的字典
 */
+ (NSDictionary *)nullObjHandledDictWithDict:(NSDictionary *)dictionary;


@end
