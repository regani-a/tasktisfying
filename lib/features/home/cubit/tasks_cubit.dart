import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasktisfying/models/task_model.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required DateTime dueAt,
  }) async {
    try {
      emit(TasksLoading());
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      final newTaskRef = _firestore.collection('tasks').doc();
      final now = DateTime.now();

      final task = TaskModel(
        id: newTaskRef.id,
        uid: user.uid,
        title: title,
        description: description,
        color: color,
        dueAt: dueAt,
        createdAt: now,
        updatedAt: now,
      );

      await newTaskRef.set(task.toMap());

      emit(AddNewTaskSuccess(task));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> getAllTasks() async {
    try {
      emit(TasksLoading());
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      final snapshot = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: user.uid)
          .get();

      final tasks = snapshot.docs
          .map((doc) => TaskModel.fromMap(doc.data()))
          .toList();

      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }
}
