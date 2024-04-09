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

  wire wr_qr = uio_in[7];

  wire wr_addr = uio_in[6];
  wire [5:0] addr_in = uio_in[5:0];

  wire [31:0] a;
  wire [31:0] b;
  wire [31:0] c;
  wire [31:0] d;

  reg [2:0] sel_reg;

  chacha_state my_instance (
    .clk(clk),
    .rst_n(rst_n),

    .wr_qr(wr_qr),
    .round_sel(sel_reg[2]),
    .qr_sel(sel_reg[1:0]),
    .a_in(a),
    .b_in(b),
    .c_in(c),
    .d_in(d),
    .a_out(a),
    .b_out(b),
    .c_out(c),
    .d_out(d),

    .wr_addr(wr_addr),
    .addr_in(addr_in),
    .data_in(ui_in),
    .data_out(uo_out)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      sel_reg <= 0;
    end else if (wr_qr) begin
      sel_reg <= sel_reg + 1;
    end
  end

endmodule
