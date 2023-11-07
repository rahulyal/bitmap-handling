class BookingObject {
  String confirmationCode;
  Map<String, String> patientObject;
  String status;
  String userID;

  BookingObject({
    required this.confirmationCode,
    required this.patientObject,
    required this.status,
    required this.userID,
  });
}
