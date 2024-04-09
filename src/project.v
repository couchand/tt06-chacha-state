/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_couchand_chacha_state (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  assign uio_out = 0;
  assign uio_oe  = 0;

  wire wr_full = uio_in[7];
  wire wr_addr = uio_in[6];
  wire [5:0] addr_in = uio_in[5:0];

  reg [31:0] s_in[15:0];
  wire [31:0] s_out[15:0];

  chacha_state my_instance (
    .clk(clk),
    .rst_n(rst_n),
    .wr_full(wr_full),
    .s_in(s_in),
    .s_out(s_out),
    .wr_addr(wr_addr),
    .addr_in(addr_in),
    .data_in(ui_in),
    .data_out(uo_out)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      for (int i = 0; i < 16; i++) begin
        s_in[i] <= 32'b0;
      end
    end
  end

endmodule
