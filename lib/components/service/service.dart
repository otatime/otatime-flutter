import 'package:flutter/foundation.dart';

/// 표준적인 [Service]에 대한 데이터 로드 상태를 나타내는 열거형입니다.
enum ServiceStatus {
  /// 아직 아무 작업도 수행하지 않은 상태
  none,

  /// 서버에 데이터 요청하고 대기 중인 상태
  loading,

  /// 데이터 요청 성공 및 역직렬화 완료
  loaded,

  /// 서버에 데이터 요청 실패
  errored,

  /// 기존 데이터를 유지한 채 새로 고침 요청 중인 상태
  refresh
}

/// MVVM 아키텍처 패턴에서 ViewModel 역할에 해당하는 추상 클래스입니다.
/// 주로 데이터 로딩 및 상태 관리를 담당합니다.
abstract class Service<T> extends ChangeNotifier {
  Service({
    ServiceStatus initialStatus = ServiceStatus.none
  }) {
    _statusNotifier = ValueNotifier(initialStatus);
    _statusNotifier.addListener(notifyListeners);
  }

  /// 현재 상태를 정의하고 리빌드를 위해 알림을 제공하는 내부 [Listenable] 인스턴스입니다.
  late final ValueNotifier<ServiceStatus> _statusNotifier;

  /// 주어진 값으로 현재 상태를 내부적으로 갱신합니다.
  set _status(ServiceStatus newStatus) {
    _statusNotifier.value = newStatus;
  }

  /// 현재 상태를 반환합니다.
  ServiceStatus get status => _statusNotifier.value;

  /// UI에 표시할 데이터가 없는 경우, 즉 아직 데이터를 로드하고 있는지에 대한 여부를 반환합니다.
  /// 즉, 데이터가 UI에 안전하게 표시될 수 없는 "준비 중" 상태를 판별하는 데 유용합니다.
  ///
  /// 참고로 로딩 인디케이터 또는 플레이스 홀더를 표시할 때 주로 활용됩니다.
  bool get isLoading => status == ServiceStatus.none
                     || status == ServiceStatus.loading;

  T? _data;

  /// 현재 역직렬화되어 로드된 데이터를 반환합니다.
  T get data {
    assert(
      _data != null || status == ServiceStatus.refresh,
      "데이터의 참조 시점은 데이터가 이미 로드된 상태여야만 합니다."
    );
    assert(
      status == ServiceStatus.loaded || status == ServiceStatus.refresh,
      "데이터를 참조하는 호출 시점은 항상 [ServiceStatus.loaded] 일 때여야 합니다."
    );

    return _data!;
  }

  /// 현재 로드되어 역직렬화된 데이터를 주어진 데이터로 수정합니다.
  set data (T newData) {
    if (_data != newData) {
      _data = newData;
      notifyListeners();
    }
  }

  /// 데이터 로드 중 오류 발생 시 호출되어야 하는 메서드입니다.
  /// 기본 구현에서는 상태만 [ServiceStatus.errored]로 설정합니다.
  void fail() {
    _status = ServiceStatus.errored;
  }

  /// 성공적으로 데이터 로드가 완료될 시 호출되어야 하는 메서드입니다.
  /// 내부적으로 상태를 [ServiceStatus.loaded]로 설정하고 데이터를 정의합니다.
  void done(T newData) {
    _data = newData;
    _status = ServiceStatus.loaded;
  }

  /// 데이터를 로드하거나 새로 고침을 시작합니다.
  ///
  /// 이 메서드는 반드시 [done] 또는 [fail] 호출로 종료되어야 합니다.
  /// 그렇지 않으면 기존 상태가 멈춘 채 UI가 제때 갱신되지 않을 수 있습니다.
  @mustCallSuper
  Future<void> load({bool isRefresh = false}) async {
    _status = isRefresh
      ? ServiceStatus.refresh
      : ServiceStatus.loading;
  }

  /// 로드되기 전까지 기존 데이터를 유지하되 새로 고침을 요청합니다.
  Future<void> refresh() async => await load(isRefresh: true);
}