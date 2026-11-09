
import 'dart:io';

class MoodEntry {
  DateTime createdAt;
  int score;
  String? note;

  MoodEntry(this.createdAt, this.score, this.note);

  @override
  String toString() {
    String date = createdAt.toString().substring(0, 16);
    return '[$date] Score: $score/10 - ${note ?? '(no note)'}';
  }
}

class MoodLogger {
  List<MoodEntry> entries = [];

  void addEntry(int score, String? note) {
    if (score < 1 || score > 10) {
      print('Error: Score must be between 1 and 10.');
      return;
    }

    if (note == null || note.trim().isEmpty) {
      note = null;
    }

    entries.add(MoodEntry(DateTime.now(), score, note));
    print('Mood entry added!');
  }

  List<MoodEntry> getAllEntries() {
    return entries;
  }

  double? getAverageScore() {
    if (entries.isEmpty) {
      return null;
    }

    int total = 0;
    for (var entry in entries) {
      total += entry.score;
    }

    return total / entries.length;
  }

  List<MoodEntry> getEntriesAbove(int threshold) {
    return entries.where((entry) => entry.score >= threshold).toList();
  }
}

void main() {
  MoodLogger logger = MoodLogger();

  while (true) {
    print('\n===== MOOD TRACKER =====');
    print('1. Add entry');
    print('2. View all entries');
    print('3. View average');
    print('4. Filter by score');
    print('5. Quit');

    stdout.write('Choose an option: ');
    String? choice = stdin.readLineSync();

    if (choice == '1') {
      stdout.write('Enter mood score (1-10): ');
      int? score = int.tryParse(stdin.readLineSync() ?? '');

      if (score == null) {
        print('Invalid score.');
        continue;
      }

      stdout.write('Enter note (optional): ');
      String? note = stdin.readLineSync();

      logger.addEntry(score, note);

    } else if (choice == '2') {
      var entries = logger.getAllEntries();

      if (entries.isEmpty) {
        print('No entries yet.');
      } else {
        for (var entry in entries) {
          print(entry);
        }
      }

    } else if (choice == '3') {
      double? average = logger.getAverageScore();

      if (average == null) {
        print('No entries yet.');
      } else {
        print('Average mood score: ${average.toStringAsFixed(2)}');
      }

    } else if (choice == '4') {
      stdout.write('Enter minimum score: ');
      int? threshold = int.tryParse(stdin.readLineSync() ?? '');

      if (threshold == null) {
        print('Invalid score.');
        continue;
      }

      var filtered = logger.getEntriesAbove(threshold);

      if (filtered.isEmpty) {
        print('No matching entries.');
      } else {
        for (var entry in filtered) {
          print(entry);
        }
      }

    } else if (choice == '5') {
      print('Goodbye!');
      break;

    } else {
      print('Invalid option. Try again.');
    }
  }
}
