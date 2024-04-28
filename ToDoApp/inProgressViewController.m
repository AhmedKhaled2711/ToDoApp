//
//  DoingViewController.m
//  ToDoApp
//
//  Created by Ahmed Khaled on 21/04/2024.
//

#import "inProgressViewController.h"
#import "TaskModel.h"
#import "HelperClass.h"
#import "DetailsViewController.h"

@interface inProgressViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;

@property (strong, nonatomic) NSMutableArray<TaskModel *> *allDoingTasksArray;
@property (strong, nonatomic) NSArray<TaskModel *> *loadedTasks;
@property (strong, nonatomic) NSArray<TaskModel *> *filteredDataArray;

@end

@implementation inProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)segmentedClick:(id)sender {
    NSInteger selectedIndex = self.prioritySegmentedControl.selectedSegmentIndex;
        NSArray<TaskModel *> *filteredTasks = [HelperClass filterTasksFromArray:self.loadedTasks withFilter:@"1"];
        
        switch (selectedIndex) {
            case 0:
                self.allDoingTasksArray = [filteredTasks mutableCopy];
                break;
            case 1:
                self.allDoingTasksArray = [[HelperClass filterTasksByPriority:filteredTasks withPriority:@"0"] mutableCopy];
                break;
            case 2:
                self.allDoingTasksArray = [[HelperClass filterTasksByPriority:filteredTasks withPriority:@"1"] mutableCopy];
                break;
            case 3:
                self.allDoingTasksArray = [[HelperClass filterTasksByPriority:filteredTasks withPriority:@"2"] mutableCopy];
                break;
            default:
                break;
        }
        [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.loadedTasks = [HelperClass readArrayWithTaskObjFromUserDefaults:@"taskArray"];
    NSArray<TaskModel *> *filteredTasks = [HelperClass filterTasksFromArray:self.loadedTasks withFilter:@"1"];
    self.allDoingTasksArray = [filteredTasks mutableCopy];
    [self.tableView reloadData];
    
    if (self.allDoingTasksArray.count == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty"]];
        imageView.contentMode = UIViewContentModeCenter;
        self.tableView.backgroundView = imageView;
    } else {
        self.tableView.backgroundView = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doingCell" forIndexPath:indexPath];
    TaskModel *taskModel = self.allDoingTasksArray[indexPath.row];
    cell.textLabel.text = taskModel.taskName;
    
    UIImage *priorityImage = nil;
    switch ([taskModel.taskPriority intValue]) {
        case 0:
            priorityImage = [UIImage imageNamed:@"low"];
            break;
        case 1:
            priorityImage = [UIImage imageNamed:@"medium"];
            break;
        case 2:
            priorityImage = [UIImage imageNamed:@"high"];
            break;
        default:
            break;
    }
    
    CGFloat imageSize = 50.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
    imageView.image = priorityImage;
    cell.accessoryView = imageView;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allDoingTasksArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskModel *selectedTask = self.allDoingTasksArray[indexPath.row];
    DetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    [detailsViewController setDetailsTaskModel:selectedTask];
    NSMutableArray<TaskModel *> *mutableLoadedTasks = [self.loadedTasks mutableCopy];
    [detailsViewController setDetailsArray:mutableLoadedTasks];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Doing List";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are You Sure Want to Delete ?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                TaskModel *removedTask = self.allDoingTasksArray[indexPath.row];
                NSMutableArray<TaskModel *> *originalList = [self.loadedTasks mutableCopy];
                [self.allDoingTasksArray removeObjectAtIndex:indexPath.row];
                [originalList removeObject:removedTask];
                [HelperClass removeArrayFromUserDefaults:@"taskArray"];
                [HelperClass saveTaskArrayToUserDefaults:@"taskArray" withArray:originalList];
                [tableView reloadData];
            }];
            UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:yesButton];
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
