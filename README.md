仿摩拜单车app,我的贴纸中类似于碰撞球功能
--------------------------

#### 一.首先,需要学习一些知识点


1.CoreMotion框架(加速计和陀螺仪)
* [http://blog.csdn.net/sifenkesi1/article/details/52621873](http://blog.csdn.net/sifenkesi1/article/details/52621873);
* [http://justsee.iteye.com/blog/1933099](http://justsee.iteye.com/blog/1933099);

2.UIDynamicAnimator - 仿真物理学
* [http://www.jianshu.com/p/8aa3525f8d48](http://www.jianshu.com/p/8aa3525f8d48);
* [http://www.cnblogs.com/pengsi/p/5798312.html](http://www.cnblogs.com/pengsi/p/5798312.html);
* [http://blog.csdn.net/lengshengren/article/details/12000649](http://blog.csdn.net/lengshengren/article/details/12000649);
* [http://blog.csdn.net/sharktoping/article/details/52277158](http://blog.csdn.net/sharktoping/article/details/52277158);


#### 二.代码如下

~~~
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
~~~

~~~
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
~~~

#### 三.效果图
![效果图](film.mov)
