
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/home/data/models/tip_model.dart';

void main() {
  test('parseTipsResponse parses GET /random array', () {
    final tips = parseTipsResponse([
      {
        'id': 1,
        'title': 'Did you know?',
        'description': 'Solar panels work even on cloudy days.',
      },
      {
        'id': 2,
        'title': 'Energy tip',
        'description': 'Clean panels improve efficiency.',
      },
    ]);

    expect(tips, hasLength(2));
    expect(tips.first.id, 1);
    expect(tips.first.description, 'Solar panels work even on cloudy days.');
  });

  test('parseTipsResponse caps tips at 3', () {
    final tips = parseTipsResponse([
      {'id': 1, 'title': 'One', 'description': 'A'},
      {'id': 2, 'title': 'Two', 'description': 'B'},
      {'id': 3, 'title': 'Three', 'description': 'C'},
      {'id': 4, 'title': 'Four', 'description': 'D'},
    ]);

    expect(tips, hasLength(3));
    expect(tips.last.id, 3);
  });

  test('parseTipsResponse skips empty tips', () {
    final tips = parseTipsResponse([
      {'id': 1, 'title': '', 'description': ''},
      {'id': 2, 'title': 'Valid', 'description': 'Body'},
    ]);

    expect(tips, hasLength(1));
    expect(tips.first.title, 'Valid');
  });
}
