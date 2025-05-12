
# 🌦️ Weather App

## 🚀 Giới thiệu

Weather App là một ứng dụng di động đa nền tảng được xây dựng bằng **Flutter** và **Dart**, giúp người dùng tra cứu thông tin thời tiết hiện tại và dự báo cho các ngày tiếp theo. Ứng dụng tích hợp **OpenWeatherMap API** để cung cấp dữ liệu thời tiết chi tiết, bao gồm nhiệt độ, độ ẩm, tốc độ gió và trạng thái khí hậu.

## ✨ Tính năng chính

* 🌡️ **Thời tiết hiện tại**: hiển thị nhiệt độ, độ ẩm, tốc độ gió và trạng thái thời tiết của thành phố bất kỳ.
* 📅 **Dự báo 5 ngày**: lọc bản ghi tại thời điểm 12:00 mỗi ngày.
* 🔍 **Tìm kiếm nhanh** theo tên thành phố.
* 🎨 **Giao diện thân thiện** với các widget như `Card`, `ListView` ngang/dọc và hiệu ứng gradient.
* 🔄 **Chuyển đổi** giữa trang chủ và trang chi tiết dự báo.
* ⚠️ **Xử lý lỗi** khi kết nối API hoặc dữ liệu không hợp lệ.

## 🖥️ Yêu cầu hệ thống

* Flutter ≥ 3.0
* Dart ≥ 3.7
* Android SDK / iOS SDK
* Kết nối Internet để truy cập API

## 📦 Cài đặt

1. Clone repository:

   ```bash
   git clone https://github.com/username/weather_app.git
   cd weather_app
````

2. Cài đặt dependencies:

   ```bash
   flutter pub get
   ```

3. Thiết lập API key:

   * Mở file `lib/services/weather_service.dart`
   * Thay thế biến `apiKey` bằng API key từ OpenWeatherMap của bạn.

4. Chạy ứng dụng:

   ```bash
   flutter run
   ```

## 🗂️ Cấu trúc thư mục

```
weather_app/
├── assets/                  📂 Hình ảnh icon thời tiết, wind speed, humidity...
├── lib/
│   ├── main.dart            📝 Điểm khởi đầu, khởi tạo MaterialApp
│   ├── models/
│   │   └── constants.dart   🎨 Định nghĩa màu sắc và hằng số chung
│   ├── screens/
│   │   ├── home.dart        🏠 Trang chủ hiển thị thời tiết hiện tại và dự báo
│   │   └── detail_page.dart 📊 Trang chi tiết dự báo theo khung giờ
│   ├── services/
│   │   └── weather_service.dart 🌐 Xử lý gọi OpenWeatherMap API
│   └── widgets/
│       └── weather_item.dart ☁️ Widget phụ trợ hiển thị thông số thời tiết
└── pubspec.yaml             🔧 Cấu hình Flutter, khai báo assets và dependencies
```

## ⚙️ Kiến trúc & Công nghệ

* **Flutter & Dart**: Phát triển giao diện người dùng với widget, cơ chế hot reload, quản lý trạng thái đơn giản (`setState`).
* **OpenWeatherMap API**: Lấy dữ liệu thời tiết hiện tại và dự báo.
* **HTTP package**: Gửi yêu cầu HTTP GET và giải mã JSON.
* **Intl package**: Định dạng ngày tháng.

## 🛠️ Hướng dẫn phát triển

1. **Thêm hoặc tuỳ chỉnh widget**

   * Sử dụng `weatherItem` để tái sử dụng giao diện thông số.
2. **Quản lý trạng thái nâng cao**

   * Có thể mở rộng sang **Provider**, **Bloc** hoặc **Riverpod**.
3. **Mở rộng tính năng**

   * Cảnh báo thời tiết nguy hiểm, dự báo chi tiết theo giờ, thay đổi giao diện theo sở thích.

## 📚 Tài liệu tham khảo

* [Flutter Documentation](https://flutter.dev/docs)
* [OpenWeatherMap API](https://openweathermap.org/api)

---

*👤 Sinh viên thực hiện: Phạm Đình Nghĩa (1671020222)*
*👨‍🏫 Giáo viên hướng dẫn: Phạm Văn Tiệp*

```
```
