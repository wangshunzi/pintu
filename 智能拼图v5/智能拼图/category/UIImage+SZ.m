//
//  UIImage+SZ.m
//  智能拼图
//
//  Created by mac on 14-5-25.
//  Copyright (c) 2014年 shunzi. All rights reserved.
//

#import "UIImage+SZ.h"

@implementation UIImage (SZ)
- (NSArray *)createSubImageWithCount:(NSInteger)count
{
 
        
    
    // 计算列数
    int columnRow = (int)sqrt(count);
    CGFloat imageW = self.size.width / columnRow;
    CGFloat imageH = self.size.height / columnRow;
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        CGFloat imageX = (i % columnRow) * imageW;
        CGFloat imageY = (i / columnRow) * imageH;
        CGImageRef subCGImage = CGImageCreateWithImageInRect([self CGImage], CGRectMake(imageX, imageY, imageW, imageH));
        UIImage *subImage = [UIImage imageWithCGImage:subCGImage];
        CGImageRelease(subCGImage);
        [imageArray addObject:subImage];
    }
        
    
    
    return imageArray;
       
  
}
@end
