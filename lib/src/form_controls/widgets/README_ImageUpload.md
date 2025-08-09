# Image Upload Field Implementation

## Overview

The `ImageUploadField` widget provides a complete image upload solution with camera and gallery selection capabilities, image preview, and management features.

## Features

- ✅ **Camera Capture**: Take photos directly from device camera
- ✅ **Gallery Selection**: Choose images from device gallery
- ✅ **Image Preview**: Display selected images with animations
- ✅ **Image Management**: Replace or remove selected images
- ✅ **Animated UI**: Smooth transitions and visual feedback
- ✅ **Customizable**: Configurable size, labels, and callbacks

## Usage

### Basic Implementation

```dart
ImageUploadField(
  label: 'Profile Picture',
  hint: 'Upload your profile picture from camera or gallery',
  onImageSelected: (File? file) {
    // Handle the selected image file
    print('Image selected: ${file?.path}');
  },
)
```

### Advanced Configuration

```dart
ImageUploadField(
  label: 'Document Upload',
  hint: 'Upload a document or certificate',
  width: 300,
  height: 200,
  onImageSelected: (File? file) {
    if (file != null) {
      // Process the uploaded file
      uploadToServer(file);
    }
  },
  onImageRemoved: () {
    // Handle image removal
    clearImageData();
  },
)
```

## Implementation Details

### Current State (Production Ready)

The implementation now uses the real `image_picker` package for actual camera and gallery access. The widget provides:

- Real camera capture functionality
- Gallery image selection
- Actual image display and file information
- Production-ready error handling

### Dependencies

The `image_picker` package is included in `pubspec.yaml`:

```yaml
dependencies:
  image_picker: ^1.0.7
```

### Image Selection Implementation

```dart
Future<void> _pickImage({required bool isCamera}) async {
  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      _setImage(File(pickedFile.path));
    }
  } catch (e) {
    // Handle errors with user feedback
  }
}
```

## Required Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to camera to take photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to photo library to select images</string>
```

## Widget API

### Properties

- `label` (String?): Optional label text above the upload area
- `hint` (String?): Optional hint text below the upload area
- `onImageSelected` (Function(File?)?): Callback when image is selected
- `onImageRemoved` (Function()?): Callback when image is removed
- `width` (double?): Custom width for the upload area
- `height` (double?): Custom height for the upload area

### Methods

- `_showImageSourceDialog()`: Shows camera/gallery selection dialog
- `_pickImage({required bool isCamera})`: Handles image selection
- `_setImage(File? image)`: Updates the selected image
- `_removeImage()`: Shows confirmation and removes image

## UI Components

### Upload Area (No Image Selected)

- Large tap area with upload icon
- Clear call-to-action text
- Quick action buttons for camera/gallery
- Responsive design with hover effects

### Image Preview (Image Selected)

- Animated entrance with scale and fade
- Image placeholder with success indicator
- Action buttons (replace/remove) with tooltips
- File information overlay
- Confirmation dialogs for destructive actions

## Animations

- **Scale Animation**: Smooth entrance when image is selected
- **Fade Animation**: Opacity transition for better UX
- **Elastic Animation**: Bouncy effect for engaging interactions

## Best Practices

1. **Error Handling**: Proper try-catch blocks for image operations
2. **User Feedback**: SnackBar messages for user actions
3. **Confirmation Dialogs**: Prevent accidental image removal
4. **Responsive Design**: Adapts to different screen sizes
5. **Accessibility**: Tooltips and semantic labels

## Example Integration

See `ImageUploadDemo` widget for a complete example showing:

- Multiple image upload fields
- Status tracking
- User feedback integration
- Real-world usage patterns
