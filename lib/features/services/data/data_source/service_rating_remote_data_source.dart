import '../models/service_rating_model.dart';

abstract class ServiceRatingRemoteDataSource {
  Future<ServiceRatingModel> getServiceRating(String serviceId);
  Future<void> submitServiceRating(ServiceRatingSubmissionModel submission);
}

class ServiceRatingRemoteDataSourceImpl
    implements ServiceRatingRemoteDataSource {
  const ServiceRatingRemoteDataSourceImpl();

  static const _byService = <String, ServiceRatingModel>{
    'svc-1': ServiceRatingModel(
      serviceId: 'svc-1',
      serviceReferenceId: '#SR-8291',
      technician: ServiceRatingTechnicianModel(
        name: 'David Miller',
        role: 'Maintenance Specialist',
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&q=80',
      ),
      serviceDate: 'Oct 26, 2023',
      serviceTime: '10:30 AM',
      existingPhotos: [
        ServiceRatingPhotoModel(
          imageUrl:
              'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=500&q=80',
        ),
        ServiceRatingPhotoModel(
          imageUrl:
              'https://images.unsplash.com/photo-1559302504-64aae6ca6b6d?w=500&q=80',
        ),
      ],
    ),
    'svc-2': ServiceRatingModel(
      serviceId: 'svc-2',
      serviceReferenceId: '#SR-8292',
      technician: ServiceRatingTechnicianModel(
        name: 'David Miller',
        role: 'Maintenance Specialist',
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&q=80',
      ),
      serviceDate: 'Oct 26, 2023',
      serviceTime: '10:30 AM',
      existingPhotos: [
        ServiceRatingPhotoModel(
          imageUrl:
              'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=500&q=80',
        ),
      ],
    ),
  };

  static const _fallback = ServiceRatingModel(
    serviceId: 'svc-default',
    serviceReferenceId: '#SR-8291',
    technician: ServiceRatingTechnicianModel(
      name: 'David Miller',
      role: 'Maintenance Specialist',
      avatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&q=80',
    ),
    serviceDate: 'Oct 26, 2023',
    serviceTime: '10:30 AM',
    existingPhotos: [
      ServiceRatingPhotoModel(
        imageUrl:
            'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=500&q=80',
      ),
      ServiceRatingPhotoModel(
        imageUrl:
            'https://images.unsplash.com/photo-1559302504-64aae6ca6b6d?w=500&q=80',
      ),
    ],
  );

  @override
  Future<ServiceRatingModel> getServiceRating(String serviceId) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _byService[serviceId] ?? _fallback;
  }

  @override
  Future<void> submitServiceRating(ServiceRatingSubmissionModel submission) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
