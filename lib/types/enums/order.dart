enum Order {
  Ascending,
  Descending,
}

extension FilterOrderFunctions on Order {
  String get text => const {
        Order.Ascending: '升序.',
        Order.Descending: '倒序.',
      }[this]!;
}
