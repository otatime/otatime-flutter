import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/service/service.dart';

/// 서비스의 인스턴스를 생성하는 빌더 함수 유형.
typedef ServiceInstanceBuilder<T extends Service> = T Function(BuildContext context);

/// 생성된 서비스 인스턴스를 사용하여 위젯을 빌드하는 함수 유형.
typedef ServiceWidgetBuilder<T extends Service> = Widget Function(BuildContext context, T service);

/// 해당 위젯은 [Service]의 생명주기를 관리하고, 서비스의 상태 변화에 따라 UI를 다시 빌드합니다.
///
/// [Service] 인스턴스는 위젯이 생성될 때 초기화되고, 위젯이 파괴될 때 함께 소멸됩니다.
class ServiceBuilder<T extends Service> extends StatefulWidget {
  const ServiceBuilder({
    super.key,
    required this.serviceBuilder,
    required this.builder,
  });

  /// [Service] 인스턴스를 생성하는 함수.
  final ServiceInstanceBuilder<T> serviceBuilder;

  /// [Service] 인스턴스를 사용하여 UI를 구성하는 빌더.
  final ServiceWidgetBuilder<T> builder;

  @override
  State<ServiceBuilder<T>> createState() => _ServiceBuilderState<T>();
}

class _ServiceBuilderState<T extends Service> extends State<ServiceBuilder<T>> {
  /// 위젯의 생명주기 동안 관리될 서비스 인스턴스.
  late final T _service;

  @override
  void initState() {
    super.initState();
    _service = widget.serviceBuilder(context);

    // 서비스의 초기 데이터 로드를 트리거.
    _service.load();
  }

  @override
  Widget build(BuildContext context) {
    // 서비스의 상태 변경을 감지하여 UI를 다시 빌드.
    return ListenableBuilder(
      listenable: _service,
      builder: (context, _) => widget.builder(context, _service),
    );
  }
}