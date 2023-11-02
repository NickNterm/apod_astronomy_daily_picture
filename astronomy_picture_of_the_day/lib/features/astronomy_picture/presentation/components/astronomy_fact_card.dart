import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/astronomy_fact.dart';

class AstronomyFactCard extends StatelessWidget {
  const AstronomyFactCard({
    Key? key,
    required this.fact,
  }) : super(key: key);

  final AstronomyFact fact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: fact.imageUrl,
                height: 230,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            fact.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat('dd-MM-yyyy').format(fact.date),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              interactive: true,
              thumbVisibility: true,
              thickness: 3,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                child: Text(
                  fact.explanation,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              fact.copyRight,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
