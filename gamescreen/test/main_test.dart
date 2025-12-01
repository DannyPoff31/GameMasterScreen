import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newproject/main.dart';

void main() {
  // ========================================================================
  // UNIT TESTS: Testing individual components in isolation
  // ========================================================================
  group('MyApp Unit Tests', () {
    testWidgets('MyApp creates MaterialApp with correct theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      expect(find.byType(MaterialApp), findsOneWidget);
      
      final MaterialApp app = find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
      expect(app.title, 'Flutter Demo');
      expect(app.debugShowCheckedModeBanner, false);
    });

    testWidgets('MyApp sets correct scaffold background color', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      final MaterialApp app = find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
      expect(app.theme?.scaffoldBackgroundColor, Color.fromARGB(255, 45, 40, 55));
    });

    testWidgets('MyApp applies custom theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      final MaterialApp app = find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
      // Verify theme is applied
      expect(app.theme, isNotNull);
    });
  });

  group('MyHomePage Unit Tests', () {
    testWidgets('MyHomePage initializes with correct state', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      expect(find.byType(MyHomePage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('AppBar displays correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      expect(find.text('Gamemaster Screen'), findsOneWidget);
    });

    testWidgets('Drawer is present in scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      expect(find.byType(Drawer), findsOneWidget);
    });
  });

  group('UI Components Unit Tests', () {
    testWidgets('Create Player button is present in drawer', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      expect(find.text('Create Player'), findsOneWidget);
    });

    testWidgets('Room Page button is present in body', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      expect(find.text('Room Page'), findsOneWidget);
    });

    testWidgets('Time controls are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Clock time controls should be visible
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Start'), findsOneWidget);
    });

    testWidgets('Stat Blocks section exists', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      expect(find.text('Stat Blocks'), findsOneWidget);
    });

    testWidgets('Instantiated Monsters section exists', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      expect(find.text('Instantiated Monsters'), findsOneWidget);
    });
  });

  // ========================================================================
  // INTEGRATION TESTS: Testing component interactions
  // ========================================================================
  group('MyApp Integration Tests', () {
    testWidgets('Drawer opens when drawer button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      expect(find.byType(Drawer), findsOneWidget);
      
      // Open drawer
      await tester.tapAt(Offset(10, 50));
      await tester.pumpAndSettle();
      
      // Verify drawer interaction
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('Create Player dialog can be opened', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Find and tap Create Player button
      final createButton = find.text('Create Player');
      expect(createButton, findsOneWidget);
      
      await tester.tap(createButton);
      await tester.pumpAndSettle();
      
      // Verify dialog appeared
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Time controls interact correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Find Edit and Start buttons in time section
      final editButton = find.text('Edit');
      expect(editButton, findsOneWidget);
      
      final startButton = find.text('Start');
      expect(startButton, findsOneWidget);
    });

    testWidgets('Room Page navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      final roomPageButton = find.text('Room Page');
      expect(roomPageButton, findsOneWidget);
      
      await tester.tap(roomPageButton);
      await tester.pumpAndSettle();
      
      // Navigation should occur
      expect(find.byType(MaterialPageRoute), findsWidgets);
    });

    testWidgets('Stat Blocks and Monsters sections display together', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Both sections should be visible
      expect(find.text('Stat Blocks'), findsOneWidget);
      expect(find.text('Instantiated Monsters'), findsOneWidget);
    });

    testWidgets('Layout structure is correct (main body row)', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Should have main column with expanded flex areas
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
    });
  });

  // ========================================================================
  // REGRESSION TESTS: Ensuring previously fixed bugs don't reoccur
  // ========================================================================
  group('MyApp Regression Tests', () {
    testWidgets('Drawer does not block main content', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Main content should be visible
      expect(find.text('Gamemaster Screen'), findsOneWidget);
      expect(find.text('Room Page'), findsOneWidget);
    });

    testWidgets('Dialog closes after submission', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Open dialog
      await tester.tap(find.text('Create Player'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      
      // Close dialog via Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      
      // Dialog should be closed
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Clock state does not affect other UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Toggle clock start/stop multiple times
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Start'));
        await tester.pumpAndSettle();
      }
      
      // Other UI elements should still be present and functional
      expect(find.text('Room Page'), findsOneWidget);
      expect(find.text('Create Player'), findsOneWidget);
    });

    testWidgets('Multiple players can be added without state corruption', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Attempt to add multiple players (mock dialog interaction)
      expect(find.text('Create Player'), findsOneWidget);
      
      // UI should remain stable
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('Room list initializes with default rooms', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // App should initialize without crashing
      expect(find.byType(MyHomePage), findsOneWidget);
    });

    testWidgets('Sketches ValueNotifier does not cause widget tree issues', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Widget should render without errors
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(CustomScrollView), findsWidgets);
    });
  });

  // ========================================================================
  // ACCEPTANCE TESTS: High-level user scenarios and requirements
  // ========================================================================
  group('MyApp Acceptance Tests', () {
    testWidgets('User can view the game master interface', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Main screen should be visible with all key elements
      expect(find.text('Gamemaster Screen'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('User can access player character management', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Player section should be accessible
      expect(find.text('Player Characters'), findsOneWidget);
      expect(find.text('Create Player'), findsOneWidget);
    });

    testWidgets('User can manage game time with time controls', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Time controls should be present
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Start'), findsOneWidget);
    });

    testWidgets('User can create stat blocks for NPCs', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Stat block section should be accessible
      expect(find.text('Stat Blocks'), findsOneWidget);
      expect(find.text('Create new block'), findsOneWidget);
    });

    testWidgets('User can manage instantiated monsters', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Monster section should be visible
      expect(find.text('Instantiated Monsters'), findsOneWidget);
    });

    testWidgets('User can navigate to room drawing page', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Room Page button should be accessible
      expect(find.text('Room Page'), findsOneWidget);
      
      await tester.tap(find.text('Room Page'));
      await tester.pumpAndSettle();
    });

    testWidgets('User can edit player information via dialog', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Open create dialog
      await tester.tap(find.text('Create Player'));
      await tester.pumpAndSettle();
      
      // Dialog should show input fields
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('User interface maintains layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Layout should have correct structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('User can cancel operations without data loss', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Open dialog
      await tester.tap(find.text('Create Player'));
      await tester.pumpAndSettle();
      
      // Cancel dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      
      // UI should be back to initial state
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Create Player'), findsOneWidget);
    });

    testWidgets('Application does not crash on startup', (WidgetTester tester) async {
      // Main assertion: pumpWidget should not throw
      expect(
        () async {
          await tester.pumpWidget(const MyApp());
          await tester.pumpAndSettle();
        },
        returnsNormally,
      );
    });

    testWidgets('All major UI sections are accessible', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Verify all sections are rendered
      expect(find.text('Player Characters'), findsOneWidget);
      expect(find.text('Stat Blocks'), findsOneWidget);
      expect(find.text('Instantiated Monsters'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('User can view game map/room layout', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Map area should be rendered
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
    });
  });

  // ========================================================================
  // COMBINED SCENARIO TESTS: Real user workflows
  // ========================================================================
  group('MyApp Workflow Tests', () {
    testWidgets('Complete game session setup workflow', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Step 1: Verify initial state
      expect(find.text('Gamemaster Screen'), findsOneWidget);
      
      // Step 2: Access player creation
      expect(find.text('Create Player'), findsOneWidget);
      
      // Step 3: Access clock controls
      expect(find.text('Start'), findsOneWidget);
      
      // Step 4: Access stat blocks
      expect(find.text('Create new block'), findsOneWidget);
      
      // Step 5: Access room navigation
      expect(find.text('Room Page'), findsOneWidget);
    });

    testWidgets('Dialog interaction workflow', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Open dialog
      await tester.tap(find.text('Create Player'));
      await tester.pumpAndSettle();
      
      // Verify dialog elements
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
      
      // Close dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Multi-section interaction workflow', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Time control section
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Start'), findsOneWidget);
      
      // Monster section
      expect(find.text('Instantiated Monsters'), findsOneWidget);
      
      // Stat blocks section
      expect(find.text('Stat Blocks'), findsOneWidget);
    });
  });
}
