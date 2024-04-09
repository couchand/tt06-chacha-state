# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
  dut._log.info("Start")

  clock = Clock(dut.clk, 10, units="us")
  cocotb.start_soon(clock.start())

  # Reset
  dut._log.info("Reset")
  dut.ena.value = 1
  dut.ui_in.value = 0
  dut.uio_in.value = 0
  dut.rst_n.value = 0
  await ClockCycles(dut.clk, 10)
  dut.rst_n.value = 1
  await ClockCycles(dut.clk, 10)


  dut._log.info("Write some bytes");
  dut.ui_in.value = 255;
  dut.uio_in.value = 64;
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 42;
  dut.uio_in.value = 68;
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 1;
  dut.uio_in.value = 69;
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 2;
  dut.uio_in.value = 70;
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0
  dut.uio_in.value = 0

  await ClockCycles(dut.clk, 10)

  dut._log.info("Assert some bytes");
  dut.uio_in.value = 0
  await ClockCycles(dut.clk, 1)
  assert dut.uo_out.value == 255
  dut.uio_in.value = 4
  await ClockCycles(dut.clk, 1)
  assert dut.uo_out.value == 42
  dut.uio_in.value = 5
  await ClockCycles(dut.clk, 1)
  assert dut.uo_out.value == 1
  dut.uio_in.value = 6
  await ClockCycles(dut.clk, 1)
  assert dut.uo_out.value == 2
