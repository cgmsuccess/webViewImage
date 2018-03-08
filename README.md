# webViewImage
网页图片点击浏览

<a href="https://github.com/cgmsuccess/webViewImage">简单的提供思路，喜欢就送我一颗星星吧😄</a>

<h1>简单的效果图</h1>

### 具体实现还是要根据网页节点进行修正，不能一概而论，就是简单的document 操作。

![test.gif](http://upload-images.jianshu.io/upload_images/2018474-f867c6953349ede0.gif?imageMogr2/auto-orient/strip)

###  实现思路 注入js 获取节点，拿到图片，
```
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
```
