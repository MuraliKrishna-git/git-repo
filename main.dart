import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
enum Gender { male, female, other }
class User {
  final String name;
  final String email;
  final int age;
  final Gender gender;
  final DateTime dob;
  final bool termsAccepted;

  User({
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.dob,
    required this.termsAccepted,
  });
}
class Candidate extends User{
  Candidate({
    required super.name,
    required super.email,
    required super.age,
    required super.gender,
    required super.dob,
    required super.termsAccepted,
  });
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Form Demo',
      debugShowCheckedModeBanner: false,
      home: UserFormScreen(),
    );
  }
}

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

enum Role{user, candidate}
class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  Role? _roleController = Role.user;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  Gender? _selectedGender = Gender.male;
  DateTime? _selectedDOB;
  bool _termsAccepted = false;
  Future<void> _pickDOB(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() {
          _selectedDOB = picked;
        });
      }
    } catch (e) {
      print("Error picking date: $e");
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please accept the terms.")),
        );
        return;
      }
      if(_roleController! == Role.user) {
        final user = User(
          name: _nameController.text,
          email: _emailController.text,
          age: int.parse(_ageController.text),
          gender: _selectedGender!,
          dob: _selectedDOB!,
          termsAccepted: _termsAccepted,
        );

        print("User Created: ${user.name}, ${user.email}, ${user.gender}");
      } else if (_roleController! == Role.candidate){
        final candidate = Candidate(
          name: _nameController.text,
          email: _emailController.text,
          age: int.parse(_ageController.text),
          gender: _selectedGender!,
          dob: _selectedDOB!,
          termsAccepted: _termsAccepted,
        );

        print("Candidate Created: ${candidate.name}, ${candidate.email}, ${candidate.gender}");
      }



      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form Submitted Successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Registration Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Role>(
                  value: _roleController,
                  decoration: const InputDecoration(labelText: "Role"),
                  onChanged: (Role? newValue) {
                    setState(() {
                      _roleController = newValue;
                    });
                  },
                  items: Role.values.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender.name.toUpperCase()),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                  validator: (value) =>
                  value!.isEmpty ? "Name is required" : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value!.contains("@") ? null : "Enter a valid email",
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Age is required";
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 0) {
                      return "Enter a valid age";
                    }
                    return null;
                  },
                ),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) =>
                  value != null && value.length < 6
                      ? "Password must be 6+ chars"
                      : null,
                ),

                DropdownButtonFormField<Gender>(
                  value: _selectedGender,
                  decoration: const InputDecoration(labelText: "Gender"),
                  onChanged: (Gender? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: Gender.values.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender.name.toUpperCase()),
                    );
                  }).toList(),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Text("DOB: "),
                      Text(_selectedDOB == null
                          ? "Not selected"
                          : "${_selectedDOB!.day}/${_selectedDOB!.month}/${_selectedDOB!.year}"),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _pickDOB(context),
                        child: const Text("Pick Date"),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value!;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text("I accept the Terms and Conditions"),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
