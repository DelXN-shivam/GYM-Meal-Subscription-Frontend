import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscriptionProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Razorpay _razorpay = Razorpay();
  bool _isLoading = false;
  Map<String, dynamic>? _currentSubscription;
  List<Map<String, dynamic>> _subscriptionHistory = [];

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get currentSubscription => _currentSubscription;
  List<Map<String, dynamic>> get subscriptionHistory => _subscriptionHistory;

  SubscriptionProvider() {
    _setupRazorpay();
  }

  void _setupRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle successful payment
    print('Payment Success: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print('Payment Error: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    print('External Wallet: ${response.walletName}');
  }

  Future<void> createSubscription({
    required String userId,
    required String planType, // weekly/monthly
    required int mealsPerDay,
    required List<String> dietaryPreferences,
    required Map<String, dynamic> deliveryAddress,
    required Map<String, dynamic> deliverySchedule,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Calculate subscription price
      final price = _calculateSubscriptionPrice(
        planType: planType,
        mealsPerDay: mealsPerDay,
      );

      // Create subscription document
      final subscriptionRef = await _firestore.collection('subscriptions').add({
        'userId': userId,
        'planType': planType,
        'mealsPerDay': mealsPerDay,
        'dietaryPreferences': dietaryPreferences,
        'deliveryAddress': deliveryAddress,
        'deliverySchedule': deliverySchedule,
        'price': price,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _currentSubscription = {
        'id': subscriptionRef.id,
        'planType': planType,
        'mealsPerDay': mealsPerDay,
        'dietaryPreferences': dietaryPreferences,
        'deliveryAddress': deliveryAddress,
        'deliverySchedule': deliverySchedule,
        'price': price,
        'status': 'pending',
      };

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  double _calculateSubscriptionPrice({
    required String planType,
    required int mealsPerDay,
  }) {
    const double basePricePerMeal = 150.0; // Base price per meal
    double totalPrice = basePricePerMeal * mealsPerDay;

    // Apply plan type multiplier
    if (planType.toLowerCase() == 'monthly') {
      totalPrice *= 28; // 28 days
      totalPrice *= 0.9; // 10% discount for monthly plans
    } else {
      totalPrice *= 7; // 7 days for weekly plan
    }

    return totalPrice;
  }

  Future<void> processPayment({
    required String subscriptionId,
    required double amount,
    required String currency,
  }) async {
    try {
      final options = {
        'key': 'YOUR_RAZORPAY_KEY', // Replace with your Razorpay key
        'amount': (amount * 100).toInt(), // Amount in smallest currency unit
        'name': 'Gym Meal Subscription',
        'description': 'Subscription Payment',
        'prefill': {'contact': '1234567890', 'email': 'user@example.com'}
      };

      _razorpay.open(options);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadSubscriptionHistory(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final querySnapshot = await _firestore
          .collection('subscriptions')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _subscriptionHistory = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateDeliverySchedule({
    required String subscriptionId,
    required Map<String, dynamic> newSchedule,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('subscriptions').doc(subscriptionId).update({
        'deliverySchedule': newSchedule,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (_currentSubscription != null &&
          _currentSubscription!['id'] == subscriptionId) {
        _currentSubscription!['deliverySchedule'] = newSchedule;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
