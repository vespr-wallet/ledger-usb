@JS("window.navigator")
library usb;

import 'dart:js_interop';

@JS()
external WebUSB get usb;

extension type WebUSB._(JSObject o) implements JSObject {
  @JS('getDevices')
  external JSPromise<JSArray<USBDevice>> _getDevices();

  @JS('requestDevice')
  external JSPromise<USBDevice> _requestDevice(RequestUSBDeviceFilters filters);

  Future<List<USBDevice>> getDevices() async {
    final jsDevices = await _getDevices().toDart;
    final devices = jsDevices.toDart;

    for (final device in devices) {
      print("${device.manufacturerName} ${device.productName}");
      print("Serial ${device.serialNumber}");
      print("vendorId ${device.vendorId}");
      print("productId ${device.productId}");
    }

    return devices;
  }

  Future<USBDevice?> requestDevice(RequestUSBDeviceFilters filters) async {
    try {
      final device = await _requestDevice(filters).toDart;
      return device as USBDevice?;
    } catch (e) {
      print("Error requesting device: $e");
      return null;
    }
  }
}

extension type USBDevice._(JSObject o) implements JSObject {
  @JS('open')
  // ignore: prefer_void_to_null
  external JSPromise<Null> _open();

  @JS('transferIn')
  external JSPromise<USBInTransferResult> _transferIn(
    int endpointNumber,
    int packetSize,
  );

  @JS('transferOut')
  external JSPromise<USBOutTransferResult> _transferOut(
    int endpointNumber,
    JSUint8Array data,
  );

  @JS('close')
  external JSPromise<JSAny> _close();

  external String get manufacturerName;
  external String get productName;
  external String get serialNumber;
  external int get vendorId;
  external int get productId;

  external bool get opened;

  Future<void> open() async {
    if (!opened) {
      await _open().toDart;
    }
  }

  Future<USBInTransferResult> transferIn(
    int endpointNumber,
    int packetSize,
  ) async {
    final result = await _transferIn(endpointNumber, packetSize).toDart;
    return result;
  }

  Future<USBOutTransferResult> transferOut(
    int endpointNumber,
    JSUint8Array data,
  ) async {
    final result = await _transferOut(endpointNumber, data).toDart;
    return result;
  }

  Future<void> close() async {
    if (opened) {
      await _close().toDart;
    }
  }
}

extension type USBInTransferResult._(JSObject o) implements JSObject {
  external JSDataView? get data;
  external String get status;
}

extension type USBOutTransferResult._(JSObject o) implements JSObject {
  external int get bytesWritten;
  external String get status;
}

extension type RequestUSBDeviceFilters._(JSObject o) implements JSObject {
  external JSArray<RequestUSBDeviceFilter> filters;

  external RequestUSBDeviceFilters.js({
    required JSArray<RequestUSBDeviceFilter> filters,
  });

  static RequestUSBDeviceFilters dart(List<RequestUSBDeviceFilter> filters) =>
      RequestUSBDeviceFilters.js(filters: filters.toJS);
}

extension type RequestUSBDeviceFilter._(JSObject o) implements JSObject {
  external int? get vendorId;
  external int? get productId;
  external String? get classCode;
  external String? get subclassCode;
  external String? get protocolCode;
  external String? get serialNumber;

  external RequestUSBDeviceFilter({
    int? vendorId,
    int? productId,
    String? classCode,
    String? subclassCode,
    String? protocolCode,
    String? serialNumber,
  });
}