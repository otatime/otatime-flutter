import org.jetbrains.kotlin.konan.properties.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProps = Properties().apply {
    val keystorePropsFile = rootProject.file("key.properties")
    if (keystorePropsFile.exists()) {
        load(FileInputStream(keystorePropsFile))
    } else {
        throw Exception("/android 폴더에 'key.properties'와 'keystore.jks' 파일을 추가하세요.")
    }
}

android {
    namespace = "com.devttangkong.otatime_flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.devttangkong.otatime_flutter"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProps.getProperty("keyAlias")
            keyPassword = keystoreProps.getProperty("keyPassword")
            storeFile = file("../keystore.jks")
            storePassword = keystoreProps.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(file("proguard-rules.pro"))

            // `flutter run --release`으로 빌드 할 때는 릴리스 키로 서명됩니다.
            signingConfig = signingConfigs.getByName("release")
        }

        debug {
            // `flutter run --debug`으로 빌드 할 때는 릴리스 키로 서명됩니다.
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
