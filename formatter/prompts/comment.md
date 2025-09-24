# 주석 작성 지침

1. 주석은 한국어로 작성할 것.

2. 코드 내부 동작이나 너무 뻔한 내용은 작성하지 말 것.
   - 예: `int i = 0; // i를 0으로 초기화`는 불필요.

3. 주석은 제 3자가 코드 내용을 처음 접해도 이해할 수 있도록 작성할 것.
   - 무엇을 하는 코드인지, 어떤 목적을 가지고 있는지 중심으로 설명.

4. 주석은 **기능 중심**으로 작성하고, 구현 방식보다는 의미/목적을 설명할 것.

5. UI 관련 코드의 경우, 화면에 표시되는 내용이나 사용자에게 보여지는 의미까지 포함할 것.

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
