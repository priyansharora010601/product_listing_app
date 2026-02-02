// create_icon.dart
// Run with: dart run create_icon.dart

import 'dart:io';
import 'dart:convert';

void main() async {
  // Create assets/images folder
  final dir = Directory('assets/images');
  if (!await dir.exists()) {
    await dir.create(recursive: true);
    print('✅ Created: assets/images/');
  }

  // Simple 1x1 purple pixel as placeholder
  // You'll need to replace this with actual icon
  print('');
  print('📁 Folder created: assets/images/');
  print('');
  print('⚠️  Please manually add your app_icon.png to assets/images/');
  print('');
  print('You can create one at:');
  print('  • https://www.canva.com');
  print('  • https://www.figma.com');
  print('  • https://www.appicon.co');
  print('');
  print('Icon specifications:');
  print('  • Size: 1024 x 1024 px');
  print('  • Background: Gradient #6B5FFF to #2196F3');
  print('  • Icon: White shopping bag');
  print('  • Format: PNG');
  print('');
}