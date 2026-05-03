import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/cert_detail/cert_detail_screen.dart';
import '../../features/quiz/quiz_screen.dart';
import '../../features/quiz/explanation_screen.dart';
import '../../features/wrong_note/wrong_note_screen.dart';
import '../../features/one_min_core/one_min_core_screen.dart';
import '../../features/stats/stats_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/mock_exam/mock_exam_setup_screen.dart';
import '../../features/mock_exam/mock_exam_active_screen.dart';
import '../../features/mock_exam/mock_exam_result_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, _) => const HomeScreen(),
    ),
    GoRoute(
      path: '/cert/:certId',
      builder: (_, state) => CertDetailScreen(
        certId: state.pathParameters['certId']!,
      ),
    ),
    GoRoute(
      path: '/cert/:certId/quiz',
      builder: (_, state) => QuizScreen(
        certId: state.pathParameters['certId']!,
        mode: state.uri.queryParameters['mode'] ?? 'all',
      ),
    ),
    GoRoute(
      path: '/cert/:certId/explanation',
      builder: (_, state) => ExplanationScreen(
        certId: state.pathParameters['certId']!,
        questionId: int.parse(state.uri.queryParameters['questionId'] ?? '0'),
        showGradeButtons: state.extra != false,
      ),
    ),
    GoRoute(
      path: '/cert/:certId/wrong-note',
      builder: (_, state) => WrongNoteScreen(
        certId: state.pathParameters['certId']!,
      ),
    ),
    GoRoute(
      path: '/cert/:certId/one-min',
      builder: (_, state) => OneMinCoreScreen(
        certId: state.pathParameters['certId']!,
      ),
    ),
    GoRoute(
      path: '/stats',
      builder: (context, _) => const StatsScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, _) => const SearchScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, _) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/mock-exam/:certId',
      builder: (_, state) => MockExamSetupScreen(
        certId: state.pathParameters['certId']!,
      ),
    ),
    GoRoute(
      path: '/mock-exam/:certId/active',
      builder: (_, state) => MockExamActiveScreen(
        certId: state.pathParameters['certId']!,
      ),
    ),
    GoRoute(
      path: '/mock-exam/:certId/result',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return MockExamResultScreen(
          certId: state.pathParameters['certId']!,
          correct: extra['correct'] as int? ?? 0,
          total: extra['total'] as int? ?? 0,
          elapsedSeconds: extra['elapsed'] as int? ?? 0,
        );
      },
    ),
  ],
);
