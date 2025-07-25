import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/service/service.dart';

typedef ServiceInstanceBuilder<T extends Service> = T Function(BuildContext context);
typedef ServiceWidgetBuilder<T extends Service> = Widget Function(BuildContext context, T service);

class ServiceBuilder<T extends Service> extends StatefulWidget {
  const ServiceBuilder({
    super.key,
    required this.serviceBuilder,
    required this.builder,
  });

  final ServiceInstanceBuilder<T> serviceBuilder;
  final ServiceWidgetBuilder<T> builder;

  @override
  State<ServiceBuilder<T>> createState() => _ServiceBuilderState<T>();
}

class _ServiceBuilderState<T extends Service> extends State<ServiceBuilder<T>> {
  late final T _service;

  @override
  void initState() {
    super.initState();
    _service = widget.serviceBuilder(context);
    _service.load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _service,
      builder: (context, _) => widget.builder(context, _service),
    );
  }
}