import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nerutalk/domain/models/call_models.dart';

class CallHistoryController extends GetxController {
  final RxList<CallHistory> callHistory = <CallHistory>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCallHistory();
  }

  Future<void> loadCallHistory() async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for now
      callHistory.value = [
        CallHistory(
          id: '1',
          callId: 'call_1',
          otherParticipantId: 'user2',
          otherParticipantName: 'John Doe',
          type: CallType.video,
          status: CallStatus.ended,
          startedAt: DateTime.now().subtract(const Duration(hours: 2)),
          endedAt: DateTime.now().subtract(const Duration(hours: 2, minutes: -15)),
          duration: 900, // 15 minutes
          isIncoming: false,
        ),
        CallHistory(
          id: '2',
          callId: 'call_2',
          otherParticipantId: 'user3',
          otherParticipantName: 'Alice Smith',
          type: CallType.audio,
          status: CallStatus.missed,
          startedAt: DateTime.now().subtract(const Duration(days: 1)),
          isIncoming: true,
        ),
        CallHistory(
          id: '3',
          callId: 'call_3',
          otherParticipantId: 'user4',
          otherParticipantName: 'Bob Wilson',
          type: CallType.video,
          status: CallStatus.declined,
          startedAt: DateTime.now().subtract(const Duration(days: 2)),
          isIncoming: false,
        ),
        CallHistory(
          id: '4',
          callId: 'call_4',
          otherParticipantId: 'user5',
          otherParticipantName: 'Sarah Johnson',
          type: CallType.audio,
          status: CallStatus.ended,
          startedAt: DateTime.now().subtract(const Duration(days: 3)),
          endedAt: DateTime.now().subtract(const Duration(days: 3, minutes: -30)),
          duration: 1800, // 30 minutes
          isIncoming: true,
        ),
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load call history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHistory() async {
    await loadCallHistory();
  }

  void initiateCall(String userId, CallType type) {
    // TODO: Implement call initiation
    Get.snackbar(
      'Call',
      'Initiating ${type.name} call to user $userId...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showCallDetails(CallHistory call) {
    // TODO: Navigate to call details page
    Get.snackbar(
      'Call Details',
      'Call with ${call.otherParticipantName} on ${call.startedAt}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void clearHistory() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Call History'),
        content: const Text('Are you sure you want to clear all call history?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              callHistory.clear();
              Get.back();
              Get.snackbar(
                'Success',
                'Call history cleared',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
