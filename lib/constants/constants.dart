// Function to calculate the offer percentage
double percentage(double mrp, double sellingPrice) {
  if (mrp <= 0 || sellingPrice <= 0 || sellingPrice > mrp) {
    return 0.0; // Return 0 if values are invalid
  }
  double discount = ((mrp - sellingPrice) / mrp) * 100;
  return double.parse(discount.toStringAsFixed(1));
}
