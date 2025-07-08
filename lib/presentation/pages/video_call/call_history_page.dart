import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nerutalk/core/constants/app_colors.dart';
import 'package:nerutalk/core/constants/app_strings.dart';
import 'package:nerutalk/presentation/controllers/call_history_controller.dart';
import 'package:nerutalk/presentation/routes/app_routes.dart';
import 'package:nerutalk/presentation/widgets/common/loading_indicator.dart';

class CallHistoryPage extends GetView<CallHistoryController> {
  const CallHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.calls.tr),
        actions: [
          IconButton(
            onPressed: controller.clearHistory,
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingIndicator();
        }

        if (controller.callHistory.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.call_outlined,
                  size: 80,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noCallHistory.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.startFirstCall.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshHistory,
          child: ListView.builder(
            itemCount: controller.callHistory.length,
            itemBuilder: (context, index) {
              final call = controller.callHistory[index];
              return _buildCallItem(call);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.newCall),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.video_call, color: Colors.white),
      ),
    );
  }

  Widget _buildCallItem(dynamic call) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            backgroundImage: call.otherParticipantAvatar != null
                ? NetworkImage(call.otherParticipantAvatar!)
                : null,
            child: call.otherParticipantAvatar == null
                ? Text(
                    call.otherParticipantName?[0]?.toUpperCase() ?? 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                call.isIncoming ? Icons.call_received : Icons.call_made,
                size: 12,
                color: _getCallStatusColor(call.status),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        call.otherParticipantName ?? AppStrings.unknownUser.tr,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            call.type.name == 'video' ? Icons.videocam : Icons.call,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            _getCallStatusText(call.status, call.isIncoming),
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          if (call.duration != null) ...[
            Text(
              ' • ${call.formattedDuration}',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatCallTime(call.startedAt),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => controller.initiateCall(
              call.otherParticipantId ?? '',
              call.type,
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                call.type.name == 'video' ? Icons.videocam : Icons.call,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      onTap: () => controller.showCallDetails(call),
    );
  }

  Color _getCallStatusColor(dynamic status) {
    switch (status.toString()) {
      case 'CallStatus.ended':
        return Colors.green;
      case 'CallStatus.declined':
      case 'CallStatus.missed':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getCallStatusText(dynamic status, bool isIncoming) {
    switch (status.toString()) {
      case 'CallStatus.ended':
        return isIncoming ? AppStrings.incoming.tr : AppStrings.outgoing.tr;
      case 'CallStatus.declined':
        return AppStrings.declined.tr;
      case 'CallStatus.missed':
        return AppStrings.missed.tr;
      default:
        return AppStrings.unknown.tr;
    }
  }

  String _formatCallTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return AppStrings.now.tr;
    }
  }
}
