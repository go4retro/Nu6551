`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:57:39 10/26/2020 
// Design Name: 
// Module Name:    Nu6551 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Nu6551(
              input _reset_bus,
              input clock_bus,
              input r_w_bus,
              input _cs0_bus,
              input cs1_bus,
              input [1:0]address_bus,
              inout [7:0]data_bus,
              output _int_bus,
              input clock_uc,
              input r_w_uc,
              input _ce_uc,
              input [1:0]address_uc,
              inout [7:0]data_uc,
              output _int_uc_data,
              output _int_uc_status,
              output _int_uc_cmd,
              output _int_uc_ctrl
             );

wire [7:0]                       data_txd;
wire [7:0]                       data_rxd;
wire [7:0]                       data_status;
wire [7:0]                       data_cmd;
wire [7:0]                       data_ctrl;

wire ce_bus;
wire ce_data_bus;
wire ce_status_bus;
wire ce_cmd_bus;
wire ce_ctrl_bus;

wire ce_data_uc;
wire ce_status_uc;

reg [7:0]data_bus_out;
reg [7:0]data_uc_out;
reg int_data_out;
reg int_status_out;
reg int_cmd_out;
reg int_ctrl_out;

reg reset_data_out;

assign _int_uc_data =            !int_data_out;
assign _int_uc_status =          !int_status_out;
assign _int_uc_cmd =             !int_cmd_out;
assign _int_uc_ctrl =            !int_ctrl_out;

assign ce_bus =                  !_cs0_bus & cs1_bus;
assign ce_data_bus =             (ce_bus & (address_bus == 0));
assign ce_status_bus =           (ce_bus & (address_bus == 1));
assign ce_cmd_bus =              (ce_bus & (address_bus == 2));
assign ce_ctrl_bus =             (ce_bus & (address_bus == 3));
assign data_bus =                data_bus_out;

assign ce_data_uc =              (!_ce_uc & (address_uc == 0));
assign ce_status_uc =            (!_ce_uc & (address_uc == 1));
assign data_uc =                 data_uc_out;

assign reset_data =              !_reset_bus | (reset_data_out & !clock_bus); // clear RXD on read or reset
assign reset_regs =              !_reset_bus | int_status_out; // clear on reset or programmed reset
assign _int_bus =                'bz;

register 								txd_reg(clock_bus, !reset_data, ce_data_bus & !r_w_bus, data_bus, data_txd);
register #(.WIDTH(5),.RESET('b00010))	cmd_reg43210(clock_bus, !reset_regs, ce_cmd_bus & !r_w_bus, data_bus[4:0], data_cmd[4:0]);
register #(.WIDTH(3),.RESET('b000))	cmd_reg765(clock_bus, _reset_bus, ce_cmd_bus & !r_w_bus, data_bus[7:5], data_cmd[7:5]);
register #(.RESET('b00010000))	ctrl_reg(clock_bus, _reset_bus, ce_ctrl_bus & !r_w_bus, data_bus, data_ctrl);

register 								rxd_reg(clock_uc, !reset_regs, ce_data_uc & !r_w_uc, data_uc, data_rxd);
register #(.RESET('b00000000))	status_reg(clock_uc, !reset_regs, ce_status_uc & !r_w_uc, data_uc, data_status);

always @(*)
begin
   if(r_w_bus & ce_bus & clock_bus)
   begin
   case (address_bus)
     0: data_bus_out = data_rxd;
     1: data_bus_out = data_status;
     2: data_bus_out = data_cmd;
     3: data_bus_out = data_ctrl;
   endcase
   end
   else
      data_bus_out = 8'bz;
end

always @(*)
begin
   if(r_w_uc & !_ce_uc & clock_uc)
   begin
   case (address_uc)
     0: data_uc_out = data_txd;
     2: data_uc_out = data_cmd;
     3: data_uc_out = data_ctrl;
     default: data_uc_out = 8'bz;
   endcase
   end
   else
      data_uc_out = 8'bz;
end

always @(negedge clock_bus)
begin
   reset_data_out <=    (ce_data_bus & !r_w_bus);
   int_data_out <=      (ce_data_bus & !r_w_bus);
   int_status_out <=    (ce_status_bus & !r_w_bus);
   int_cmd_out <=       (ce_cmd_bus & !r_w_bus);
   int_ctrl_out <=      (ce_ctrl_bus & !r_w_bus);
end

endmodule
