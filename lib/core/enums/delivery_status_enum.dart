
enum DateEnum {
  today('Today'),
  yesterday('Yesterday'),
  last7Days('Last 7 days'),
  lastMonth('Last month'),
  older('Older');

  final String status;

  const DateEnum(this.status);
}
