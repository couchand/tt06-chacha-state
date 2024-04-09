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

  for b in range(0, 4):
    dut._log.info(f'Testing byte {b} of the words');

    dut._log.info("Write some bytes");
    for i in range(0, 16):
      dut.ui_in.value = i;
      dut.uio_in.value = 64 | (i * 4 + b);
      await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 10)

    dut.uio_in.value = 128;
    await ClockCycles(dut.clk, 64)

    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 10)

    dut._log.info("Assert some bytes");
    for i in range(0, 16):
      dut.uio_in.value = i * 4 + b;
      await ClockCycles(dut.clk, 1)
      assert dut.uo_out.value == i

    dut._log.info("Next word...");
    await ClockCycles(dut.clk, 10)
