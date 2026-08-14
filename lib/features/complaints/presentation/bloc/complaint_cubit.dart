
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/features/complaints/data/models/complaint_model.dart';
import 'package:untitled1/features/complaints/data/repositories/complaint_repository.dart';

import '../../../../core/constants/failure_success_message.dart';

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
      (failure) => emit(ComplaintError(message: mapFailureToMessage(failure))),
      (complaints) {
        _cachedComplaints = complaints;
        emit(ComplaintSuccess(complaints: List.from(_cachedComplaints)));
      },
    );
  }

  Future<void> addComplaints({required int businessId, required String subject, required String message,}) async {AddComplaintParams params = AddComplaintParams(businessId: businessId, subject: subject, message: message,);
    emit(ComplaintLoading());
    final result = await repository.createComplaint(params);
    result.fold(
      (failure) => emit(ComplaintError(message: mapFailureToMessage(failure))),
      (complaint) {
        emit(const ComplaintActionSuccess(message: complaintSubmittedSuccessfully));
      },
    );
  }

  Future<void> getComplaintDetails(int id) async {
    emit(ComplaintDetailsLoading());
    final result = await repository.getComplaintDetails(id);
    result.fold(
      (failure) => emit(ComplaintError(message: mapFailureToMessage(failure))),
      (complaint) {
        emit(ComplaintDetailsSuccess(complaint: complaint));
      },
    );
  }
  Future<void> sendMessage({required int complaintId, required String message,}) async {

    final complaintIndex = _cachedComplaints.indexWhere((complaint) => complaint.id == complaintId,);
    final currentComplaint = _cachedComplaints[complaintIndex];

    emit(
      ComplaintDetailsSuccess(
        complaint: currentComplaint,
        isSendingMessage: true,
      ),
    );

    final result = await repository.sendMessage(
      complaintId: complaintId,
      message: message,
    );

    result.fold(
          (failure) {
        emit(
          ComplaintDetailsSuccess(
            complaint: currentComplaint,
            isSendingMessage: false,
            messageError: mapFailureToMessage(failure),
          ),
        );
      },
          (complaint) {
            currentComplaint.copyWith(messages: complaint.messages);
        emit(ComplaintDetailsSuccess(complaint: complaint, isSendingMessage: false,),
        );
      },
    );
  }
}
