# Copilot Instructions for Interesting Flutter

## Architecture Overview

แอป Flutter นี้แสดงวิดเจ็ตเชิงโต้ตอบมากกว่า 45 รายการใน 10 หมวดหมู่ พร้อมด้วย Clean Architecture และการจัดการสถานะด้วย Riverpod โครงสร้างหลัก:

- **Domain Layer**: `lib/domain/repositories/` - อินเทอร์เฟซแบบนามธรรม (สัญญาทางธุรกิจ)
- **Data Layer**: `lib/data/datasources/` (การใช้งาน GraphQL) + `lib/data/repositories/` (การมอบหมายแบบง่าย)
- **Presentation**: `lib/presentation/` - UI, providers และการแสดงวิดเจ็ต
- **Core**: `lib/core/` - บริการที่ใช้ร่วมกัน, ยูทิลิตี้ และการกำหนดค่า

## Key Development Patterns

### Navigation System

- ใช้เมธอดช่วยเหลือ `AppNavigator` แทนการเรียก Navigator โดยตรง:
  ```dart
  AppNavigator.goToWidgetDetail(context, category);
  AppNavigator.goHomeGlobal(); // จากบริการ/ลอจิกทางธุรกิจ
  ```
- Named routes ในคลาส `AppRoutes` พร้อมค่าคงที่ที่ปลอดภัยต่อประเภท
- การเปลี่ยนหน้าแบบกำหนดเองผ่าน `CustomPageRoute` พร้อมแอนิเมชันที่ปรับแต่งได้

### State Management (Riverpod)

- **Providers**: `lib/presentation/providers/` - สถานะเฉพาะฟีเจอร์
- **Global State**: `lib/core/providers/app_provider.dart` - ธีม, การโหลด, การนำทาง
- **รูปแบบ**: StateNotifier สำหรับสถานะที่ซับซ้อน, Provider สำหรับค่าง่ายๆ
  ```dart
  final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) => MyNotifier());
  ```

### Authentication (Mock Implementation)

- Service abstraction: `lib/core/services/authentication/auth_service.dart`
- **คอมเมนต์ TODO** ทั่วโครงการระบุจุดการรวมเข้ากับ Firebase
- Mock service สำหรับการพัฒนา พร้อมสำหรับการรวมเข้ากับ Firebase/Supabase ในการผลิต

### Widget Showcase Structure

แต่ละหมวดหมู่ใช้รูปแบบนี้:

```
lib/presentation/widgets/[category]/
├── [category]_showcase.dart     # การแสดงหลักพร้อม AnimationConfiguration
├── example_widget_1.dart        # ตัวอย่างวิดเจ็ตแต่ละรายการ
└── example_widget_2.dart
```

## Development Workflows

### Running the App

ใช้ VS Code task หรือ PowerShell:

```powershell
flutter run -d edge  # เว็บ (ฟีเจอร์กล้องจำกัด)
flutter run -d android  # แนะนำสำหรับการทดสอบฟีเจอร์เต็มรูปแบบ
```

### Platform-Specific Features

- **กล้อง/การอัปโหลดรูปภาพ**: ทดสอบบนอุปกรณ์ Android/iOS (ไม่ใช่ emulators)
- **แผนที่**: การรวมเข้ากับ OpenStreetMap ผ่าน `flutter_map`
- **GraphQL**: ตัวอย่าง SpaceX API ใน `lib/data/datasources/spacex_graphql_datasource.dart`

### Adding New Widget Examples

1. สร้างวิดเจ็ตในที่เหมาะสม `lib/presentation/widgets/[category]/`
2. เพิ่มเข้าไปในการแสดงหมวดหมู่โดยใช้ `AnimatedShowcaseCard`
3. ใช้ `flutter_staggered_animations` สำหรับแอนิเมชันรายการที่สอดคล้องกัน:
   ```dart
   AnimationConfiguration.toStaggeredList(
     duration: const Duration(milliseconds: 375),
     childAnimationBuilder: (widget) => SlideAnimation(
       horizontalOffset: 50.0,
       child: FadeInAnimation(child: widget),
     ),
   ```

### Error Handling

- ใช้ยูทิลิตี้ `SafeExecution` ใน `lib/core/exceptions/`
- ข้อยกเว้นแบบกำหนดเองใน `lib/core/exceptions/app_exceptions.dart`
- การแสดงข้อผิดพลาดแบบโกลบอลผ่าน NavigationService snackbars

## Project Conventions

### File Organization

- **Absolute imports**: ใช้ prefix `package:interesting_flutter/` เสมอ
- **ทิศทางการขึ้นต่อกัน**: Domain ← Data ← Presentation
- **การจัดกลุ่ม**: วิดเจ็ตที่เกี่ยวข้องในไดเรกทอรีเดียวกันพร้อมไฟล์แสดงที่ใช้ร่วมกัน

### Styling Standards

- **Material Design 3**: ธีมที่สอดคล้องกันผ่าน `ColorScheme.fromSeed(seedColor: 0xFF6750A4)`
- **Card elevation**: มาตรฐาน 8dp พร้อมมุมโค้งมน (รัศมี 16px)
- **แอนิเมชัน**: ระยะเวลา 300ms สำหรับการเปลี่ยน, 375ms สำหรับรายการแบบ staggered
- **รูปแบบไล่สี**: การเปลี่ยนสีจากหลักไปรอง

### Testing Structure

- การตั้งค่าการทดสอบขั้นต่ำ (placeholder ใน `test/widget_test.dart`)
- มุ่งเน้นการทดสอบแบบแมนนวลสำหรับการโต้ตอบ UI
- Mock services ให้สำหรับการยืนยันตัวตนและเลเยอร์ข้อมูล

## Firebase Integration

- ได้รับการกำหนดค่าแล้วแต่การใช้งานขั้นต่ำ (เพียงการเริ่มต้น)
- พร้อมสำหรับการยืนยันตัวตน, Firestore และบริการ Firebase อื่นๆ
- ไฟล์การกำหนดค่าพร้อมสำหรับทุกแพลตฟอร์ม

## Critical Dependencies

```yaml
flutter_riverpod: ^2.6.1 # การจัดการสถานะ
graphql_flutter: ^5.2.0 # การรวมเข้ากับ SpaceX API
flutter_staggered_animations: ^1.1.1 # แอนิเมชันที่สอดคล้องกัน
image_picker: ^1.0.7 # การเข้าถึงกล้อง/แกลเลอรี่
flutter_map: ^6.1.0 # แผนที่เชิงโต้ตอบ
```

## Build & Development Notes

- **แพลตฟอร์มหลัก**: Android (รองรับฟีเจอร์เต็มรูปแบบ)
- **ข้อจำกัดเว็บ**: กล้องจำกัดเฉพาะ file picker
- **เป้าหมายประสิทธิภาพ**: 60fps สำหรับแอนิเมชันทั้งหมด
- **การวิเคราะห์โค้ด**: ใช้แพ็กเกจ `flutter_lints` พร้อมกฎมาตรฐาน
