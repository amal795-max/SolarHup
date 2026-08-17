import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/features/services/data/models/service_request_model.dart';
import 'package:untitled1/features/services/presentation/bloc/service_requests_cubit/service_requests_cubit.dart';
import 'package:untitled1/features/services/presentation/pages/booking_confirmation_screen.dart';
import 'package:untitled1/widgets/error_widget.dart';
import 'package:untitled1/widgets/loader.dart';

class ServiceRequestDetailScreen extends StatefulWidget {
  final int requestId;

  const ServiceRequestDetailScreen({super.key, required this.requestId});

  @override
  State<ServiceRequestDetailScreen> createState() =>
      _ServiceRequestDetailScreenState();
}

class _ServiceRequestDetailScreenState
    extends State<ServiceRequestDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceRequestsCubit>().loadRequestDetail(widget.requestId);
  }

  Future<void> _reload() async {
    await context.read<ServiceRequestsCubit>().loadRequestDetail(
      widget.requestId,
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<ServiceRequestsCubit>();
        final request = _resolveRequest(state, cubit);
        final isLoading = state is ServiceRequestDetailsLoading;
        final hasCachedData = request != null;

        if (state is ServiceRequestDetailsError && !hasCachedData) {
          return Scaffold(
            body: SafeArea(
              child: errorWidget(
                message: state.message,
                hasButton: true,
                onPressed: _reload,
              ),
            ),
          );
        }

        if (isLoading && !hasCachedData) {
          return const Scaffold(body: SafeArea(child: LoadingIndicator()));
        }

        if (request == null) {
          return const Scaffold(body: SafeArea(child: LoadingIndicator()));
        }

        return BookingConfirmationScreen(
          booking: request.toBookingConfirmation(),
          headerTitleKey: 'service_request_details_title',
          headerSubtitleKey: 'service_request_details_subtitle',
          showBackButton: true,
          onRefresh: _reload,
        );
      },
    );
  }

  ServiceRequestModel? _resolveRequest(
    ServiceRequestsState state,
    ServiceRequestsCubit cubit,
  ) {
    final fromState = switch (state) {
      ServiceRequestDetailsLoaded(:final request) => request,
      ServiceRequestCancelling(:final request) => request,
      _ => null,
    };
    if (fromState != null) return fromState;

    for (final item in cubit.cachedRequests) {
      if (item.id == widget.requestId) return item;
    }
    return null;
  }
}
