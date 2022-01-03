import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:humekuri/src/ble/ble_device_connector.dart';
import 'package:humekuri/src/ble/ble_device_interactor.dart';
import 'package:humekuri/src/ble/ble_scanner.dart';
import 'package:humekuri/src/ble/ble_status_monitor.dart';
import 'package:humekuri/src/ui/ble_status_screen.dart';
import 'package:humekuri/src/ui/device_list.dart';
import 'package:provider/provider.dart';
import 'src/ble/ble_logger.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:humekuri/singletons/ble_device_notify.dart';

const _themeColor = Colors.blue;
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final _bleLogger = BleLogger();
  final _ble = FlutterReactiveBle();
  final _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
  final _monitor = BleStatusMonitor(_ble);
  final _connector = BleDeviceConnector(
    ble: _ble,
    logMessage: _bleLogger.addToLog,
  );
  final _serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: _ble.discoverServices,
    readCharacteristic: _ble.readCharacteristic,
    writeWithResponse: _ble.writeCharacteristicWithResponse,
    writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
    subscribeToCharacteristic: _ble.subscribeToCharacteristic,
    logMessage: _bleLogger.addToLog,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        Provider.value(value: _connector),
        Provider.value(value: _serviceDiscoverer),
        Provider.value(value: _bleLogger),
        StreamProvider<BleScannerState?>(
          create: (_) => _scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => _monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => _connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Reactive BLE example',
        color: _themeColor,
        theme: ThemeData(primarySwatch: _themeColor),
        home: HomePage(),
      ),
    ),
  );
}
/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
*/

class HomePage extends StatefulWidget {
  const HomePage({Key? key,}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "humekuri";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    bleDeviceNotify.loadDocment();
  }

  void onReceiveEventSetState() {
    setState(() {
    });
    print("event received on main"); // カウントが蓄積してる?
  }

  @override
  Widget build(BuildContext context) {
    //bleDeviceNotify.addListener(onReceiveEventSetState);
    return MaterialApp(
      title: 'Flutter PDF View',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('example app')
        ),
        backgroundColor: Colors.white,
        body: Center(child: Builder(
          builder: (BuildContext context) {
            return Column(
              children: <Widget>[
                TextButton(
                  child: Text("Bluetooth Setting"),
                  onPressed: () {
                    if (true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                          

                          return const DeviceListScreen();
                           
                          }
                          
                          /*
                          SfPdfViewer.network(
                          'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
                          key: _pdfViewerKey,
                          scrollDirection: PdfScrollDirection.horizontal,
                          pageLayoutMode: PdfPageLayoutMode.continuous,
                          ),
                        */
                        ),
                      );
                    }
                  },
                ),
                TextButton(
                  child: Text("Connect Bluetooth"),
                  onPressed: () {
                    bleDeviceNotify.connectAndSetNotify();
                  },
                ),
                TextButton(
                  child: Text("Notify Bluetooth"),
                  onPressed: () {
                    bleDeviceNotify.setNotification();
                  },
                ),
                TextButton(
                  child: Text("Open PDF"),
                  onPressed: () {
                    if (true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                          

                          return Scaffold(
                            /*
                            body: Padding(
                              padding: EdgeInsets.only(top: marginTopBottom.toDouble(), bottom: marginTopBottom.toDouble()),
                              child: SfPdfViewer.file(file,
                              key: _pdfViewerKey,
                              scrollDirection: PdfScrollDirection.horizontal,
                              pageLayoutMode: PdfPageLayoutMode.continuous,
                              enableDoubleTapZooming: false,
                              controller: _pdfViewerController,
                            
                            )),
                            floatingActionButton: FloatingActionButton(
                              onPressed: () {
                                // Add your onPressed code here!
                                print("next");
                                _pdfViewerController.nextPage();
                              },
                              backgroundColor: Colors.green,
                              child: const Icon(Icons.skip_next),
                            ),
                            */
                            body: 
                            //Text('Output: ${bleDeviceNotify.event.toString()}'),
                            //Text("dummy")
                            Row(children: [
                              Expanded(child: 
                              
                                PDFViewer(
                                  document: bleDeviceNotify.documentLeft,
                                  zoomSteps: 1,
                                  //uncomment below line to preload all pages
                                  lazyLoad: false,
                                  // uncomment below line to scroll vertically
                                  scrollDirection: Axis.horizontal,
                                  showPicker: false,
                                  showNavigation: true,
                                  showIndicator: false,
                                  controller: bleDeviceNotify.pageControllerLeft,
                                  onPageChanged: (page) => {
                                    bleDeviceNotify.onPageChanged(page)
                                  },
                                  navigationBuilder:
                                    (context, page, totalPages, jumpToPage, animateToPage) {
                                      bleDeviceNotify.animateToPage = animateToPage;
                                  return ButtonBar(
                                    alignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.first_page),
                                        onPressed: () {
                                          animateToPage(page: 0);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        onPressed: () {
                                          animateToPage(page: page! - 2);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          animateToPage(page: page);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.last_page),
                                        onPressed: () {
                                          jumpToPage(page: totalPages! - 1);
                                        },
                                      ),
                                    ],
                                  );
                                }
                                ),
                              ),
                              Expanded(child: 
                                PDFViewer(
                                  document: bleDeviceNotify.documentRight,
                                  zoomSteps: 1,
                                  //lazyLoad: false,
                                  controller: bleDeviceNotify.pageControllerRight,
                                  scrollDirection: Axis.horizontal,
                                  showPicker: false,
                                  showNavigation: false,
                                  //showIndicator: false,
                                ),
                              ),
                            ]),
                            
                          );
                           
                          }
                          
                          /*
                          SfPdfViewer.network(
                          'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
                          key: _pdfViewerKey,
                          scrollDirection: PdfScrollDirection.horizontal,
                          pageLayoutMode: PdfPageLayoutMode.continuous,
                          ),
                        */
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        )),
        
      ),
    );
    
  }
}
