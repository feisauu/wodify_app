import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/src/body_parts/add_body_part_form.dart';
import 'package:flutter_workout_tracker/src/body_parts/body_part_model.dart';
import 'package:flutter_workout_tracker/src/exercise_set/excercise_list_view.dart';
import 'package:flutter_workout_tracker/src/prefs.dart';
import 'package:flutter_workout_tracker/screens/welcome_screen.dart';
import 'package:collection/collection.dart';

class BodyPartListView extends StatefulWidget {
  BodyPartListView({super.key, required this.bodyParts});

  static const routeName = '/';

  List<BodyPart> bodyParts;

  @override
  State<BodyPartListView> createState() => _BodyPartListViewState();
}

class _BodyPartListViewState extends State<BodyPartListView> {
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    List<BodyPart> bodyPartList = await getBodyPartsList();
    bodyPartList.sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      widget.bodyParts = bodyPartList;
    });
  }

  String _getImageForBodyPart(String name) {
    switch (name.toLowerCase()) {
      case 'chest':
        return 'assets/images/chest.png';
      case 'back':
        return 'assets/images/back.png';
      case 'arms':
        return 'assets/images/arms.png';
      case 'legs':
        return 'assets/images/legs.png';
      case 'abs':
        return 'assets/images/abs.png';
      case 'biceps':
        return 'assets/images/biceps.png';
      case 'forearms':
        return 'assets/images/forearms.png';
      case 'triceps':
        return 'assets/images/triceps.png';
      case 'waist':
        return 'assets/images/waist.png';
      case 'shoulders':
        return 'assets/images/shoulders.png';
      default:
        return 'assets/images/default.png'; // Ensure there's a default image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Body Parts',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFCB0505), // Red color
        iconTheme: const IconThemeData(
          color: Colors.white, // Change back arrow color to white
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _navigateToAddBodyPartForm(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            // Changed to logout icon
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFCB0505), // Changed background color to red
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 20,
                      child: Icon(Icons.person, color: Colors.grey[800]),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Welcome to Wodify!',
                        style: TextStyle(
                          color: Color(0xFF021328), // New text color
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF), // White color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Choose your body parts',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'See all',
                            style: TextStyle(
                              color: Color(0xFF76767C),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1, // Adjusted ratio for better look
                        ),
                        itemCount: widget.bodyParts.length,
                        itemBuilder: (context, index) {
                          final bodyPart = widget.bodyParts[index];
                          return _buildBodyPartCard(context, bodyPart);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddBodyPartForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddBodyPartForm(),
    ).then((value) async {
      if (value != null) {
        setState(() {
          widget.bodyParts = value;
        });
      }
    });
  }

  Widget _buildBodyPartCard(BuildContext context, BodyPart bodyPart) {
    return Card(
      color: const Color(0xFFCB0505), // Corrected color code to be fully opaque
      shadowColor: const Color(0xFFCB0505), // New shadow color
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => _navigateToExerciseListView(context, bodyPart),
        splashColor: const Color(0xFFCB0505).withOpacity(0.3), // Interactive splash color
        child: Padding(
          padding: const EdgeInsets.all(4.0), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                _getImageForBodyPart(bodyPart.name),
                height: 80, // Adjust the size as needed
                width: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 6), // Further reduced spacing
              Center(
                child: Text(
                  bodyPart.name,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16, // Further reduced text size
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToExerciseListView(BuildContext context, BodyPart bodyPart) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseListView(bodyPart: bodyPart),
      ),
    ).then((value) {
      if (value != null) {
        setState(() => widget.bodyParts = value);
      }
    });
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(context, '/welcome'); // Navigate to WelcomeScreen
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
