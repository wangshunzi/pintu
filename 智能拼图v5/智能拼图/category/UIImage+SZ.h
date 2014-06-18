//
//  UIImage+SZ.h
//  智能拼图
//
//  Created by mac on 14-5-25.
//  Copyright (c) 2014年 shunzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SZ)
/**
 *  将一个图片平均切成count片;
 *
 *  @param count 切成多少片
 *
 *  @return 图片数组
 */
- (NSArray *)createSubImageWithCount:(NSInteger)count;




@end
