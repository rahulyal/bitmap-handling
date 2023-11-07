import 'bookingobject.dart';

/////////////////////////////////////////////////
/// Class Definition
/////////////////////////////////////////////////

class AppointmentBlockObject {
  final String doctorID;
  final Map<String, DateTime> timeUnit;
  BookingObject? bookingObject;

  AppointmentBlockObject({
    required this.doctorID,
    required this.timeUnit,
    this.bookingObject,
  });

  ////////////////////////////////////////////////
  /// Dummy objects to populate data for testing
  ////////////////////////////////////////////////

  // static List<AppointmentBlockObject> dummys = [
  //   AppointmentBlockObject(
  //     doctorID: 'doctor0001',
  //     timeUnit: {
  //       'AptStartTime': DateTime(2023, 10, 2, 9, 0, 0),
  //       'AptEndTime': DateTime(2023, 10, 2, 9, 30, 0),
  //       'WeekID': DateTime(2023, 10, 1, 0, 0, 0),
  //     },
  //     bookingObject: BookingObject(
  //         confirmationCode: 'YVX67',
  //         patientObject: {
  //           'Name': 'Patient0001',
  //           'PhoneNumber': '4083879396',
  //           'DOB': '1970-01-01'
  //         },
  //         status: 'Booked',
  //         userID: 'user001'),
  //   ),
  //   AppointmentBlockObject(
  //     doctorID: 'doctor0002',
  //     timeUnit: {
  //       'AptStartTime': DateTime(2023, 10, 2, 9, 30, 0),
  //       'AptEndTime': DateTime(2023, 10, 2, 10, 0, 0),
  //       'WeekID': DateTime(2023, 10, 1, 0, 0, 0),
  //     },
  //     bookingObject: BookingObject(
  //         confirmationCode: 'YVZ87',
  //         patientObject: {
  //           'Name': 'Patient0002',
  //           'PhoneNumber': '4083879369',
  //           'DOB': '1970-02-02'
  //         },
  //         status: 'Booked',
  //         userID: 'user002'),
  //   ),
  // ];
}
