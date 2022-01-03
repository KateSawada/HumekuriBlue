import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:humekuri/src/ble/ble_device_interactor.dart';
import 'package:humekuri/src/ble/ble_scanner.dart';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class BleDeviceNotify extends ChangeNotifier{
  static final BleDeviceNotify _bleDeviceNotify = new BleDeviceNotify._internal();

  late PDFDocument documentLeft;
  late PDFDocument documentRight;

  final PageController pageControllerLeft = PageController();
  final PageController pageControllerRight = PageController(initialPage: 1);

  
  late var animateToPage;

  int currentPage = 0;
  int totalPage = 0;
  

  bool isDeviceConnected = false;
  String deviceId = "";

  final flutterReactiveBle = FlutterReactiveBle();

  late QualifiedCharacteristic characteristic;
  late DiscoveredDevice? discoveredDevice;
  // serviceDiscoverer = BleDeviceInteractor(bleDiscoverServices: bleDiscoverServices, readCharacteristic: readCharacteristic, writeWithResponse: writeWithResponse, writeWithOutResponse: writeWithOutResponse, logMessage: logMessage, subscribeToCharacteristic: subscribeToCharacteristic);

  /*
  void setDevice(String deviceId, DiscoveredService service, DiscoveredDevice? discoveredDevice,){
    this.discoveredDevice = discoveredDevice;
    this.deviceId = deviceId;
    //serviceDiscoverer.discoverServices(deviceId);
    //flutterReactiveBle.connectToDevice(id: this.deviceId);
    characteristic = QualifiedCharacteristic(serviceId: discoveredDevice!.serviceUuids[0], characteristicId: service.serviceId, deviceId: this.deviceId);
    setSubscribe();
    print("set");
  }
  
  void setSubscribe(){
    flutterReactiveBle.subscribeToCharacteristic(characteristic).listen((data) {
      onReceiveEvent(data);
    });
  }
  */
  /*
  late StreamSubscription<List<int>>? subscribeStream;
  final QualifiedCharacteristic characteristic;
  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)
      subscribeToCharacteristic;

  void subscribe(event) {
    this.subscribeStream = this.subscribeToCharacteristic(this.characteristic).listen((event) {
      this.onReceiveEvent(event);
    });
  }
  */
  void onPageChanged(int page) {
    print(page);
    
  }

  void loadDocment() async {
    print("start load");
    documentLeft = await PDFDocument.fromAsset("assets/anima.pdf");
    documentRight = await PDFDocument.fromAsset("assets/anima.pdf");
    totalPage = documentLeft.count;
    print("end load: pages ${totalPage}");
  }



  void onReceiveEvent() {

    if (currentPage + 2 < totalPage){
      currentPage ++;
      //pageControllerLeft.jumpToPage(currentPage);
      pageControllerLeft.animateToPage(currentPage , duration: Duration(milliseconds: 400), curve: Curves.linear);
      //pageControllerRight.jumpToPage(currentPage + 1  );
      //.animateToPage(currentPage, duration: Duration(microseconds: 10), curve: const Curve());
      pageControllerRight.animateToPage(currentPage + 1, duration: Duration(milliseconds: 400), curve: Curves.linear);

    }


    // Listenerへの変更の通知
    // https://qiita.com/agajo/items/50d5d7497d28730de1d3#5-changenotifier
    //notifyListeners(); 
  }

  String logMessage (String str){
    print(str);
    return str;
  }

  // connect from home screen
  void connectAndSetNotify() {
    print("start connct and set");
    BleScanner bleScanner = BleScanner(
      ble: flutterReactiveBle, 
      logMessage: logMessage);
    List<DiscoveredDevice> discoveredDevices = [];
    bool scanIsInProgress = false;
    BleScannerState bleScannerState = 
      BleScannerState(
        discoveredDevices: discoveredDevices, 
        scanIsInProgress: scanIsInProgress
        );
    
    // Device Id    "504918EF-9FA6-DD98-8E9B0ABB670E19E4"
    // Service Id   "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
    //bleScanner.startScan([Uuid.parse("4fafc201-1fb5-459e-8fcc-c5c9c331914b")]);
    var stream;
    stream = flutterReactiveBle.scanForDevices(withServices: [Uuid.parse("4fafc201-1fb5-459e-8fcc-c5c9c331914b")]).listen((device) {
      print("${device.name}\n${device.id}");
      flutterReactiveBle.connectToDevice(id: device.id).listen((event) {
        if (event.connectionState == DeviceConnectionState.connected){
          setNotification();
        }
        print(event);
      });
      
      discoveredDevice = device;
      
      //setNotification(device);
      print("stop scanning");
      
        stream.cancel();
    });
    print("done");
    
    //bleScannerState.discoveredDevices.

    //print(discoveredDevices);
  }

  void setNotification(){
    print("set");
    characteristic = 
        QualifiedCharacteristic(
          characteristicId: Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8"), 
          serviceId: discoveredDevice!.serviceUuids[0], 
          deviceId: discoveredDevice!.id);
        flutterReactiveBle.subscribeToCharacteristic(characteristic).listen((data) {
          onReceiveEvent();
          print(data);
        });
  }

  factory BleDeviceNotify(){
    return _bleDeviceNotify;
  }
  BleDeviceNotify._internal();
}
final bleDeviceNotify = BleDeviceNotify();