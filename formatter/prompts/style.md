# 코드 스타일 규칙
절대 기존 Dart 공식 포매터를 따라하지 마십시오.
아래 규칙을 절대적으로 지키고 포맷팅하세요.

## 트레일링 콤마(,) 규칙
위젯 트리의 마지막 파라미터 뒤에는 반드시 `,`를 추가해야 한다.  
`,`가 없으면 출력은 잘못된 것으로 간주된다.

✅ 올바른 예시:

```dart
child: ListView.builder(
  itemCount: models.length,
  itemBuilder: (context, index) {
    return MyScrollItem(model: models[index]);
  }, // , 추가
),
```

❌ 잘못된 예시:
콤마를 누락한 경우.

```dart
child: ListView.builder(
  itemCount: models.length,
  itemBuilder: (context, index) {
    return MyScrollItem(model: models[index]);
  }
),
```

### 트레일링 콤마를 빼고 정렬을 바꾸지 않는다.
`,`가 누락되었다고 해서, 다음과 같이 닫는 괄호와 함께 정렬을 바꾸는 방식은 금지한다.

❌ 금지된 예시:

```dart
child: ListView.builder(
  itemCount: models.length,
  itemBuilder: (context, index) {
    return MyScrollItem(model: models[index]);
  }),
```

## 코드 정렬 규칙
setState 같은 함수 호출 구문은 한 줄 또는 블록 형태로만 작성한다.
줄바꿈이 어색하거나 들여쓰기가 불균형한 코드는 금지된다.

✅ 올바른 예시:

```dart
setState(() => current = DateTime(current.year, current.month - 1));
```

```dart
void setMessage(String newValue) => setState(() {
    ...
});
```

또는

```dart
setState(() {
    current = DateTime(current.year, current.month - 1);
});
```

❌ 잘못된 예시:
줄바꿈 위치 잘못된 경우.

```dart
setState(
    () => current = DateTime(current.year, current.month - 1));
```

```dart
void setMessage(String newValue)
    => setState(() {
    ...
});
```