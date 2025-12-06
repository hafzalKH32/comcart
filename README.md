# 🛒 Ecom Cart – Flutter E-Commerce App

A modern and responsive e-commerce demo application built using **Flutter**, featuring product listing, product editing, cart management, smooth UI animations, and a clean minimal design.

---

## ✨ Features

### 🛍 Product & UI
- Beautiful animated product grid with hero transitions
- Product detail page with full specification
- Responsive layout (mobile / tablet)
- Modern gradients, shadows, Lottie success animation

### 🧾 Cart System
- Global cart service with add / remove / clear functions
- Real-time quantity sync across **List, Detail & Cart pages**
- Cart total calculation and summary
- Success confirmation screen with animation
- Auto clear cart upon successful order

### 🧠 Architecture & Data
| Component | Description |
|-----------|------------|
| Flutter | UI framework |
| BLoC | State management for product states |
| CartService | Global cart logic |
| Dio | REST API client |
| Sliver Widgets | CustomScrollView + SliverGrid |
| Lottie | Animated success screen |

---

## 📂 Folder Structure

```plaintext
lib/
 ├── core/
 │   └── cart_service.dart
 ├── features/
 │   └── products/
 │       ├── data/
 │       │   ├── models/
 │       │   └── product_repository.dart
 │       ├── logic/
 │       │   ├── product_list/
 │       │   └── product_detail/
 │       └── presentation/
 │           ├── product_list/
 │           │   └── product_list_page.dart
 │           ├── product_detail/
 │           ├── product_edit/
 │           └── cart/
 ├── main.dart
