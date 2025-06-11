# Traffic Light Controller - Verilog Implementation

### Author: Amaan Sami

---

## 🚦 Overview

This project implements a **Finite State Machine (FSM)-based Traffic Light Controller** in Verilog that controls two perpendicular traffic flows:

- **Road A (East-West)** — High-priority road  
- **Road B (North-South)**

The controller manages timing, vehicle detection sensors, and safe transitions between signals.

---

## 🎯 Features

- ✅ Dual-road control (East-West and North-South)
- ✅ Priority for East-West lane (high traffic assumption)
- ✅ 13-State FSM design
- ✅ Vehicle detection sensors `Sa` and `Sb`
- ✅ Fully synchronous design with enable and reset
- ✅ Comprehensive testbench
- ✅ Waveform generation (`traffic.vcd`)

---

## 🧮 FSM State Diagram

> The state machine operates with 13 states, giving priority to Road A.

![State Diagram](state_diagram.jpg)

---

## 🕹 Inputs

| Signal | Description |
|--------|-------------|
| `clk`  | System Clock |
| `reset` | Active-low asynchronous reset |
| `enable` | FSM enable |
| `Sa` | East-West vehicle sensor |
| `Sb` | North-South vehicle sensor |

## 🚦 Outputs

| Signal | Description |
|--------|-------------|
| `R_a, Y_a, G_a` | Road A lights |
| `R_b, Y_b, G_b` | Road B lights |

---

## 🧪 Testbench

> The testbench verifies controller functionality with multiple traffic patterns.

![Testbench Simulation](test_bench_pic.png)

---

## 💻 Simulation Instructions

> This simulation uses a scaled clock (10ns period) for faster verification.

1️⃣ Compile using any Verilog simulator (Icarus, ModelSim, Vivado etc.)

```bash
iverilog -o traffic_sim Traffic_Light_Controller.v Traffic_Light_Controller_tb.v
vvp traffic_sim
gtkwave traffic.vcd
