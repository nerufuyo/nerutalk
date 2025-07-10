import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nerutalk/core/constants/app_colors.dart';
import 'package:nerutalk/presentation/controllers/video_call_controller.dart';

class VideoCallPage extends GetView<VideoCallController> {
  const VideoCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => Stack(
          children: [
            // Video rendering area
            _buildVideoArea(),

            // Controls overlay
            _buildControlsOverlay(),

            // Top bar with participant info
            _buildTopBar(),

            // Bottom controls
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoArea() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: controller.isVideoEnabled.value
          ? Container(
              color: Colors.grey[900],
              child: const Center(
                child: Text(
                  'Video Stream Area\n(Agora RTC will render here)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    controller.otherParticipantName.value[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildControlsOverlay() {
    if (!controller.showControls.value) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.3),
      child: GestureDetector(
        onTap: controller.toggleControls,
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.callStatus.value == 'ongoing'
                          ? Colors.green
                          : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => Text(
                      controller.callDuration.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (controller.participants.length > 2) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${controller.participants.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: AnimatedOpacity(
          opacity: controller.showControls.value ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Mute/Unmute Audio
                _buildControlButton(
                  icon: controller.isAudioEnabled.value
                      ? Icons.mic
                      : Icons.mic_off,
                  onPressed: controller.toggleAudio,
                  backgroundColor: controller.isAudioEnabled.value
                      ? Colors.grey[800]
                      : Colors.red,
                ),

                // End Call
                _buildControlButton(
                  icon: Icons.call_end,
                  onPressed: controller.endCall,
                  backgroundColor: Colors.red,
                  isLarge: true,
                ),

                // Enable/Disable Video
                _buildControlButton(
                  icon: controller.isVideoEnabled.value
                      ? Icons.videocam
                      : Icons.videocam_off,
                  onPressed: controller.toggleVideo,
                  backgroundColor: controller.isVideoEnabled.value
                      ? Colors.grey[800]
                      : Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
    bool isLarge = false,
  }) {
    final size = isLarge ? 64.0 : 52.0;
    final iconSize = isLarge ? 32.0 : 24.0;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey[800],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }
}
