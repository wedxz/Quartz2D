//
//  QuartzView.m
//  Quartz2DDemo
//
//  Created by vvusu on 6/16/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "QuartzView.h"

@implementation QuartzView

- (void)drawRect:(CGRect)rect {
    //1.取得图形上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    [self drawlineGraph];
//    [self drawRectWithContext:context];
//    [self drawRectByUIKitWithContext:context];
//    [self drawArc:context];
//    [self drawEllipse:context];
//    [self drawCurve:context];
//    [self drawText:context];
//    [self drawImage:context];
//    [self drawLinearGradient:context];
//    [self drawRectByUIKitWithContext2:context];
//    [self drawBackgroundWithPattern:context];
//    [self drawImageCTM:context];
//    [self drawImage2:context];
    [self refreshLabelText:context];
}

- (void)drawLine {
    //1.取得图形上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2.创建路径对象
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 20, 50);//移动到指定位置（设置路径起点）
    CGPathAddLineToPoint(path, nil, 20, 100);//绘制直线（从起始位置开始）
    CGPathAddLineToPoint(path, nil, 300, 100);//绘制另外一条直线（从上一直线终点开始绘制）
    
    
    //3.添加路径到图形上下文
    CGContextAddPath(context, path);
    
    //4.设置图形上下文状态属性
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1);//设置笔触颜色
    CGContextSetRGBFillColor(context, 0, 1.0, 0, 1);//设置填充色
    CGContextSetLineWidth(context, 2.0);//设置线条宽度
    CGContextSetLineCap(context, kCGLineCapRound);//设置顶点样式,（20,50）和（300,100）是顶点
    CGContextSetLineJoin(context, kCGLineJoinRound);//设置连接点样式，(20,100)是连接点
    /*设置线段样式
     phase:虚线开始的位置
     lengths:虚线长度间隔（例如下面的定义说明第一条线段长度8，然后间隔3重新绘制8点的长度线段，当然这个数组可以定义更多元素）
     count:虚线数组元素个数
     */
    CGFloat lengths[2] = { 18, 9 };
    CGContextSetLineDash(context, 0, lengths, 2);
    /*设置阴影
     context:图形上下文
     offset:偏移量
     blur:模糊度
     color:阴影颜色
     */
    CGColorRef color = [UIColor grayColor].CGColor;//颜色转化，由于Quartz 2D跨平台，所以其中不能使用UIKit中的对象，但是UIkit提供了转化方法
    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 0.8, color);
    
    //5.绘制图像到指定图形上下文
    /*CGPathDrawingMode是填充方式,枚举类型
     kCGPathFill:只有填充（非零缠绕数填充），不绘制边框
     kCGPathEOFill:奇偶规则填充（多条路径交叉时，奇数交叉填充，偶交叉不填充）
     kCGPathStroke:只有边框
     kCGPathFillStroke：既有边框又有填充
     kCGPathEOFillStroke：奇偶填充并绘制边框
     */
    CGContextDrawPath(context, kCGPathFillStroke);//最后一个参数是填充类型
    
    //6.释放对象
    CGPathRelease(path);
}

- (void)drawlineGraph
{
    //1.获得图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    //2.绘制路径（相当于前面创建路径并添加路径到图形上下文两步操作）
    CGContextMoveToPoint(context, 20, 50);
    CGContextAddLineToPoint(context, 20, 100);
    CGContextAddLineToPoint(context, 300, 100);
    //封闭路径:a.创建一条起点和终点的线,不推荐
    //CGPathAddLineToPoint(path, nil, 20, 50);
    //封闭路径:b.直接调用路径封闭方法
    CGContextClosePath(context);
    
    //3.设置图形上下文属性
    [[UIColor redColor]setStroke];//设置红色边框
    [[UIColor greenColor]setFill];//设置绿色填充
    //[[UIColor blueColor]set];//同时设置填充和边框色
    
    //4.绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark 绘制矩形
-(void)drawRectWithContext:(CGContextRef)context
{
    //添加矩形对象
    CGRect rect=CGRectMake(20, 50, 280.0, 50.0);
    CGContextAddRect(context,rect);
    //设置属性
    [[UIColor blueColor]set];
    //绘制
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark 绘制矩形（利用UIKit的封装方法）
-(void)drawRectByUIKitWithContext:(CGContextRef)context
{
    CGRect rect= CGRectMake(20, 150, 280.0, 50.0);
    CGRect rect2=CGRectMake(20, 250, 280.0, 50.0);
    //设置属性
    [[UIColor yellowColor]set];
    //绘制矩形,相当于创建对象、添加对象到上下文、绘制三个步骤
    UIRectFill(rect);//绘制矩形（只有填充）
    
    [[UIColor redColor]setStroke];
    UIRectFrame(rect2);//绘制矩形(只有边框)
}

#pragma mark 绘制椭圆
-(void)drawEllipse:(CGContextRef)context
{
    //添加对象,绘制椭圆（圆形）的过程也是先创建一个矩形
    CGRect rect=CGRectMake(50, 50, 220.0, 200.0);
    CGContextAddEllipseInRect(context, rect);
    //设置属性
    [[UIColor purpleColor]set];
    //绘制
    CGContextDrawPath(context, kCGPathFillStroke);
}

-(void)drawArc:(CGContextRef)context
{
    /*添加弧形对象
     x:中心点x坐标
     y:中心点y坐标
     radius:半径
     startAngle:起始弧度
     endAngle:终止弧度
     closewise:是否逆时针绘制，0则顺时针绘制
     */
    CGContextAddArc(context, 160, 160, 100.0, 0.0, M_PI_2, 1);
    
    //设置属性
    [[UIColor yellowColor]set];
    
    //绘制
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark 绘制贝塞尔曲线
-(void)drawCurve:(CGContextRef)context
{
    //绘制曲线
    CGContextMoveToPoint(context, 20, 100);//移动到起始位置
    /*绘制二次贝塞尔曲线
     c:图形上下文
     cpx:控制点x坐标
     cpy:控制点y坐标
     x:结束点x坐标
     y:结束点y坐标
     */
    CGContextAddQuadCurveToPoint(context, 160, 0, 300, 100);
    
    CGContextMoveToPoint(context, 20, 500);
    /*绘制三次贝塞尔曲线
     c:图形上下文
     cp1x:第一个控制点x坐标
     cp1y:第一个控制点y坐标
     cp2x:第二个控制点x坐标
     cp2y:第二个控制点y坐标
     x:结束点x坐标
     y:结束点y坐标
     */
    CGContextAddCurveToPoint(context, 80, 300, 240, 500, 300, 300);
    
    //设置图形上下文属性
    [[UIColor yellowColor]setFill];
    [[UIColor redColor]setStroke];
    
    //绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

#pragma mark - 绘制文字
-(void)drawText:(CGContextRef)context{
    //绘制到指定的区域内容
    NSString *str=@"Star Walk is the most beautiful stargazing app you’ve ever seen on a mobile device. It will become your go-to interactive astro guide to the night sky, following your every movement in real-time and allowing you to explore over 200, 000 celestial bodies with extensive information about stars and constellations that you find.";
    CGRect rect= CGRectMake(20, 50, 280, 300);
    UIFont *font=[UIFont systemFontOfSize:18];//设置字体
    UIColor *color=[UIColor redColor];//字体颜色
    NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init];//段落样式
    NSTextAlignment align=NSTextAlignmentLeft;//对齐方式
    style.alignment=align;
    [str drawInRect:rect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:style}];
}

#pragma mark - 绘制图像
-(void)drawImage:(CGContextRef)context{
    UIImage *image=[UIImage imageNamed:@"mm02.jpg"];
    //从某一点开始绘制
//    [image drawAtPoint:CGPointMake(10, 50)];
    //绘制到指定的矩形中，注意如果大小不合适会会进行拉伸
    [image drawInRect:CGRectMake(10, 50, 300, 450)];
    //平铺绘制
//        [image drawAsPatternInRect:CGRectMake(0, 0, 320, 568)];
}

-(void)drawImage2:(CGContextRef)context{
//    UIImage *image=[UIImage imageNamed:@"mm02.jpg"];
//    //图像绘制
//    CGRect rect= CGRectMake(10, 50, 300, 450);
//    CGContextDrawImage(context, rect, image.CGImage);
    
    //解决图片倒过来，因为坐标系不同
    UIImage *image=[UIImage imageNamed:@"mm02.jpg"];
    CGSize size=[UIScreen mainScreen].bounds.size;
    CGContextSaveGState(context);
    CGFloat height=450,y=50;
    //上下文形变
    CGContextScaleCTM(context, 1.0, -1.0);//在y轴缩放-1相当于沿着x张旋转180
    CGContextTranslateCTM(context, 0, -(size.height-(size.height-2*y-height)));//向上平移
    //图像绘制
    CGRect rect= CGRectMake(10, y, 300, height);
    CGContextDrawImage(context, rect, image.CGImage);
    
    CGContextRestoreGState(context);
}

#pragma mark 线性渐变
-(void)drawLinearGradient:(CGContextRef)context{
    //使用rgb颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat compoents[12] =
    {
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3]={0,0.3,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    /*绘制线性渐变
     context:图形上下文
     gradient:渐变色
     startPoint:起始位置
     endPoint:终止位置
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
     */
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(320, 300), kCGGradientDrawsAfterEndLocation);
    
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}

#pragma mark 径向渐变
-(void)drawRadialGradient:(CGContextRef)context{
    //使用rgb颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat compoents[12]={
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3]={0,0.3,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    /*绘制径向渐变
     context:图形上下文
     gradient:渐变色
     startCenter:起始点位置
     startRadius:起始半径（通常为0，否则在此半径范围内容无任何填充）
     endCenter:终点位置（通常和起始点相同，否则会有偏移）
     endRadius:终点半径（也就是渐变的扩散长度）
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
     */
    CGContextDrawRadialGradient(context, gradient, CGPointMake(160, 284),0, CGPointMake(165, 289), 150, kCGGradientDrawsAfterEndLocation);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}

/*
 上面我们只是绘制渐变到图形上下文，实际开发中有时候我们还需要填充对应的渐变色，例如现在绘制了一个矩形，如何填充成渐变色呢？在此可以利用渐变裁切来完成（当然利用层CALayer更加方便但这不在今天的话题讨论范围内），特别说明一下区域裁切并不仅仅适用于渐变填充，对于其他图形绘制仍然适用，并且注意裁切只能限于矩形裁切。
 */

-(void)drawRectWithLinearGradientFill:(CGContextRef)context{
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    //裁切处一块矩形用于显示，注意必须先裁切再调用渐变
    //CGContextClipToRect(context, CGRectMake(20, 50, 280, 300));
    //裁切还可以使用UIKit中对应的方法
    UIRectClip(CGRectMake(20, 50, 280, 300));
    
    CGFloat compoents[12]={
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3]={0,0.3,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(20, 50), CGPointMake(300, 300), kCGGradientDrawsAfterEndLocation);
    
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}

#pragma mark 叠加模式
-(void)drawRectByUIKitWithContext2:(CGContextRef)context{
    CGRect rect= CGRectMake(0, 130.0, 320.0, 50.0);
    CGRect rect1= CGRectMake(0, 390.0, 320.0, 50.0);
    
    
    CGRect rect2=CGRectMake(20, 50.0, 10.0, 250.0);
    CGRect rect3=CGRectMake(40.0, 50.0, 10.0, 250.0);
    CGRect rect4=CGRectMake(60.0, 50.0, 10.0, 250.0);
    CGRect rect5=CGRectMake(80.0, 50.0, 10.0, 250.0);
    CGRect rect6=CGRectMake(100.0, 50.0, 10.0, 250.0);
    CGRect rect7=CGRectMake(120.0, 50.0, 10.0, 250.0);
    CGRect rect8=CGRectMake(140.0, 50.0, 10.0, 250.0);
    CGRect rect9=CGRectMake(160.0, 50.0, 10.0, 250.0);
    CGRect rect10=CGRectMake(180.0, 50.0, 10.0, 250.0);
    CGRect rect11=CGRectMake(200.0, 50.0, 10.0, 250.0);
    CGRect rect12=CGRectMake(220.0, 50.0, 10.0, 250.0);
    CGRect rect13=CGRectMake(240.0, 50.0, 10.0, 250.0);
    CGRect rect14=CGRectMake(260.0, 50.0, 10.0, 250.0);
    CGRect rect15=CGRectMake(280.0, 50.0, 10.0, 250.0);
    
    CGRect rect16=CGRectMake(30.0, 310.0, 10.0, 250.0);
    CGRect rect17=CGRectMake(50.0, 310.0, 10.0, 250.0);
    CGRect rect18=CGRectMake(70.0, 310.0, 10.0, 250.0);
    CGRect rect19=CGRectMake(90.0, 310.0, 10.0, 250.0);
    CGRect rect20=CGRectMake(110.0, 310.0, 10.0, 250.0);
    CGRect rect21=CGRectMake(130.0, 310.0, 10.0, 250.0);
    CGRect rect22=CGRectMake(150.0, 310.0, 10.0, 250.0);
    CGRect rect23=CGRectMake(170.0, 310.0, 10.0, 250.0);
    CGRect rect24=CGRectMake(190.0, 310.0, 10.0, 250.0);
    CGRect rect25=CGRectMake(210.0, 310.0, 10.0, 250.0);
    CGRect rect26=CGRectMake(230.0, 310.0, 10.0, 250.0);
    CGRect rect27=CGRectMake(250.0, 310.0, 10.0, 250.0);
    CGRect rect28=CGRectMake(270.0, 310.0, 10.0, 250.0);
    CGRect rect29=CGRectMake(290.0, 310.0, 10.0, 250.0);
    
    
    [[UIColor yellowColor]set];
    UIRectFill(rect);
    
    [[UIColor greenColor]setFill];
    UIRectFill(rect1);
    
    [[UIColor redColor]setFill];
    UIRectFillUsingBlendMode(rect2, kCGBlendModeClear);
    UIRectFillUsingBlendMode(rect3, kCGBlendModeColor);
    UIRectFillUsingBlendMode(rect4, kCGBlendModeColorBurn);
    UIRectFillUsingBlendMode(rect5, kCGBlendModeColorDodge);
    UIRectFillUsingBlendMode(rect6, kCGBlendModeCopy);
    UIRectFillUsingBlendMode(rect7, kCGBlendModeDarken);
    UIRectFillUsingBlendMode(rect8, kCGBlendModeDestinationAtop);
    UIRectFillUsingBlendMode(rect9, kCGBlendModeDestinationIn);
    UIRectFillUsingBlendMode(rect10, kCGBlendModeDestinationOut);
    UIRectFillUsingBlendMode(rect11, kCGBlendModeDestinationOver);
    UIRectFillUsingBlendMode(rect12, kCGBlendModeDifference);
    UIRectFillUsingBlendMode(rect13, kCGBlendModeExclusion);
    UIRectFillUsingBlendMode(rect14, kCGBlendModeHardLight);
    UIRectFillUsingBlendMode(rect15, kCGBlendModeHue);
    UIRectFillUsingBlendMode(rect16, kCGBlendModeLighten);
    
    UIRectFillUsingBlendMode(rect17, kCGBlendModeLuminosity);
    UIRectFillUsingBlendMode(rect18, kCGBlendModeMultiply);
    UIRectFillUsingBlendMode(rect19, kCGBlendModeNormal);
    UIRectFillUsingBlendMode(rect20, kCGBlendModeOverlay);
    UIRectFillUsingBlendMode(rect21, kCGBlendModePlusDarker);
    UIRectFillUsingBlendMode(rect22, kCGBlendModePlusLighter);
    UIRectFillUsingBlendMode(rect23, kCGBlendModeSaturation);
    UIRectFillUsingBlendMode(rect24, kCGBlendModeScreen);
    UIRectFillUsingBlendMode(rect25, kCGBlendModeSoftLight);
    UIRectFillUsingBlendMode(rect26, kCGBlendModeSourceAtop);
    UIRectFillUsingBlendMode(rect27, kCGBlendModeSourceIn);
    UIRectFillUsingBlendMode(rect28, kCGBlendModeSourceOut);
    UIRectFillUsingBlendMode(rect29, kCGBlendModeXOR);
}

#pragma mark - 有颜色填充模式
#define TILE_SIZE 20

void drawColoredTile(void *info,CGContextRef context){
    //有颜色填充，这里设置填充色
    CGContextSetRGBFillColor(context, 254.0/255.0, 52.0/255.0, 90.0/255.0, 1);
    CGContextFillRect(context, CGRectMake(0, 0, TILE_SIZE, TILE_SIZE));
    CGContextFillRect(context, CGRectMake(TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE));
}

-(void)drawBackgroundWithColoredPattern:(CGContextRef)context{
    //设备无关的颜色空间
    //    CGColorSpaceRef rgbSpace= CGColorSpaceCreateDeviceRGB();
    //模式填充颜色空间,注意对于有颜色填充模式，这里传NULL
    CGColorSpaceRef colorSpace = CGColorSpaceCreatePattern(NULL);
    //将填充色颜色空间设置为模式填充的颜色空间
    CGContextSetFillColorSpace(context, colorSpace);
    
    //填充模式回调函数结构体
    CGPatternCallbacks callback = {0,&drawColoredTile,NULL};
    /*填充模式
     info://传递给callback的参数
     bounds:瓷砖大小
     matrix:形变
     xStep:瓷砖横向间距
     yStep:瓷砖纵向间距
     tiling:贴砖的方法
     isClored:绘制的瓷砖是否已经指定了颜色(对于有颜色瓷砖此处指定位true)
     callbacks:回调函数
     */
    CGPatternRef pattern=CGPatternCreate(NULL, CGRectMake(0, 0, 2*TILE_SIZE, 2*TILE_SIZE), CGAffineTransformIdentity,2*TILE_SIZE+ 5,2*TILE_SIZE+ 5, kCGPatternTilingNoDistortion, true, &callback);
    
    CGFloat alpha=1;
    //注意最后一个参数对于有颜色瓷砖指定为透明度的参数地址，对于无颜色瓷砖则指定当前颜色空间对应的颜色数组
    CGContextSetFillPattern(context, pattern, &alpha);
    
    UIRectFill(CGRectMake(0, 0, 320, 568));
    
    //    CGColorSpaceRelease(rgbSpace);
    CGColorSpaceRelease(colorSpace);
    CGPatternRelease(pattern);
}

/*
 这里强调一点，在drawTile回调方法中不要使用UIKit封装方法进行图形绘制（例如UIRectFill等），由于这个方法由Core Graphics内部调用，而Core Graphics考虑到跨平台问题，内部是不允许调用UIKit方法的。
 */
#pragma mark - 无颜色填充模式
//填充瓷砖的回调函数（必须满足CGPatternCallbacks签名）
void drawTile(void *info,CGContextRef context){
    CGContextFillRect(context, CGRectMake(0, 0, TILE_SIZE, TILE_SIZE));
    CGContextFillRect(context, CGRectMake(TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE));
}

-(void)drawBackgroundWithPattern:(CGContextRef)context{
    //设备无关的颜色空间
    CGColorSpaceRef rgbSpace= CGColorSpaceCreateDeviceRGB();
    //模式填充颜色空间
    CGColorSpaceRef colorSpace=CGColorSpaceCreatePattern(rgbSpace);
    //将填充色颜色空间设置为模式填充的颜色空间
    CGContextSetFillColorSpace(context, colorSpace);
    
    //填充模式回调函数结构体
    CGPatternCallbacks callback={0,&drawTile,NULL};
    /*填充模式
     info://传递给callback的参数
     bounds:瓷砖大小
     matrix:形变
     xStep:瓷砖横向间距
     yStep:瓷砖纵向间距
     tiling:贴砖的方法（瓷砖摆放的方式）
     isClored:绘制的瓷砖是否已经指定了颜色（对于无颜色瓷砖此处指定位false）
     callbacks:回调函数
     */
    CGPatternRef pattern=CGPatternCreate(NULL, CGRectMake(0, 0, 2*TILE_SIZE, 2*TILE_SIZE), CGAffineTransformIdentity,2*TILE_SIZE+ 5,2*TILE_SIZE+ 5, kCGPatternTilingNoDistortion, false, &callback);
    
    CGFloat components[]={254.0/255.0,52.0/255.0,90.0/255.0,1.0};
    //注意最后一个参数对于无颜色填充模式指定为当前颜色空间颜色数据
    CGContextSetFillPattern(context, pattern, components);
    //    CGContextSetStrokePattern(context, pattern, components);
    UIRectFill(CGRectMake(0, 0, 320, 568));
    
    CGColorSpaceRelease(rgbSpace);
    CGColorSpaceRelease(colorSpace);
    CGPatternRelease(pattern);
}

#pragma mark -上下文变换
#pragma mark 图形上下文形变
-(void)drawImageCTM:(CGContextRef)context{
    //保存初始状态
    CGContextSaveGState(context);
    
    //形变第一步：图形上下文向右平移40
    CGContextTranslateCTM(context, 100, 0);
    
    //形变第二步：缩放0.8
    CGContextScaleCTM(context, 0.8, 0.8);
    
    //形变第三步：旋转
    CGContextRotateCTM(context, M_PI_4/4);
    
    UIImage *image=[UIImage imageNamed:@"mm01.jpg"];
    [image drawInRect:CGRectMake(0, 50, 240, 300)];
    
    //恢复到初始状态
    CGContextRestoreGState(context);
}

#pragma mark - 刷新
- (void)refreshLabelText:(CGContextRef)context{
    NSString *str=_title;
    UIFont *font=[UIFont fontWithName:@"Marker Felt" size:_fontSize];
    UIColor *foreignColor=[UIColor redColor];
    [str drawInRect:CGRectMake(100, 120, 300, 200) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:foreignColor}];
}

@end
