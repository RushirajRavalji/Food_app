import 'package:flutter/material.dart';
import 'package:food_app/config/colors.dart';
import 'dart:math' as math;

class OrderConfirmationScreen extends StatefulWidget {
  @override
  _OrderConfirmationScreenState createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Circle animation grows from 0 to 1
    _circleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.7, curve: Curves.easeOut),
    ));
    
    // Check mark animation starts after circle is mostly formed
    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.6, 1.0, curve: Curves.elasticOut),
    ));
    
    // Start the animation automatically
    _controller.forward();
    
    // Navigate back to home after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated circle with checkmark
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Green circle that grows
                      Container(
                        width: 150 * _circleAnimation.value,
                        height: 150 * _circleAnimation.value,
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Checkmark that appears
                      Transform.scale(
                        scale: _checkAnimation.value,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 30),
            Text(
              "Order Confirmed!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Your order has been placed successfully",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}