//
//  ViewController.m
//  WebViewImage
//
//  Created by apple on 17/5/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"

#import "CGM_ImageReadViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    //https://www.nkbjx.com/cn_xc_news/webpage/getNewsDetaild?id=11066
    //http://192.168.1.204:8080/cn_xc_news/webpage/getNewsDetaild?id=11066
    
    
    // [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.204:8080/cn_xc_news/webpage/getNewsDetaild?id=6549"]]];
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.delegate =self;
    
    [self.view addSubview:webView];


}

/*
 
 //js方法遍历图片添加点击事件 返回所有图片
 static  NSString * const jsGetImages =
 @"function getImages(){\
 var srcs = [];\
 var objs = document.getElementsByTagName(\"img\");\
 for(var i=0;i<objs.length;i++){\
 srcs[i] = objs[i].src;\
 };\
 for(var i=0;i<objs.length;i++){\
 objs[i].onclick=function(){\
 document.location=\"myweb:imageClick:\"+srcs+','+this.src;\
 };\
 };\
 return objs.length;\
 };";
 
 
 */

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    
    //js方法遍历图片添加点击事件 返回所有图片
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var srcs = [];\
    var objs = document.getElementById(\"content\").getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    srcs[i] = objs[i].src;\
    };\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+srcs+','+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    //    document.location=\"myweb:imageClick:\"+srcs+','+this.src;\  注册点击事件，这里在 shouldStartLoadWithRequest 拿到 所有的图片 srcs， 和获点击图片的那个一个图片this.src
 
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str = request.URL.absoluteString;
    
    if ([str hasPrefix:@"myweb:imageClick:"]) {
        str = [str stringByReplacingOccurrencesOfString:@"myweb:imageClick:"
                                             withString:@""];
        NSArray * imageUrlArr = [str  componentsSeparatedByString:@","];
        NSLog(@"imageUrlArr = %@" ,imageUrlArr) ;
        
        NSString *iamgeUrl = [imageUrlArr lastObject] ;
        NSUInteger index =  [imageUrlArr indexOfObject:iamgeUrl];
        
        NSMutableArray *muArr= [NSMutableArray arrayWithArray:imageUrlArr];
        [muArr removeLastObject];  //移除最后一个元素
        
        CGM_ImageReadViewController *readImageCtrl=[[CGM_ImageReadViewController alloc] initWithImageArr:muArr AndIndex:index];
        [self.navigationController pushViewController:readImageCtrl animated:YES];
    }
    
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
