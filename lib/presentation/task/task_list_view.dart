import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_task_checkin_app/domain/models/task.dart';
import 'package:offline_task_checkin_app/presentation/admin/admin_task_form_view.dart';
import 'package:offline_task_checkin_app/presentation/auth/auth_controller.dart';
import 'task_controller.dart';
import '../../core/utils/date_utils.dart';
import '../../routes/app_routes.dart';

class TaskListView extends StatelessWidget {
  TaskListView({super.key});
  final auth = Get.find<AuthController>();

  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Tasks',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                Get.offAllNamed(AppRoutes.roleSelection);
              },
              child: const Icon(Icons.logout_outlined, color: Colors.white),
            ),
          ),
        ],
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
      body: SafeArea(
        child: Column(
          children: [
            _sortBar(),
            _filterBar(),
            Expanded(child: _taskList()),
          ],
        ),
      ),
      // floatingActionButton: Obx(
      //   () => controller.isLoading.value
      //       ? const SizedBox.shrink()
      //       : _gradientFAB(),
      // ),
      floatingActionButton: Obx(() {
        final isAdmin = auth.currentUser.value?.role == 'admin';

        if (!isAdmin || controller.isLoading.value) {
          return const SizedBox.shrink();
        }

        return _gradientFAB();
      }),
    );
  }

  // SORT BAR
  Widget _sortBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _sortChip(
            label: 'Priority',
            icon: Icons.flag,
            onTap: controller.sortTasksByPriority,
          ),
          const SizedBox(width: 12),
          _sortChip(
            label: 'Due Date',
            icon: Icons.calendar_today,
            onTap: controller.sortTasksByDueDate,
          ),
        ],
      ),
    );
  }

  Widget _filterBar() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Wrap(
          spacing: 8,
          children: ['All', 'Open', 'In Progress', 'Done']
              .map(
                (status) => ChoiceChip(
                  label: Text(status),
                  selected: controller.selectedStatus.value == status,
                  onSelected: (_) => controller.filterByStatus(status),
                ),
              )
              .toList(),
        ),
      );
    });
  }

  Widget _sortChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.blue),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // TASK LIST
  Widget _taskList() {
    return Obx(() {
      if (controller.isLoading.value && controller.tasks.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMsg.value.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorMsg.value,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      if (controller.tasks.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.fetchTasks,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 200),
              Center(
                child: Text(
                  'No tasks available',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchTasks,
        child: ListView.builder(
          key: const PageStorageKey('taskList'),
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final task = controller.tasks[index];
            return _taskCard(task);
          },
        ),
      );
    });
  }

  void _confirmDelete(Task task) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back();
              await controller.deleteTask(task);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _taskCard(Task task) {
    final isAdmin = auth.currentUser.value?.role == 'admin';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Get.toNamed(AppRoutes.taskDetail, arguments: task),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 TITLE + ADMIN ACTIONS
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isAdmin)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Get.to(
                            () => AdminTaskFormView(
                              onTaskSaved: (updatedTask) {
                                controller.upsertTask(updatedTask);
                              },
                            ),
                            arguments: task,
                          );
                        } else if (value == 'delete') {
                          _confirmDelete(task);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // 🔹 META INFO
              Text(
                'Due: ${DateUtilsC.formatShortDate(task.dueDate)}',
                style: const TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 12),

              // 🔹 STATUS + PRIORITY
              Row(
                children: [
                  _statusChip(task.status),
                  const SizedBox(width: 8),
                  _priorityChip(task.priority),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = switch (status) {
      'Open' => Colors.blue,
      'In Progress' => Colors.orange,
      'Done' => Colors.green,
      _ => Colors.grey,
    };

    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: color),
    );
  }

  Widget _priorityChip(String priority) {
    final color = switch (priority) {
      'High' => Colors.red,
      'Medium' => Colors.orange,
      _ => Colors.grey,
    };

    return Chip(
      label: Text('Priority: $priority'),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: color),
    );
  }

  // FLOATING ACTION BUTTON
  Widget _gradientFAB() {
    return FloatingActionButton(
      // onPressed: () async {
      //   final result = await Get.toNamed(AppRoutes.adminTaskForm);
      //   if (result == true) {
      //     await controller.fetchTasks();
      //   }
      // },
      onPressed: () {
        Get.to(
          () => AdminTaskFormView(
            onTaskSaved: (task) {
              controller.upsertTask(task);
            },
          ),
        );
      },

      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1E3C72)],
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
