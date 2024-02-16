import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LocationFileScreen extends StatelessWidget {
  const LocationFileScreen({
    @PathParam('id') required this.id,
    super.key
  });
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location File'),
      ),
      body: Center(
        child: TextButton(
          onPressed: (){
            AutoRouter.of(context).pop('root');
          },
          child: const Text('Back'),
        )
      ),
    );
  }
}
