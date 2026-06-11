
import 'package:evencir_test/screens/home_screen/widgets/app_bottom_nav_bar.dart';
import 'package:evencir_test/screens/home_screen/widgets/calendar_bottom_sheet.dart';
import 'package:evencir_test/screens/home_screen/widgets/calories_card.dart';
import 'package:evencir_test/screens/home_screen/widgets/hydration_card.dart';
import 'package:evencir_test/screens/home_screen/widgets/section_headers.dart';
import 'package:evencir_test/screens/home_screen/widgets/short_divider.dart';
import 'package:evencir_test/screens/home_screen/widgets/space_widget.dart';
import 'package:evencir_test/screens/home_screen/widgets/week_date_strip.dart';
import 'package:evencir_test/screens/home_screen/widgets/week_selector_bar.dart';
import 'package:evencir_test/screens/home_screen/widgets/weight_card.dart';
import 'package:evencir_test/screens/home_screen/widgets/workout_card.dart';
import 'package:evencir_test/screens/mood_screen/mood_screen.dart';
import 'package:evencir_test/screens/training_plan/screens/training_calendar_screen.dart';
import 'package:evencir_test/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Builder(
        builder: (context) {
          if (_currentNavIndex == 0) {
            return HomeScreenBody();
          } else if (_currentNavIndex == 1) {
            return TrainingCalendarScreen();
          } else if (_currentNavIndex == 2) {
            return MoodScreen();
          }
          return HomeScreenBody();
        },
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
      ),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  DateTime _selectedDate = DateTime(2026, 6, 11);

  Future<void> _onWeekTap() async {
    final picked = await CalendarBottomSheet.show(
      context,
      initialDate: _selectedDate,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,      
      child: CustomScrollView(
        slivers: [
          WeekSelectorBar(selectedDate: _selectedDate, onWeekTap: _onWeekTap),
          SpaceWidget(gap: 12),
          WeekDateStrip(
            selectedDate: _selectedDate,
            onDateSelected: (date) => setState(() => _selectedDate = date),
          ),
          SpaceWidget(gap: 10),
          ShortDivider(),
          SpaceWidget(gap: 14),
          WorkoutSectionHeader(),
          SpaceWidget(gap: 12),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: WorkoutCard(
              title: 'Upper Body',
              date: 'December 22',
              duration: '25m - 30m',
              onTap: () {},
            ),
          ),
          SpaceWidget(gap: 26),
          const SectionHeader(title: 'My Insights'),
          SpaceWidget(gap: 12),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                spacing: 10,
                children: [
                  // Calories
                  Expanded(child: CaloriesCard(consumed: 550, total: 2500)),
                  // Weight
                  Expanded(child: WeightCard(weight: 75, change: 1.6)),
                ],
              ),
            ),
          ),
          SpaceWidget(gap: 12),
          HydrationCard(
            currentLitres: 0,
            targetLitres: 2,
            toastMessage: '500 ml added to water log',
          ),
          SpaceWidget(gap: 24),
        ],
      ),
    );
  }
}
