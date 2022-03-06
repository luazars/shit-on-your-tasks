import "package:flutter/material.dart";
import "package:login_register/models/task_model.dart";

class AddTaskScreen extends StatefulWidget {
  final Function setStateMain;
  final List<Task> tasks;
  final bool isEdit;
  final Task? taskToEdit;

  const AddTaskScreen(this.setStateMain, this.tasks,
      {this.isEdit = false, this.taskToEdit, Key? key})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskTextController = TextEditingController();

  int colorSelected = 0;
  final List<Color> colors = [
    Colors.white,
    Colors.grey,
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
  ];
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      taskTitleController.text = widget.taskToEdit!.title;
      taskTextController.text = widget.taskToEdit!.text;
      colorSelected = colors.indexOf(widget.taskToEdit!.color);
    }
  }

  @override
  Widget build(BuildContext context) {
    //*Widgets
    final addTaskButton = Material(
      color: Theme.of(context).colorScheme.primary,
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (!widget.isEdit) {
            addTask(taskTitleController.text, taskTextController.text,
                colors[colorSelected]);
          } else {
            replaceTask(taskTitleController.text, taskTextController.text,
                colors[colorSelected]);
          }
        },
        child: Text(
          widget.isEdit ? "Save Task" : "Add Task",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final taskTitleField = Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: taskTitleController,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Please enter something");
            }
            return null;
          },
          obscureText: false,
          onSaved: (value) {
            taskTitleController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Title",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 25)
      ],
    );

    final taskTextField = Column(
      children: [
        TextFormField(
          minLines: 5,
          maxLines: 5,
          autofocus: false,
          controller: taskTextController,
          keyboardType: TextInputType.text,
          obscureText: false,
          onSaved: (value) {
            taskTextController.text = value ?? "";
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Notes",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 25)
      ],
    );

    final colorPicker = Center(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: ((context, index) => Stack(
              alignment: Alignment.center,
              children: [
                if (index == colorSelected)
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      color: colors[index],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(7.5),
                  child: GestureDetector(
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        color: colors[index],
                      ),
                    ),
                    onTap: () => setState(() => colorSelected = index),
                  ),
                ),
              ],
            )),
      ),
    );

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.isEdit ? "Edit your task" : "Add new task")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              taskTitleField,
              taskTextField,
              SizedBox(
                child: colorPicker,
                height: 50,
              ),
              const SizedBox(height: 20),
              addTaskButton,
            ],
          ),
        ),
      ),
    );
  }

  addTask(String taskTitle, String taskText, Color color) {
    int indexLastIsDone =
        widget.tasks.lastIndexWhere((element) => element.isDone == false);
    if (_formKey.currentState!.validate()) {
      widget.tasks.insert(indexLastIsDone + 1,
          Task(taskTitle, taskText, false, color, indexLastIsDone + 1));
    }
    Navigator.pop(context);
    widget.setStateMain();
  }

  replaceTask(String taskTitle, String taskText, Color color) {
    if (_formKey.currentState!.validate()) {
      var index = widget.tasks.indexOf(widget.taskToEdit!);
      widget.tasks.removeAt(index);
      widget.tasks.insert(
          index,
          Task(taskTitle, taskText, widget.taskToEdit!.isDone, color,
              widget.taskToEdit!.index));
      Navigator.pop(context);
      widget.setStateMain();
    }
  }
}
