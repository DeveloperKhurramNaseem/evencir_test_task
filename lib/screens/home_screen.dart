import 'package:evencir_test/mood_screen/mood_screen.dart';
import 'package:evencir_test/training_plan/screens/training_calendar_screen.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime(2024, 12, 22);
  int _currentNavIndex = 0;

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
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Builder(builder: (context){
        if(_currentNavIndex == 0)
      {
        return HomeScreenBody();
      }else if(_currentNavIndex == 1){
        return TrainingCalendarScreen();
      }else if(_currentNavIndex == 2){
        return MoodScreen();
      }
      return HomeScreenBody();
      }),
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
   DateTime _selectedDate = DateTime(2024, 12, 22);
  int _currentNavIndex = 0;

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
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeekSelectorBar(
                  selectedDate: _selectedDate,
                  onWeekTap: _onWeekTap,
                ),
                const SizedBox(height: 8),

                // Date strip
                WeekDateStrip(
                  selectedDate: _selectedDate,
                  onDateSelected: (date) =>
                      setState(() => _selectedDate = date),
                ),

                // const SizedBox(height: 24),

                // // ── Workouts section ─────────────────
                _SectionHeader(
                  title: 'Workouts',
                  trailing: Row(
                    children: const [
                      Icon(
                        Icons.wb_sunny_outlined,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '9°',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.nightlight_round,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: WorkoutCard(
                    title: 'Upper Body',
                    date: 'December 22',
                    duration: '25m - 30m',
                    onTap: () {},
                  ),
                ),

                const SizedBox(height: 28),

                // // ── My Insights section ──────────────
                const _SectionHeader(title: 'My Insights'),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Calories
                      Expanded(
                        flex: 55,
                        child: CaloriesCard(consumed: 550, total: 2500),
                      ),
                      const SizedBox(width: 12),
                      // Weight
                      Expanded(
                        flex: 45,
                        child: WeightCard(weight: 75, change: 1.6),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // // Hydration (full width)
                HydrationCard(
                  currentLitres: 0,
                  targetLitres: 2,
                  toastMessage: '500 ml added to water log',
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        // Column(
        //   children: [
        //     // ── Top bar ──────────────────────────────────
        //     WeekSelectorBar(
        //       selectedDate: _selectedDate,
        //       onWeekTap: _onWeekTap,
        //     ),

        //     // ── Scrollable content ────────────────────────
        //     Expanded(
        //       child:
        //     ),

        //     // ── Bottom navigation ─────────────────────────
        //     AppBottomNavBar(
        //       currentIndex: _currentNavIndex,
        //       onTap: (index) => setState(() => _currentNavIndex = index),
        //     ),
        //   ],
        // ),
      );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
