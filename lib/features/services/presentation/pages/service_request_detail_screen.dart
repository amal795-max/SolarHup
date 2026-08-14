import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/features/services/data/models/service_request_model.dart';
import 'package:untitled1/features/services/presentation/bloc/service_requests_cubit/service_requests_cubit.dart';
import 'package:untitled1/features/services/presentation/pages/booking_confirmation_screen.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class ServiceRequestDetailScreen extends StatefulWidget {
  final int requestId;

  const ServiceRequestDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<ServiceRequestDetailScreen> createState() =>
      _ServiceRequestDetailScreenState();
}

class _ServiceRequestDetailScreenState extends State<ServiceRequestDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceRequestsCubit>().loadRequestDetail(widget.requestId);
  }

  Future<void> _reload() async {
    await context
        .read<ServiceRequestsCubit>()
        .loadRequestDetail(widget.requestId);
  }

  Future<void> _cancelRequest() async {
    final success = await context
        .read<ServiceRequestsCubit>()
        .cancelRequest(widget.requestId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'service_request_cancelled_success'.tr()
              : 'stores_error_title'.tr(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceRequestsCubit, ServiceRequestsState>(
      listenWhen: (previous, current) =>
          current is ServiceRequestDetailsError &&
          previous is! ServiceRequestDetailsLoading,
      listener: (context, state) {
        if (state is ServiceRequestDetailsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is ServiceRequestDetailsLoading) {
          return const Scaffold(
            body: SafeArea(child: LoadingIndicator()),
          );
        }

        if (state is ServiceRequestDetailsError) {
          return Scaffold(
            body: SafeArea(
              child: EmptyWidget(
                icon: Icons.error_outline_rounded,
                title: 'stores_error_title'.tr(),
                subtitle: state.message,
                action: CustomButton(
                  text: 'stores_retry'.tr(),
                  onPressed: _reload,
                ),
              ),
            ),
          );
        }

        final request = _resolveRequest(state);
        if (request == null) {
          return const Scaffold(
            body: SafeArea(child: LoadingIndicator()),
          );
        }

        final isCancelling = state is ServiceRequestCancelling;

        return BookingConfirmationScreen(
          booking: request.toBookingConfirmation(),
          headerTitleKey: 'service_request_details_title',
          headerSubtitleKey: 'service_request_details_subtitle',
          showCancelButton: request.canCancel,
          isCancelling: isCancelling,
          onCancelTap: request.canCancel && !isCancelling ? _cancelRequest : null,
          showBackButton: true,
        );
      },
    );
  }

  ServiceRequestModel? _resolveRequest(ServiceRequestsState state) {
    return switch (state) {
      ServiceRequestDetailsLoaded(:final request) => request,
      ServiceRequestCancelling(:final request) => request,
      _ => null,
    };
  }
}
