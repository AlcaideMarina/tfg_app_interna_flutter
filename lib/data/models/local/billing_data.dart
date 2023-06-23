class BillingData {
  final double paymentByCash;
  final double paymentByReceipt;
  final double paymentByTransfer;
  final double paid;
  final double toBePaid;
  final double totalPrice;

  BillingData(this.paymentByCash, this.paymentByReceipt, this.paymentByTransfer,
      this.paid, this.toBePaid, this.totalPrice);
}
