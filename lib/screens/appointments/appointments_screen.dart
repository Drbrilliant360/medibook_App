import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_routes.dart';
import '../../models/appointment_model.dart';
import '../../services/appointment_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/medi_app_bar.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final appointmentService = AppointmentService();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const MediAppBar(
          title: 'My Appointments',
          style: MediAppBarStyle.primary,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: StreamBuilder<List<AppointmentModel>>(
          stream: appointmentService.getAppointmentsStream(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final all = snapshot.data ?? [];
            final upcoming = all
                .where((a) =>
                    a.status == 'pending' || a.status == 'confirmed')
                .toList();
            final completed =
                all.where((a) => a.status == 'completed').toList();
            final cancelled =
                all.where((a) => a.status == 'cancelled').toList();

            return TabBarView(
              children: [
                _buildList(context, upcoming, 'No upcoming appointments'),
                _buildList(context, completed, 'No completed appointments'),
                _buildList(context, cancelled, 'No cancelled appointments'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, List<AppointmentModel> appointments, String emptyMessage) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.calendar,
                size: 64, color: AppColors.textSecondary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(emptyMessage, style: AppTextStyles.bodyMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: appointments.length,
      itemBuilder: (context, index) => AppointmentCard(
        appointment: appointments[index],
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.appointmentDetail,
          arguments: appointments[index],
        ),
      ),
    );
  }
}
