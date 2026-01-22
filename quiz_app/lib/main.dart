import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: false),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuesIndex = 0;
  int _score = 0;
  final List<Map<String, Object>> _questions = [
    {
      'question': 'What is Flutter?',
      'answers': [
        {'text': 'A programming language', 'score': 0},
        {'text': 'A UI framework', 'score': 1},
        {'text': 'A database', 'score': 0},
        {'text': 'An operating system', 'score': 0},
      ],
    },
    {
      'question': 'Which language is used in Flutter?',
      'answers': [
        {'text': 'Java', 'score': 0},
        {'text': 'Kotlin', 'score': 0},
        {'text': 'Dart', 'score': 1},
        {'text': 'Swift', 'score': 0},
      ],
    },
    {
      'question': 'Who developed Flutter?',
      'answers': [
        {'text': 'Apple', 'score': 0},
        {'text': 'Google', 'score': 1},
        {'text': 'Microsoft', 'score': 0},
        {'text': 'Facebook', 'score': 0},
      ],
    },
  ];

  void _answerQuestion(int score) {
    _score += score;
    setState(() {
      _currentQuesIndex++;
    });
  }

  void _resetQuiz() {
    setState(() {
      _score = 0;
      _currentQuesIndex = 0;
    });
  }

  void _skipQuestion() {
    setState(() {
      _currentQuesIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Quiz App')),
      body: _currentQuesIndex < _questions.length
          ? Quiz(
              questionData: _questions[_currentQuesIndex],
              answerQuestion: _answerQuestion,
              skipQuestion: _skipQuestion,
            )
          : Result(score: _score, onRestart: _resetQuiz),
    );
  }
}

class Quiz extends StatelessWidget {
  final Map<String, Object> questionData;
  final void Function(int) answerQuestion;
  final VoidCallback skipQuestion;
  const Quiz({
    super.key,
    required this.questionData,
    required this.answerQuestion,
    required this.skipQuestion,
  });

  @override
  Widget build(BuildContext context) {
    final answers = questionData['answers'] as List<Map<String, Object>>;
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            questionData['question'] as String,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ...answers.map((answer) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () => answerQuestion(answer['score'] as int),
                child: Text(answer['text'] as String),
              ),
            );
          }).toList(),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: skipQuestion,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade100),
              child: const Text('Skip', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}

class Result extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;

  const Result({super.key, required this.score, required this.onRestart});

  String get resultText {
    if (score == 3) {
      return 'Perfect! 🎉';
    } else if (score == 2) {
      return 'Good job 👍';
    } else {
      return 'Better luck next time! 😄';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            resultText,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text('Score: $score', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: onRestart, child: Text('Restart Quiz')),
        ],
      ),
    );
  }
}
