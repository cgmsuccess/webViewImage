//
//  ImageReadViewController.h
//  简单的图片浏览器的封装
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGM_ImageReadViewController : UIViewController

// index  是scrcollview  contenoffset  如果不设置偏移，就为 输入0  ,

-(instancetype)initWithImageArr:(NSMutableArray *)sourArr AndIndex:(NSInteger)Index;

@end
