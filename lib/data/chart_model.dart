class Watchlist {
  final String symbol;
  final String tittle;
  final String subtittle;
  final String logoUrl;
  String change;
  String price;
  bool isPositive;

  Watchlist({
    required this.symbol,
    required this.tittle,
    required this.subtittle,
    this.logoUrl = "",
    this.change = '',
    this.price = 'IsLoading....',
    this.isPositive = true,
  });
}
