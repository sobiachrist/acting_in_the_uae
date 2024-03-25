
class Job {
  final int id;
  final String title;
  final String description;
  final String location;
  final String salary;
  final List<String> requirements;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.requirements,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      salary: json['salary'],
      requirements: List<String>.from(json['requirements']),
    );
  }

  // Extension: Check if the job meets certain requirements
  bool meetsRequirements(List<String> userSkills) {
    for (var req in requirements) {
      if (!userSkills.contains(req)) {
        return false;
      }
    }
    return true;
  }
}
