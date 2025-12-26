import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_task_checkin_app/domain/models/task.dart';
import 'checkin_controller.dart';

class CheckinFormView extends StatelessWidget {
  CheckinFormView({super.key});

  final _formKey = GlobalKey<FormState>();
  final CheckinController controller = Get.find<CheckinController>();

  @override
  Widget build(BuildContext context) {
    final Task task = Get.arguments as Task;
    final String taskId = task.id;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          'Check In',
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
              _taskInfoCard(task),
              const SizedBox(height: 16),
              _formCard(taskId),
            ],
          ),
        ),
      ),
    );
  }

  // TASK INFO
  Widget _taskInfoCard(Task task) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
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
            const SizedBox(height: 6),
            Text(
              'Location: ${task.location}',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  //  FORM CARD
  Widget _formCard(String taskId) {
    return Expanded(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: _inputDecoration('Notes'),
                  validator: (v) =>
                      v == null || v.length < 10 ? 'Min 10 characters' : null,
                  onChanged: controller.notes,
                ),
                const SizedBox(height: 16),

                /// CATEGORY
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.category.value,
                    decoration: _inputDecoration('Category'),
                    items: const [
                      DropdownMenuItem(value: 'Safety', child: Text('Safety')),
                      DropdownMenuItem(
                          value: 'Progress', child: Text('Progress')),
                      DropdownMenuItem(value: 'Issue', child: Text('Issue')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: controller.category,
                  ),
                ),

                const SizedBox(height: 16),

                /// ERROR MESSAGE
                Obx(() => controller.errorMsg.value.isNotEmpty
                    ? Text(
                        controller.errorMsg.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const SizedBox()),

                const Spacer(),

                /// SUBMIT BUTTON
                Obx(() => _gradientButton(
                      isLoading: controller.isLoading.value,
                      onTap: controller.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                controller.submitCheckin(taskId);
                              }
                            },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //  UI HELPERS

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF1F5FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.blueGrey.shade200,
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
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _gradientButton({
    required bool isLoading,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Submit Check-in',
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
