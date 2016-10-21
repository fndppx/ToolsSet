//
//  VHPaiseView.m
//  VhallIphone
//
//  Created by vhall on 15/8/15.
//  Copyright (c) 2015年 www.vhall.com. All rights reserved.
//

#import "VHPaiseView.h"

@interface VHPaiseView()

@end


@implementation VHPaiseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
    }
    return self;
}



-(void)setNum:(NSInteger)num
{
    if(num==1)
    {
        [self addHert:num];
    }
    else
    {
        __block float step = num/10.0;
        __block int   lastnum = 0;
        __block int timeout=1; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),timeout*200*NSEC_PER_MSEC, 0); //每x毫秒秒执行
        dispatch_source_set_event_handler(_timer, ^{
            timeout++;
            if(timeout>10){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }else{
                int cnt = (int)(timeout*step) - lastnum;
                lastnum = lastnum+cnt;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
//                    NSLog(@"%d",cnt);
                    if(cnt >0)
                        [self addHert:cnt];
                });
            }
        });
        
        dispatch_resume(_timer);
    }
}

-(void)addHert:(NSInteger)num
{
    for (int i = 0; i < num; i++) {
        int x = arc4random() % 6;
        NSString* str = [NSString stringWithFormat:@"%d",x];
        UIImageView* view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:str]];
        view.frame = CGRectMake(0, 0, 27, 27);
        [self addSubview:view];
        float duration = [self initView:view];
        [UIView  animateWithDuration:duration*0.2 animations:^{
            view.transform =CGAffineTransformScale(view.transform, 3, 3);;
        } completion:^(BOOL finished) {
            [UIView  animateWithDuration:duration*0.8 animations:^{
                view.alpha = 0.1;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }];
    }
}

-(float)initView:(UIView*)view
{
    float duration = 1.0+ 2*(arc4random() % 100)/100.0;
    float rw = (arc4random() % 100)/100.0;
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = duration;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.width/2-13, self.height-13, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(rw*self.width-13, 0.8f*self.height-13, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.width/2-13, 0.0f, 1.0f)]];
    popAnimation.keyTimes = @[@0.0f,@0.2f, @1.0f];
//    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    popAnimation.removedOnCompletion = NO;
    popAnimation.fillMode=kCAFillModeBoth ;
    [view.layer addAnimation:popAnimation forKey:nil];
    
    return duration;
}

//让view穿透
-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
        
    UIView *superView = [super hitTest:point withEvent:event];
    return superView;
    
}
@end
