import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'models/dataobjects.dart';
import 'dart:typed_data';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ////////////////////////////////////
  /// Firestore Snippets
  ////////////////////////////////////

  final FirebaseFirestore db = FirebaseFirestore.instance;

  AppointmentBlockObject appointmentBlockBooked = AppointmentBlockObject(
    doctorID: 'doctor0002',
    timeUnit: {
      'AptStartTime': DateTime(2023, 10, 2, 9, 0, 0),
      'AptEndTime': DateTime(2023, 10, 2, 9, 30, 0),
      'WeekID': DateTime(2023, 10, 1, 0, 0, 0),
    },
    bookingObject: BookingObject(
      confirmationCode: 'AAAA',
      patientObject: {
        'Name': 'Patient0001',
        'PhoneNumber': '4083879396',
        'DOB': '1970-01-01'
      },
      status: 'Booked',
      userID: 'user001',
    ),
  );

  AppointmentBlockObject appointmentBlock = AppointmentBlockObject(
    doctorID: 'doctor0001',
    timeUnit: {
      'AptStartTime': DateTime(2023, 10, 2, 9, 0, 0),
      'AptEndTime': DateTime(2023, 10, 2, 9, 30, 0),
      'WeekID': DateTime(2023, 10, 1, 0, 0, 0),
    },
    bookingObject: null,
  );

  void addAppointment(AppointmentBlockObject appointmentBlock) {
    // Access specific data from the appointmentBlock instance
    String doctorID = appointmentBlock.doctorID;
    Map<String, DateTime> timeUnit = appointmentBlock.timeUnit;
    BookingObject? bookingObject = appointmentBlock.bookingObject;

    // Create a map with the appointment data to be stored in Firestore
    Map<String, dynamic> appointmentData = {
      'doctorID': doctorID,
      'timeUnit': {
        'AptStartTime': timeUnit['AptStartTime'],
        'AptEndTime': timeUnit['AptEndTime'],
        'WeekID': timeUnit['WeekID'],
      },
      'bookingObject': {
        'confirmationCode': bookingObject?.confirmationCode,
        'patientObject': bookingObject?.patientObject,
        'status': bookingObject?.status,
        'userID': bookingObject?.userID,
      },
    };

    // Access the Firestore instance and add the appointment data to the 'appointments' collection
    db.collection('DB2').add(appointmentData);

    print('Appointment data added to Firestore successfully.');
  }

  void getStartedReadData() async {
    // [START get_started_read_data]
    await db.collection("Hospitals").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
    // [END get_started_read_data]
  }

  Uint32List data = Uint32List.fromList([0, 4027580400, 65535]);
  // Uint8List data = Uint8List.fromList([0x48, 0x65, 0x6c, 0x6c, 0x6f]);
  String date = '2023-11-06'; // Example byte data
  void storeBytes() {
    db
        .collection('Hospitals')
        .doc(hospitalid)
        .collection('Doctors')
        .doc(doctorid)
        .set({
      'Availabilities': {date: data},
    }, SetOptions(merge: true)).then((_) {
      print("Availability added");
    }).catchError((error) {
      print("Failed to add availability: $error");
    });

    // db
    //     .collection('Hospitals')
    //     .doc(hospitalid)
    //     .collection('Doctors')
    //     .doc(doctorid)
    //     .set({
    //   'Schedules': {'1': data},
    // }, SetOptions(merge: true)).then((_) {
    //   print("schedules added");
    // }).catchError((error) {
    //   print("Failed to add schedules: $error");
    // });
  }

  String hospitalid = 'RkkkdH28tNYNv2pYHL0v';
  String doctorid = '5eCUnYfipYELO0thZG5F';
  String datetime = '2023-11-06 09:30:00.000';

  void getAvailabilities(hospitalid, doctorid, datetime) async {
    db
        .collection('Hospitals')
        .doc(hospitalid)
        .collection('Doctors')
        .doc(doctorid)
        .get()
        .then((doc) {
      if (doc.exists) {
        print('Document Exists');
        final data = doc.data();
        final availabilities = data?['Availabilities'];
        print("Availabilities: $availabilities");

        final date = datetime.substring(0, 10);
        final available = availabilities?[date];
        print("Available: $available");

        // void printAvailability(Uint32List bitmap) {
        //   for (int j = 0; j < bitmap.length; j++) {
        //     for (int i = 0; i < 31; i++) {
        //       if (((bitmap[j] & (1 << i)) != 0) &&
        //           ((bitmap[j] & (1 << (i + 1))) != 0)) {
        //         if (i % 2 == 0) {
        //           int minutes = ((j * 32) + i) * 15;
        //           int hours = minutes ~/ 60;
        //           minutes %= 60;
        //           print(
        //               'At ${hours}:${minutes.toString().padLeft(2, '0')}, a 30 min slot is available');
        //         }
        //       }
        //     }
        //   }
        // }

        DateTime dated = DateTime.parse(datetime);

        List<DateTime> printAvailability(Uint32List bitmap, DateTime dated) {
          List<DateTime> startTimes = [];

          for (int j = 0; j < bitmap.length; j++) {
            for (int i = 0; i < 31; i++) {
              if (((bitmap[j] & (1 << i)) != 0) &&
                  ((bitmap[j] & (1 << (i + 1))) != 0)) {
                if (i % 2 == 0) {
                  int minutes = ((j * 32) + i) * 15;
                  DateTime startTime = DateTime(dated.year, dated.month,
                      dated.day, minutes ~/ 60, minutes % 60);
                  startTimes.add(startTime);
                }
              }
            }
          }

          return startTimes;
        }

        if (available != null && available is List<dynamic>) {
          List<int> intList = available.map((item) => item as int).toList();
          Uint32List bitmap = Uint32List.fromList(intList);
          // printAvailability(bitmap);
          List<DateTime> startTimes = printAvailability(bitmap, dated);
          print("Start times: $startTimes");
        } else {
          print("Available is not a list of integers");
        }
      } else {
        print("No such document!");
      }
    });
  }

  void setUnavaiable(hospitalid, doctorid, datetime) {
    db
        .collection('Hospitals')
        .doc(hospitalid)
        .collection('Doctors')
        .doc(doctorid)
        .get()
        .then((doc) {
      if (doc.exists) {
        print('Document Exists');
        final data = doc.data();
        final availabilities = data?['Availabilities'];
        print("Availabilities: $availabilities");

        final date = datetime.substring(0, 10);
        final available = availabilities?[date];
        print("Available: $available");

        DateTime dated = DateTime.parse(datetime);

        void setUnavailability(Uint32List bitmap, int startSlot, int endSlot) {
          // Calculate the bit positions for the start and end slots
          int startIndex = startSlot ~/ 32;
          int endIndex = endSlot ~/ 32;
          int bitIndex = startSlot % 32;
          int totalBits = endSlot - startSlot;
          int bitCount = 0;

          for (int i = startIndex; i <= endIndex; i++) {
            for (;
                bitCount < totalBits && bitIndex < 32;
                bitCount++, bitIndex++) {
              bitmap[i] &= ~(1 << bitIndex);
            }
            bitIndex = 0;
          }
        }

        void printAvailability(Uint32List bitmap) {
          for (int j = 0; j < bitmap.length; j++) {
            for (int i = 0; i < 31; i++) {
              if (((bitmap[j] & (1 << i)) != 0) &&
                  ((bitmap[j] & (1 << (i + 1))) != 0)) {
                if (i % 2 == 0) {
                  int minutes = ((j * 32) + i) * 15;
                  int hours = minutes ~/ 60;
                  minutes %= 60;
                  print(
                      'At ${hours}:${minutes.toString().padLeft(2, '0')}, a 30 min slot is available');
                }
              }
            }
          }
        }

        if (available != null && available is List<dynamic>) {
          List<int> intList = available.map((item) => item as int).toList();
          Uint32List bitmap = Uint32List.fromList(intList);
          // printAvailability(bitmap);
          int start = 0;
          int end = 0;
          if (dated.minute == 30) {
            start = dated.hour * 4 + 1;
            end = start + 2;
          } else {
            start = dated.hour * 4;
            end = start + 2;
          }
          setUnavailability(bitmap, start, end);
          printAvailability(bitmap);
          print("Bitmap: $bitmap");
          db
              .collection('Hospitals')
              .doc(hospitalid)
              .collection('Doctors')
              .doc(doctorid)
              .set({
            'Availabilities': {date: bitmap},
          }, SetOptions(merge: true)).then((_) {
            print("Availability added");
          }).catchError((error) {
            print("Failed to add availability: $error");
          });
        } else {
          print("Available is not a list of integers");
        }
      } else {
        print("No such document!");
      }
    });
  }

  void dataModel_references() {
    // [START data_model_references]
    final aDocumentRef = db
        .collection("Hospitals")
        .doc("RkkkdH28tNYNv2pYHL0v")
        .collection("Doctors")
        .doc("5eCUnYfipYELO0thZG5F");
    aDocumentRef.get().then((doc) {
      if (doc.exists) {
        print('Document Exists');
        print("Document data: ${doc.data()}");
      } else {
        print("No such document!");
      }
    });
    // [END data_model_references]

    // final testByQUery =
    //     db.collection("DB2").where("doctorID", isEqualTo: "doctor0002");
    // testByQUery.get().then((event) {
    //   for (var doc in event.docs) {
    //     print("${doc.id} => ${doc.data()}");
    //   }
    // });

    // [START data_model_references2]
    // final aCollectionRef = db.collection("DB2");
    // aCollectionRef.get().then((event) {
    //   for (var doc in event.docs) {
    //     print("${doc.id}");
    //   }
    // });
    // [END data_model_references2]

    // [START data_model_references3]
    // final aDocRef = db.doc("DB2/j1eipV2GNWFeDQFilmEL");
    // aDocRef.get().then((doc) {
    //   if (doc.exists) {
    //     var bookingObject = doc.data()?['bookingObject'];
    //     if (bookingObject != null) {
    //       var confirmationCode = bookingObject['confirmationCode'];
    //       print("Confirmation code: $confirmationCode");
    //     } else {
    //       print("No booking object!");
    //     }
    //   } else {
    //     print("No such document!");
    //   }
    // });
    //[END data_model_references3]
  }

  ////////////////////////////////////
  /// UI
  ////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Hello World!',
                ),
                FloatingActionButton(
                  onPressed: storeBytes,
                  tooltip: 'SetAvailability',
                  child: Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () {
                    setUnavaiable(hospitalid, doctorid, datetime);
                  },
                  tooltip: 'SetUnavailability',
                  child: Icon(Icons.find_in_page),
                ),
                FloatingActionButton(
                  onPressed: () {
                    getAvailabilities(hospitalid, doctorid, datetime);
                  },
                  tooltip: 'GetAvailabilities',
                  child: Icon(Icons.find_replace),
                )
              ]),
        ));
  }
}
