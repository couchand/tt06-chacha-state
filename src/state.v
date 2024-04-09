`define default_netname none

module chacha_state (
  input wire clk,
  input wire rst_n,
  //input wire wr_full,
  //input wire [31:0] s_in[15:0],
  //output reg [31:0] s_out[15:0],
  input wire wr_addr,
  input wire [5:0] addr_in,
  input wire [7:0] data_in,
  output wire [7:0] data_out
);
  reg [31:0] s_out[15:0];

  wire [31:0] current_word = s_out[addr_in[5:2]];
  assign data_out = addr_in[1]
    ? (addr_in[0] ? current_word[31:24] : current_word[23:16])
    : (addr_in[0] ? current_word[15:8] : current_word[7:0]);

  always @(posedge clk) begin
    if (!rst_n) begin
      for (int i = 0; i < 16; i++) begin
        s_out[i] <= 32'b0;
      end
    //end else if (wr_full) begin
    //  for (int i = 0; i < 16; i++) begin
    //    s_out[i] <= s_in[i];
    //  end
    end else if (wr_addr) begin
      if (addr_in[1]) begin
        if (addr_in[0]) begin
          s_out[addr_in[5:2]][31:24] <= data_in;
        end else begin
          s_out[addr_in[5:2]][23:16] <= data_in;
        end
      end else begin
        if (addr_in[0]) begin
          s_out[addr_in[5:2]][15:8] <= data_in;
        end else begin
          s_out[addr_in[5:2]][7:0] <= data_in;
        end
      end
    end
  end

endmodule
