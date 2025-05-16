import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasktisfying/features/home/cubit/tasks_cubit.dart';
import 'package:tasktisfying/features/home/pages/home_page.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:intl/intl.dart';

class AddNewTaskPage extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (_) => const AddNewTaskPage(),
      );
  const AddNewTaskPage({super.key});

  @override
  State<AddNewTaskPage> createState() => _AddNewTaskPageState();
}

class _AddNewTaskPageState extends State<AddNewTaskPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Color selectedColor = const Color.fromRGBO(246, 222, 194, 1);
  final formKey = GlobalKey<FormState>();

  void createNewTask() async {
    if (formKey.currentState!.validate()) {
      await context.read<TasksCubit>().createNewTask(
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            color: selectedColor,
            dueAt: selectedDate,
          );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // allow resize on keyboard open
      appBar: AppBar(
        title: const Text("Add New Task"),
        actions: [
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );
              if (picked != null) {
                setState(() => selectedDate = picked);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(DateFormat("MM-d-y").format(selectedDate)),
            ),
          ),
        ],
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is TasksError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is AddNewTaskSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Task added successfully!")),
            );
            Navigator.pushAndRemoveUntil(
              context,
              HomePage.route(),
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Title'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Title cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(hintText: 'Description'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Description cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ColorPicker(
                      color: selectedColor,
                      onColorChanged: (color) => setState(() {
                        selectedColor = color;
                      }),
                      heading: const Text("Select color"),
                      subheading: const Text("Pick a shade"),
                      pickersEnabled: const {ColorPickerType.wheel: true},
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: createNewTask,
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
