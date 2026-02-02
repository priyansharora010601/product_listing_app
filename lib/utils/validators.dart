class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  // Product name validation
  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product name is required';
    }

    if (value.trim().length < 3) {
      return 'Product name must be at least 3 characters';
    }

    if (value.trim().length > 100) {
      return 'Product name must be less than 100 characters';
    }

    return null;
  }

  // Price validation - ONLY NUMBERS
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    // Remove any whitespace
    final cleanValue = value.trim();

    // Check if it contains only numbers and optionally one decimal point
    final priceRegex = RegExp(r'^\d+\.?\d{0,2}$');
    if (!priceRegex.hasMatch(cleanValue)) {
      return 'Please enter a valid price (numbers only)';
    }

    final price = double.tryParse(cleanValue);
    if (price == null) {
      return 'Please enter a valid price';
    }

    if (price <= 0) {
      return 'Price must be greater than 0';
    }

    if (price > 999999.99) {
      return 'Price is too high';
    }

    return null;
  }

  // Description validation
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }

    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }

    if (value.trim().length > 1000) {
      return 'Description must be less than 1000 characters';
    }

    return null;
  }

  // Image URL validation (optional)
  static String? validateImageUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Image is optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/.*\.(png|jpg|jpeg|gif|webp|svg)(\?.*)?$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid image URL';
    }

    return null;
  }
}