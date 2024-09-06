// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    show
        InAppWebView,
        InAppWebViewController,
        InAppWebViewGroupOptions,
        InAppWebViewOptions,
        URLRequest,
        WebUri;

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  PaymentsScreenState createState() => PaymentsScreenState();
}

class PaymentsScreenState extends State<PaymentsScreen> {
  late InAppWebViewGroupOptions _options;

  @override
  void initState() {
    super.initState();
    _options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donate Us!"),
        leading: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                CupertinoIcons.chevron_back,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: InAppWebView(
        initialOptions: _options,
        initialUrlRequest: URLRequest(
          url: WebUri(
            'https://wizium.lemonsqueezy.com/buy/0635acea-8876-4d13-ab06-ba23d888442c?embed=1',
          ),
        ),
        onWebViewCreated: (InAppWebViewController controller) {},
      ),
    );
  }
}
