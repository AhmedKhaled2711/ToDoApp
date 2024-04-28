//
//  ToDoViewController.m
//  ToDoApp
//
//  Created by Ahmed Khaled on 21/04/2024.
//

#import "ToDoViewController.h"
#import "NewTaskViewController.h"
#import "TaskModel.h"
#import "DetailsViewController.h"
#import "HelperClass.h"

@interface ToDoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray<TaskModel *> *filteredDataArray;
@property (strong, nonatomic) NSMutableArray<TaskModel *> *allTasksArray;
@property (strong, nonatomic) NSArray<TaskModel *> *loadedTasks;
@property (strong, nonatomic) NSArray<TaskModel *> *filteredTasks;

@end

@implementation ToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar.delegate = self;
   
}
- (IBAction)segmentedAction:(id)sender {
    NSInteger selectedIndex = _segmentedController.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:{
            self.filteredTasks = [HelperClass filterTasksFromArray:self.loadedTasks withFilter:@"0"];
            self.allTasksArray = [self.filteredTasks mutableCopy];
            [self.tableView reloadData];
            break;
        }
        case 1:{
            self.filteredTasks = [HelperClass filterTasksFromArray:self.loadedTasks withFilter:@"0"];
            NSArray<TaskModel *> *lowPriorityTasks = [HelperClass filterTasksByPriority:self.filteredTasks withPriority:@"0"];
            self.allTasksArray = [lowPriorityTasks mutableCopy];
            [self.tableView reloadData];
            break;
        }
        case 2:{
            self.filteredTasks = [HelperClass filterTasksFromArray:self.loadedTasks withFilter:@"0"];
            NSArray<TaskModel *> *mediumPriorityTasks = [HelperClass filterTasksByPriority:self.filteredTasks withPriority:@"1"];
            self.allTasksArray = [mediumPriorityTasks mutableCopy];
            [self.tableView reloadData];
            break;
        }
            break;
        case 3:{
            self.filteredTasks = [HelperClass filterTasksFromArray:self.loadedTasks withFilter:@"0"];
            NSArray<TaskModel *> *highPriorityTasks = [HelperClass filterTasksByPriority:self.filteredTasks withPriority:@"2"];
            self.allTasksArray = [highPriorityTasks mutableCopy];
            [self.tableView reloadData];
            break;
        }
            break;
        
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.loadedTasks = [HelperClass readArrayWithTaskObjFromUserDefaults:@"taskArray"];
    self.filteredTasks = [HelperClass filterTasksFromArray:self.loadedTasks withFilter:@"0"];
    
    self.allTasksArray = [self.filteredTasks mutableCopy];
    [self.tableView reloadData];
    
    if (_allTasksArray.count == 0) {
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell" forIndexPath:indexPath];
    TaskModel *task = self.allTasksArray[indexPath.row];
    cell.textLabel.text = task.taskName;
    
    UIImage *priorityImage = nil;
    switch ([task.taskPriority intValue]) {
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
    return self.allTasksArray.count;
}
- (IBAction)addNewTask:(id)sender {
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskModel *selectedTask = self.allTasksArray[indexPath.row];
    DetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    [detailsViewController setDetailsTaskModel:selectedTask];
    NSMutableArray<TaskModel *> *mutableLoadedTasks = [self.loadedTasks mutableCopy];
    [detailsViewController setDetailsArray:mutableLoadedTasks];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"TODO List";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are You Sure Want to Delete ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TaskModel *removedTask = [TaskModel new];
            removedTask = [self->_allTasksArray objectAtIndex:indexPath.row];
            NSMutableArray<TaskModel *> *originalList = [self->_loadedTasks mutableCopy];
            [self->_allTasksArray removeObject:removedTask];
            [originalList removeObject:removedTask];
            [HelperClass removeArrayFromUserDefaults:@"taskArray"];
            [HelperClass saveTaskArrayToUserDefaults:@"taskArray" withArray:originalList];
            [tableView reloadData];
        }];
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:yesButton];
        [alert addAction:noButton];
        [self presentViewController: alert animated:YES completion:nil];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {}
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
            self.allTasksArray = [self.filteredTasks mutableCopy];
        } else {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
            self.allTasksArray = [self.filteredTasks filteredArrayUsingPredicate:predicate];
        }
        [self.tableView reloadData];

}


@end


