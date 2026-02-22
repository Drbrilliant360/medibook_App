import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'doctor_home_screen.dart';
import 'doctor_appointments_screen.dart';
import 'doctor_schedule_screen.dart';
import 'doctor_profile_screen.dart';

class DoctorNavigation extends StatefulWidget {
  const DoctorNavigation({super.key});

  @override
  State<DoctorNavigation> createState() => _DoctorNavigationState();
}

class _DoctorNavigationState extends State<DoctorNavigation> {
  int _currentIndex = 0;

  final _screens = const [
    DoctorHomeScreen(),
    DoctorAppointmentsScreen(),
    DoctorScheduleScreen(),
    DoctorProfileSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(CupertinoIcons.square_grid_2x2),
            selectedIcon: Icon(CupertinoIcons.square_grid_2x2),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.calendar),
            selectedIcon: Icon(CupertinoIcons.calendar),
            label: 'Appointments',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.clock),
            selectedIcon: Icon(CupertinoIcons.clock),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.person),
            selectedIcon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
