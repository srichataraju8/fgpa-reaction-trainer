# FPGA Reaction-Time Trainer

A millisecond-accurate physical reflex trainer designed and implemented on a **Digilent Basys 3 (Xilinx Artix-7 FPGA)** development board. The entire system architecture is built using structural and behavioral **Verilog HDL** at the Register-Transfer Level (RTL). The hardware design features a robust finite state machine (FSM), multi-stage asynchronous input debouncing, and a time-multiplexed 4-digit 7-segment display subsystem.

---

## ⚙️ Architecture & Engineering Design

### 1. Finite State Machine (FSM) Controller
The core application flow is governed by a synchronous Verilog FSM (`game_fsm.v`) operating across four distinct execution states:
* `STATE_IDLE` (00): Awaits user initialization via the hardware start button while zeroing all transient memory registers.
* `STATE_DELAY` (01): Introduces a variable delay interval using an external seed variable to completely eliminate predictability or user anticipation.
* `STATE_TRIGGER` (10): Illuminates the visual LED stimulus array and enables the high-frequency BCD counter module instantly.
* `STATE_RESULTS` (11): Latches the final count values upon receipt of a filtered response button trigger, freezing the player's millisecond score on the scoreboard until a hardware master reset is asserted.

### 2. Multi-Stage Asynchronous Input Debouncer
Mechanical pushbuttons produce severe switch bounce noise that leads to false triggers. To counter this, all asynchronous physical button lines are passed through an internal shift-register filter (`debouncer.v`). The input level must remain logically stable for a hardcoded 10ms counter threshold before updating the internal synchronized output state, ensuring each click registers exactly once.

### 3. Time-Multiplexed 7-Segment Readout
The Basys 3 hardware configuration maps the segment anodes across all four display locations simultaneously. To present discrete numeric readouts on each display digit, the multiplexer module (`seven_seg_mux.v`) implements dynamic refresh logic running at ~800Hz. By cycling through separate cathode lines faster than human persistence of vision, it renders a seamless, flicker-free real-time time score display.

---

## 📂 Repository Directory Tree

```text
├── src/
│   ├── reaction_trainer_top.v   # Top-level structural wrapper module
│   ├── game_fsm.v               # Core controller finite state machine 
│   ├── debouncer.v              # Hardware button filtering block
│   ├── counter_ms.v             # Millisecond binary-coded-decimal (BCD) counter
│   └── seven_seg_mux.v          # Dynamic display cathode multiplexer
├── sim/
│   └── reaction_trainer_tb.v    # Self-checking structural simulation testbench
└── constraints/
    └── Basys3_Master.xdc        # Xilinx Design Constraints pin-mapping configuration
```

---

## 🛠️ System Hardware Specifications

* **Target Device:** Digilent Basys 3 (Artix-7 XC7A35T-1CPG236C FPGA)
* **Oscillator Core:** 100 MHz Master System Clock (`clk`)
* **Physical Interface Controls:**
  * Tactile Pushbuttons (Master Reset, Game Start, Reflex Stop)
  * Onboard LED Array (Visual indicator prompt)
  * Common Anode 4-Digit 7-Segment Display Module

---

## 💻 Synthesis & Verification Toolchain

This project was built, verified, and implemented utilizing the **Xilinx Vivado Design Suite**.

1. Clone the project tree structure into your working environment:
   ```bash
   git clone https://github.com
   ```
2. Launch Xilinx Vivado and create a blank project targeting the **Artix-7 XC7A35T-1CPG236C** part.
3. Import all physical source hardware modules located inside the `/src` folder into the design hierarchy.
4. Import the Xilinx Design Constraints pin configuration from the `/constraints` directory.
5. Launch **Behavioral Simulation** via the included testbench layout (`/sim`) to verify FSM transit times and flag timing anomalies.
6. Execute **Synthesis** and run **Implementation**.
7. Generate the final device `.bit` bitstream file.
8. Connect the Basys 3 hardware board over micro-USB, launch the Vivado **Hardware Manager**, and program the FPGA target device.

