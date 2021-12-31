import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:humekuri/src/ble/ble_device_interactor.dart';

class BleDeviceNotify extends ChangeNotifier{
  static final BleDeviceNotify _bleDeviceNotify = new BleDeviceNotify._internal();

  bool isDeviceConnected = false;
  String deviceId = "";
  List<int> event = [0, 0, 0, 0];

  final flutterReactiveBle = FlutterReactiveBle();

  QualifiedCharacteristic characteristic;
  DiscoveredDevice discoveredDevice;

  BleDeviceInteractor serviceDiscoverer;
  
  void setDevice(String deviceId, DiscoveredDevice discoveredDevice){
    this.discoveredDevice = discoveredDevice;
    this.deviceId = deviceId;
    flutterReactiveBle.connectToDevice(id: this.deviceId);
    characteristic = QualifiedCharacteristic(serviceId: discoveredDevice.serviceUuids[0], characteristicId: discoveredDevice.cha, deviceId: this.deviceId);
  }
  
  void setSubscribe(){
    flutterReactiveBle.subscribeToCharacteristic(characteristic).listen((data) {
      this.onReceiveEvent(data);
    });

    

  }

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



  void onReceiveEvent(List<int> event) {
    this.event = event;
    print("event received on singleton");

    // Listenerへの変更の通知
    // https://qiita.com/agajo/items/50d5d7497d28730de1d3#5-changenotifier
    notifyListeners(); 
  }

  factory BleDeviceNotify(){
    return _bleDeviceNotify;
  }
  BleDeviceNotify._internal();
}
final bleDeviceNotify = BleDeviceNotify();