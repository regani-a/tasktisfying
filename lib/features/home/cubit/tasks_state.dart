part of 'tasks_cubit.dart';

abstract class TasksState {}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksError extends TasksState {
  final String error;
  TasksError(this.error);
}

class AddNewTaskSuccess extends TasksState {
  final TaskModel task;
  AddNewTaskSuccess(this.task);
}

class GetTasksSuccess extends TasksState {
  final List<TaskModel> tasks;
  GetTasksSuccess(this.tasks);
}
