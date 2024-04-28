//
//  Utils.m
//  ToDoApp
//
//  Created by Ahmed Khaled on 21/04/2024.
//

#import "HelperClass.h"
#import "TaskModel.h"

@implementation HelperClass

//+ (NSArray<TaskModel *> *)filterTasksFromArray:(NSArray<TaskModel *> *)tasks withFilter:(NSString*)filteredKey{
//    NSMutableArray<TaskModel *> *filteredArray = [NSMutableArray array];
//    NSArray<TaskModel *> *loadedTasks = tasks;
//    for (TaskModel *task in loadedTasks) {
//        NSString *statesString = task.taskState;
//        if ([statesString isEqualToString:filteredKey]) {
//            [filteredArray addObject:task];
//        }
//    }
//    
//    return filteredArray;
//}
//
//+ (NSArray<TaskModel *> *)filterTasksByPriority:(NSArray<TaskModel *> *)tasks withPriority:(NSString*)filteredKey{
//    NSMutableArray<TaskModel *> *filteredArray = [NSMutableArray array];
//    NSArray<TaskModel *> *loadedTasks = tasks;
//    for (TaskModel *task in loadedTasks) {
//        NSString *priorityString = task.taskPriority;
//        if ([priorityString isEqualToString:filteredKey]) {
//            [filteredArray addObject:task];
//        }
//    }
//    
//    return filteredArray;
//}
//+(void)saveTaskArrayToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray{
//
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:keyName];
//}
//
//
//+(NSMutableArray *)readArrayWithTaskObjFromUserDefaults:(NSString*)keyName{
//    NSMutableArray *myArray;
//    NSData *data =  [[NSUserDefaults standardUserDefaults] objectForKey:keyName];
//    myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    if (myArray == nil) {
//        myArray = [NSMutableArray new];
//    }
//    return myArray;
//}
//+(void)removeArrayFromUserDefaults:(NSString *)keyName{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyName];
//}
+ (NSArray<TaskModel *> *)filterTasksFromArray:(NSArray<TaskModel *> *)tasks withFilter:(NSString *)filterKey {
    NSMutableArray<TaskModel *> *filteredArray = [NSMutableArray array];
    for (TaskModel *task in tasks) {
        NSString *statesString = task.taskState;
        if ([statesString isEqualToString:filterKey]) {
            [filteredArray addObject:task];
        }
    }
    return filteredArray;
}

+ (NSArray<TaskModel *> *)filterTasksByPriority:(NSArray<TaskModel *> *)tasks withPriority:(NSString *)priorityKey {
    NSMutableArray<TaskModel *> *filteredArray = [NSMutableArray array];
    for (TaskModel *task in tasks) {
        NSString *priorityString = task.taskPriority;
        if ([priorityString isEqualToString:priorityKey]) {
            [filteredArray addObject:task];
        }
    }
    return filteredArray;
}

+ (void)saveTaskArrayToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)taskArray {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:taskArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:keyName];
}

+ (NSMutableArray *)readArrayWithTaskObjFromUserDefaults:(NSString *)keyName {
    NSMutableArray *taskArray;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:keyName];
    taskArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (taskArray == nil) {
        taskArray = [NSMutableArray new];
    }
    return taskArray;
}

+ (void)removeArrayFromUserDefaults:(NSString *)keyName {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyName];
}

@end
