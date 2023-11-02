import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/AstronomyFact/astronomyfact_bloc.dart';

class CustomButtonGetFact extends StatelessWidget {
  const CustomButtonGetFact({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, [mounted = true]) {
    return Material(
      child: InkWell(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now().subtract(const Duration(days: 1)),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            if (!mounted) return;
            BlocProvider.of<AstronomyfactBloc>(context)
                .add(GetAstronomyFactEvent(pickedDate));
          }
        },
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(15),
          child: const Center(
            child: Text(
              'Select Date',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
