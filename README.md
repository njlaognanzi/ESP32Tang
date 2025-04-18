# ESP32Tang System-on-Module (SOM) – Industrial IO Controller

A compact, modular industrial controller featuring an ESP32-S3 MCU and a Gowin GW1NR-LV9 FPGA for flexible IO, communication, and data acquisition tasks.

---

## 📦 System Overview

This system is built around the **ESP32Tang SOM**, consisting of:

- **ESP32-S3-WROOM-1** (MCU)
- **GOWIN GW1NR-LV9** (FPGA)

The two devices communicate via **1x SPI bus**, with dedicated interfaces for ADC (I²C), CAN (SPI), and Ethernet (SPI).

---

## 🧠 Functional Description

### ESP32-S3-WROOM-1 (MCU)
- Main controller responsible for:
  - System logic
  - Communication protocol handling
  - Output command generation
- **Connectivity:**
  - Wi-Fi and Bluetooth
  - 1x SPI to external Ethernet PHY (e.g. W5500)
- **Fault Handling:**
  - Captures 8x DO fault signals via GPIO using DMA or interrupt
- **SPI Master Role:**
  - Communicates with FPGA to:
    - Read DI, ADC, CAN bus status
    - Send commands for DO, PWM, and analog outputs

---

### GW1NR-LV9 (FPGA)
- Acts as co-processor with real-time IO control logic
- SPI slave interface to ESP32-S3
- Handles:
  - **8x Digital Inputs (DI)**
  - **8x Digital Outputs (DO)**
  - **4x PWM Outputs**
- Manages external **ADS1115** (or ADS1015) via I²C for analog input
- Communicates with **MCP2515 + CAN transceiver (e.g. MCP2551)** over SPI for CAN 2.0 protocol support

---

## 🔌 IO and Communication Interfaces

| Function         | Interface | Handled by      |
|------------------|-----------|-----------------|
| 8x DO Fault      | GPIO      | ESP32-S3        |
| Ethernet (W5500) | SPI       | ESP32-S3        |
| System SPI       | SPI       | ESP32 ⇄ FPGA     |
| 8x Digital Inputs| GPIO      | FPGA            |
| 8x Digital Outputs| GPIO     | FPGA            |
| 4x PWM Outputs   | PWM/GPIO  | FPGA            |
| 4x Analog Inputs | I²C (ADC) | FPGA + ADS1115  |
| CAN Bus          | SPI       | FPGA + MCP2515  |

---

## 📐 System Block Diagram

![Image](https://github.com/user-attachments/assets/b7afcbff-79dd-48b6-a5ca-5a4e1bf28a29)

---

## ⚙️ Applications

- Industrial data acquisition
- Process control
- CAN-based sensor interfacing
- Industrial IoT gateway

---
## 📎 License

[MIT License](LICENSE)

