# Programmatic Simulink: Automotive Cruise Control PI-Controller

![MATLAB](https://img.shields.io/badge/MATLAB-R2017a-blue.svg)
![Simulink](https://img.shields.io/badge/Simulink-Automated-orange.svg)
![Control Systems](https://img.shields.io/badge/Control_Systems-PID-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

An automated Model-Based Systems Engineering (MBSE) project that uses MATLAB scripts to programmatically generate, wire, configure, and simulate a closed-loop automotive cruise control system in Simulink—without any manual drag-and-drop operations.

## 📌 Project Overview & Engineering Highlights

This project simulates a vehicle attempting to reach and maintain a target speed of 20 m/s (72 km/h) under normal conditions, and subsequently facing a sudden uphill disturbance.

- 🚗 **Vehicle Plant Dynamics**: Modeled using a First-Order Transfer Function $G(s) = \frac{1}{ms + b}$, representing a 1000 kg vehicle mass ($m$) with a 50 N.s/m aerodynamic drag coefficient ($b$).
- 🎛️ **Closed-Loop PI Control**: Implements a Proportional-Integral controller manually tuned ($P=800$, $I=40$) to prioritize rapid disturbance rejection and zero-overshoot acceleration, outperforming standard conservative auto-tuning algorithms.
- ⛰️ **Disturbance Modeling**: Injects a sudden 2000 N opposing force at $t = 30s$ to simulate steep uphill driving, demonstrating the controller's integral windup and recovery capabilities.
- ⚙️ **100% Script-Driven Automation**: The entire Simulink `.slx` model, block generation, parameter injection, auto-routing, and scope visualization are handled purely via MATLAB code.

## 📈 System Response Analysis

Based on the simulation results:
1. **Acceleration Phase (0 - 30s)**: The vehicle smoothly accelerates and locks onto the 20 m/s target at $t = 15s$ with zero overshoot.
2. **Disturbance Phase (30 - 60s)**: Upon hitting the 2000 N hill load at $t = 30s$, the speed drops slightly but the Integral ($I$) controller aggressively compensates, driving the system back toward the setpoint.

## 🛠️ Tech Stack & Requirements

- **Environment**: MATLAB & Simulink
- **Compatibility**: R2017a and newer (uses `'on'` for autorouting compatibility).

## 🚀 Quick Start

To run the automated model generation and simulation:

1. Open MATLAB.
2. Navigate to the directory containing the script.
3. Run the following command in the Command Window:
   ```matlab
   cruise_control
