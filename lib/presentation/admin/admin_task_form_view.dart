import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_controller.dart';
import '../../domain/models/task.dart';
import '../../domain/models/user.dart';

class AdminTaskFormView extends StatefulWidget {
  const AdminTaskFormView({super.key, this.onTaskSaved});
  final void Function(Task task)? onTaskSaved;
  @override
  State<AdminTaskFormView> createState() => _AdminTaskFormViewState();
}

class _AdminTaskFormViewState extends State<AdminTaskFormView> {
  final controller = Get.put(AdminController());
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  late TextEditingController locationCtrl;

  String title = '';
  String desc = '';
  String status = 'Open';
  String priority = 'Low';
  String location = '';
  DateTime? dueDate;
  Task? editTask;
  bool isEdit = false;
  @override
  void initState() {
    super.initState();

    editTask = Get.arguments as Task?;
    isEdit = editTask != null;

    titleCtrl = TextEditingController(
      text: isEdit ? editTask!.title : '',
    );

    descCtrl = TextEditingController(
      text: isEdit ? editTask!.description : '',
    );

    locationCtrl = TextEditingController(
      text: isEdit ? editTask!.location : '',
    );

    if (isEdit) {
      status = editTask!.status;
      priority = editTask!.priority;
      dueDate = editTask!.dueDate;
      assignedUserId = editTask!.assignedUserId;
    }
    if (!users.any((u) => u.id == assignedUserId)) {
      assignedUserId = users.first.id;
    }
  }

  final users = [
    User(
      id: 'u1',
      email: 'rahul.sharma@gmail.com',
      displayName: 'Rahul Sharma',
      role: 'member',
    ),
    User(
      id: 'u2',
      email: 'priya.patel@gmail.com',
      displayName: 'Priya Patel',
      role: 'member',
    ),
    User(
      id: 'u3',
      email: 'amit.verma@gmail.com',
      displayName: 'Amit Verma',
      role: 'member',
    ),
    User(
      id: 'u4',
      email: 'neha.singh@gmail.com',
      displayName: 'Neha Singh',
      role: 'member',
    ),
    User(
      id: 'u5',
      email: 'suresh.nair@gmail.com',
      displayName: 'Suresh Nair',
      role: 'member',
    ),
    User(
      id: 'u6',
      email: 'pooja.kulkarni@gmail.com',
      displayName: 'Pooja Kulkarni',
      role: 'member',
    ),
    User(
      id: 'u7',
      email: 'vikas.yadav@gmail.com',
      displayName: 'Vikas Yadav',
      role: 'member',
    ),
    User(
      id: 'u8',
      email: 'anjali.mehta@gmail.com',
      displayName: 'Anjali Mehta',
      role: 'member',
    ),
  ];

  String assignedUserId = 'u1';

  void _save() {
    if (!_formKey.currentState!.validate() || dueDate == null) {
      Get.snackbar(
        'Error',
        'All fields are required',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final task = Task(
      id: isEdit ? editTask!.id : '',
      title: titleCtrl.text,
      description: descCtrl.text,
      status: status,
      priority: priority,
      dueDate: dueDate!,
      location: locationCtrl.text,
      assignedUserId: assignedUserId,
      updatedAt: DateTime.now(),
      syncStatus: 'pending',
    );
    controller.saveTask(
      task,
      isEdit: isEdit,
      onSuccess: () {
        widget.onTaskSaved?.call(task);
      },
    );

    // controller.saveTask(task, isEdit: isEdit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: false,
        // title: const Text(
        //   'Create Task',
        //   style: TextStyle(color: Colors.white),
        // ),
        title: Text(
          isEdit ? 'Edit Task' : 'Create Task',
          style: const TextStyle(color: Colors.white),
        ),

        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 20),
        //     child: InkWell(
        //       onTap: () {
        //         Get.offAllNamed(AppRoutes.roleSelection);
        //       },
        //       child: const Icon(Icons.logout_outlined, color: Colors.white),
        //     ),
        //   ),
        // ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1E3C72)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // _field('Title', onChanged: (v) => title = v),
                  // _field('Description', onChanged: (v) => desc = v),
                  _field('Title', controller: titleCtrl),
                  _field('Description', controller: descCtrl),

                  _dropdown(
                    'Status',
                    status,
                    ['Open', 'In Progress', 'Done'],
                    (v) => setState(() => status = v),
                  ),
                  _dropdown(
                    'Priority',
                    priority,
                    ['Low', 'Medium', 'High'],
                    (v) => setState(() => priority = v),
                  ),
                  // _field('Location', onChanged: (v) => location = v),
                  _field('Location', controller: locationCtrl),
                  const SizedBox(height: 12),
                  _datePicker(),
                  const SizedBox(height: 12),
                  _dropdown(
                    'Assign User',
                    assignedUserId,
                    users.map((e) => e.id).toList(),
                    (v) => setState(() => assignedUserId = v),
                    labelBuilder: (id) =>
                        users.firstWhere((u) => u.id == id).displayName!,
                  ),
                  const SizedBox(height: 24),
                  Obx(() => controller.errorMsg.value.isNotEmpty
                      ? Text(controller.errorMsg.value,
                          style: const TextStyle(color: Colors.red))
                      : const SizedBox()),
                  const SizedBox(height: 16),
                  Obx(() => _gradientButton(
                        text: controller.isLoading.value
                            ? 'Saving...'
                            : 'Save Task',
                        onTap: controller.isLoading.value ? null : _save,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label, {
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        decoration: _inputDecoration(label),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    Function(String) onChanged, {
    String Function(String)? labelBuilder,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: _inputDecoration(label),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(labelBuilder != null ? labelBuilder(e) : e),
                ))
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }

  Widget _datePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) setState(() => dueDate = picked);
      },
      child: InputDecorator(
        decoration: _inputDecoration('Due Date'),
        child: Text(
          dueDate == null
              ? 'Select date'
              : dueDate!.toString().split(' ').first,
        ),
      ),
    );
  }

  Widget _gradientButton({required String text, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1E3C72)],
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: const Color(0xFFF1F5FB), // 👈 YOUR DESIRED COLOR
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.blueGrey.shade200,
          width: 1,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF2196F3),
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }
}
