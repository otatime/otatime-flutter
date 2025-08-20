import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/service/service.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/app_page_route.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/pages/address/address_model.dart';
import 'package:otatime_flutter/pages/address/address_service.dart';
import 'package:otatime_flutter/widgets/circular_button.dart';
import 'package:otatime_flutter/widgets/column_item.dart';
import 'package:otatime_flutter/widgets/column_list.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/header_connection.dart';
import 'package:otatime_flutter/widgets/info_placeholder.dart';
import 'package:otatime_flutter/widgets/input_field.dart';
import 'package:otatime_flutter/widgets/labeled_box.dart';
import 'package:otatime_flutter/widgets/radio.dart';
import 'package:otatime_flutter/widgets/skeleton.dart';
import 'package:otatime_flutter/widgets/transition.dart';
import 'package:otatime_flutter/widgets/wide_button.dart';

class Address {
  const Address({
    required this.zipCode,
    required this.street,
    required this.details,
    required this.latitude,
    required this.longitude,
  });

  final String zipCode;   // 우편 주소
  final String street;    // 도로명 주소
  final String details;   // 상세 주소
  final double latitude;  // 위도
  final double longitude; // 경도
}

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  AddressModel? selectedModel;
  String? details;
  bool isLoading = false;

  /// 사용자가 최종적으로 주소 선택을 완료하면 호출됩니다.
  void done() async {
    setState(() => isLoading = true);

    assert(selectedModel != null);
    final service = LocationService(model: selectedModel!);
    await service.load();

    // 선택한 주소에 대한 위도 및 경도에 대한 조회 결과.
    final LocationModel location = service.data.model;

    final Address result = Address(
      zipCode: selectedModel!.zipNo,
      details: details ?? "",
      street: selectedModel!.roadAddr,
      latitude: location.entY,
      longitude: location.entX,
    );

    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  void updateDetails(String newValue) => setState(() {
    details = newValue;
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Disableable(
            isEnabled: !isLoading,
            child: HeaderConnection(
              title: "주소 선택",
              child: ListView(
                padding: EdgeInsets.all(Dimens.outerPadding),
                children: [
                  LabeledBox(
                    label: "도로명 주소",
                    child: ColumnList(
                      children: [
                        ColumnItem.push(
                          title: selectedModel?.roadAddr ?? "주소 검색하기",
                          iconPath: "navigation".svg,
                          onTap: () async {
                            // 도로명 주소 검색 페이지로 이동.
                            final result = await Navigator.push(
                              context,
                              AppPageRoute(builder: (_) => _AddressSearchPage()),
                            ) as AddressModel?;

                            if (result != null) {
                              setState(() => selectedModel = result);
                            }
                          }
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: Dimens.innerPadding * 2),
                  LabeledBox(
                    label: "상세 또는 기타사항",
                    child: InputField(
                      hintText: "예: 코엑스 컨벤션 센터 3층 d홀",
                      onChanged: updateDetails,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.only(
            left: Dimens.outerPadding,
            right: Dimens.outerPadding,
            bottom: Dimens.outerPadding,
          ),
          child: Disableable(
            isEnabled: selectedModel != null,
            child: WideButton(
              label: "선택하기",
              onTap: done,
              isLoading: isLoading,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressSearchPage extends StatefulWidget {
  const _AddressSearchPage({super.key});

  @override
  State<_AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<_AddressSearchPage> {
  AddressService? service;

  /// 현재 선택된 주소 정보를 정의합니다.
  AddressModel? selectedModel;

  /// 사용자가 검색하여 주소 선택을 완료하면 호출됩니다.
  void done() {
    Navigator.pop(context, selectedModel);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AppBarConnection(
            appBars: [
              AppBar(
                behavior: MaterialAppBarBehavior(
                  alwaysScrolling: false,
                  floating: true,
                ),
                body: serachBarWidget(autoFocus: true),
              ),
            ],
            child: ListenableBuilder(
              listenable: service ?? ValueNotifier([]),
              builder: (context, child) {
                // 로딩 상태가 변화할 때마다 전환 애니메이션 적용.
                return Transition(
                  child: Builder(
                    key: ValueKey(service?.status),
                    builder: (context) {
                      if (service == null) return SizedBox();

                      // 사용자가 검색어를 너무 짧게 입력한 경우.
                      if (service!.keyword.length <= 2) {
                        return InfoPlaceholder(
                          iconPath: "search".svg,
                          title: "검색어가 너무 짧아요",
                          label: "검색어는 최소 2글자 이상 입력해주세요."
                        );
                      }

                      if (service!.status == ServiceStatus.loading) {
                        return _ScrollView.skeletonWidget();
                      }

                      // 검색 결과가 존재하지 않는 경우.
                      if (service!.data.isEmpty) {
                        return InfoPlaceholder(
                          iconPath: "search".svg,
                          title: "다시 시도해주세요!",
                          label: "‘${service!.keyword}’ 검색 결과를 찾을 수 없습니다.",
                        );
                      }

                      return _ScrollView(
                        service: service!,
                        selectedModel: selectedModel,
                        onChanged: (newModel) {
                          setState(() => selectedModel = newModel);
                        },
                      );
                    },
                  ),
                );
              }
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.only(
            left: Dimens.outerPadding,
            right: Dimens.outerPadding,
            bottom: Dimens.outerPadding,
          ),
          child: Disableable(
            isEnabled: selectedModel != null,
            child: WideButton(label: "선택하기", onTap: done)
          ),
        ),
      ],
    );
  }

  Widget serachBarWidget({required bool autoFocus}) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.outerPadding,
        right: Dimens.outerPadding,
        bottom: Dimens.outerPadding,
      ),
      child: Row(
        children: [
          // 뒤로가기 버튼.
          CircularButton(
            iconPath: "arrow_left".svg,
            onTap: () => Navigator.pop(context),
          ),

          // 검색바 표시.
          Expanded(
            child: Hero(
              tag: "search-bar",
              child: InputField(
                hintText: "주소 검색",
                autofocus: autoFocus,
                onChanged: (newValue) {
                  setState(() {
                    if (newValue.isEmpty) {
                      return service = null;
                    }

                    service = AddressService(keyword: newValue);

                    // 최소 검색어 길이를 충족한 경우.
                    if (service!.status == ServiceStatus.none
                     && service!.keyword.length > 2) {
                      service?.load();
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollView extends StatelessWidget {
  const _ScrollView({
    super.key,
    required this.service,
    required this.selectedModel,
    required this.onChanged,
  });

  final AddressService service;
  final AddressModel? selectedModel;
  final ValueChanged<AddressModel> onChanged;

  @override
  Widget build(BuildContext context) {
    return wrapperWidget(
      itemCount: service.data.length,
      itemBuilder: (context, index) {
        final AddressModel model = service.data[index];

        return _ScrollItem(
          isSelected: model == selectedModel,
          model: model,
          onTap: () => onChanged.call(model),
        );
      },
    );
  }

  static Widget wrapperWidget({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return ListView.separated(
      padding: EdgeInsets.all(Dimens.outerPadding),
      separatorBuilder: (context, index) {
        return SizedBox(height: Dimens.innerPadding);
      },
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  static Widget skeletonWidget() {
    return wrapperWidget(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _ScrollItem.skeletonWidget();
      },
    );
  }
}

class _ScrollItem extends StatelessWidget {
  const _ScrollItem({
    super.key,
    required this.isSelected,
    required this.model,
    required this.onTap,
  });

  final bool isSelected;
  final AddressModel model;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: () {
        if (!isSelected) {
          onTap.call();
          HapticFeedback.vibrate();
        }
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.innerPadding),
        decoration: BoxDecoration(
          color: Scheme.current.deepground,
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
        ),
        child: Row(
          spacing: Dimens.innerPadding,
          children: [
            Radio(
              isEnabled: isSelected,
              onChanged: (newValue) {},
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: Dimens.columnSpacing,
                children: [
                  // 도로명주소 표시.
                  Text(
                    model.roadAddr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  // 지번 주소 표시.
                  Text(
                    model.jibunAddr,
                    style: TextStyle(color: Scheme.current.foreground2),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: Dimens.rowSpacing,
                    children: [
                      SvgPicture.asset(
                        "mail-filled".svg,
                        width: 14,
                        color: Scheme.current.foreground2,
                      ),

                      // 우편 변호 표시.
                      Text(model.zipNo, style: TextStyle(color: Scheme.current.foreground2))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget skeletonWidget() {
    return Skeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: Dimens.columnSpacing,
        children: [
          Skeleton.partOf(height: 60),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Skeleton.partOf(height: 30),
          )
        ],
      ),
    );
  }
}