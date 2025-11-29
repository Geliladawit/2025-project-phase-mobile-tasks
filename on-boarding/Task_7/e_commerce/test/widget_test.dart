import 'dart:io';
import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce/main.dart';

// --- MOCK IMAGE LOADING LOGIC ---
class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

class _MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future.value(_MockHttpClientRequest());
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future.value(_MockHttpClientResponse());
  @override
  HttpHeaders get headers => _MockHttpHeaders();
  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
}

class _MockHttpClientResponse implements HttpClientResponse {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
  @override
  int get statusCode => 200;
  @override
  int get contentLength => kTransparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([kTransparentImage]).listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

final List<int> kTransparentImage = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
];

void main() {
  setUpAll(() {
    HttpOverrides.global = _MockHttpOverrides();
  });

  //TEST PRODUCT LISTING
  testWidgets('Product list displays initial products', (WidgetTester tester) async {
    await tester.pumpWidget(const EcommerceApp());

    expect(find.text("Derby Leather Shoes"), findsOneWidget);
    expect(find.text("Cloud Running Sneaker"), findsOneWidget);
    

  });

  //PRODUCT CREATION
  testWidgets('Add new product successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const EcommerceApp());

    final fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, "Name"), "Test Shoe");
    await tester.enterText(find.widgetWithText(TextFormField, "Category"), "Test Category");
    await tester.enterText(find.widgetWithText(TextFormField, "Price"), "55.5");
    await tester.enterText(find.widgetWithText(TextFormField, "Description"), "Nice shoe");
    await tester.enterText(find.widgetWithText(TextFormField, "Image URL"), "test.png");

    final addButton = find.text("ADD PRODUCT");
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text("Test Shoe"), 500);
    expect(find.text("Test Shoe"), findsOneWidget);
  });

  //INVALID PRODUCT CREATION
  testWidgets('Show validation error when name is empty', (WidgetTester tester) async {
    await tester.pumpWidget(const EcommerceApp());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, "Category"), "Cat");
    await tester.enterText(find.widgetWithText(TextFormField, "Price"), "10");
    await tester.enterText(find.widgetWithText(TextFormField, "Description"), "desc");
    await tester.enterText(find.widgetWithText(TextFormField, "Image URL"), "url");

    await tester.tap(find.text("ADD PRODUCT"));
    await tester.pump(); 

    expect(find.text("Please enter Name"), findsOneWidget);
  });

  //NAVIGATION TEST
  testWidgets('Back button navigates from Product Detail back to home screen',
      (WidgetTester tester) async {

    await tester.pumpWidget(const EcommerceApp());

    await tester.tap(find.text("Derby Leather Shoes"));
    await tester.pumpAndSettle();

    expect(find.text("Description"), findsOneWidget);

    final backButton = find.byIcon(Icons.arrow_back_ios_new);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(find.text("Available Products"), findsOneWidget);
  });
}