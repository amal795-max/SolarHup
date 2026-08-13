import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/complaints/data/models/complaint_model.dart';
import 'package:untitled1/features/complaints/data/repositories/complaint_repository.dart';

part 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  final ComplaintRepository repository;
  List<ComplaintModel> _cachedComplaints = [];

  ComplaintCubit(this.repository) : super(ComplaintInitial());
  List<ComplaintModel> get complaints => _cachedComplaints;

  Future<void> getMyComplaints() async {
    emit(ComplaintLoading());
    final result = await repository.getMyComplaints();
    result.fold(
          (failure) =>
          emit(ComplaintError(message: mapFailureToMessage(failure))),
          (complaints) {
        _cachedComplaints = complaints;
        emit(ComplaintSuccess(complaints: List.from(_cachedComplaints)));
      },
    );
  }

  Future<void> getComplaintDetails(int id) async {
    emit(ComplaintDetailsLoading());
    final result = await repository.getComplaintDetails(id);
    result.fold(
          (failure) =>
          emit(ComplaintError(message: mapFailureToMessage(failure))),
          (complaint) {
        _updateLocalCache(complaint);
        emit(ComplaintDetailsSuccess(complaint: complaint));
      },
    );
  }

  Future<void> sendMessage({required int complaintId, required String message,}) async {
    final current = state;
    if (current is! ComplaintDetailsSuccess) return;

    final originalComplaint = current.complaint;

    final tempMessage = ComplaintMessageModel(
      id: -DateTime.now().millisecondsSinceEpoch,
      senderId: originalComplaint.customerId,
      senderRole: 'customer',
      message: message,
      createdAt: DateTime.now(),
    );

    final updatedMessages = [...originalComplaint.messages, tempMessage];
    final optimisticComplaint = originalComplaint.copyWith(
      messages: updatedMessages,
      updatedAt: DateTime.now(),
    );

    emit(ComplaintDetailsSuccess(complaint: optimisticComplaint));

    final result = await repository.sendMessage(
      complaintId: complaintId,
      message: message,
    );

    result.fold(
          (failure) {
        emit(ComplaintDetailsSuccess(complaint: originalComplaint));
        emit(ComplaintError(message: mapFailureToMessage(failure)));
      },
          (newMessage) {
        final finalMessages = originalComplaint.messages.where((m) => m.id > 0).toList();
        finalMessages.add(newMessage);

        final finalComplaint = originalComplaint.copyWith(
          messages: finalMessages,
          updatedAt: DateTime.now(),
        );

        _updateLocalCache(finalComplaint);
        emit(ComplaintDetailsSuccess(complaint: finalComplaint));
      },
    );
  }

  void _updateLocalCache(ComplaintModel updatedComplaint) {
    final index = _cachedComplaints.indexWhere((c) => c.id == updatedComplaint.id);
    if (index != -1) {
      _cachedComplaints[index] = updatedComplaint;
    } else {
      _cachedComplaints.insert(0, updatedComplaint);
    }
  }
}