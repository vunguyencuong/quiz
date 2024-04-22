class Answer {
  final int questionId;
  final int choiceId;

  Answer({required this.questionId, required this.choiceId});

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'choiceId': choiceId,
    };
  }
}