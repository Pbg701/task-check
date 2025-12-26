
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_task_checkin_app/presentation/auth/auth_controller.dart';
import 'package:offline_task_checkin_app/presentation/checkin/checkin_form_view.dart';
import 'package:offline_task_checkin_app/routes/app_routes.dart';
import '../../domain/models/task.dart';

class TaskDetailView extends StatelessWidget {
  const TaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Task task = Get.arguments as Task;
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        actions: [
          Obx(() {
            if (auth.currentUser.value?.role != 'admin') {
              return const SizedBox.shrink();
            }

            return IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Get.toNamed(
                  AppRoutes.adminTaskForm,
                  arguments: task, // edit mode
                );
              },
            );
          }),
        ],
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Task Details',
          style: TextStyle(color: Colors.white),
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _taskHeader(task),
              const SizedBox(height: 16),
              _detailCard(task),
              const Spacer(),
              _checkInButton(task),
            ],
          ),
        ),
      ),
    );
  }

  /* --------------------------------------------------
      HEADER
  -------------------------------------------------- */
  Widget _taskHeader(Task task) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
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
    );
  }

  /* --------------------------------------------------
      DETAIL CARD
  -------------------------------------------------- */
  Widget _detailCard(Task task) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoRow(Icons.calendar_today, 'Due Date',
                task.dueDate.toString().split(' ').first),
            _infoRow(Icons.location_on, 'Location', task.location),
            _infoRow(Icons.person, 'Assigned To', task.assignedUserId),
            _infoRow(Icons.update, 'Last Updated',
                task.updatedAt.toString().split(' ').first),
            const Divider(height: 24),
            Row(
              children: [
                const Text(
                  'Sync Status:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                _syncChip(task.syncStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /* --------------------------------------------------
      CHIPS
  -------------------------------------------------- */
  Widget _statusChip(String status) {
    return Chip(
      label: Text(status),
      backgroundColor: status == 'Done'
          ? Colors.green.shade100
          : status == 'In Progress'
              ? Colors.orange.shade100
              : Colors.blue.shade100,
    );
  }

  Widget _priorityChip(String priority) {
    return Chip(
      label: Text(priority),
      backgroundColor: priority == 'High'
          ? Colors.red.shade100
          : priority == 'Medium'
              ? Colors.orange.shade100
              : Colors.green.shade100,
    );
  }

  Widget _syncChip(String sync) {
    return Chip(
      label: Text(sync),
      backgroundColor: sync == 'pending'
          ? Colors.orange.shade200
          : sync == 'synced'
              ? Colors.green.shade200
              : Colors.red.shade200,
    );
  }

  /* --------------------------------------------------
      ACTION BUTTON
  -------------------------------------------------- */
  Widget _checkInButton(Task task) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CheckinFormView(), arguments: task);
        //  Get.toNamed('/checkin', arguments: task);
      },
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1E3C72)],
          ),
        ),
        child: const Text(
          'Check-in',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CheckInView extends StatelessWidget {
  const CheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    final Task task = Get.arguments as Task;

    return Scaffold(
      appBar: AppBar(title: const Text('Check-In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Task ID: ${task.id}'),
            Text('Location: ${task.location}'),
            Text('Status: ${task.status}'),
          ],
        ),
      ),
    );
  }
}
