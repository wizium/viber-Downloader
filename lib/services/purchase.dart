import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '/screens/sign_in.dart';
import '/widget/home_drawer.dart';
import '/main.dart';
import 'state.dart';

InAppPurchase inAppPurchase = InAppPurchase.instance;
late PurchaseParam purchaseParam;
FirebaseFirestore firestore = FirebaseFirestore.instance;
listenToPurchase(List<PurchaseDetails> purchaseDetails) async {
  Timestamp? endDate;
  for (PurchaseDetails element in purchaseDetails) {
    if (element.status == PurchaseStatus.pending) {
      debugPrint("Purchase pending");
    } else if (element.status == PurchaseStatus.error) {
      debugPrint("Error Buying");
    } else if (element.status == PurchaseStatus.purchased) {
      endDate = Timestamp.fromDate(
        DateTime.now().add(
          const Duration(days: 365),
        ),
      );
      await firestore
          .collection("subscription_details")
          .doc(auth.currentUser!.uid)
          .set(
        {"endDate": endDate},
      );
      preferences.setString(
        "endDate",
        endDate.toDate().toString(),
      );
      subscriptionCheck(
        endDate,
      );
      debugPrint("purchased");
    }
  }
}

initStore(VoidCallback callback) async {
  ProductDetailsResponse productDetailsResponse =
      await inAppPurchase.queryProductDetails(kProductIds);
  if (productDetailsResponse.error == null) {
    products = productDetailsResponse.productDetails;
  } else {
    debugPrint(productDetailsResponse.error.toString());
  }
  callback();
}

buy({required ProductDetails product}) async {
  if (auth.currentUser == null) {
    Get.snackbar(
      "Error",
      "Please login first",
      mainButton: TextButton(
        onPressed: () {
          Get.to(
            const LoginScreen(),
          );
        },
        child: const Text("Login"),
      ),
    );
  } else {
    purchaseParam = PurchaseParam(productDetails: product);
    await inAppPurchase.buyConsumable(
      purchaseParam: purchaseParam,
    );
  }
}
