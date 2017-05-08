//
//  ImageReadViewController.m
//  简单的图片浏览器的封装
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CGM_ImageReadViewController.h"
#import "UIImageView+WebCache.h"
#define CGMwidth  [UIScreen mainScreen].bounds.size.width
#define CGMHeight  [UIScreen mainScreen].bounds.size.height


@interface CGM_ImageReadViewController ()<UIScrollViewDelegate>

{
    UILabel *label;
}

@property (nonatomic,strong)NSMutableArray *ImageArr;

@property (nonatomic,strong)UIScrollView *scorllview;

@property (nonatomic,assign)NSInteger Index;
@end

@implementation CGM_ImageReadViewController

-(NSMutableArray *)ImageArr{
    if (!_ImageArr) {
        _ImageArr =[NSMutableArray new];
    }
    return _ImageArr;
}


-(instancetype)initWithImageArr:(NSMutableArray *)sourArr AndIndex:(NSInteger)Index{
    if (self = [super init]) {
        self.ImageArr = [sourArr mutableCopy];
        _Index = Index;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor=[UIColor blackColor];
    _scorllview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGMwidth, CGMHeight)];
    _scorllview.contentOffset = CGPointMake(CGMwidth*_Index, CGMHeight);
    _scorllview.delegate=self;
    [self.view addSubview:_scorllview];
    _scorllview.contentSize = CGSizeMake(CGMwidth*self.ImageArr.count, CGMwidth);
    _scorllview.pagingEnabled = YES;
   
    label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%ld/%ld",_Index+1,self.ImageArr.count];
    [self.view addSubview:label];
    label.textColor=[UIColor whiteColor];
    
    label.frame=CGRectMake((CGMwidth-100)/2, CGMHeight-50, 100, 50);
    label.textAlignment = NSTextAlignmentCenter;
    
    
    for (int i = 0; i<self.ImageArr.count; i++) {
        //去后缀
        NSString *cutStr = self.ImageArr[i];
//        //获得宽高比
//        NSArray *cutArr = [cutStr componentsSeparatedByString:@"___"];
//        NSString *thanString;
//        if (cutArr.count==2) {
//            thanString  = cutArr.lastObject;
//        }else{
//            thanString = @"";
//        }
        
        
        
        UIImageView *imageview =[[UIImageView alloc] init];
        imageview.contentMode =UIViewContentModeScaleAspectFit;
        imageview.clipsToBounds = YES;
        
//        if (thanString.length!=0) {
//            NSLog(@"thanString = %@",thanString);
//        }else{
//            NSLog(@"dqfqefeq");
//        }
//        
        
        UIScrollView *scr =[[UIScrollView alloc] initWithFrame:CGRectMake(CGMwidth*i, 0, CGMwidth, CGMHeight)];
       
        
        imageview.frame=CGRectMake(CGMwidth/2, CGMHeight/2,0, 0);
        
        [UIView animateWithDuration:0.4f animations:^{
            imageview.frame=CGRectMake(CGMwidth/4, CGMHeight/4, CGMwidth/2, CGMHeight/2);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4f animations:^{
                
                imageview.frame=CGRectMake(0, 0, CGMwidth, CGMHeight);
            }];
        }];
        
        NSString *str = self.ImageArr.firstObject;
        //当为空的时候
        if (self.ImageArr.count==1&&str.length==0) {
                imageview.image =[UIImage imageNamed:@"ic_touxiang.png"];
        }else{

            [imageview sd_setImageWithURL:[NSURL URLWithString:self.ImageArr[i]] placeholderImage:[UIImage imageNamed:@"111111.png"] options:SDWebImageRetryFailed];
//            [imageview sd_setImageWithURL:[NSURL URLWithString:self.ImageArr[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                
//            }];
            
        }
        
        
        [scr addSubview:imageview];
        [_scorllview addSubview:scr];
        scr.delegate=self;
        scr.minimumZoomScale = 1.0f;
        scr.maximumZoomScale = 2.0f;
        scr.tag=10+i;
        
        UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
        
        UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [tap1 requireGestureRecognizerToFail:tap2];
        
        tap2.numberOfTapsRequired=2;
        [scr  addGestureRecognizer:tap2];
        [scr addGestureRecognizer:tap1];
        scr.userInteractionEnabled = YES;
        [scr  addSubview:imageview];
        imageview.backgroundColor= [UIColor blackColor];
    }
}

-(void)cilckbtn{
    
    [self.navigationController popViewControllerAnimated:NO];

}

-(void)tap1:(UITapGestureRecognizer *)tap1{
    [self.navigationController popViewControllerAnimated:NO];

}


#pragma mark 缩放相关
-(void)tap:(UITapGestureRecognizer *)tap{
    UIScrollView *scr =(UIScrollView *)tap.view;
    CGFloat zoomScale = scr.zoomScale;
    if(zoomScale<=1.0f){
        [scr setZoomScale:2.0f animated:YES];
            }else{
        [scr setZoomScale:1.0f animated:YES];
    }
}

//  缩小或者放大回调该方法， 告诉系统需要缩放的图片是哪一张
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageview=scrollView.subviews.firstObject;
    
    return imageview; // 在scrollView上的图片可以缩放;
}

// 已经缩放会自动回调该方法:
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"已经缩放%f", scale);// scale > 1是放大， scale < 1 是缩小
    if (scale < 1.0f) { // 缩小放到中心:
        view.center = CGPointMake(scrollView.frame.size.width / 2.0, scrollView.frame.size.height / 2.0);
        //        view.center = scrollView.center;
    }
}

#pragma mark UIscorllviewDelegate

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _scorllview) {
        NSInteger index = scrollView.contentOffset.x/CGMwidth;
        label.text = [NSString stringWithFormat:@"%ld/%ld",index+1,self.ImageArr.count];
        
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView == _scorllview) {
        NSInteger index = scrollView.contentOffset.x/CGMwidth;
        label.text = [NSString stringWithFormat:@"%ld/%ld",index+1,self.ImageArr.count];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
