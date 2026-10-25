# ActantBot WorkDesk

Tài liệu public để tự host và vận hành ActantOS WorkDesk.

WorkDesk là portal self-hosted cho nhóm ActantBot. Portal có bốn bot chuyên biệt cho hướng dẫn IT, tiếp nhận sự cố bảo mật, yêu cầu quyền truy cập, và tri thức vận hành. ActantOS kernel kiểm tra các thao tác ghi theo policy, ký quyết định, và lưu receipt có thể audit.

Repo này là bộ tài liệu bàn giao cho operator. Repo chỉ chứa hướng dẫn deploy, mẫu cấu hình, kiến trúc, vận hành, xử lý lỗi, và ảnh giao diện hiện tại. Repo không chứa source code WorkDesk, dữ liệu khách hàng, tài khoản lab, hoặc secret production.

## Bắt đầu

- [Hosting guide](docs/hosting.md) mô tả thứ tự triển khai.
- [Architecture](docs/architecture.md) mô tả ranh giới dịch vụ.
- [Operations guide](docs/operations.md) mô tả health check, backup, nâng cấp, và degraded mode.
- [Troubleshooting](docs/troubleshooting.md) ghép triệu chứng với cách kiểm tra.
- [ActantOS WorkDesk](https://actantos.com/platform/workdesk) giới thiệu sản phẩm và giao diện portal hiện tại.

## Luồng chính

Người dùng đăng nhập qua OIDC. Portal gửi yêu cầu tới WorkDesk server. Server lưu trạng thái và gọi ActantOS kernel. Kernel đánh giá Cedar policy trước khi cho phép thao tác. Connector hoặc executor trả kết quả. Hệ thống đối soát kết quả và ghi receipt.

## Lưu ý an toàn

Không mở PostgreSQL hoặc kernel ra internet. Không dùng credential trong file mẫu cho môi trường thật. Không bật development login trong production. Không đưa password, OTP, raw provider token, dữ liệu khách hàng, hoặc secret vào issue public.

Hướng dẫn tiếng Anh trong `README.md` và `docs/` là bản operator chính.
