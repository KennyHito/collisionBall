//
//  ViewController.m
//  collisionBall
//
//  Created by Apple on 2017/7/17.
//  Copyright © 2017年 KennyHito. All rights reserved.
//一个小球弹性碰撞(UIDynamic和CMMotion综合使用)

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()<UICollisionBehaviorDelegate>

@property (nonatomic, strong) NSMutableArray *balls;
@property (nonatomic, strong) UIGravityBehavior *gravityBeahvior;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItemBehavior;
@property (nonatomic) CMMotionManager *MotionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *clickBtn = [UIButton new];
    [clickBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [clickBtn setBackgroundColor:[UIColor redColor]];
    [clickBtn setTitle:@"开始碰撞" forState:UIControlStateNormal];
    [clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:clickBtn];
    clickBtn.frame = CGRectMake((self.view.frame.size.width - 80)/2, 80, 80, 40);
    
}

- (void)buttonClickAction:(UIButton *)sender{
    sender.enabled = NO;
    [self setupBalls];
    [self useGyroPush];
}

- (void)setupBalls{
    
    self.balls = [NSMutableArray array];
    //添加20个球体
    NSUInteger numOfBalls = 20;
    for (NSUInteger i = 0; i < numOfBalls; i ++) {
        
        UIImageView *ball = [UIImageView new];
        
        //球的随机颜色
        ball.image = [UIImage imageNamed:[NSString stringWithFormat:@"headIcon-%ld.jpg",i]];
        
        //球的大小
        CGFloat width = 40;
        ball.layer.cornerRadius = width/2;
        ball.layer.masksToBounds = YES;
        
        //球的随机位置
        CGRect frame = CGRectMake(arc4random()%((int)(self.view.bounds.size.width - width)), 0, width, width);
        [ball setFrame:frame];
        
        //添加球体到父视图
        [self.view addSubview:ball];
        
        //球堆添加该球
        [self.balls addObject:ball];
    }
    //使用拥有重力特性和碰撞特性
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    _animator = animator;
    
    //添加重力的动态特性，使其可执行
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:self.balls];
    [self.animator addBehavior:gravity];
    _gravity = gravity;
    
    //添加碰撞的动态特性，使其可执行
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:self.balls];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    _collision = collision;
    
    //弹性
    UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.balls];
    dynamicItemBehavior.allowsRotation = YES;//允许旋转
    dynamicItemBehavior.elasticity = 0.6;//弹性
    [self.animator addBehavior:dynamicItemBehavior];
}


- (void)useGyroPush{
    //初始化全局管理对象
    
    self.MotionManager = [[CMMotionManager alloc]init];
    self.MotionManager.deviceMotionUpdateInterval = 0.01;
    
    __weak ViewController *weakSelf = self;
    
    [self.MotionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *_Nullable motion,NSError * _Nullable error) {
        
        double rotation = atan2(motion.attitude.pitch, motion.attitude.roll);
        
        //重力角度
        weakSelf.gravity.angle = rotation;
        
        //        NSString *yaw = [NSString stringWithFormat:@"%f",motion.attitude.yaw];
        //        NSString *pitch = [NSString stringWithFormat:@"%f",motion.attitude.pitch];
        //        NSString *roll = [NSString stringWithFormat:@"%f",motion.attitude.roll];
        //NSLog(@"yaw = %@,pitch = %@, roll = %@,rotation = %fd",yaw,pitch,roll,rotation);
        
    }];
    
}

- (void)dealloc{
    [self.MotionManager stopDeviceMotionUpdates];
}

#pragma mark - UICollisionBehaviorDelegate
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p {
    
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier {
    
}

@end
