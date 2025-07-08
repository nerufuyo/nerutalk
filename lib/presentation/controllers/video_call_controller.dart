import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nerutalk/domain/models/call_models.dart';
import 'package:nerutalk/presentation/routes/app_routes.dart';

class VideoCallController extends GetxController {
  final RxBool isVideoEnabled = true.obs;
  final RxBool isAudioEnabled = true.obs;
  final RxBool showControls = true.obs;
  final RxString callStatus = 'connecting'.obs;
  final RxString callDuration = '00:00'.obs;
  final RxString otherParticipantName = 'Unknown User'.obs;
  final RxList<CallParticipant> participants = <CallParticipant>[].obs;

  Timer? _callTimer;
  DateTime? _callStartTime;
  String? callId;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    callId = arguments?['callId'];
    otherParticipantName.value =
        arguments?['participantName'] ?? 'Unknown User';

    _initializeCall();
    _startControlsTimer();
  }

  @override
  void onClose() {
    _callTimer?.cancel();
    _endCallCleanup();
    super.onClose();
  }

  void _initializeCall() {
    // TODO: Initialize Agora RTC Engine
    // TODO: Join channel with call ID

    // Simulate call connection
    Future.delayed(const Duration(seconds: 2), () {
      callStatus.value = 'ongoing';
      _callStartTime = DateTime.now();
      _startCallTimer();
    });

    // Mock participants
    participants.value = [
      CallParticipant(
        userId: 'current_user',
        name: 'Me',
        isVideoEnabled: isVideoEnabled.value,
        isAudioEnabled: isAudioEnabled.value,
        joinedAt: DateTime.now(),
      ),
      CallParticipant(
        userId: 'other_user',
        name: otherParticipantName.value,
        isVideoEnabled: true,
        isAudioEnabled: true,
        joinedAt: DateTime.now(),
      ),
    ];
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_callStartTime != null) {
        final duration = DateTime.now().difference(_callStartTime!);
        final minutes = duration.inMinutes.toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
        callDuration.value = '$minutes:$seconds';
      }
    });
  }

  void _startControlsTimer() {
    // Hide controls after 3 seconds
    Timer(const Duration(seconds: 3), () {
      showControls.value = false;
    });
  }

  void toggleControls() {
    showControls.value = !showControls.value;

    if (showControls.value) {
      _startControlsTimer();
    }
  }

  void toggleAudio() {
    isAudioEnabled.value = !isAudioEnabled.value;

    // TODO: Enable/disable audio in Agora RTC

    // Update participant state
    final currentUserIndex = participants.indexWhere(
      (p) => p.userId == 'current_user',
    );
    if (currentUserIndex != -1) {
      participants[currentUserIndex] = participants[currentUserIndex].copyWith(
        isAudioEnabled: isAudioEnabled.value,
      );
    }

    Get.snackbar(
      'Audio',
      isAudioEnabled.value ? 'Microphone enabled' : 'Microphone disabled',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  void toggleVideo() {
    isVideoEnabled.value = !isVideoEnabled.value;

    // TODO: Enable/disable video in Agora RTC

    // Update participant state
    final currentUserIndex = participants.indexWhere(
      (p) => p.userId == 'current_user',
    );
    if (currentUserIndex != -1) {
      participants[currentUserIndex] = participants[currentUserIndex].copyWith(
        isVideoEnabled: isVideoEnabled.value,
      );
    }

    Get.snackbar(
      'Video',
      isVideoEnabled.value ? 'Camera enabled' : 'Camera disabled',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  void endCall() {
    Get.dialog(
      AlertDialog(
        title: const Text('End Call'),
        content: const Text('Are you sure you want to end this call?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _endCall();
            },
            child: const Text('End Call', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _endCall() {
    callStatus.value = 'ended';
    _endCallCleanup();

    // TODO: Leave Agora channel
    // TODO: Send end call event to backend

    Get.offAllNamed(AppRoutes.home);
    Get.snackbar(
      'Call Ended',
      'Call duration: ${callDuration.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _endCallCleanup() {
    _callTimer?.cancel();
    // TODO: Cleanup Agora RTC Engine
  }

  void switchCamera() {
    // TODO: Implement camera switching with Agora RTC
    Get.snackbar(
      'Camera',
      'Camera switched',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  void enableSpeaker() {
    // TODO: Enable speaker mode
    Get.snackbar(
      'Audio',
      'Speaker enabled',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }
}
