import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:tasktisfying/features/home/cubit/tasks_cubit.dart';
import 'package:tasktisfying/features/home/widgets/date_selector.dart';
import 'package:tasktisfying/features/home/widgets/task_card.dart';
import 'package:tasktisfying/core/constants/utils.dart';
import 'add_new_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static MaterialPageRoute route() => MaterialPageRoute(builder: (_) => const HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().getAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add),
            onPressed: () {
              Navigator.push(context, AddNewTaskPage.route());
            },
          ),
        ],
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TasksError) {
            return Center(child: Text(state.error));
          }
            if (state is GetTasksSuccess) {
              final tasks = state.tasks.where(
                  (elem) =>
                      DateFormat('d').format(elem.dueAt) ==
                          DateFormat('d').format(selectedDate) &&
                      selectedDate.month == elem.dueAt.month &&
                      selectedDate.year == elem.dueAt.year,
                )
                .toList();

              return Column(
                children: [
                  DateSelector(
                    selectedDate: selectedDate,
                    onTap: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Row(
                          children: [
                            Expanded(
                              child: TaskCard(
                                color: task.color,
                                headerText: task.title,
                                descriptionText: task.description,
                              ),
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: strengthenColor(task.color, 0.69),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                DateFormat.jm().format(task.dueAt),
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }

          return const SizedBox();
        },
      ),
    );
  }
}
