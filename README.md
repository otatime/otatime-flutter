# Otatime Flutter

## 필수 설정

### 환경 변수 설정
프로젝트 최상위 폴더에 있는 `standard.env` 파일을 `.env`로 복사하거나 이름을 변경한 뒤, 값이 비어있는 누락된 키 값을 추가하세요.

### 키 스토어 추가
디버그 및 릴리스 빌드에서 해시 기반 기능이 올바르게 동작하려면,  
프로젝트 최상위 폴더 기준 `/android` 경로에 `keystore.jks` 파일과 `key.properties` 파일을 추가해야 합니다.

> [!NOTE]
> 릴리스 및 디버그 빌드에서 예외 없이 모두 폴더 내에 추가된 `keystore.jks`를 사용하여 애플리케이션을 빌드 합니다.

#### 예시 코드
`key.properties` 파일에 대한 유효한 형식은 다음과 같습니다.

```properties
storePassword=000000
keyPassword=000000
keyAlias=example
```