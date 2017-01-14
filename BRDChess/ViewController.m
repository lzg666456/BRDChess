//
//  ViewController.m
//  BRDChess
//
//  Created by boruida3015 on 3017/1/14.
//  Copyright © 3017年 boruida3015. All rights reserved.
//

#import "ViewController.h"

@interface Chess : UIButton
@property (nonatomic) BOOL Redflag;
@property NSIndexPath *path;
@end

@implementation Chess

-(instancetype)initWithPath:(NSIndexPath *)path{
    
    self = [super init];
    if (self) {
        self.path=path;
    }
    return self;
}

-(void)setRedflag:(BOOL)Redflag{
    _Redflag=Redflag;
    [self setTitleColor:(Redflag?[UIColor redColor]:[UIColor blackColor]) forState:UIControlStateNormal];
}

@end

@interface ChessMapbackView : UIView
// 棋盘格式为9*10
//

@end

@implementation ChessMapbackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor grayColor];
        
        UILabel *lbl1=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)/2-15, 50, 30)];
        lbl1.text=@"楚河";
        [self addSubview:lbl1];
        
        UILabel *lbl2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-50, CGRectGetHeight(self.frame)/2-15, 50, 30)];
        lbl2.text=@"汉界";
        [self addSubview:lbl2];

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat _rowWidth=self.frame.size.width/8.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [super drawRect:rect];
    
    //画行线
    CGRect linebounds;
    for (int i = 0; i < 10; i++)
    {
        linebounds = CGRectMake(0, i * _rowWidth - 1 , self.frame.size.width , 2);
        CGContextMoveToPoint(context, CGRectGetMinX(linebounds), CGRectGetMinY(linebounds));
        CGContextAddLineToPoint(context, CGRectGetMaxX(linebounds), CGRectGetMinY(linebounds));
        CGContextAddLineToPoint(context, CGRectGetMaxX(linebounds), CGRectGetMaxY(linebounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(linebounds), CGRectGetMaxY(linebounds));
        CGContextClosePath(context);
        [[UIColor whiteColor]setStroke];
        [[UIColor whiteColor]setFill];
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    //画列线
    for (int j = 0 ; j < 2; j++)
    {
        for (int i = 0 ; i < 9; i++)
        {
            if (j == 0)
            {
                linebounds =CGRectMake(i * _rowWidth - 1 , 0, 2 , (self.frame.size.height - _rowWidth)/2.0);
            }
            else
            {
                linebounds =CGRectMake(i * _rowWidth - 1 , (self.frame.size.height - _rowWidth)/2.0 + _rowWidth, 2 , (self.frame.size.height - _rowWidth)/2.0);
            }
            CGContextMoveToPoint(context, CGRectGetMinX(linebounds), CGRectGetMinY(linebounds));
            CGContextAddLineToPoint(context, CGRectGetMaxX(linebounds), CGRectGetMinY(linebounds));
            CGContextAddLineToPoint(context, CGRectGetMaxX(linebounds), CGRectGetMaxY(linebounds));
            CGContextAddLineToPoint(context, CGRectGetMinX(linebounds), CGRectGetMaxY(linebounds));
            CGContextClosePath(context);
            [[UIColor whiteColor]setStroke];
            [[UIColor whiteColor]setFill];
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
    
    CGContextMoveToPoint(context, 3*_rowWidth-1, 0);
    CGContextAddLineToPoint(context, 3*_rowWidth+1, 0);
    CGContextAddLineToPoint(context, 5*_rowWidth+1, 2*_rowWidth);
    CGContextAddLineToPoint(context, 5*_rowWidth-1, 2*_rowWidth);
    CGContextClosePath(context);
    [[UIColor whiteColor]setStroke];
    [[UIColor whiteColor]setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextMoveToPoint(context, 3*_rowWidth-1, 2*_rowWidth);
    CGContextAddLineToPoint(context, 3*_rowWidth+1, 2*_rowWidth);
    CGContextAddLineToPoint(context, 5*_rowWidth+1, 0);
    CGContextAddLineToPoint(context, 5*_rowWidth-1, 0);
    CGContextClosePath(context);
    [[UIColor whiteColor]setStroke];
    [[UIColor whiteColor]setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextMoveToPoint(context, 3*_rowWidth-1, 9*_rowWidth);
    CGContextAddLineToPoint(context, 3*_rowWidth+1, 9*_rowWidth);
    CGContextAddLineToPoint(context, 5*_rowWidth+1, 7*_rowWidth);
    CGContextAddLineToPoint(context, 5*_rowWidth-1, 7*_rowWidth);
    CGContextClosePath(context);
    [[UIColor whiteColor]setStroke];
    [[UIColor whiteColor]setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextMoveToPoint(context, 3*_rowWidth-1, 7*_rowWidth);
    CGContextAddLineToPoint(context, 3*_rowWidth+1, 7*_rowWidth);
    CGContextAddLineToPoint(context, 5*_rowWidth+1, 9*_rowWidth);
    CGContextAddLineToPoint(context, 5*_rowWidth-1, 9*_rowWidth);
    CGContextClosePath(context);
    [[UIColor whiteColor]setStroke];
    [[UIColor whiteColor]setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end

@interface ChessMap : UIView
{
    CGPoint chesssize;          //棋子显示大小
    CGPoint chessbound;         //棋子占位大小
    CGPoint chessoffset;        //棋子居中偏移量
    
    Chess *selectedChess;
    NSArray *arr;
    
    BOOL redturnflag;
}
-(void) reset;
@end

@implementation ChessMap

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        chesssize=CGPointMake(30, 30);
        chessbound=CGPointMake(36, 36);
        chessoffset=CGPointMake(3, 3);
        arr=@[@"车",@"马",@"象",@"士",@"帅",@"炮",@"卒",];
        self.backgroundColor=[UIColor redColor];
        [self reset];

    }
    return self;
}

-(void) reset{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    [self addSubview:[[ChessMapbackView alloc] initWithFrame:CGRectMake(18, 18, 8*36, 9*36)]];
    for (int i=0; i<2; i++) {
        for (int j=0; j<9; j++) {
            [self addChess:[NSIndexPath indexPathForRow:(i?0:9) inSection:j]];
        }
        for (int j=0; j<9; j+=2) {
            [self addChess:[NSIndexPath indexPathForRow:(i?3:6) inSection:j]];
        }
        
        [self addChess:[NSIndexPath indexPathForRow:(i?2:7) inSection:1]];
        [self addChess:[NSIndexPath indexPathForRow:(i?2:7) inSection:7]];
    }
}

-(void)addChess:(NSIndexPath *)path{
    Chess *mChess=[[Chess alloc] initWithPath:path];
    mChess.frame=CGRectMake(path.section*chessbound.x+chessoffset.x, path.row*chessbound.y+chessoffset.y, chesssize.x, chesssize.y);
    [mChess setBackgroundColor:[UIColor whiteColor]];
    [mChess setRedflag:path.row<5];

    mChess.layer.cornerRadius=15;
    mChess.layer.borderColor=[UIColor grayColor].CGColor;
    mChess.layer.borderWidth=2;
    
    if(ABS(path.row-4.5)==4.5){
        [mChess setTitle:arr[4-ABS(path.section-4)] forState:UIControlStateNormal];
    }
    if(ABS(path.row-4.5)==2.5){
        [mChess setTitle:arr[5] forState:UIControlStateNormal];
    }
    if(ABS(path.row-4.5)==1.5){
        [mChess setTitle:arr[6] forState:UIControlStateNormal];
    }
    [mChess addTarget:self action:@selector(SelectChess:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:mChess];
}

-(void) SelectChess:(Chess *)sender{
    if (sender.Redflag==redturnflag) {  //选中棋子
        if (selectedChess==sender) {
            [selectedChess setSelected:NO];
            selectedChess.backgroundColor=[UIColor whiteColor];
            selectedChess=nil;
        } else {
            [selectedChess setSelected:NO];
            selectedChess.backgroundColor=[UIColor whiteColor];
            selectedChess=nil;
            
            [sender setSelected:YES];
            sender.backgroundColor=[UIColor blueColor];
            selectedChess =sender;
        }
    } else {
        if(selectedChess && selectedChess.Redflag!=sender.Redflag){
            int idx=0;
            while (![arr[idx] isEqualToString:selectedChess.titleLabel.text])idx++;
            
            if (YES) {  // can eat?
                NSLog(@"[%@]%@吃掉[%@]%@",selectedChess.Redflag?@"红方":@"黑方",selectedChess.titleLabel.text,sender.Redflag?@"红方":@"黑方",sender.titleLabel.text);
                selectedChess.frame=sender.frame;
                [sender removeFromSuperview];
                [selectedChess setSelected:NO];
                selectedChess.backgroundColor=[UIColor whiteColor];
                selectedChess =nil;
                redturnflag=!redturnflag;
            }
        } else {
            NSLog(@"Err:等待[%@]走棋！！！",redturnflag?@"红方":@"黑方");
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint  pt = [touch locationInView:self];
    
    NSInteger row = floor((pt.y)/chessbound.y);
    NSInteger line = floor((pt.x)/chessbound.x);
    NSLog(@"row:%ld line:%ld",(long)row,(long)line);
    
    if (selectedChess) {
        int idx=0;
        while (![arr[idx] isEqualToString:selectedChess.titleLabel.text])idx++;
        
        if (true) {   // can move?
            selectedChess.frame=CGRectMake(line*chessbound.x+chessoffset.x, row*chessbound.y+chessoffset.y, chesssize.x, chesssize.y);
            [selectedChess setSelected:NO];
            selectedChess.backgroundColor=[UIColor whiteColor];
            selectedChess =nil;
            redturnflag=!redturnflag;
        }
    }
}



@end

@interface ViewController ()
{
    ChessMap *map;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    map=[[ChessMap alloc] initWithFrame:CGRectMake(0, 30, 36*9, 36*10)];
    [self.view addSubview:map];
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(20, 400, 50, 30)];
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn setTitle:@"重置" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)reset:(id)sender{
    [map reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
