# 주석 작성 지침

1. 주석은 한국어로 작성할 것.

2. 코드 내부 동작이나 뻔한 내용은 작성하지 말 것.
   - 예: `int i = 0; // i를 0으로 초기화`는 불필요.
   - 예: `ListView()`와 같은 흔히 알고 있는 위젯은 주석 불필요.
   - 예: `Transition()`와 같은 이름으로 기능과 뜻을 충분히 유추할 수 있는 경우에도 주석 불필요.
   - 즉, 관례적으로 이미 알고 있는 언어적 문법은 별도의 주석을 작성하지 말 것.

3. 주석은 제 3자가 코드 내용을 처음 접해도 이해할 수 있도록 작성할 것.
   - 무엇을 하는 코드인지, 어떤 목적을 가지고 있는지 중심으로 설명.
   - 만약 별도의 주석 없이도 제 3자가 충분히 이해할 수 있는 경우는 주석을 생략할 것.

4. 주석은 **기능 중심**으로 작성하고, 구현 방식보다는 의미/목적을 설명할 것.

5. UI 관련 코드의 경우, 화면에 표시되는 내용이나 사용자에게 보여지는 의미까지 포함할 것.

6. 가독성과 시각적 아름다움 유지
    - 경우에 따라 주석 위에는 공백을 남겨 시각적 구분 확보.
    - 주석 작성으로 코드가 시각적으로 더 나빠질 경우, 공백을 활용하거나 주석을 생략하여 시각적 아름다움을 유지.

## Widget

✅ 올바른 예시:

```dart
ListView(
  children: [
    // 사용자의 이메일 표시.
    Text(model.email),

    // 사용자의 닉네임 표시.
    Text(model.nickname),
  ]
);
```

```dart
// 하단 선택하기 버튼 영역.
Padding(
  padding: EdgeInsetsGeometry.only(15),
  child: Disableable(

    // 도로명 주소가 선택되었을 때만 버튼을 활성화.
    isEnabled: selectedModel != null,
    child: WideButton(
      label: "선택하기",
      onTap: done,
      isLoading: isLoading,
    ),
  ),
),
```

❌ 금지된 예시:

```dart
ListView(
  children: [
    // 사용자의 이메일 표시.
    Text(model.email),
    // 사용자의 닉네임 표시.
    Text(model.nickname),
  ]
);
```

```dart
// 하단 선택하기 버튼 영역.
Padding(
  padding: EdgeInsetsGeometry.only(15),
  child: Disableable(
    // 도로명 주소가 선택되었을 때만 버튼을 활성화.
    isEnabled: selectedModel != null,
    child: WideButton(
      label: "선택하기",
      onTap: done,
      isLoading: isLoading,
    ),
  ),
),
```

또는 다음과 같이 파라미터 또는 인자에 주석을 작성하는 경우.

✅ 올바른 예시:

```dart
ListView.builder(
  controller: scrollController,
  padding: EdgeInsets.all(15),

  // 주석 1
  itemCount: models.length,

  // 주석 1
  itemBuilder: (context, index) {
    return MyScrollItem(model: models[index]);
  },
),
```

❌ 금지된 예시:

```dart
ListView.builder(
  controller: scrollController,
  padding: EdgeInsets.all(15),
  // 주석 1
  itemCount: models.length
  // 주석 1
  itemBuilder: (context, index) {
    return MyScrollItem(model: models[index]);
  },
),
```

## Widget Class
위젯에 대한 주석을 작성할 경우, `해당 위젯은`라는 문장으로 시작합니다.

```dart
/// 해당 위젯은 ...(생략)
class MyWidget extends StatefulWidget {...}
```

## Function

```dart
/// 사용자 메세지를 주어진 문자열로 수정하고 이를 갱신합니다.
void setMessage(String newValue) {...}
```

## Getter

```dart
/// 현재 사용자가 입력한 검색어를 제출할 수 있는지에 대한 여부.
bool get canSubmit;
```

## Setter

```dart
/// 사용자의 현재 상태를 주어진 상태로 업데이트합니다.
set status(UserStatus newValue) {...}
```

## Alignment

✅ 올바른 예시:

```dart
/// A
final String a;

/// B
final String b;

/// C
final String c;
```

❌ 잘못된 예시:

```dart
/// A
final String a;
/// B
final String b;
/// C
final String c;
```

## Variable
상수와 변수는 "입니다"와 같은 단어를 생략합니다.

```dart
class A {
    const A({required this.value});

    /// 사용자가 직접 정의한 관례적 테마 유형.
    final String value;
}
```

## 작성 여부
다음과 같은 경우에는 주석 작성을 하지 마십시오:

- `title`, `isEnabled`, `onChanged` 등 이름만으로 의미가 명확한 코드 요소의 경우.
- 제3자가 코드를 읽었을 때 주석 없이도 기능과 의도를 충분히 이해하고 파악할 수 있는 경우.

❗ 주석은 꼭 필요한 경우에만 작성하고, 중복되거나 설명이 불필요한 부분은 생략합니다.

```dart
// 사용자가 OS의 테마 설정을 앱에 동기화할지 결정하는 스위치.
ColumnItem.switcher(
    title: "OS 테마 사용",
    isEnabled: SettingsBinding.theme.getValue() == Theme.device,
    onChanged: (useOSTheme) {
        // OS 테마 사용 여부에 따라 앱 테마를 설정.
        useOSTheme
            ? SettingsBinding.theme.setValue(Theme.device)
            : SettingsBinding.theme.setValue(Scheme.themeOf(Scheme.device));

        // 앱 전체를 다시 빌드하여 테마 변경을 즉시 적용.
        RebuildableApp.rebuild();
    },
),
```
