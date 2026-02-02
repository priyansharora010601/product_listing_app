import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showTagline;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const AppLogo({
    super.key,
    this.size = 80,
    this.showText = true,
    this.showTagline = true,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Icon
        Container(
          padding: EdgeInsets.all(size * 0.3),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            size: size,
            color: iconColor ?? primaryColor,
          ),
        ),

        if (showText) ...[
          SizedBox(height: size * 0.4),
          Text(
            'ShopEase',
            style: TextStyle(
              fontSize: size * 0.45,
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.white,
              letterSpacing: 2,
            ),
          ),
        ],

        if (showTagline) ...[
          SizedBox(height: size * 0.1),
          Text(
            'Shop with ease',
            style: TextStyle(
              fontSize: size * 0.2,
              color: (textColor ?? Colors.white).withOpacity(0.8),
              letterSpacing: 1,
            ),
          ),
        ],
      ],
    );
  }
}

// Small logo for AppBar or compact spaces
class AppLogoSmall extends StatelessWidget {
  final double size;

  const AppLogoSmall({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(size * 0.2),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            size: size * 0.6,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'ShopEase',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}