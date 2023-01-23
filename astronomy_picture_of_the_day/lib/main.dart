import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/astronomy_picture/presentation/bloc/AstronomyFact/astronomyfact_bloc.dart';
import 'features/astronomy_picture/presentation/page/page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // initialize the data
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AstronomyfactBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
          fontFamily: GoogleFonts.ubuntu().fontFamily,
          //fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        home: const MainPage(),
      ),
    );
  }
}
