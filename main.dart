import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
        ),
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: WorkoutList(),
    );
  }
}

class WorkoutList extends StatelessWidget {
  final List<Workout> workouts = [
    Workout(
      id: 1,
      name: 'Push-ups',
      imageUrl: 'https://burst.shopifycdn.com/photos/arm-back-muscles.jpg?width=1000&format=pjpg&exif=0&iptc=0',
      details: 'Push-ups are a great upper body workout that targets the chest, shoulders, and triceps.',
    ),
    Workout(
      id: 2,
      name: 'Squats',
      imageUrl: 'https://i0.wp.com/www.muscleandfitness.com/wp-content/uploads/2019/02/1109-Barbell-Back-Squat-GettyImages-614107160.jpg?quality=86&strip=all',
      details: 'Squats are a lower body exercise that targets the quadriceps, hamstrings, and glutes.',
    ),
    Workout(
      id: 3,
      name: 'Plank',
      imageUrl: 'https://media.istockphoto.com/id/628092382/photo/its-great-for-the-abs.jpg?s=612x612&w=0&k=20&c=YOWaZRjuyh-OG6rv8k0quDNxRwqrxdMm8xgqe37Jmak=',
      details: 'The plank is a core-strengthening exercise that also engages the shoulders, back, and legs.',
    ),
    // Add more workout data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Navigate to the search screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen(workouts: workouts)),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return WorkoutCard(workout: workouts[index]);
        },
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  final List<Workout> workouts;

  SearchScreen({required this.workouts});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<Workout> searchResults;

  @override
  void initState() {
    super.initState();
    searchResults = List.from(widget.workouts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Workouts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (query) {
                // Update the search results based on the query
                setState(() {
                  searchResults = widget.workouts
                      .where((workout) =>
                      workout.name.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter workout name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return WorkoutCard(workout: searchResults[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final Workout workout;

  WorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WorkoutDetail(workout: workout)),
        );
      },
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImage(
              imageUrl: workout.imageUrl,
              height: 250.0,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 250.0,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              color: Theme.of(context).primaryColor, // Use primary color
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    workout.details,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class WorkoutDetail extends StatelessWidget {
  final Workout workout;

  WorkoutDetail({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CachedNetworkImage(
            imageUrl: workout.imageUrl,
            height: 200.0,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 200.0,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            padding: EdgeInsets.all(15.0),
            color: Theme.of(context).colorScheme.secondary,
            child: Text(
              workout.details,
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Back'),
          ),
        ],
      ),
    );
  }
}

class Workout {
  final int id;
  final String name;
  final String imageUrl;
  final String details;

  Workout({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.details,
  });
}
