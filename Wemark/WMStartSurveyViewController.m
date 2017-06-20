//
//  WMStartSurveyViewController.m
//  Wemark
//
//  Created by Ashish on 07/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMStartSurveyViewController.h"
#import "WMMyAssignmentsViewController.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"

@interface WMStartSurveyViewController ()
@property(nonatomic, strong) NSArray *start;
@property(nonatomic, strong) NSArray *pending;
@property(nonatomic, strong) NSArray *completed;
@property (nonatomic, strong) NSString *selectedStart;
@property (nonatomic, strong) NSString *selectedPending;
@property (nonatomic, strong) NSString *selectedCompleted;
@property (weak, nonatomic) IBOutlet UICollectionView *startCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *pendingCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *completedCollectionView;

@end

@implementation WMStartSurveyViewController
{
    UIActivityIndicatorView * activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.tintColor = [UIColor whiteColor];
    [activityView setHidesWhenStopped:true];
    [self.view addSubview:activityView];
    
    self.title = @"Start Survey";
    
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    if (authKey.length == 0) {
        return;
    }
    [[WMWebservicesHelper sharedInstance] getAllSearchParametersWithCompletionBlock:^(BOOL result, id responseDict, NSError *error) {
        if (result) {
            self.start = responseDict[@"start"];
            self.pending = responseDict[@"pending"];
            self.completed = responseDict[@"completed"];
            //[self updateUIContent];
        }else{
            NSDictionary *resDict = responseDict;
            if ([resDict[@"code"]
                 integerValue] == 409) {
                NSLog(@"Error responseDict:->%@",resDict[@"message"]);
            }else{
                NSLog(@"Error:->%@",error.localizedDescription);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityView stopAnimating];
            [self.startCollectionView reloadData];
            [self.pendingCollectionView reloadData];
            [self.completedCollectionView reloadData];
        });
    } authkey:authKey];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Start Survey"]) {
        WMStartSurveyViewController  *vc = segue.destinationViewController;
        //vc.profileDict = self.dataObject;
    }
}


#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/4 - 20, 50);
}


- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"Start Survey" sender:self];
    if (collectionView.tag == 1) {
        self.selectedStart = [self.start[indexPath.row] objectForKey:@"start"];
    } else if (collectionView.tag == 2) {
        self.selectedPending = [self.pending[indexPath.row] objectForKey:@"pending"];
    } else if (collectionView.tag == 3) {
        self.selectedCompleted = [self.completed[indexPath.row] objectForKey:@"completed"];
    }
    
    }

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1) {
        return self.start.count;
    } else if (collectionView.tag == 2) {
        return self.pending.count;
    } else if (collectionView.tag == 3) {
        return self.completed.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
    cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if (collectionView.tag == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Start Survey" forIndexPath:indexPath];
        UILabel *lbl = [cell viewWithTag:1];
        lbl.text = [self.start[indexPath.row] objectForKey:@"start"];
        
    } else if (collectionView.tag == 2) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Start Survey" forIndexPath:indexPath];
        UILabel *lbl = [cell viewWithTag:1];
        lbl.text = [self.pending[indexPath.row] objectForKey:@"pending"];
        
    } else if (collectionView.tag == 3) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Start Survey" forIndexPath:indexPath];
        UILabel *lbl = [cell viewWithTag:1];
        lbl.text = [self.completed[indexPath.row] objectForKey:@"completed"];
    }
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    cell.selectedBackgroundView = bgView;
    return cell;
}


- (IBAction)startBtnTapped:(id)sender {
   [self performSegueWithIdentifier:@"Start Survey" sender:nil];
}


- (IBAction)startSurveySubmitBtn:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure to submit your assignment ?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
          }];
       [alertController addAction:cancelAction];
       [alertController addAction:submitAction];
    
    [self presentViewController:alertController animated:true completion:^{
    }];

}

@end
