import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:otatime_flutter/components/service/rest_service.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/pages/home/home_model.dart';
import 'package:otatime_flutter/widgets/shared/post_scroll_item.dart';
import 'package:otatime_flutter/widgets/transition.dart';

class PostScrollView extends StatelessWidget {
  const PostScrollView({
    super.key,
    required this.service,
  });

  final RestService<PostResultModel, dynamic> service;

  @override
  Widget build(BuildContext context) {
    return Transition(
      child: Builder(
        // 로드 상태 여부가 변경될 때 전환 애니메이션 적용.
        key: ValueKey(service.isLoading),
        builder: (context) {
          if (service.isLoading) return skeletonWidget();

          final List<PostModel> posts = service.data.posts;

          return wrapperWidget(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostScrollItem(model: posts[index]);
            },
          );
        },
      ),
    );
  }

  Widget wrapperWidget({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 너비에 따라 아이템의 최소 가로 크기를 400으로 유지하면서 컬럼 개수를 동적으로 계산함.
        final int crossCount = max(1, (constraints.maxWidth / 400).floor());

        return AlignedGridView.count(
          crossAxisCount: crossCount,
          crossAxisSpacing: Dimens.outerPadding,
          mainAxisSpacing: Dimens.outerPadding,
          padding: EdgeInsets.all(Dimens.outerPadding),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
    );
  }

  Widget skeletonWidget() {
    return wrapperWidget(
      itemCount: 5,
      itemBuilder: (context, index) {
        return PostScrollItem.skeletonWidget();
      },
    );
  }
}