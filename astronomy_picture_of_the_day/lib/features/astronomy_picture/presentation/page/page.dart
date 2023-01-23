import 'package:astronomy_picture_of_the_day/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/astronomy_fact_card.dart';
import '../bloc/AstronomyFact/astronomyfact_bloc.dart';
import '../components/custom_button_get_fact.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, [mounted = true]) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astronomy Fact'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => di.sl<AstronomyfactBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              BlocBuilder<AstronomyfactBloc, AstronomyfactState>(
                bloc: context.read<AstronomyfactBloc>()
                  ..add(GetAstronomyFactEvent(DateTime.now().subtract(const Duration(days: 1)))),
                builder: (context, state) {
                  if (state is AstronomyfactLoading || state is AstronomyfactInitial) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is AstronomyfactLoaded) {
                    return Expanded(
                      child: AstronomyFactCard(fact: state.astronomyFact),
                    );
                  } else if (state is AstronomyfactError) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    return const Expanded(
                      child: Center(
                        child: Text('error'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 15),
              const CustomButtonGetFact(),
            ],
          ),
        ),
      ),
    );
  }
}
