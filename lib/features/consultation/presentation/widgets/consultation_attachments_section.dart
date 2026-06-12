import 'dart:io' show File;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/consultation/data/models/consultation_attachment_model.dart';
import 'package:untitled1/features/consultation/presentation/bloc/book_consultation_bloc/book_consultation_bloc.dart';

class ConsultationAttachmentsSection extends StatelessWidget {
  final List<ConsultationAttachmentModel> attachments;

  const ConsultationAttachmentsSection({
    super.key,
    required this.attachments,
  });

  static const _maxFileSizeBytes = 10 * 1024 * 1024;

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (file == null || !context.mounted) return;

    final size = await file.length();
    if (size > _maxFileSizeBytes) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('consultation_attachment_too_large'.tr()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final path = file.path;
    if (path.isEmpty || !context.mounted) return;

    context.read<BookConsultationBloc>().add(
          AddAttachmentEvent(
            ConsultationAttachmentModel(
              id: '${DateTime.now().millisecondsSinceEpoch}_${file.name}',
              path: path,
              name: file.name,
            ),
          ),
        );
  }

  void _showPickOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text('consultation_pick_gallery'.tr()),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text('consultation_pick_camera'.tr()),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(context, ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'consultation_attachments'.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        if (attachments.isNotEmpty) ...[
          SizedBox(
            height: 88.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: attachments.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final attachment = attachments[index];
                return _AttachmentThumbnail(
                  attachment: attachment,
                  onRemove: () => context.read<BookConsultationBloc>().add(
                        RemoveAttachmentEvent(attachment.id),
                      ),
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
        ],
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showPickOptions(context),
            borderRadius: BorderRadius.circular(14.r),
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: theme.colorScheme.outline,
                radius: 14.r,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 120.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 32.sp,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'consultation_upload_files'.tr(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'consultation_upload_hint'.tr(),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AttachmentThumbnail extends StatelessWidget {
  final ConsultationAttachmentModel attachment;
  final VoidCallback onRemove;

  const _AttachmentThumbnail({
    required this.attachment,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: SizedBox(
            width: 88.w,
            height: 88.h,
            child: _AttachmentImage(path: attachment.path),
          ),
        ),
        Positioned(
          top: -6.h,
          right: -6.w,
          child: Material(
            color: isDark ? AppColors.darkGray : AppColors.white,
            shape: const CircleBorder(),
            elevation: 2,
            child: InkWell(
              onTap: onRemove,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Icon(
                  Icons.close_rounded,
                  size: 16.sp,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AttachmentImage extends StatelessWidget {
  final String path;

  const _AttachmentImage({required this.path});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _AttachmentPlaceholder(),
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const _AttachmentPlaceholder(),
    );
  }
}

class _AttachmentPlaceholder extends StatelessWidget {
  const _AttachmentPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Icon(
        Icons.image_outlined,
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, end.clamp(0, metric.length)),
          paint,
        );
        distance = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
