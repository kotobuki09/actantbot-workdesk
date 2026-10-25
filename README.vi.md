<p align="center">
  <a href="https://actantos.com/platform/workdesk">
    <img src="docs/images/actantbot-brand.png" alt="ActantBot" width="136">
  </a>
</p>

# ActantBot WorkDesk

<p align="center">
  Tài liệu self-hosting và triển khai cho portal ActantOS WorkDesk.
</p>

<p align="center">
  <a href="https://actantos.com">ActantOS</a> ·
  <a href="https://actantos.com/platform/workdesk">WorkDesk</a> ·
  <a href="https://eralab.si">ERA Lab</a> ·
  <a href="docs/hosting.md">Hosting</a> ·
  <a href="docs/operations.md">Operations</a>
</p>

WorkDesk là portal self-hosted cho nhóm ActantBot. Portal có bốn bot chuyên biệt cho hướng dẫn IT, tiếp nhận sự cố bảo mật, yêu cầu quyền truy cập, và tri thức vận hành. ActantOS kernel kiểm tra các thao tác ghi theo policy, ký quyết định, và lưu receipt có thể audit.

Repo này là bộ tài liệu bàn giao cho operator. Repo chỉ chứa hướng dẫn deploy, mẫu cấu hình, kiến trúc, vận hành, xử lý lỗi, và ảnh giao diện hiện tại. Repo không chứa source code WorkDesk, dữ liệu khách hàng, tài khoản lab, hoặc secret production.

## Bắt đầu

- [Hosting guide](docs/hosting.md) mô tả thứ tự triển khai.
- [Architecture](docs/architecture.md) mô tả ranh giới dịch vụ.
- [Operations guide](docs/operations.md) mô tả health check, backup, nâng cấp, và degraded mode.
- [Troubleshooting](docs/troubleshooting.md) ghép triệu chứng với cách kiểm tra.
- [ActantOS WorkDesk](https://actantos.com/platform/workdesk) giới thiệu sản phẩm và giao diện portal hiện tại.

## Liên kết hệ sinh thái

- [ActantOS](https://actantos.com) là website sản phẩm.
- [WorkDesk](https://actantos.com/platform/workdesk) giới thiệu portal hỗ trợ IT cho nhân viên.
- [ERA Lab](https://eralab.si) cung cấp bối cảnh rộng hơn về lab và các dự án.

## Gia đình ActantBot

<table align="center">
  <tr>
    <td align="center"><img src="docs/images/bots/actantbot-it.png" alt="ActantBot IT" width="108"><br><strong>IT</strong><br><sub>Runbook</sub></td>
    <td align="center"><img src="docs/images/bots/actantbot-secure.png" alt="ActantBot Secure" width="108"><br><strong>Secure</strong><br><sub>Tiếp nhận sự cố</sub></td>
    <td align="center"><img src="docs/images/bots/actantbot-access.png" alt="ActantBot Access" width="108"><br><strong>Access</strong><br><sub>Yêu cầu truy cập</sub></td>
    <td align="center"><img src="docs/images/bots/actantbot-know.png" alt="ActantBot Know" width="108"><br><strong>Know</strong><br><sub>Tri thức vận hành</sub></td>
  </tr>
</table>

## Luồng chính

Người dùng đăng nhập qua OIDC. Portal gửi yêu cầu tới WorkDesk server. Server lưu trạng thái và gọi ActantOS kernel. Kernel đánh giá Cedar policy trước khi cho phép thao tác. Connector hoặc executor trả kết quả. Hệ thống đối soát kết quả và ghi receipt.

## Lưu ý an toàn

Không mở PostgreSQL hoặc kernel ra internet. Không dùng credential trong file mẫu cho môi trường thật. Không bật development login trong production. Không đưa password, OTP, raw provider token, dữ liệu khách hàng, hoặc secret vào issue public.

Hướng dẫn tiếng Anh trong `README.md` và `docs/` là bản operator chính.

## Giấy phép

Repo này được phát hành theo [MIT License](LICENSE). Copyright (c) 2026 kotobuki09.
