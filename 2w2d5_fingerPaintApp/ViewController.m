//
//  ViewController.m
//  2w2d5_fingerPaintApp
//
//  Created by Seantastic31 on 09/07/2017.
//  Copyright © 2017 Seantastic31. All rights reserved.
//

#import "ViewController.h"
#import "PaintView.h"

@interface ViewController ()

@property (strong, nonatomic) PaintView *paintView;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *purpleButton;
@property (weak, nonatomic) IBOutlet UIButton *eraserButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paintView = [[PaintView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeColorButton:(UIButton *)sender
{
    NSLog(@"change color");
    [self.paintView changeLineWidth:2];
    [self.paintView changeLineColor:sender.backgroundColor];
}

- (IBAction)eraserMode:(UIButton *)sender
{
    NSLog(@"erase color");
    [self.paintView changeLineWidth:6];
    [self.paintView changeLineColor:sender.backgroundColor];
}

- (IBAction)clearScreen:(UIButton *)sender
{
    NSLog(@"clear screen");
    [self.paintView clearScreen];
}

@end
