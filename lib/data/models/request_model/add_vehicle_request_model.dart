class AddVehicleRequestModel {
    String type;
    String vehicleModel;
    int year;
    String plateNumber;
    String color;
    int capacity;
    bool isPrimary;

    AddVehicleRequestModel({
      required this.type,
      required this.vehicleModel,
      required this.year,
      required this.plateNumber,
      required this.color,
      required this.capacity,
      required this.isPrimary,
    });

    Map<String, dynamic> toJson() => {
          "type": type,
          "vehicleModel": vehicleModel,
          "year": year,
          "plateNumber": plateNumber,
          "color": color,
          "capacity": capacity,
          "isPrimary": isPrimary,
        };
  }