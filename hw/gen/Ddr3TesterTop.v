// Generator : SpinalHDL v1.15.0    git head : 05a01af3d3345aa0afcaad8e0186dde13a359db2
// Component : Ddr3TesterTop
// Git hash  : 99c3d5b596332371ea9ac284121f91f82495cc18
// Date      : 27/11/2026, 15:09:59

`timescale 1ns/1ps

module Ddr3TesterTop (
  input  wire          sys_clk,
  input  wire          sys_resetn,
  output reg  [7:0]    led,
  output wire [7:0]    led2,
  output wire          uart_txp,
  inout  wire [15:0]   DDR3_DQ,
  inout  wire [1:0]    DDR3_DQS,
  output wire [1:0]    DDR3_DM,
  output wire [13:0]   DDR3_A,
  output wire [2:0]    DDR3_BA,
  output wire          DDR3_nRAS,
  output wire          DDR3_nCAS,
  output wire          DDR3_nWE,
  output wire          DDR3_nCS,
  output wire          DDR3_CK,
  output wire          DDR3_CKE,
  output wire          DDR3_nRESET,
  output wire          DDR3_ODT
);

  wire                pll_clkout;
  wire                pll_clkoutp;
  wire                pll_clkoutd;
  wire                pll_lock;
  wire                coreArea_ddr3_io_axi_ar_ready;
  wire                coreArea_ddr3_io_axi_aw_ready;
  wire                coreArea_ddr3_io_axi_w_ready;
  wire                coreArea_ddr3_io_axi_r_valid;
  wire       [63:0]   coreArea_ddr3_io_axi_r_payload_data;
  wire       [3:0]    coreArea_ddr3_io_axi_r_payload_id;
  wire       [1:0]    coreArea_ddr3_io_axi_r_payload_resp;
  wire                coreArea_ddr3_io_axi_r_payload_last;
  wire                coreArea_ddr3_io_axi_b_valid;
  wire       [3:0]    coreArea_ddr3_io_axi_b_payload_id;
  wire       [1:0]    coreArea_ddr3_io_axi_b_payload_resp;
  wire                coreArea_ddr3_io_init_done;
  wire                coreArea_ddr3_io_write_level_done;
  wire                coreArea_ddr3_io_read_calib_done;
  wire       [7:0]    coreArea_ddr3_io_wstep;
  wire       [1:0]    coreArea_ddr3_io_rclkpos;
  wire       [2:0]    coreArea_ddr3_io_rclksel;
  wire       [2:0]    coreArea_ddr3_io_best_rot;
  wire       [3:0]    coreArea_ddr3_io_best_score;
  wire       [3:0]    coreArea_ddr3_io_dbg_state;
  wire       [1:0]    coreArea_ddr3_io_pad_DDR3_DM;
  wire       [13:0]   coreArea_ddr3_io_pad_DDR3_A;
  wire       [2:0]    coreArea_ddr3_io_pad_DDR3_BA;
  wire                coreArea_ddr3_io_pad_DDR3_nRAS;
  wire                coreArea_ddr3_io_pad_DDR3_nCAS;
  wire                coreArea_ddr3_io_pad_DDR3_nWE;
  wire                coreArea_ddr3_io_pad_DDR3_nCS;
  wire                coreArea_ddr3_io_pad_DDR3_CK;
  wire                coreArea_ddr3_io_pad_DDR3_CKE;
  wire                coreArea_ddr3_io_pad_DDR3_nRESET;
  wire                coreArea_ddr3_io_pad_DDR3_ODT;
  wire                coreArea_engine_io_axi_ar_valid;
  wire       [31:0]   coreArea_engine_io_axi_ar_payload_addr;
  wire       [3:0]    coreArea_engine_io_axi_ar_payload_id;
  wire       [3:0]    coreArea_engine_io_axi_ar_payload_region;
  wire       [7:0]    coreArea_engine_io_axi_ar_payload_len;
  wire       [2:0]    coreArea_engine_io_axi_ar_payload_size;
  wire       [1:0]    coreArea_engine_io_axi_ar_payload_burst;
  wire       [0:0]    coreArea_engine_io_axi_ar_payload_lock;
  wire       [3:0]    coreArea_engine_io_axi_ar_payload_cache;
  wire       [3:0]    coreArea_engine_io_axi_ar_payload_qos;
  wire       [2:0]    coreArea_engine_io_axi_ar_payload_prot;
  wire                coreArea_engine_io_axi_aw_valid;
  wire       [31:0]   coreArea_engine_io_axi_aw_payload_addr;
  wire       [3:0]    coreArea_engine_io_axi_aw_payload_id;
  wire       [3:0]    coreArea_engine_io_axi_aw_payload_region;
  wire       [7:0]    coreArea_engine_io_axi_aw_payload_len;
  wire       [2:0]    coreArea_engine_io_axi_aw_payload_size;
  wire       [1:0]    coreArea_engine_io_axi_aw_payload_burst;
  wire       [0:0]    coreArea_engine_io_axi_aw_payload_lock;
  wire       [3:0]    coreArea_engine_io_axi_aw_payload_cache;
  wire       [3:0]    coreArea_engine_io_axi_aw_payload_qos;
  wire       [2:0]    coreArea_engine_io_axi_aw_payload_prot;
  wire                coreArea_engine_io_axi_w_valid;
  wire       [63:0]   coreArea_engine_io_axi_w_payload_data;
  wire       [7:0]    coreArea_engine_io_axi_w_payload_strb;
  wire                coreArea_engine_io_axi_w_payload_last;
  wire                coreArea_engine_io_axi_r_ready;
  wire                coreArea_engine_io_axi_b_ready;
  wire                coreArea_engine_io_uart_tx;
  wire                coreArea_engine_io_test_busy;
  wire                coreArea_engine_io_test_pass;
  wire                coreArea_engine_io_test_error;
  wire                coreArea_engine_io_heartbeat;
  reg        [15:0]   _zz_when_Ddr3TesterTop_l67;
  wire                when_Ddr3TesterTop_l67;
  wire                when_Ddr3TesterTop_l69;
  wire                porDone;
  wire                globalResetn;
  wire                _zz_1;

  Gowin_rPLL pll (
    .clkin   (sys_clk    ), //i
    .clkout  (pll_clkout ), //o
    .clkoutp (pll_clkoutp), //o
    .clkoutd (pll_clkoutd), //o
    .lock    (pll_lock   )  //o
  );
  Ddr3Axi4 coreArea_ddr3 (
    .io_pclk                  (pll_clkoutd                                  ), //i
    .io_fclk                  (pll_clkout                                   ), //i
    .io_ck                    (pll_clkoutp                                  ), //i
    .io_resetn                (globalResetn                                 ), //i
    .io_axi_aw_valid          (coreArea_engine_io_axi_aw_valid              ), //i
    .io_axi_aw_ready          (coreArea_ddr3_io_axi_aw_ready                ), //o
    .io_axi_aw_payload_addr   (coreArea_engine_io_axi_aw_payload_addr[31:0] ), //i
    .io_axi_aw_payload_id     (coreArea_engine_io_axi_aw_payload_id[3:0]    ), //i
    .io_axi_aw_payload_region (coreArea_engine_io_axi_aw_payload_region[3:0]), //i
    .io_axi_aw_payload_len    (coreArea_engine_io_axi_aw_payload_len[7:0]   ), //i
    .io_axi_aw_payload_size   (coreArea_engine_io_axi_aw_payload_size[2:0]  ), //i
    .io_axi_aw_payload_burst  (coreArea_engine_io_axi_aw_payload_burst[1:0] ), //i
    .io_axi_aw_payload_lock   (coreArea_engine_io_axi_aw_payload_lock       ), //i
    .io_axi_aw_payload_cache  (coreArea_engine_io_axi_aw_payload_cache[3:0] ), //i
    .io_axi_aw_payload_qos    (coreArea_engine_io_axi_aw_payload_qos[3:0]   ), //i
    .io_axi_aw_payload_prot   (coreArea_engine_io_axi_aw_payload_prot[2:0]  ), //i
    .io_axi_w_valid           (coreArea_engine_io_axi_w_valid               ), //i
    .io_axi_w_ready           (coreArea_ddr3_io_axi_w_ready                 ), //o
    .io_axi_w_payload_data    (coreArea_engine_io_axi_w_payload_data[63:0]  ), //i
    .io_axi_w_payload_strb    (coreArea_engine_io_axi_w_payload_strb[7:0]   ), //i
    .io_axi_w_payload_last    (coreArea_engine_io_axi_w_payload_last        ), //i
    .io_axi_b_valid           (coreArea_ddr3_io_axi_b_valid                 ), //o
    .io_axi_b_ready           (coreArea_engine_io_axi_b_ready               ), //i
    .io_axi_b_payload_id      (coreArea_ddr3_io_axi_b_payload_id[3:0]       ), //o
    .io_axi_b_payload_resp    (coreArea_ddr3_io_axi_b_payload_resp[1:0]     ), //o
    .io_axi_ar_valid          (coreArea_engine_io_axi_ar_valid              ), //i
    .io_axi_ar_ready          (coreArea_ddr3_io_axi_ar_ready                ), //o
    .io_axi_ar_payload_addr   (coreArea_engine_io_axi_ar_payload_addr[31:0] ), //i
    .io_axi_ar_payload_id     (coreArea_engine_io_axi_ar_payload_id[3:0]    ), //i
    .io_axi_ar_payload_region (coreArea_engine_io_axi_ar_payload_region[3:0]), //i
    .io_axi_ar_payload_len    (coreArea_engine_io_axi_ar_payload_len[7:0]   ), //i
    .io_axi_ar_payload_size   (coreArea_engine_io_axi_ar_payload_size[2:0]  ), //i
    .io_axi_ar_payload_burst  (coreArea_engine_io_axi_ar_payload_burst[1:0] ), //i
    .io_axi_ar_payload_lock   (coreArea_engine_io_axi_ar_payload_lock       ), //i
    .io_axi_ar_payload_cache  (coreArea_engine_io_axi_ar_payload_cache[3:0] ), //i
    .io_axi_ar_payload_qos    (coreArea_engine_io_axi_ar_payload_qos[3:0]   ), //i
    .io_axi_ar_payload_prot   (coreArea_engine_io_axi_ar_payload_prot[2:0]  ), //i
    .io_axi_r_valid           (coreArea_ddr3_io_axi_r_valid                 ), //o
    .io_axi_r_ready           (coreArea_engine_io_axi_r_ready               ), //i
    .io_axi_r_payload_data    (coreArea_ddr3_io_axi_r_payload_data[63:0]    ), //o
    .io_axi_r_payload_id      (coreArea_ddr3_io_axi_r_payload_id[3:0]       ), //o
    .io_axi_r_payload_resp    (coreArea_ddr3_io_axi_r_payload_resp[1:0]     ), //o
    .io_axi_r_payload_last    (coreArea_ddr3_io_axi_r_payload_last          ), //o
    .io_init_done             (coreArea_ddr3_io_init_done                   ), //o
    .io_write_level_done      (coreArea_ddr3_io_write_level_done            ), //o
    .io_read_calib_done       (coreArea_ddr3_io_read_calib_done             ), //o
    .io_wstep                 (coreArea_ddr3_io_wstep[7:0]                  ), //o
    .io_rclkpos               (coreArea_ddr3_io_rclkpos[1:0]                ), //o
    .io_rclksel               (coreArea_ddr3_io_rclksel[2:0]                ), //o
    .io_best_rot              (coreArea_ddr3_io_best_rot[2:0]               ), //o
    .io_best_score            (coreArea_ddr3_io_best_score[3:0]             ), //o
    .io_dbg_state             (coreArea_ddr3_io_dbg_state[3:0]              ), //o
    .io_pad_DDR3_DQ           (DDR3_DQ                                      ), //~
    .io_pad_DDR3_DQS          (DDR3_DQS                                     ), //~
    .io_pad_DDR3_DM           (coreArea_ddr3_io_pad_DDR3_DM[1:0]            ), //o
    .io_pad_DDR3_A            (coreArea_ddr3_io_pad_DDR3_A[13:0]            ), //o
    .io_pad_DDR3_BA           (coreArea_ddr3_io_pad_DDR3_BA[2:0]            ), //o
    .io_pad_DDR3_nRAS         (coreArea_ddr3_io_pad_DDR3_nRAS               ), //o
    .io_pad_DDR3_nCAS         (coreArea_ddr3_io_pad_DDR3_nCAS               ), //o
    .io_pad_DDR3_nWE          (coreArea_ddr3_io_pad_DDR3_nWE                ), //o
    .io_pad_DDR3_nCS          (coreArea_ddr3_io_pad_DDR3_nCS                ), //o
    .io_pad_DDR3_CK           (coreArea_ddr3_io_pad_DDR3_CK                 ), //o
    .io_pad_DDR3_CKE          (coreArea_ddr3_io_pad_DDR3_CKE                ), //o
    .io_pad_DDR3_nRESET       (coreArea_ddr3_io_pad_DDR3_nRESET             ), //o
    .io_pad_DDR3_ODT          (coreArea_ddr3_io_pad_DDR3_ODT                )  //o
  );
  Ddr3MemtestEngine coreArea_engine (
    .io_axi_aw_valid          (coreArea_engine_io_axi_aw_valid              ), //o
    .io_axi_aw_ready          (coreArea_ddr3_io_axi_aw_ready                ), //i
    .io_axi_aw_payload_addr   (coreArea_engine_io_axi_aw_payload_addr[31:0] ), //o
    .io_axi_aw_payload_id     (coreArea_engine_io_axi_aw_payload_id[3:0]    ), //o
    .io_axi_aw_payload_region (coreArea_engine_io_axi_aw_payload_region[3:0]), //o
    .io_axi_aw_payload_len    (coreArea_engine_io_axi_aw_payload_len[7:0]   ), //o
    .io_axi_aw_payload_size   (coreArea_engine_io_axi_aw_payload_size[2:0]  ), //o
    .io_axi_aw_payload_burst  (coreArea_engine_io_axi_aw_payload_burst[1:0] ), //o
    .io_axi_aw_payload_lock   (coreArea_engine_io_axi_aw_payload_lock       ), //o
    .io_axi_aw_payload_cache  (coreArea_engine_io_axi_aw_payload_cache[3:0] ), //o
    .io_axi_aw_payload_qos    (coreArea_engine_io_axi_aw_payload_qos[3:0]   ), //o
    .io_axi_aw_payload_prot   (coreArea_engine_io_axi_aw_payload_prot[2:0]  ), //o
    .io_axi_w_valid           (coreArea_engine_io_axi_w_valid               ), //o
    .io_axi_w_ready           (coreArea_ddr3_io_axi_w_ready                 ), //i
    .io_axi_w_payload_data    (coreArea_engine_io_axi_w_payload_data[63:0]  ), //o
    .io_axi_w_payload_strb    (coreArea_engine_io_axi_w_payload_strb[7:0]   ), //o
    .io_axi_w_payload_last    (coreArea_engine_io_axi_w_payload_last        ), //o
    .io_axi_b_valid           (coreArea_ddr3_io_axi_b_valid                 ), //i
    .io_axi_b_ready           (coreArea_engine_io_axi_b_ready               ), //o
    .io_axi_b_payload_id      (coreArea_ddr3_io_axi_b_payload_id[3:0]       ), //i
    .io_axi_b_payload_resp    (coreArea_ddr3_io_axi_b_payload_resp[1:0]     ), //i
    .io_axi_ar_valid          (coreArea_engine_io_axi_ar_valid              ), //o
    .io_axi_ar_ready          (coreArea_ddr3_io_axi_ar_ready                ), //i
    .io_axi_ar_payload_addr   (coreArea_engine_io_axi_ar_payload_addr[31:0] ), //o
    .io_axi_ar_payload_id     (coreArea_engine_io_axi_ar_payload_id[3:0]    ), //o
    .io_axi_ar_payload_region (coreArea_engine_io_axi_ar_payload_region[3:0]), //o
    .io_axi_ar_payload_len    (coreArea_engine_io_axi_ar_payload_len[7:0]   ), //o
    .io_axi_ar_payload_size   (coreArea_engine_io_axi_ar_payload_size[2:0]  ), //o
    .io_axi_ar_payload_burst  (coreArea_engine_io_axi_ar_payload_burst[1:0] ), //o
    .io_axi_ar_payload_lock   (coreArea_engine_io_axi_ar_payload_lock       ), //o
    .io_axi_ar_payload_cache  (coreArea_engine_io_axi_ar_payload_cache[3:0] ), //o
    .io_axi_ar_payload_qos    (coreArea_engine_io_axi_ar_payload_qos[3:0]   ), //o
    .io_axi_ar_payload_prot   (coreArea_engine_io_axi_ar_payload_prot[2:0]  ), //o
    .io_axi_r_valid           (coreArea_ddr3_io_axi_r_valid                 ), //i
    .io_axi_r_ready           (coreArea_engine_io_axi_r_ready               ), //o
    .io_axi_r_payload_data    (coreArea_ddr3_io_axi_r_payload_data[63:0]    ), //i
    .io_axi_r_payload_id      (coreArea_ddr3_io_axi_r_payload_id[3:0]       ), //i
    .io_axi_r_payload_resp    (coreArea_ddr3_io_axi_r_payload_resp[1:0]     ), //i
    .io_axi_r_payload_last    (coreArea_ddr3_io_axi_r_payload_last          ), //i
    .io_pll_lock              (pll_lock                                     ), //i
    .io_init_done             (coreArea_ddr3_io_init_done                   ), //i
    .io_write_level_done      (coreArea_ddr3_io_write_level_done            ), //i
    .io_read_calib_done       (coreArea_ddr3_io_read_calib_done             ), //i
    .io_wstep                 (coreArea_ddr3_io_wstep[7:0]                  ), //i
    .io_rclkpos               (coreArea_ddr3_io_rclkpos[1:0]                ), //i
    .io_rclksel               (coreArea_ddr3_io_rclksel[2:0]                ), //i
    .io_best_rot              (coreArea_ddr3_io_best_rot[2:0]               ), //i
    .io_best_score            (coreArea_ddr3_io_best_score[3:0]             ), //i
    .io_dbg_state             (coreArea_ddr3_io_dbg_state[3:0]              ), //i
    .io_uart_tx               (coreArea_engine_io_uart_tx                   ), //o
    .io_test_busy             (coreArea_engine_io_test_busy                 ), //o
    .io_test_pass             (coreArea_engine_io_test_pass                 ), //o
    .io_test_error            (coreArea_engine_io_test_error                ), //o
    .io_heartbeat             (coreArea_engine_io_heartbeat                 ), //o
    .clkoutd                  (pll_clkoutd                                  ), //i
    ._zz_1                    (_zz_1                                        )  //i
  );
  initial begin
    _zz_when_Ddr3TesterTop_l67 = 16'h0;
  end

  assign when_Ddr3TesterTop_l67 = (pll_lock && (_zz_when_Ddr3TesterTop_l67 != 16'hffff));
  assign when_Ddr3TesterTop_l69 = (! pll_lock);
  assign porDone = (_zz_when_Ddr3TesterTop_l67 == 16'hffff);
  assign globalResetn = (sys_resetn && porDone);
  assign _zz_1 = (! globalResetn);
  assign DDR3_DM = coreArea_ddr3_io_pad_DDR3_DM;
  assign DDR3_A = coreArea_ddr3_io_pad_DDR3_A;
  assign DDR3_BA = coreArea_ddr3_io_pad_DDR3_BA;
  assign DDR3_nRAS = coreArea_ddr3_io_pad_DDR3_nRAS;
  assign DDR3_nCAS = coreArea_ddr3_io_pad_DDR3_nCAS;
  assign DDR3_nWE = coreArea_ddr3_io_pad_DDR3_nWE;
  assign DDR3_nCS = coreArea_ddr3_io_pad_DDR3_nCS;
  assign DDR3_CK = coreArea_ddr3_io_pad_DDR3_CK;
  assign DDR3_CKE = coreArea_ddr3_io_pad_DDR3_CKE;
  assign DDR3_nRESET = coreArea_ddr3_io_pad_DDR3_nRESET;
  assign DDR3_ODT = coreArea_ddr3_io_pad_DDR3_ODT;
  assign uart_txp = coreArea_engine_io_uart_tx;
  always @(*) begin
    led[0] = (! pll_lock);
    led[1] = (! coreArea_ddr3_io_init_done);
    led[2] = (! coreArea_ddr3_io_write_level_done);
    led[3] = (! coreArea_ddr3_io_read_calib_done);
    led[4] = (! coreArea_engine_io_heartbeat);
    led[5] = (! coreArea_engine_io_test_busy);
    led[6] = (! coreArea_engine_io_test_error);
    led[7] = (! coreArea_engine_io_test_pass);
  end

  assign led2 = (~ coreArea_ddr3_io_wstep);
  always @(posedge pll_clkoutd) begin
    if(when_Ddr3TesterTop_l67) begin
      _zz_when_Ddr3TesterTop_l67 <= (_zz_when_Ddr3TesterTop_l67 + 16'h0001);
    end else begin
      if(when_Ddr3TesterTop_l69) begin
        _zz_when_Ddr3TesterTop_l67 <= 16'h0;
      end
    end
  end


endmodule

module Ddr3MemtestEngine (
  output reg           io_axi_aw_valid,
  input  wire          io_axi_aw_ready,
  output reg  [31:0]   io_axi_aw_payload_addr,
  output wire [3:0]    io_axi_aw_payload_id,
  output wire [3:0]    io_axi_aw_payload_region,
  output reg  [7:0]    io_axi_aw_payload_len,
  output wire [2:0]    io_axi_aw_payload_size,
  output wire [1:0]    io_axi_aw_payload_burst,
  output wire [0:0]    io_axi_aw_payload_lock,
  output wire [3:0]    io_axi_aw_payload_cache,
  output wire [3:0]    io_axi_aw_payload_qos,
  output wire [2:0]    io_axi_aw_payload_prot,
  output reg           io_axi_w_valid,
  input  wire          io_axi_w_ready,
  output reg  [63:0]   io_axi_w_payload_data,
  output reg  [7:0]    io_axi_w_payload_strb,
  output reg           io_axi_w_payload_last,
  input  wire          io_axi_b_valid,
  output wire          io_axi_b_ready,
  input  wire [3:0]    io_axi_b_payload_id,
  input  wire [1:0]    io_axi_b_payload_resp,
  output reg           io_axi_ar_valid,
  input  wire          io_axi_ar_ready,
  output reg  [31:0]   io_axi_ar_payload_addr,
  output wire [3:0]    io_axi_ar_payload_id,
  output wire [3:0]    io_axi_ar_payload_region,
  output reg  [7:0]    io_axi_ar_payload_len,
  output wire [2:0]    io_axi_ar_payload_size,
  output wire [1:0]    io_axi_ar_payload_burst,
  output wire [0:0]    io_axi_ar_payload_lock,
  output wire [3:0]    io_axi_ar_payload_cache,
  output wire [3:0]    io_axi_ar_payload_qos,
  output wire [2:0]    io_axi_ar_payload_prot,
  input  wire          io_axi_r_valid,
  output reg           io_axi_r_ready,
  input  wire [63:0]   io_axi_r_payload_data,
  input  wire [3:0]    io_axi_r_payload_id,
  input  wire [1:0]    io_axi_r_payload_resp,
  input  wire          io_axi_r_payload_last,
  input  wire          io_pll_lock,
  input  wire          io_init_done,
  input  wire          io_write_level_done,
  input  wire          io_read_calib_done,
  input  wire [7:0]    io_wstep,
  input  wire [1:0]    io_rclkpos,
  input  wire [2:0]    io_rclksel,
  input  wire [2:0]    io_best_rot,
  input  wire [3:0]    io_best_score,
  input  wire [3:0]    io_dbg_state,
  output wire          io_uart_tx,
  output wire          io_test_busy,
  output wire          io_test_pass,
  output wire          io_test_error,
  output wire          io_heartbeat,
  input  wire          clkoutd,
  input  wire          _zz_1
);
  localparam fsm_BOOT = 5'd0;
  localparam fsm_sBootBanner = 5'd1;
  localparam fsm_sWaitCalib = 5'd2;
  localparam fsm_sPrintCalib = 5'd3;
  localparam fsm_sPrintBanner = 5'd4;
  localparam fsm_sSingleWriteAW = 5'd5;
  localparam fsm_sSingleWriteW0 = 5'd6;
  localparam fsm_sSingleWriteW1 = 5'd7;
  localparam fsm_sSingleWriteB = 5'd8;
  localparam fsm_sSingleReadAR = 5'd9;
  localparam fsm_sSingleReadR0 = 5'd10;
  localparam fsm_sSingleReadR1 = 5'd11;
  localparam fsm_sBulkWriteAW = 5'd12;
  localparam fsm_sBulkWriteW = 5'd13;
  localparam fsm_sBulkWriteB = 5'd14;
  localparam fsm_sBulkReadAR = 5'd15;
  localparam fsm_sBulkReadR = 5'd16;
  localparam fsm_sReportPass = 5'd17;
  localparam fsm_sReportFail = 5'd18;
  localparam fsm_sLoopDelay = 5'd19;

  wire                uart_io_write_ready;
  wire                uart_io_txd;
  wire                uart_io_busy;
  reg        [7:0]    _zz_printChar;
  wire       [3:0]    _zz_printChar_1;
  wire       [14:0]   _zz_currentByteAddr;
  wire       [31:0]   _zz_beatBlockAddr;
  wire       [10:0]   _zz_beatBlockAddr_1;
  wire       [6:0]    _zz_beatBlockAddr_2;
  reg        [7:0]    _zz_nextPrintChar_2;
  wire       [3:0]    _zz_nextPrintChar_3;
  reg        [7:0]    _zz_nextPrintChar_4;
  wire       [3:0]    _zz_nextPrintChar_5;
  reg        [7:0]    _zz_nextPrintChar_6;
  wire       [3:0]    _zz_nextPrintChar_7;
  reg        [7:0]    _zz_nextPrintChar_8;
  wire       [3:0]    _zz_nextPrintChar_9;
  reg        [7:0]    _zz_nextPrintChar_10;
  wire       [3:0]    _zz_nextPrintChar_11;
  reg        [7:0]    _zz_nextPrintChar_12;
  wire       [3:0]    _zz_nextPrintChar_13;
  wire       [3:0]    _zz_nextPrintChar_14;
  reg        [7:0]    _zz_nextPrintChar_15;
  wire       [3:0]    _zz_nextPrintChar_16;
  wire       [3:0]    _zz_nextPrintChar_17;
  reg        [7:0]    _zz_nextPrintChar_18;
  wire       [3:0]    _zz_nextPrintChar_19;
  wire       [3:0]    _zz_nextPrintChar_20;
  wire       [2:0]    _zz_nextPrintChar_21;
  reg        [7:0]    _zz_nextPrintChar_22;
  wire       [3:0]    _zz_nextPrintChar_23;
  wire       [31:0]   _zz_io_axi_w_payload_data;
  wire       [31:0]   _zz_io_axi_w_payload_data_1;
  wire       [10:0]   _zz_when_Ddr3MemtestEngine_l470;
  wire       [31:0]   _zz__zz_errExpected;
  wire       [31:0]   _zz__zz_errExpected_1;
  wire       [10:0]   _zz_when_Ddr3MemtestEngine_l516;
  reg        [7:0]    _zz_nextPrintChar_24;
  reg        [3:0]    _zz_nextPrintNib;
  reg                 _zz_nextUseNib;
  reg        [7:0]    _zz_nextPrintChar_25;
  reg        [3:0]    _zz_nextPrintNib_1;
  reg                 _zz_nextUseNib_1;
  wire                txStream_valid;
  wire                txStream_ready;
  wire       [7:0]    txStream_payload;
  wire       [7:0]    hexAsciiRom_0;
  wire       [7:0]    hexAsciiRom_1;
  wire       [7:0]    hexAsciiRom_2;
  wire       [7:0]    hexAsciiRom_3;
  wire       [7:0]    hexAsciiRom_4;
  wire       [7:0]    hexAsciiRom_5;
  wire       [7:0]    hexAsciiRom_6;
  wire       [7:0]    hexAsciiRom_7;
  wire       [7:0]    hexAsciiRom_8;
  wire       [7:0]    hexAsciiRom_9;
  wire       [7:0]    hexAsciiRom_10;
  wire       [7:0]    hexAsciiRom_11;
  wire       [7:0]    hexAsciiRom_12;
  wire       [7:0]    hexAsciiRom_13;
  wire       [7:0]    hexAsciiRom_14;
  wire       [7:0]    hexAsciiRom_15;
  reg                 nextPrintValid;
  reg        [7:0]    nextPrintChar;
  reg                 nextUseNib;
  reg        [3:0]    nextPrintNib;
  reg                 stageValid;
  reg        [7:0]    stageChar;
  reg                 stageUseNib;
  reg        [3:0]    stageNib;
  reg                 printValid;
  reg        [7:0]    printChar;
  wire                txStream_fire;
  wire                canPrint;
  reg        [15:0]   passCount;
  reg                 errorReg;
  reg                 passReg;
  reg        [31:0]   errAddr;
  reg        [63:0]   errExpected;
  reg        [63:0]   errActual;
  reg        [63:0]   errActual1;
  reg        [24:0]   hbCounter;
  reg                 hbReg;
  wire                when_Ddr3MemtestEngine_l104;
  wire       [7:0]    fullStrb;
  reg        [10:0]   burstIndex;
  reg        [7:0]    beatIdx;
  reg        [31:0]   wrCycleCnt;
  reg        [31:0]   rdCycleCnt;
  wire       [31:0]   currentByteAddr;
  wire       [31:0]   beatBlockAddr;
  wire       [7:0]    passPrefix_0;
  wire       [7:0]    passPrefix_1;
  wire       [7:0]    passPrefix_2;
  wire       [7:0]    passPrefix_3;
  wire       [7:0]    passPrefix_4;
  wire       [7:0]    passPrefix_5;
  wire       [7:0]    passPrefix_6;
  wire       [7:0]    failPrefix_0;
  wire       [7:0]    failPrefix_1;
  wire       [7:0]    failPrefix_2;
  wire       [7:0]    failPrefix_3;
  wire       [7:0]    failPrefix_4;
  wire       [7:0]    failPrefix_5;
  wire       [7:0]    failPrefix_6;
  wire       [7:0]    failPrefix_7;
  wire       [7:0]    failPrefix_8;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [6:0]    fsm_msgIndex;
  reg        [27:0]   fsm_delayCounter;
  reg        [4:0]    fsm_stateReg;
  reg        [4:0]    fsm_stateNext;
  wire                when_Ddr3MemtestEngine_l240;
  wire                when_Ddr3MemtestEngine_l248;
  wire                when_Ddr3MemtestEngine_l403;
  wire                when_Ddr3MemtestEngine_l421;
  wire                when_Ddr3MemtestEngine_l427;
  wire                when_Ddr3MemtestEngine_l459;
  wire                when_Ddr3MemtestEngine_l470;
  wire       [63:0]   _zz_errExpected;
  wire                _zz_when_Ddr3MemtestEngine_l498;
  wire                when_Ddr3MemtestEngine_l498;
  wire                when_Ddr3MemtestEngine_l511;
  wire                when_Ddr3MemtestEngine_l515;
  wire                when_Ddr3MemtestEngine_l516;
  wire       [5:0]    _zz_nextPrintChar;
  wire                when_Ddr3MemtestEngine_l556;
  wire       [6:0]    _zz_nextPrintChar_1;
  wire                when_Ddr3MemtestEngine_l601;
  wire                when_Ddr3MemtestEngine_l614;
  `ifndef SYNTHESIS
  reg [111:0] fsm_stateReg_string;
  reg [111:0] fsm_stateNext_string;
  `endif


  assign _zz_currentByteAddr = ({4'd0,burstIndex} <<< 3'd4);
  assign _zz_beatBlockAddr_1 = ({4'd0,_zz_beatBlockAddr_2} <<< 3'd4);
  assign _zz_beatBlockAddr = {21'd0, _zz_beatBlockAddr_1};
  assign _zz_beatBlockAddr_2 = (beatIdx >>> 1'd1);
  assign _zz_nextPrintChar_14 = {2'd0, io_rclkpos};
  assign _zz_nextPrintChar_17 = {1'd0, io_rclksel};
  assign _zz_nextPrintChar_21 = io_best_rot;
  assign _zz_nextPrintChar_20 = {1'd0, _zz_nextPrintChar_21};
  assign _zz_io_axi_w_payload_data = (beatBlockAddr + 32'h00000002);
  assign _zz_io_axi_w_payload_data_1 = (beatBlockAddr + 32'h00000001);
  assign _zz_when_Ddr3MemtestEngine_l470 = (burstIndex + 11'h040);
  assign _zz__zz_errExpected = (beatBlockAddr + 32'h00000002);
  assign _zz__zz_errExpected_1 = (beatBlockAddr + 32'h00000001);
  assign _zz_when_Ddr3MemtestEngine_l516 = (burstIndex + 11'h040);
  assign _zz_printChar_1 = stageNib;
  assign _zz_nextPrintChar_3 = io_dbg_state;
  assign _zz_nextPrintChar_5 = io_wstep[7 : 4];
  assign _zz_nextPrintChar_7 = io_wstep[3 : 0];
  assign _zz_nextPrintChar_9 = io_wstep[7 : 4];
  assign _zz_nextPrintChar_11 = io_wstep[3 : 0];
  assign _zz_nextPrintChar_13 = _zz_nextPrintChar_14;
  assign _zz_nextPrintChar_16 = _zz_nextPrintChar_17;
  assign _zz_nextPrintChar_19 = _zz_nextPrintChar_20;
  assign _zz_nextPrintChar_23 = io_best_score;
  UartTx uart (
    .io_write_valid   (txStream_valid       ), //i
    .io_write_ready   (uart_io_write_ready  ), //o
    .io_write_payload (txStream_payload[7:0]), //i
    .io_txd           (uart_io_txd          ), //o
    .io_busy          (uart_io_busy         ), //o
    .clkoutd          (clkoutd              ), //i
    ._zz_1            (_zz_1                )  //i
  );
  always @(*) begin
    case(_zz_printChar_1)
      4'b0000 : _zz_printChar = hexAsciiRom_0;
      4'b0001 : _zz_printChar = hexAsciiRom_1;
      4'b0010 : _zz_printChar = hexAsciiRom_2;
      4'b0011 : _zz_printChar = hexAsciiRom_3;
      4'b0100 : _zz_printChar = hexAsciiRom_4;
      4'b0101 : _zz_printChar = hexAsciiRom_5;
      4'b0110 : _zz_printChar = hexAsciiRom_6;
      4'b0111 : _zz_printChar = hexAsciiRom_7;
      4'b1000 : _zz_printChar = hexAsciiRom_8;
      4'b1001 : _zz_printChar = hexAsciiRom_9;
      4'b1010 : _zz_printChar = hexAsciiRom_10;
      4'b1011 : _zz_printChar = hexAsciiRom_11;
      4'b1100 : _zz_printChar = hexAsciiRom_12;
      4'b1101 : _zz_printChar = hexAsciiRom_13;
      4'b1110 : _zz_printChar = hexAsciiRom_14;
      default : _zz_printChar = hexAsciiRom_15;
    endcase
  end

  always @(*) begin
    case(_zz_nextPrintChar_3)
      4'b0000 : _zz_nextPrintChar_2 = hexAsciiRom_0;
      4'b0001 : _zz_nextPrintChar_2 = hexAsciiRom_1;
      4'b0010 : _zz_nextPrintChar_2 = hexAsciiRom_2;
      4'b0011 : _zz_nextPrintChar_2 = hexAsciiRom_3;
      4'b0100 : _zz_nextPrintChar_2 = hexAsciiRom_4;
      4'b0101 : _zz_nextPrintChar_2 = hexAsciiRom_5;
      4'b0110 : _zz_nextPrintChar_2 = hexAsciiRom_6;
      4'b0111 : _zz_nextPrintChar_2 = hexAsciiRom_7;
      4'b1000 : _zz_nextPrintChar_2 = hexAsciiRom_8;
      4'b1001 : _zz_nextPrintChar_2 = hexAsciiRom_9;
      4'b1010 : _zz_nextPrintChar_2 = hexAsciiRom_10;
      4'b1011 : _zz_nextPrintChar_2 = hexAsciiRom_11;
      4'b1100 : _zz_nextPrintChar_2 = hexAsciiRom_12;
      4'b1101 : _zz_nextPrintChar_2 = hexAsciiRom_13;
      4'b1110 : _zz_nextPrintChar_2 = hexAsciiRom_14;
      default : _zz_nextPrintChar_2 = hexAsciiRom_15;
    endcase
  end

  always @(*) begin
    case(_zz_nextPrintChar_5)
      4'b0000 : _zz_nextPrintChar_4 = hexAsciiRom_0;
      4'b0001 : _zz_nextPrintChar_4 = hexAsciiRom_1;
      4'b0010 : _zz_nextPrintChar_4 = hexAsciiRom_2;
      4'b0011 : _zz_nextPrintChar_4 = hexAsciiRom_3;
      4'b0100 : _zz_nextPrintChar_4 = hexAsciiRom_4;
      4'b0101 : _zz_nextPrintChar_4 = hexAsciiRom_5;
      4'b0110 : _zz_nextPrintChar_4 = hexAsciiRom_6;
      4'b0111 : _zz_nextPrintChar_4 = hexAsciiRom_7;
      4'b1000 : _zz_nextPrintChar_4 = hexAsciiRom_8;
      4'b1001 : _zz_nextPrintChar_4 = hexAsciiRom_9;
      4'b1010 : _zz_nextPrintChar_4 = hexAsciiRom_10;
      4'b1011 : _zz_nextPrintChar_4 = hexAsciiRom_11;
      4'b1100 : _zz_nextPrintChar_4 = hexAsciiRom_12;
      4'b1101 : _zz_nextPrintChar_4 = hexAsciiRom_13;
      4'b1110 : _zz_nextPrintChar_4 = hexAsciiRom_14;
      default : _zz_nextPrintChar_4 = hexAsciiRom_15;
    endcase
  end

  always @(*) begin
    case(_zz_nextPrintChar_7)
      4'b0000 : _zz_nextPrintChar_6 = hexAsciiRom_0;
      4'b0001 : _zz_nextPrintChar_6 = hexAsciiRom_1;
      4'b0010 : _zz_nextPrintChar_6 = hexAsciiRom_2;
      4'b0011 : _zz_nextPrintChar_6 = hexAsciiRom_3;
      4'b0100 : _zz_nextPrintChar_6 = hexAsciiRom_4;
      4'b0101 : _zz_nextPrintChar_6 = hexAsciiRom_5;
      4'b0110 : _zz_nextPrintChar_6 = hexAsciiRom_6;
      4'b0111 : _zz_nextPrintChar_6 = hexAsciiRom_7;
      4'b1000 : _zz_nextPrintChar_6 = hexAsciiRom_8;
      4'b1001 : _zz_nextPrintChar_6 = hexAsciiRom_9;
      4'b1010 : _zz_nextPrintChar_6 = hexAsciiRom_10;
      4'b1011 : _zz_nextPrintChar_6 = hexAsciiRom_11;
      4'b1100 : _zz_nextPrintChar_6 = hexAsciiRom_12;
      4'b1101 : _zz_nextPrintChar_6 = hexAsciiRom_13;
      4'b1110 : _zz_nextPrintChar_6 = hexAsciiRom_14;
      default : _zz_nextPrintChar_6 = hexAsciiRom_15;
    endcase
  end

  always @(*) begin
    case(_zz_nextPrintChar_9)
      4'b0000 : _zz_nextPrintChar_8 = hexAsciiRom_0;
      4'b0001 : _zz_nextPrintChar_8 = hexAsciiRom_1;
      4'b0010 : _zz_nextPrintChar_8 = hexAsciiRom_2;
      4'b0011 : _zz_nextPrintChar_8 = hexAsciiRom_3;
      4'b0100 : _zz_nextPrintChar_8 = hexAsciiRom_4;
      4'b0101 : _zz_nextPrintChar_8 = hexAsciiRom_5;
      4'b0110 : _zz_nextPrintChar_8 = hexAsciiRom_6;
      4'b0111 : _zz_nextPrintChar_8 = hexAsciiRom_7;
      4'b1000 : _zz_nextPrintChar_8 = hexAsciiRom_8;
      4'b1001 : _zz_nextPrintChar_8 = hexAsciiRom_9;
      4'b1010 : _zz_nextPrintChar_8 = hexAsciiRom_10;
      4'b1011 : _zz_nextPrintChar_8 = hexAsciiRom_11;
      4'b1100 : _zz_nextPrintChar_8 = hexAsciiRom_12;
      4'b1101 : _zz_nextPrintChar_8 = hexAsciiRom_13;
      4'b1110 : _zz_nextPrintChar_8 = hexAsciiRom_14;
      default : _zz_nextPrintChar_8 = hexAsciiRom_15;
    endcase
  end

  always @(*) begin
    case(_zz_nextPrintChar_11)
      4'b0000 : _zz_nextPrintChar_10 = hexAsciiRom_0;
      4'b0001 : _zz_nextPrintChar_10 = hexAsciiRom_1;
      4'b0010 : _zz_nextPrintChar_10 = hexAsciiRom_2;
      4'b0011 : _zz_nextPrintChar_10 = hexAsciiRom_3;
      4'b0100 : _zz_nextPrintChar_10 = hexAsciiRom_4;
      4'b0101 : _zz_nextPrintChar_10 = hexAsciiRom_5;
      4'b0110 : _zz_nextPrintChar_10 = hexAsciiRom_6;
      4'b0111 : _zz_nextPrintChar_10 = hexAsciiRom_7;
      4'b1000 : _zz_nextPrintChar_10 = hexAsciiRom_8;
      4'b1001 : _zz_nextPrintChar_10 = hexAsciiRom_9;
      4'b1010 : _zz_nextPrintChar_10 = hexAsciiRom_10;
      4'b1011 : _zz_nextPrintChar_10 = hexAsciiRom_11;
      4'b1100 : _zz_nextPrintChar_10 = hexAsciiRom_12;
      4'b1101 : _zz_nextPrintChar_10 = hexAsciiRom_13;
      4'b1110 : _zz_nextPrintChar_10 = hexAsciiRom_14;
      default : _zz_nextPrintChar_10 = hexAsciiRom_15;
    endcase
  end

  always @(*) begin
    case(_zz_nextPrintChar_13)
      4'b0000 : _zz_nextPrintChar_12 = hexAsciiRom_0;
      4'b0001 : _zz_nextPrintChar_12 = hexAsciiRom_1;
      4'b0010 : _zz_nextPrintChar_12 = hexAsciiRom_2;
      4'b0011 : _zz_nextPrintChar_12 = hexAsciiRom_3;
      4'b0100 : _zz_nextPrintChar_12 = hexAsciiRom_4;
      4'b0101 : _zz_nextPrintChar_12 = hexAsciiRom_5;
      4'b0110 : _zz_nextPrintChar_12 = hexAsciiRom_6;
      4'b0111 : _zz_nextPrintChar_12 = hexAsciiRom_7;
      4'b1000 : _zz_nextPrintChar_12 = hexAsciiRom_8;
      4'b1001 : _zz_nextPrintChar_12 = hexAsciiRom_9;
      4'b1010 : _zz_nextPrintChar_12 = hexAsciiRom_10;
      4'b1011 : _zz_nextPrintChar_12 = hexAsciiRom_11;
      4'b1100 : _zz_nextPrintChar_12 = hexAsciiRom_12;
      4'b1101 : _zz_nextPrintChar_12 = hexAsciiRom_13;
      4'b1110 : _zz_nextPrintChar_12 = hexAsciiRom_14;
      default : _zz_nextPrintChar_12 = hexAsciiRom_15;
    endcase
  end

  always @(*) begin
    case(_zz_nextPrintChar_16)
      4'b0000 : _zz_nextPrintChar_15 = hexAsciiRom_0;
      4'b0001 : _zz_nextPrintChar_15 = hexAsciiRom_1;
      4'b0010 : _zz_nextPrintChar_15 = hexAsciiRom_2;
      4'b0011 : _zz_nextPrintChar_15 = hexAsciiRom_3;
      4'b0100 : _zz_nextPrintChar_15 = hexAsciiRom_4;
      4'b0101 : _zz_nextPrintChar_15 = hexAsciiRom_5;
      4'b0110 : _zz_nextPrintChar_15 = hexAsciiRom_6;
      4'b0111 : _zz_nextPrintChar_15 = hexAsciiRom_7;
      4'b1000 : _zz_nextPrintChar_15 = hexAsciiRom_8;
      4'b1001 : _zz_nextPrintChar_15 = hexAsciiRom_9;
      4'b1010 : _zz_nextPrintChar_15 = hexAsciiRom_10;
      4'b1011 : _zz_nextPrintChar_15 = hexAsciiRom_11;
      4'b1100 : _zz_nextPrintChar_15 = hexAsciiRom_12;
      4'b1101 : _zz_nextPrintChar_15 = hexAsciiRom_13;
      4'b1110 : _zz_nextPrintChar_15 = hexAsciiRom_14;
      default : _zz_nextPrintChar_15 = hexAsciiRom_15;
    endcase
  end

  always @(*) begin
    case(_zz_nextPrintChar_19)
      4'b0000 : _zz_nextPrintChar_18 = hexAsciiRom_0;
      4'b0001 : _zz_nextPrintChar_18 = hexAsciiRom_1;
      4'b0010 : _zz_nextPrintChar_18 = hexAsciiRom_2;
      4'b0011 : _zz_nextPrintChar_18 = hexAsciiRom_3;
      4'b0100 : _zz_nextPrintChar_18 = hexAsciiRom_4;
      4'b0101 : _zz_nextPrintChar_18 = hexAsciiRom_5;
      4'b0110 : _zz_nextPrintChar_18 = hexAsciiRom_6;
      4'b0111 : _zz_nextPrintChar_18 = hexAsciiRom_7;
      4'b1000 : _zz_nextPrintChar_18 = hexAsciiRom_8;
      4'b1001 : _zz_nextPrintChar_18 = hexAsciiRom_9;
      4'b1010 : _zz_nextPrintChar_18 = hexAsciiRom_10;
      4'b1011 : _zz_nextPrintChar_18 = hexAsciiRom_11;
      4'b1100 : _zz_nextPrintChar_18 = hexAsciiRom_12;
      4'b1101 : _zz_nextPrintChar_18 = hexAsciiRom_13;
      4'b1110 : _zz_nextPrintChar_18 = hexAsciiRom_14;
      default : _zz_nextPrintChar_18 = hexAsciiRom_15;
    endcase
  end

  always @(*) begin
    case(_zz_nextPrintChar_23)
      4'b0000 : _zz_nextPrintChar_22 = hexAsciiRom_0;
      4'b0001 : _zz_nextPrintChar_22 = hexAsciiRom_1;
      4'b0010 : _zz_nextPrintChar_22 = hexAsciiRom_2;
      4'b0011 : _zz_nextPrintChar_22 = hexAsciiRom_3;
      4'b0100 : _zz_nextPrintChar_22 = hexAsciiRom_4;
      4'b0101 : _zz_nextPrintChar_22 = hexAsciiRom_5;
      4'b0110 : _zz_nextPrintChar_22 = hexAsciiRom_6;
      4'b0111 : _zz_nextPrintChar_22 = hexAsciiRom_7;
      4'b1000 : _zz_nextPrintChar_22 = hexAsciiRom_8;
      4'b1001 : _zz_nextPrintChar_22 = hexAsciiRom_9;
      4'b1010 : _zz_nextPrintChar_22 = hexAsciiRom_10;
      4'b1011 : _zz_nextPrintChar_22 = hexAsciiRom_11;
      4'b1100 : _zz_nextPrintChar_22 = hexAsciiRom_12;
      4'b1101 : _zz_nextPrintChar_22 = hexAsciiRom_13;
      4'b1110 : _zz_nextPrintChar_22 = hexAsciiRom_14;
      default : _zz_nextPrintChar_22 = hexAsciiRom_15;
    endcase
  end

  always @(*) begin
    case(_zz_nextPrintChar)
      6'b000000 : begin
        _zz_nextPrintChar_24 = passPrefix_0;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b000001 : begin
        _zz_nextPrintChar_24 = passPrefix_1;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b000010 : begin
        _zz_nextPrintChar_24 = passPrefix_2;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b000011 : begin
        _zz_nextPrintChar_24 = passPrefix_3;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b000100 : begin
        _zz_nextPrintChar_24 = passPrefix_4;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b000101 : begin
        _zz_nextPrintChar_24 = passPrefix_5;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b000110 : begin
        _zz_nextPrintChar_24 = passPrefix_6;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b000111 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = passCount[15 : 12];
        _zz_nextUseNib = 1'b1;
      end
      6'b001000 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = passCount[11 : 8];
        _zz_nextUseNib = 1'b1;
      end
      6'b001001 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = passCount[7 : 4];
        _zz_nextUseNib = 1'b1;
      end
      6'b001010 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = passCount[3 : 0];
        _zz_nextUseNib = 1'b1;
      end
      6'b001011 : begin
        _zz_nextPrintChar_24 = 8'h20;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b001100 : begin
        _zz_nextPrintChar_24 = 8'h57;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b001101 : begin
        _zz_nextPrintChar_24 = 8'h3d;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b001110 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = wrCycleCnt[31 : 28];
        _zz_nextUseNib = 1'b1;
      end
      6'b001111 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = wrCycleCnt[27 : 24];
        _zz_nextUseNib = 1'b1;
      end
      6'b010000 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = wrCycleCnt[23 : 20];
        _zz_nextUseNib = 1'b1;
      end
      6'b010001 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = wrCycleCnt[19 : 16];
        _zz_nextUseNib = 1'b1;
      end
      6'b010010 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = wrCycleCnt[15 : 12];
        _zz_nextUseNib = 1'b1;
      end
      6'b010011 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = wrCycleCnt[11 : 8];
        _zz_nextUseNib = 1'b1;
      end
      6'b010100 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = wrCycleCnt[7 : 4];
        _zz_nextUseNib = 1'b1;
      end
      6'b010101 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = wrCycleCnt[3 : 0];
        _zz_nextUseNib = 1'b1;
      end
      6'b010110 : begin
        _zz_nextPrintChar_24 = 8'h20;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b010111 : begin
        _zz_nextPrintChar_24 = 8'h52;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b011000 : begin
        _zz_nextPrintChar_24 = 8'h3d;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      6'b011001 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = rdCycleCnt[31 : 28];
        _zz_nextUseNib = 1'b1;
      end
      6'b011010 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = rdCycleCnt[27 : 24];
        _zz_nextUseNib = 1'b1;
      end
      6'b011011 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = rdCycleCnt[23 : 20];
        _zz_nextUseNib = 1'b1;
      end
      6'b011100 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = rdCycleCnt[19 : 16];
        _zz_nextUseNib = 1'b1;
      end
      6'b011101 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = rdCycleCnt[15 : 12];
        _zz_nextUseNib = 1'b1;
      end
      6'b011110 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = rdCycleCnt[11 : 8];
        _zz_nextUseNib = 1'b1;
      end
      6'b011111 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = rdCycleCnt[7 : 4];
        _zz_nextUseNib = 1'b1;
      end
      6'b100000 : begin
        _zz_nextPrintChar_24 = 8'h0;
        _zz_nextPrintNib = rdCycleCnt[3 : 0];
        _zz_nextUseNib = 1'b1;
      end
      6'b100001 : begin
        _zz_nextPrintChar_24 = 8'h0d;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
      default : begin
        _zz_nextPrintChar_24 = 8'h0a;
        _zz_nextPrintNib = 4'b0000;
        _zz_nextUseNib = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(_zz_nextPrintChar_1)
      7'b0000000 : begin
        _zz_nextPrintChar_25 = failPrefix_0;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0000001 : begin
        _zz_nextPrintChar_25 = failPrefix_1;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0000010 : begin
        _zz_nextPrintChar_25 = failPrefix_2;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0000011 : begin
        _zz_nextPrintChar_25 = failPrefix_3;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0000100 : begin
        _zz_nextPrintChar_25 = failPrefix_4;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0000101 : begin
        _zz_nextPrintChar_25 = failPrefix_5;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0000110 : begin
        _zz_nextPrintChar_25 = failPrefix_6;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0000111 : begin
        _zz_nextPrintChar_25 = failPrefix_7;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0001000 : begin
        _zz_nextPrintChar_25 = failPrefix_8;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0001001 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errAddr[31 : 28];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0001010 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errAddr[27 : 24];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0001011 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errAddr[23 : 20];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0001100 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errAddr[19 : 16];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0001101 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errAddr[15 : 12];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0001110 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errAddr[11 : 8];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0001111 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errAddr[7 : 4];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0010000 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errAddr[3 : 0];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0010001 : begin
        _zz_nextPrintChar_25 = 8'h20;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0010010 : begin
        _zz_nextPrintChar_25 = 8'h45;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0010011 : begin
        _zz_nextPrintChar_25 = 8'h3d;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0010100 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[63 : 60];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0010101 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[59 : 56];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0010110 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[55 : 52];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0010111 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[51 : 48];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0011000 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[47 : 44];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0011001 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[43 : 40];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0011010 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[39 : 36];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0011011 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[35 : 32];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0011100 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[31 : 28];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0011101 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[27 : 24];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0011110 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[23 : 20];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0011111 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[19 : 16];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0100000 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[15 : 12];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0100001 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[11 : 8];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0100010 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[7 : 4];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0100011 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errExpected[3 : 0];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0100100 : begin
        _zz_nextPrintChar_25 = 8'h20;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0100101 : begin
        _zz_nextPrintChar_25 = 8'h47;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0100110 : begin
        _zz_nextPrintChar_25 = 8'h3d;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0100111 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[63 : 60];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0101000 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[59 : 56];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0101001 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[55 : 52];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0101010 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[51 : 48];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0101011 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[47 : 44];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0101100 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[43 : 40];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0101101 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[39 : 36];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0101110 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[35 : 32];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0101111 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[31 : 28];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0110000 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[27 : 24];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0110001 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[23 : 20];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0110010 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[19 : 16];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0110011 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[15 : 12];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0110100 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[11 : 8];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0110101 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[7 : 4];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0110110 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual[3 : 0];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0110111 : begin
        _zz_nextPrintChar_25 = 8'h20;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0111000 : begin
        _zz_nextPrintChar_25 = 8'h48;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0111001 : begin
        _zz_nextPrintChar_25 = 8'h3d;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      7'b0111010 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[63 : 60];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0111011 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[59 : 56];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0111100 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[55 : 52];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0111101 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[51 : 48];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0111110 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[47 : 44];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b0111111 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[43 : 40];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b1000000 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[39 : 36];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b1000001 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[35 : 32];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b1000010 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[31 : 28];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b1000011 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[27 : 24];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b1000100 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[23 : 20];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b1000101 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[19 : 16];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b1000110 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[15 : 12];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b1000111 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[11 : 8];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b1001000 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[7 : 4];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b1001001 : begin
        _zz_nextPrintChar_25 = 8'h0;
        _zz_nextPrintNib_1 = errActual1[3 : 0];
        _zz_nextUseNib_1 = 1'b1;
      end
      7'b1001010 : begin
        _zz_nextPrintChar_25 = 8'h0d;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
      default : begin
        _zz_nextPrintChar_25 = 8'h0a;
        _zz_nextPrintNib_1 = 4'b0000;
        _zz_nextUseNib_1 = 1'b0;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_BOOT : fsm_stateReg_string = "BOOT          ";
      fsm_sBootBanner : fsm_stateReg_string = "sBootBanner   ";
      fsm_sWaitCalib : fsm_stateReg_string = "sWaitCalib    ";
      fsm_sPrintCalib : fsm_stateReg_string = "sPrintCalib   ";
      fsm_sPrintBanner : fsm_stateReg_string = "sPrintBanner  ";
      fsm_sSingleWriteAW : fsm_stateReg_string = "sSingleWriteAW";
      fsm_sSingleWriteW0 : fsm_stateReg_string = "sSingleWriteW0";
      fsm_sSingleWriteW1 : fsm_stateReg_string = "sSingleWriteW1";
      fsm_sSingleWriteB : fsm_stateReg_string = "sSingleWriteB ";
      fsm_sSingleReadAR : fsm_stateReg_string = "sSingleReadAR ";
      fsm_sSingleReadR0 : fsm_stateReg_string = "sSingleReadR0 ";
      fsm_sSingleReadR1 : fsm_stateReg_string = "sSingleReadR1 ";
      fsm_sBulkWriteAW : fsm_stateReg_string = "sBulkWriteAW  ";
      fsm_sBulkWriteW : fsm_stateReg_string = "sBulkWriteW   ";
      fsm_sBulkWriteB : fsm_stateReg_string = "sBulkWriteB   ";
      fsm_sBulkReadAR : fsm_stateReg_string = "sBulkReadAR   ";
      fsm_sBulkReadR : fsm_stateReg_string = "sBulkReadR    ";
      fsm_sReportPass : fsm_stateReg_string = "sReportPass   ";
      fsm_sReportFail : fsm_stateReg_string = "sReportFail   ";
      fsm_sLoopDelay : fsm_stateReg_string = "sLoopDelay    ";
      default : fsm_stateReg_string = "??????????????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_BOOT : fsm_stateNext_string = "BOOT          ";
      fsm_sBootBanner : fsm_stateNext_string = "sBootBanner   ";
      fsm_sWaitCalib : fsm_stateNext_string = "sWaitCalib    ";
      fsm_sPrintCalib : fsm_stateNext_string = "sPrintCalib   ";
      fsm_sPrintBanner : fsm_stateNext_string = "sPrintBanner  ";
      fsm_sSingleWriteAW : fsm_stateNext_string = "sSingleWriteAW";
      fsm_sSingleWriteW0 : fsm_stateNext_string = "sSingleWriteW0";
      fsm_sSingleWriteW1 : fsm_stateNext_string = "sSingleWriteW1";
      fsm_sSingleWriteB : fsm_stateNext_string = "sSingleWriteB ";
      fsm_sSingleReadAR : fsm_stateNext_string = "sSingleReadAR ";
      fsm_sSingleReadR0 : fsm_stateNext_string = "sSingleReadR0 ";
      fsm_sSingleReadR1 : fsm_stateNext_string = "sSingleReadR1 ";
      fsm_sBulkWriteAW : fsm_stateNext_string = "sBulkWriteAW  ";
      fsm_sBulkWriteW : fsm_stateNext_string = "sBulkWriteW   ";
      fsm_sBulkWriteB : fsm_stateNext_string = "sBulkWriteB   ";
      fsm_sBulkReadAR : fsm_stateNext_string = "sBulkReadAR   ";
      fsm_sBulkReadR : fsm_stateNext_string = "sBulkReadR    ";
      fsm_sReportPass : fsm_stateNext_string = "sReportPass   ";
      fsm_sReportFail : fsm_stateNext_string = "sReportFail   ";
      fsm_sLoopDelay : fsm_stateNext_string = "sLoopDelay    ";
      default : fsm_stateNext_string = "??????????????";
    endcase
  end
  `endif

  assign io_uart_tx = uart_io_txd;
  assign txStream_ready = uart_io_write_ready;
  assign hexAsciiRom_0 = 8'h30;
  assign hexAsciiRom_1 = 8'h31;
  assign hexAsciiRom_2 = 8'h32;
  assign hexAsciiRom_3 = 8'h33;
  assign hexAsciiRom_4 = 8'h34;
  assign hexAsciiRom_5 = 8'h35;
  assign hexAsciiRom_6 = 8'h36;
  assign hexAsciiRom_7 = 8'h37;
  assign hexAsciiRom_8 = 8'h38;
  assign hexAsciiRom_9 = 8'h39;
  assign hexAsciiRom_10 = 8'h41;
  assign hexAsciiRom_11 = 8'h42;
  assign hexAsciiRom_12 = 8'h43;
  assign hexAsciiRom_13 = 8'h44;
  assign hexAsciiRom_14 = 8'h45;
  assign hexAsciiRom_15 = 8'h46;
  always @(*) begin
    nextPrintValid = 1'b0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
        if(canPrint) begin
          case(fsm_msgIndex)
            7'h0 : begin
              nextPrintValid = 1'b1;
            end
            7'h01 : begin
              nextPrintValid = 1'b1;
            end
            7'h02 : begin
              nextPrintValid = 1'b1;
            end
            7'h03 : begin
              nextPrintValid = 1'b1;
            end
            7'h04 : begin
              nextPrintValid = 1'b1;
            end
            7'h05 : begin
              nextPrintValid = 1'b1;
            end
            7'h06 : begin
              nextPrintValid = 1'b1;
            end
            7'h07 : begin
              nextPrintValid = 1'b1;
            end
            7'h08 : begin
              nextPrintValid = 1'b1;
            end
            7'h09 : begin
              nextPrintValid = 1'b1;
            end
            7'h0a : begin
              nextPrintValid = 1'b1;
            end
            7'h0b : begin
              nextPrintValid = 1'b1;
            end
            7'h0c : begin
              nextPrintValid = 1'b1;
            end
            7'h0d : begin
              nextPrintValid = 1'b1;
            end
            7'h0e : begin
              nextPrintValid = 1'b1;
            end
            7'h0f : begin
              nextPrintValid = 1'b1;
            end
            7'h10 : begin
              nextPrintValid = 1'b1;
            end
            7'h11 : begin
              nextPrintValid = 1'b1;
            end
            7'h12 : begin
              nextPrintValid = 1'b1;
            end
            7'h13 : begin
              nextPrintValid = 1'b1;
            end
            default : begin
            end
          endcase
        end
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
        if(canPrint) begin
          case(fsm_msgIndex)
            7'h0 : begin
              nextPrintValid = 1'b1;
            end
            7'h01 : begin
              nextPrintValid = 1'b1;
            end
            7'h02 : begin
              nextPrintValid = 1'b1;
            end
            7'h03 : begin
              nextPrintValid = 1'b1;
            end
            7'h04 : begin
              nextPrintValid = 1'b1;
            end
            7'h05 : begin
              nextPrintValid = 1'b1;
            end
            7'h06 : begin
              nextPrintValid = 1'b1;
            end
            7'h07 : begin
              nextPrintValid = 1'b1;
            end
            7'h08 : begin
              nextPrintValid = 1'b1;
            end
            7'h09 : begin
              nextPrintValid = 1'b1;
            end
            7'h0a : begin
              nextPrintValid = 1'b1;
            end
            7'h0b : begin
              nextPrintValid = 1'b1;
            end
            7'h0c : begin
              nextPrintValid = 1'b1;
            end
            7'h0d : begin
              nextPrintValid = 1'b1;
            end
            7'h0e : begin
              nextPrintValid = 1'b1;
            end
            default : begin
            end
          endcase
        end
      end
      fsm_sPrintBanner : begin
        if(canPrint) begin
          case(fsm_msgIndex)
            7'h0 : begin
              nextPrintValid = 1'b1;
            end
            7'h01 : begin
              nextPrintValid = 1'b1;
            end
            7'h02 : begin
              nextPrintValid = 1'b1;
            end
            7'h03 : begin
              nextPrintValid = 1'b1;
            end
            7'h04 : begin
              nextPrintValid = 1'b1;
            end
            7'h05 : begin
              nextPrintValid = 1'b1;
            end
            7'h06 : begin
              nextPrintValid = 1'b1;
            end
            7'h07 : begin
              nextPrintValid = 1'b1;
            end
            7'h08 : begin
              nextPrintValid = 1'b1;
            end
            7'h09 : begin
              nextPrintValid = 1'b1;
            end
            7'h0a : begin
              nextPrintValid = 1'b1;
            end
            7'h0b : begin
              nextPrintValid = 1'b1;
            end
            7'h0c : begin
              nextPrintValid = 1'b1;
            end
            7'h0d : begin
              nextPrintValid = 1'b1;
            end
            7'h0e : begin
              nextPrintValid = 1'b1;
            end
            7'h0f : begin
              nextPrintValid = 1'b1;
            end
            7'h10 : begin
              nextPrintValid = 1'b1;
            end
            7'h11 : begin
              nextPrintValid = 1'b1;
            end
            7'h12 : begin
              nextPrintValid = 1'b1;
            end
            7'h13 : begin
              nextPrintValid = 1'b1;
            end
            7'h14 : begin
              nextPrintValid = 1'b1;
            end
            7'h15 : begin
              nextPrintValid = 1'b1;
            end
            7'h16 : begin
              nextPrintValid = 1'b1;
            end
            7'h17 : begin
              nextPrintValid = 1'b1;
            end
            7'h18 : begin
              nextPrintValid = 1'b1;
            end
            7'h19 : begin
              nextPrintValid = 1'b1;
            end
            7'h1a : begin
              nextPrintValid = 1'b1;
            end
            7'h1b : begin
              nextPrintValid = 1'b1;
            end
            7'h1c : begin
              nextPrintValid = 1'b1;
            end
            7'h1d : begin
              nextPrintValid = 1'b1;
            end
            7'h1e : begin
              nextPrintValid = 1'b1;
            end
            7'h1f : begin
              nextPrintValid = 1'b1;
            end
            7'h20 : begin
              nextPrintValid = 1'b1;
            end
            7'h21 : begin
              nextPrintValid = 1'b1;
            end
            default : begin
            end
          endcase
        end
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
        if(canPrint) begin
          if(when_Ddr3MemtestEngine_l556) begin
            nextPrintValid = 1'b1;
          end
        end
      end
      fsm_sReportFail : begin
        if(canPrint) begin
          if(when_Ddr3MemtestEngine_l601) begin
            nextPrintValid = 1'b1;
          end
        end
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    nextPrintChar = 8'h0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
        if(canPrint) begin
          case(fsm_msgIndex)
            7'h0 : begin
              nextPrintChar = 8'h0d;
            end
            7'h01 : begin
              nextPrintChar = 8'h0a;
            end
            7'h02 : begin
              nextPrintChar = 8'h5b;
            end
            7'h03 : begin
              nextPrintChar = 8'h42;
            end
            7'h04 : begin
              nextPrintChar = 8'h4f;
            end
            7'h05 : begin
              nextPrintChar = 8'h4f;
            end
            7'h06 : begin
              nextPrintChar = 8'h54;
            end
            7'h07 : begin
              nextPrintChar = 8'h5d;
            end
            7'h08 : begin
              nextPrintChar = 8'h20;
            end
            7'h09 : begin
              nextPrintChar = 8'h44;
            end
            7'h0a : begin
              nextPrintChar = 8'h44;
            end
            7'h0b : begin
              nextPrintChar = 8'h52;
            end
            7'h0c : begin
              nextPrintChar = 8'h33;
            end
            7'h0d : begin
              nextPrintChar = 8'h20;
            end
            7'h0e : begin
              nextPrintChar = 8'h43;
            end
            7'h0f : begin
              nextPrintChar = 8'h6f;
            end
            7'h10 : begin
              nextPrintChar = 8'h72;
            end
            7'h11 : begin
              nextPrintChar = 8'h65;
            end
            7'h12 : begin
              nextPrintChar = 8'h0d;
            end
            7'h13 : begin
              nextPrintChar = 8'h0a;
            end
            default : begin
            end
          endcase
        end
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
        if(canPrint) begin
          case(fsm_msgIndex)
            7'h0 : begin
              nextPrintChar = 8'h5b;
            end
            7'h01 : begin
              nextPrintChar = 8'h43;
            end
            7'h02 : begin
              nextPrintChar = 8'h41;
            end
            7'h03 : begin
              nextPrintChar = 8'h4c;
            end
            7'h04 : begin
              nextPrintChar = 8'h20;
            end
            7'h05 : begin
              nextPrintChar = 8'h73;
            end
            7'h06 : begin
              nextPrintChar = 8'h3d;
            end
            7'h07 : begin
              nextPrintChar = _zz_nextPrintChar_2;
            end
            7'h08 : begin
              nextPrintChar = 8'h20;
            end
            7'h09 : begin
              nextPrintChar = 8'h57;
            end
            7'h0a : begin
              nextPrintChar = 8'h3d;
            end
            7'h0b : begin
              nextPrintChar = _zz_nextPrintChar_4;
            end
            7'h0c : begin
              nextPrintChar = _zz_nextPrintChar_6;
            end
            7'h0d : begin
              nextPrintChar = 8'h0d;
            end
            7'h0e : begin
              nextPrintChar = 8'h0a;
            end
            default : begin
            end
          endcase
        end
      end
      fsm_sPrintBanner : begin
        if(canPrint) begin
          case(fsm_msgIndex)
            7'h0 : begin
              nextPrintChar = 8'h0d;
            end
            7'h01 : begin
              nextPrintChar = 8'h0a;
            end
            7'h02 : begin
              nextPrintChar = 8'h5b;
            end
            7'h03 : begin
              nextPrintChar = 8'h44;
            end
            7'h04 : begin
              nextPrintChar = 8'h44;
            end
            7'h05 : begin
              nextPrintChar = 8'h52;
            end
            7'h06 : begin
              nextPrintChar = 8'h33;
            end
            7'h07 : begin
              nextPrintChar = 8'h2d;
            end
            7'h08 : begin
              nextPrintChar = 8'h4f;
            end
            7'h09 : begin
              nextPrintChar = 8'h4b;
            end
            7'h0a : begin
              nextPrintChar = 8'h5d;
            end
            7'h0b : begin
              nextPrintChar = 8'h20;
            end
            7'h0c : begin
              nextPrintChar = 8'h57;
            end
            7'h0d : begin
              nextPrintChar = 8'h3d;
            end
            7'h0e : begin
              nextPrintChar = _zz_nextPrintChar_8;
            end
            7'h0f : begin
              nextPrintChar = _zz_nextPrintChar_10;
            end
            7'h10 : begin
              nextPrintChar = 8'h20;
            end
            7'h11 : begin
              nextPrintChar = 8'h50;
            end
            7'h12 : begin
              nextPrintChar = 8'h3d;
            end
            7'h13 : begin
              nextPrintChar = _zz_nextPrintChar_12;
            end
            7'h14 : begin
              nextPrintChar = 8'h20;
            end
            7'h15 : begin
              nextPrintChar = 8'h53;
            end
            7'h16 : begin
              nextPrintChar = 8'h3d;
            end
            7'h17 : begin
              nextPrintChar = _zz_nextPrintChar_15;
            end
            7'h18 : begin
              nextPrintChar = 8'h20;
            end
            7'h19 : begin
              nextPrintChar = 8'h52;
            end
            7'h1a : begin
              nextPrintChar = 8'h3d;
            end
            7'h1b : begin
              nextPrintChar = _zz_nextPrintChar_18;
            end
            7'h1c : begin
              nextPrintChar = 8'h20;
            end
            7'h1d : begin
              nextPrintChar = 8'h43;
            end
            7'h1e : begin
              nextPrintChar = 8'h3d;
            end
            7'h1f : begin
              nextPrintChar = _zz_nextPrintChar_22;
            end
            7'h20 : begin
              nextPrintChar = 8'h0d;
            end
            7'h21 : begin
              nextPrintChar = 8'h0a;
            end
            default : begin
            end
          endcase
        end
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
        if(canPrint) begin
          if(when_Ddr3MemtestEngine_l556) begin
            nextPrintChar = _zz_nextPrintChar_24;
          end
        end
      end
      fsm_sReportFail : begin
        if(canPrint) begin
          if(when_Ddr3MemtestEngine_l601) begin
            nextPrintChar = _zz_nextPrintChar_25;
          end
        end
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    nextUseNib = 1'b0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
        if(canPrint) begin
          if(when_Ddr3MemtestEngine_l556) begin
            nextUseNib = _zz_nextUseNib;
          end
        end
      end
      fsm_sReportFail : begin
        if(canPrint) begin
          if(when_Ddr3MemtestEngine_l601) begin
            nextUseNib = _zz_nextUseNib_1;
          end
        end
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    nextPrintNib = 4'b0000;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
        if(canPrint) begin
          if(when_Ddr3MemtestEngine_l556) begin
            nextPrintNib = _zz_nextPrintNib;
          end
        end
      end
      fsm_sReportFail : begin
        if(canPrint) begin
          if(when_Ddr3MemtestEngine_l601) begin
            nextPrintNib = _zz_nextPrintNib_1;
          end
        end
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  assign txStream_valid = printValid;
  assign txStream_payload = printChar;
  assign txStream_fire = (txStream_valid && txStream_ready);
  assign canPrint = ((! printValid) && (! stageValid));
  assign io_test_error = errorReg;
  assign io_test_pass = passReg;
  assign when_Ddr3MemtestEngine_l104 = (hbCounter == 25'h0);
  assign io_heartbeat = hbReg;
  always @(*) begin
    io_axi_aw_valid = 1'b0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
        io_axi_aw_valid = 1'b1;
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
        io_axi_aw_valid = 1'b1;
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_aw_payload_addr = 32'h0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
        io_axi_aw_payload_addr = 32'h0;
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
        io_axi_aw_payload_addr = currentByteAddr;
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_aw_payload_len = 8'h01;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
        io_axi_aw_payload_len = 8'h7f;
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  assign io_axi_aw_payload_size = 3'b011;
  assign io_axi_aw_payload_burst = 2'b01;
  assign io_axi_aw_payload_id = 4'b0000;
  assign io_axi_aw_payload_region = 4'b0000;
  assign io_axi_aw_payload_lock = 1'b0;
  assign io_axi_aw_payload_cache = 4'b0000;
  assign io_axi_aw_payload_qos = 4'b0000;
  assign io_axi_aw_payload_prot = 3'b000;
  assign fullStrb = 8'hff;
  always @(*) begin
    io_axi_w_valid = 1'b0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
        io_axi_w_valid = 1'b1;
      end
      fsm_sSingleWriteW1 : begin
        io_axi_w_valid = 1'b1;
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
        io_axi_w_valid = 1'b1;
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_w_payload_data = 64'h0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
        io_axi_w_payload_data = 64'h0123456789abcdef;
      end
      fsm_sSingleWriteW1 : begin
        io_axi_w_payload_data = 64'hfedcba9876543210;
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
        io_axi_w_payload_data = (beatIdx[0] ? {(beatBlockAddr ^ 32'h12345678),_zz_io_axi_w_payload_data} : {(beatBlockAddr ^ 32'h5aa55aa5),_zz_io_axi_w_payload_data_1});
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_w_payload_strb = fullStrb;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
        io_axi_w_payload_strb = fullStrb;
      end
      fsm_sSingleWriteW1 : begin
        io_axi_w_payload_strb = fullStrb;
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
        io_axi_w_payload_strb = fullStrb;
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_w_payload_last = 1'b0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
        io_axi_w_payload_last = 1'b0;
      end
      fsm_sSingleWriteW1 : begin
        io_axi_w_payload_last = 1'b1;
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
        io_axi_w_payload_last = (beatIdx == 8'h7f);
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  assign io_axi_b_ready = 1'b1;
  always @(*) begin
    io_axi_ar_valid = 1'b0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
        io_axi_ar_valid = 1'b1;
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
        io_axi_ar_valid = 1'b1;
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_ar_payload_addr = 32'h0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
        io_axi_ar_payload_addr = 32'h0;
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
        io_axi_ar_payload_addr = currentByteAddr;
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_ar_payload_len = 8'h01;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
        io_axi_ar_payload_len = 8'h7f;
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  assign io_axi_ar_payload_size = 3'b011;
  assign io_axi_ar_payload_burst = 2'b01;
  assign io_axi_ar_payload_id = 4'b0000;
  assign io_axi_ar_payload_region = 4'b0000;
  assign io_axi_ar_payload_lock = 1'b0;
  assign io_axi_ar_payload_cache = 4'b0000;
  assign io_axi_ar_payload_qos = 4'b0000;
  assign io_axi_ar_payload_prot = 3'b000;
  always @(*) begin
    io_axi_r_ready = 1'b0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
        io_axi_r_ready = 1'b1;
      end
      fsm_sSingleReadR1 : begin
        io_axi_r_ready = 1'b1;
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
        io_axi_r_ready = 1'b1;
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
      end
    endcase
  end

  assign currentByteAddr = {17'd0, _zz_currentByteAddr};
  assign beatBlockAddr = (currentByteAddr + _zz_beatBlockAddr);
  assign passPrefix_0 = 8'h5b;
  assign passPrefix_1 = 8'h50;
  assign passPrefix_2 = 8'h41;
  assign passPrefix_3 = 8'h53;
  assign passPrefix_4 = 8'h53;
  assign passPrefix_5 = 8'h5d;
  assign passPrefix_6 = 8'h20;
  assign failPrefix_0 = 8'h5b;
  assign failPrefix_1 = 8'h46;
  assign failPrefix_2 = 8'h41;
  assign failPrefix_3 = 8'h49;
  assign failPrefix_4 = 8'h4c;
  assign failPrefix_5 = 8'h5d;
  assign failPrefix_6 = 8'h20;
  assign failPrefix_7 = 8'h41;
  assign failPrefix_8 = 8'h3d;
  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
      end
      fsm_sSingleWriteW1 : begin
      end
      fsm_sSingleWriteB : begin
      end
      fsm_sSingleReadAR : begin
      end
      fsm_sSingleReadR0 : begin
      end
      fsm_sSingleReadR1 : begin
      end
      fsm_sBulkWriteAW : begin
      end
      fsm_sBulkWriteW : begin
      end
      fsm_sBulkWriteB : begin
      end
      fsm_sBulkReadAR : begin
      end
      fsm_sBulkReadR : begin
      end
      fsm_sReportPass : begin
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  assign io_test_busy = (((! (fsm_stateReg == fsm_sBootBanner)) && (! (fsm_stateReg == fsm_sWaitCalib))) && (! (fsm_stateReg == fsm_sLoopDelay)));
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
        if(canPrint) begin
          case(fsm_msgIndex)
            7'h0 : begin
            end
            7'h01 : begin
            end
            7'h02 : begin
            end
            7'h03 : begin
            end
            7'h04 : begin
            end
            7'h05 : begin
            end
            7'h06 : begin
            end
            7'h07 : begin
            end
            7'h08 : begin
            end
            7'h09 : begin
            end
            7'h0a : begin
            end
            7'h0b : begin
            end
            7'h0c : begin
            end
            7'h0d : begin
            end
            7'h0e : begin
            end
            7'h0f : begin
            end
            7'h10 : begin
            end
            7'h11 : begin
            end
            7'h12 : begin
            end
            7'h13 : begin
            end
            default : begin
              fsm_stateNext = fsm_sWaitCalib;
            end
          endcase
        end
      end
      fsm_sWaitCalib : begin
        if(when_Ddr3MemtestEngine_l240) begin
          fsm_stateNext = fsm_sPrintBanner;
        end else begin
          if(when_Ddr3MemtestEngine_l248) begin
            fsm_stateNext = fsm_sPrintCalib;
          end
        end
      end
      fsm_sPrintCalib : begin
        if(canPrint) begin
          case(fsm_msgIndex)
            7'h0 : begin
            end
            7'h01 : begin
            end
            7'h02 : begin
            end
            7'h03 : begin
            end
            7'h04 : begin
            end
            7'h05 : begin
            end
            7'h06 : begin
            end
            7'h07 : begin
            end
            7'h08 : begin
            end
            7'h09 : begin
            end
            7'h0a : begin
            end
            7'h0b : begin
            end
            7'h0c : begin
            end
            7'h0d : begin
            end
            7'h0e : begin
            end
            default : begin
              fsm_stateNext = fsm_sWaitCalib;
            end
          endcase
        end
      end
      fsm_sPrintBanner : begin
        if(canPrint) begin
          case(fsm_msgIndex)
            7'h0 : begin
            end
            7'h01 : begin
            end
            7'h02 : begin
            end
            7'h03 : begin
            end
            7'h04 : begin
            end
            7'h05 : begin
            end
            7'h06 : begin
            end
            7'h07 : begin
            end
            7'h08 : begin
            end
            7'h09 : begin
            end
            7'h0a : begin
            end
            7'h0b : begin
            end
            7'h0c : begin
            end
            7'h0d : begin
            end
            7'h0e : begin
            end
            7'h0f : begin
            end
            7'h10 : begin
            end
            7'h11 : begin
            end
            7'h12 : begin
            end
            7'h13 : begin
            end
            7'h14 : begin
            end
            7'h15 : begin
            end
            7'h16 : begin
            end
            7'h17 : begin
            end
            7'h18 : begin
            end
            7'h19 : begin
            end
            7'h1a : begin
            end
            7'h1b : begin
            end
            7'h1c : begin
            end
            7'h1d : begin
            end
            7'h1e : begin
            end
            7'h1f : begin
            end
            7'h20 : begin
            end
            7'h21 : begin
            end
            default : begin
              fsm_stateNext = fsm_sSingleWriteAW;
            end
          endcase
        end
      end
      fsm_sSingleWriteAW : begin
        if(io_axi_aw_ready) begin
          fsm_stateNext = fsm_sSingleWriteW0;
        end
      end
      fsm_sSingleWriteW0 : begin
        if(io_axi_w_ready) begin
          fsm_stateNext = fsm_sSingleWriteW1;
        end
      end
      fsm_sSingleWriteW1 : begin
        if(io_axi_w_ready) begin
          fsm_stateNext = fsm_sSingleWriteB;
        end
      end
      fsm_sSingleWriteB : begin
        if(io_axi_b_valid) begin
          fsm_stateNext = fsm_sSingleReadAR;
        end
      end
      fsm_sSingleReadAR : begin
        if(io_axi_ar_ready) begin
          fsm_stateNext = fsm_sSingleReadR0;
        end
      end
      fsm_sSingleReadR0 : begin
        if(io_axi_r_valid) begin
          fsm_stateNext = fsm_sSingleReadR1;
        end
      end
      fsm_sSingleReadR1 : begin
        if(io_axi_r_valid) begin
          if(when_Ddr3MemtestEngine_l427) begin
            fsm_stateNext = fsm_sReportFail;
          end else begin
            fsm_stateNext = fsm_sBulkWriteAW;
          end
        end
      end
      fsm_sBulkWriteAW : begin
        if(io_axi_aw_ready) begin
          fsm_stateNext = fsm_sBulkWriteW;
        end
      end
      fsm_sBulkWriteW : begin
        if(io_axi_w_ready) begin
          if(when_Ddr3MemtestEngine_l459) begin
            fsm_stateNext = fsm_sBulkWriteB;
          end
        end
      end
      fsm_sBulkWriteB : begin
        if(io_axi_b_valid) begin
          if(when_Ddr3MemtestEngine_l470) begin
            fsm_stateNext = fsm_sBulkReadAR;
          end else begin
            fsm_stateNext = fsm_sBulkWriteAW;
          end
        end
      end
      fsm_sBulkReadAR : begin
        if(io_axi_ar_ready) begin
          fsm_stateNext = fsm_sBulkReadR;
        end
      end
      fsm_sBulkReadR : begin
        if(io_axi_r_valid) begin
          if(when_Ddr3MemtestEngine_l511) begin
            fsm_stateNext = fsm_sReportFail;
          end else begin
            if(when_Ddr3MemtestEngine_l515) begin
              if(when_Ddr3MemtestEngine_l516) begin
                fsm_stateNext = fsm_sReportPass;
              end else begin
                fsm_stateNext = fsm_sBulkReadAR;
              end
            end
          end
        end
      end
      fsm_sReportPass : begin
        if(canPrint) begin
          if(!when_Ddr3MemtestEngine_l556) begin
            fsm_stateNext = fsm_sLoopDelay;
          end
        end
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
        if(when_Ddr3MemtestEngine_l614) begin
          fsm_stateNext = fsm_sBulkWriteAW;
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_sBootBanner;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_BOOT;
    end
  end

  assign when_Ddr3MemtestEngine_l240 = (((io_pll_lock && io_init_done) && io_write_level_done) && io_read_calib_done);
  assign when_Ddr3MemtestEngine_l248 = (fsm_delayCounter == 28'h2435b6e);
  assign when_Ddr3MemtestEngine_l403 = ((! errorReg) && (io_axi_r_payload_data != 64'h0123456789abcdef));
  assign when_Ddr3MemtestEngine_l421 = ((! errorReg) && (io_axi_r_payload_data != 64'hfedcba9876543210));
  assign when_Ddr3MemtestEngine_l427 = (errorReg || (io_axi_r_payload_data != 64'hfedcba9876543210));
  assign when_Ddr3MemtestEngine_l459 = (beatIdx == 8'h7f);
  assign when_Ddr3MemtestEngine_l470 = (11'h400 <= _zz_when_Ddr3MemtestEngine_l470);
  assign _zz_errExpected = (beatIdx[0] ? {(beatBlockAddr ^ 32'h12345678),_zz__zz_errExpected} : {(beatBlockAddr ^ 32'h5aa55aa5),_zz__zz_errExpected_1});
  assign _zz_when_Ddr3MemtestEngine_l498 = (io_axi_r_payload_data != _zz_errExpected);
  assign when_Ddr3MemtestEngine_l498 = ((! errorReg) && _zz_when_Ddr3MemtestEngine_l498);
  assign when_Ddr3MemtestEngine_l511 = (errorReg || _zz_when_Ddr3MemtestEngine_l498);
  assign when_Ddr3MemtestEngine_l515 = (beatIdx == 8'h7f);
  assign when_Ddr3MemtestEngine_l516 = (11'h400 <= _zz_when_Ddr3MemtestEngine_l516);
  assign _zz_nextPrintChar = fsm_msgIndex[5:0];
  assign when_Ddr3MemtestEngine_l556 = (fsm_msgIndex < 7'h23);
  assign _zz_nextPrintChar_1 = fsm_msgIndex;
  assign when_Ddr3MemtestEngine_l601 = (fsm_msgIndex < 7'h4c);
  assign when_Ddr3MemtestEngine_l614 = (fsm_delayCounter == 28'h00b964f);
  always @(posedge clkoutd or posedge _zz_1) begin
    if(_zz_1) begin
      stageValid <= 1'b0;
      stageChar <= 8'h0;
      stageUseNib <= 1'b0;
      stageNib <= 4'b0000;
      printValid <= 1'b0;
      printChar <= 8'h0;
      passCount <= 16'h0;
      errorReg <= 1'b0;
      passReg <= 1'b0;
      errAddr <= 32'h0;
      errExpected <= 64'h0;
      errActual <= 64'h0;
      errActual1 <= 64'h0;
      hbCounter <= 25'h0;
      hbReg <= 1'b0;
      burstIndex <= 11'h0;
      beatIdx <= 8'h0;
      wrCycleCnt <= 32'h0;
      rdCycleCnt <= 32'h0;
      fsm_msgIndex <= 7'h0;
      fsm_delayCounter <= 28'h0;
      fsm_stateReg <= fsm_BOOT;
    end else begin
      stageValid <= nextPrintValid;
      stageChar <= nextPrintChar;
      stageUseNib <= nextUseNib;
      stageNib <= nextPrintNib;
      if(txStream_fire) begin
        printValid <= 1'b0;
      end
      if(stageValid) begin
        printChar <= (stageUseNib ? _zz_printChar : stageChar);
        printValid <= 1'b1;
      end
      hbCounter <= (hbCounter + 25'h0000001);
      if(when_Ddr3MemtestEngine_l104) begin
        hbReg <= (! hbReg);
      end
      fsm_stateReg <= fsm_stateNext;
      case(fsm_stateReg)
        fsm_sBootBanner : begin
          if(canPrint) begin
            case(fsm_msgIndex)
              7'h0 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h01 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h02 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h03 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h04 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h05 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h06 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h07 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h08 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h09 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0a : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0b : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0c : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0d : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0e : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0f : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h10 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h11 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h12 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h13 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              default : begin
                fsm_msgIndex <= 7'h0;
                fsm_delayCounter <= 28'h0;
              end
            endcase
          end
        end
        fsm_sWaitCalib : begin
          if(when_Ddr3MemtestEngine_l240) begin
            fsm_msgIndex <= 7'h0;
          end else begin
            fsm_delayCounter <= (fsm_delayCounter + 28'h0000001);
            if(when_Ddr3MemtestEngine_l248) begin
              fsm_delayCounter <= 28'h0;
              fsm_msgIndex <= 7'h0;
            end
          end
        end
        fsm_sPrintCalib : begin
          if(canPrint) begin
            case(fsm_msgIndex)
              7'h0 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h01 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h02 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h03 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h04 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h05 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h06 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h07 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h08 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h09 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0a : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0b : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0c : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0d : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0e : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              default : begin
                fsm_msgIndex <= 7'h0;
              end
            endcase
          end
        end
        fsm_sPrintBanner : begin
          if(canPrint) begin
            case(fsm_msgIndex)
              7'h0 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h01 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h02 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h03 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h04 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h05 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h06 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h07 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h08 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h09 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0a : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0b : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0c : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0d : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0e : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0f : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h10 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h11 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h12 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h13 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h14 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h15 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h16 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h17 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h18 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h19 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1a : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1b : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1c : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1d : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1e : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1f : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h20 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h21 : begin
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              default : begin
                fsm_msgIndex <= 7'h0;
              end
            endcase
          end
        end
        fsm_sSingleWriteAW : begin
        end
        fsm_sSingleWriteW0 : begin
        end
        fsm_sSingleWriteW1 : begin
        end
        fsm_sSingleWriteB : begin
        end
        fsm_sSingleReadAR : begin
        end
        fsm_sSingleReadR0 : begin
          if(io_axi_r_valid) begin
            if(when_Ddr3MemtestEngine_l403) begin
              errorReg <= 1'b1;
              errAddr <= 32'h0;
              errExpected <= 64'h0123456789abcdef;
              errActual <= io_axi_r_payload_data;
            end
          end
        end
        fsm_sSingleReadR1 : begin
          if(io_axi_r_valid) begin
            if(errorReg) begin
              errActual1 <= io_axi_r_payload_data;
            end
            if(when_Ddr3MemtestEngine_l421) begin
              errorReg <= 1'b1;
              errAddr <= 32'h00000008;
              errExpected <= 64'hfedcba9876543210;
              errActual <= io_axi_r_payload_data;
            end
            if(when_Ddr3MemtestEngine_l427) begin
              fsm_msgIndex <= 7'h0;
            end else begin
              burstIndex <= 11'h0;
              wrCycleCnt <= 32'h0;
              rdCycleCnt <= 32'h0;
            end
          end
        end
        fsm_sBulkWriteAW : begin
          wrCycleCnt <= (wrCycleCnt + 32'h00000001);
          if(io_axi_aw_ready) begin
            beatIdx <= 8'h0;
          end
        end
        fsm_sBulkWriteW : begin
          wrCycleCnt <= (wrCycleCnt + 32'h00000001);
          if(io_axi_w_ready) begin
            if(!when_Ddr3MemtestEngine_l459) begin
              beatIdx <= (beatIdx + 8'h01);
            end
          end
        end
        fsm_sBulkWriteB : begin
          wrCycleCnt <= (wrCycleCnt + 32'h00000001);
          if(io_axi_b_valid) begin
            if(when_Ddr3MemtestEngine_l470) begin
              burstIndex <= 11'h0;
              rdCycleCnt <= 32'h0;
            end else begin
              burstIndex <= (burstIndex + 11'h040);
            end
          end
        end
        fsm_sBulkReadAR : begin
          rdCycleCnt <= (rdCycleCnt + 32'h00000001);
          if(io_axi_ar_ready) begin
            beatIdx <= 8'h0;
          end
        end
        fsm_sBulkReadR : begin
          rdCycleCnt <= (rdCycleCnt + 32'h00000001);
          if(io_axi_r_valid) begin
            if(when_Ddr3MemtestEngine_l498) begin
              errorReg <= 1'b1;
              errAddr <= (beatBlockAddr + (beatIdx[0] ? 32'h00000008 : 32'h0));
              errExpected <= _zz_errExpected;
              errActual <= io_axi_r_payload_data;
            end
            if(when_Ddr3MemtestEngine_l511) begin
              fsm_msgIndex <= 7'h0;
            end else begin
              if(when_Ddr3MemtestEngine_l515) begin
                if(when_Ddr3MemtestEngine_l516) begin
                  fsm_msgIndex <= 7'h0;
                end else begin
                  burstIndex <= (burstIndex + 11'h040);
                end
              end else begin
                beatIdx <= (beatIdx + 8'h01);
              end
            end
          end
        end
        fsm_sReportPass : begin
          passReg <= 1'b1;
          if(canPrint) begin
            if(when_Ddr3MemtestEngine_l556) begin
              fsm_msgIndex <= (fsm_msgIndex + 7'h01);
            end else begin
              passCount <= (passCount + 16'h0001);
              fsm_delayCounter <= 28'h0;
            end
          end
        end
        fsm_sReportFail : begin
          if(canPrint) begin
            if(when_Ddr3MemtestEngine_l601) begin
              fsm_msgIndex <= (fsm_msgIndex + 7'h01);
            end
          end
        end
        fsm_sLoopDelay : begin
          fsm_delayCounter <= (fsm_delayCounter + 28'h0000001);
          if(when_Ddr3MemtestEngine_l614) begin
            burstIndex <= 11'h0;
            wrCycleCnt <= 32'h0;
            rdCycleCnt <= 32'h0;
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

module Ddr3Axi4 (
  input  wire          io_pclk,
  input  wire          io_fclk,
  input  wire          io_ck,
  input  wire          io_resetn,
  input  wire          io_axi_aw_valid,
  output wire          io_axi_aw_ready,
  input  wire [31:0]   io_axi_aw_payload_addr,
  input  wire [3:0]    io_axi_aw_payload_id,
  input  wire [3:0]    io_axi_aw_payload_region,
  input  wire [7:0]    io_axi_aw_payload_len,
  input  wire [2:0]    io_axi_aw_payload_size,
  input  wire [1:0]    io_axi_aw_payload_burst,
  input  wire [0:0]    io_axi_aw_payload_lock,
  input  wire [3:0]    io_axi_aw_payload_cache,
  input  wire [3:0]    io_axi_aw_payload_qos,
  input  wire [2:0]    io_axi_aw_payload_prot,
  input  wire          io_axi_w_valid,
  output wire          io_axi_w_ready,
  input  wire [63:0]   io_axi_w_payload_data,
  input  wire [7:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output wire          io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output wire [3:0]    io_axi_b_payload_id,
  output wire [1:0]    io_axi_b_payload_resp,
  input  wire          io_axi_ar_valid,
  output wire          io_axi_ar_ready,
  input  wire [31:0]   io_axi_ar_payload_addr,
  input  wire [3:0]    io_axi_ar_payload_id,
  input  wire [3:0]    io_axi_ar_payload_region,
  input  wire [7:0]    io_axi_ar_payload_len,
  input  wire [2:0]    io_axi_ar_payload_size,
  input  wire [1:0]    io_axi_ar_payload_burst,
  input  wire [0:0]    io_axi_ar_payload_lock,
  input  wire [3:0]    io_axi_ar_payload_cache,
  input  wire [3:0]    io_axi_ar_payload_qos,
  input  wire [2:0]    io_axi_ar_payload_prot,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [63:0]   io_axi_r_payload_data,
  output wire [3:0]    io_axi_r_payload_id,
  output wire [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  output wire          io_init_done,
  output wire          io_write_level_done,
  output wire          io_read_calib_done,
  output wire [7:0]    io_wstep,
  output wire [1:0]    io_rclkpos,
  output wire [2:0]    io_rclksel,
  output wire [2:0]    io_best_rot,
  output wire [3:0]    io_best_score,
  output wire [3:0]    io_dbg_state,
  inout  wire [15:0]   io_pad_DDR3_DQ,
  inout  wire [1:0]    io_pad_DDR3_DQS,
  output wire [1:0]    io_pad_DDR3_DM,
  output wire [13:0]   io_pad_DDR3_A,
  output wire [2:0]    io_pad_DDR3_BA,
  output wire          io_pad_DDR3_nRAS,
  output wire          io_pad_DDR3_nCAS,
  output wire          io_pad_DDR3_nWE,
  output wire          io_pad_DDR3_nCS,
  output wire          io_pad_DDR3_CK,
  output wire          io_pad_DDR3_CKE,
  output wire          io_pad_DDR3_nRESET,
  output wire          io_pad_DDR3_ODT
);

  wire                area_bridge_io_axi_ar_ready;
  wire                area_bridge_io_axi_aw_ready;
  wire                area_bridge_io_axi_w_ready;
  wire                area_bridge_io_axi_r_valid;
  wire       [63:0]   area_bridge_io_axi_r_payload_data;
  wire       [3:0]    area_bridge_io_axi_r_payload_id;
  wire       [1:0]    area_bridge_io_axi_r_payload_resp;
  wire                area_bridge_io_axi_r_payload_last;
  wire                area_bridge_io_axi_b_valid;
  wire       [3:0]    area_bridge_io_axi_b_payload_id;
  wire       [1:0]    area_bridge_io_axi_b_payload_resp;
  wire                area_bridge_io_req_valid;
  wire                area_bridge_io_req_payload_write;
  wire       [26:0]   area_bridge_io_req_payload_addr;
  wire       [127:0]  area_bridge_io_req_payload_wdata;
  wire       [15:0]   area_bridge_io_req_payload_wstrb;
  wire                area_ctrl_io_req_ready;
  wire                area_ctrl_io_rsp_valid;
  wire       [127:0]  area_ctrl_io_rsp_payload_rdata;
  wire                area_ctrl_io_init_done;
  wire                area_ctrl_io_write_level_done;
  wire                area_ctrl_io_read_calib_done;
  wire       [7:0]    area_ctrl_io_wstep;
  wire       [1:0]    area_ctrl_io_rclkpos;
  wire       [2:0]    area_ctrl_io_rclksel;
  wire       [2:0]    area_ctrl_io_best_rot;
  wire       [3:0]    area_ctrl_io_best_score;
  wire       [3:0]    area_ctrl_io_dbg_state;
  wire       [1:0]    area_ctrl_io_pad_DDR3_DM;
  wire       [13:0]   area_ctrl_io_pad_DDR3_A;
  wire       [2:0]    area_ctrl_io_pad_DDR3_BA;
  wire                area_ctrl_io_pad_DDR3_nRAS;
  wire                area_ctrl_io_pad_DDR3_nCAS;
  wire                area_ctrl_io_pad_DDR3_nWE;
  wire                area_ctrl_io_pad_DDR3_nCS;
  wire                area_ctrl_io_pad_DDR3_CK;
  wire                area_ctrl_io_pad_DDR3_CKE;
  wire                area_ctrl_io_pad_DDR3_nRESET;
  wire                area_ctrl_io_pad_DDR3_ODT;
  wire                _zz_1;

  Ddr3Axi4Bridge area_bridge (
    .io_axi_aw_valid          (io_axi_aw_valid                        ), //i
    .io_axi_aw_ready          (area_bridge_io_axi_aw_ready            ), //o
    .io_axi_aw_payload_addr   (io_axi_aw_payload_addr[31:0]           ), //i
    .io_axi_aw_payload_id     (io_axi_aw_payload_id[3:0]              ), //i
    .io_axi_aw_payload_region (io_axi_aw_payload_region[3:0]          ), //i
    .io_axi_aw_payload_len    (io_axi_aw_payload_len[7:0]             ), //i
    .io_axi_aw_payload_size   (io_axi_aw_payload_size[2:0]            ), //i
    .io_axi_aw_payload_burst  (io_axi_aw_payload_burst[1:0]           ), //i
    .io_axi_aw_payload_lock   (io_axi_aw_payload_lock                 ), //i
    .io_axi_aw_payload_cache  (io_axi_aw_payload_cache[3:0]           ), //i
    .io_axi_aw_payload_qos    (io_axi_aw_payload_qos[3:0]             ), //i
    .io_axi_aw_payload_prot   (io_axi_aw_payload_prot[2:0]            ), //i
    .io_axi_w_valid           (io_axi_w_valid                         ), //i
    .io_axi_w_ready           (area_bridge_io_axi_w_ready             ), //o
    .io_axi_w_payload_data    (io_axi_w_payload_data[63:0]            ), //i
    .io_axi_w_payload_strb    (io_axi_w_payload_strb[7:0]             ), //i
    .io_axi_w_payload_last    (io_axi_w_payload_last                  ), //i
    .io_axi_b_valid           (area_bridge_io_axi_b_valid             ), //o
    .io_axi_b_ready           (io_axi_b_ready                         ), //i
    .io_axi_b_payload_id      (area_bridge_io_axi_b_payload_id[3:0]   ), //o
    .io_axi_b_payload_resp    (area_bridge_io_axi_b_payload_resp[1:0] ), //o
    .io_axi_ar_valid          (io_axi_ar_valid                        ), //i
    .io_axi_ar_ready          (area_bridge_io_axi_ar_ready            ), //o
    .io_axi_ar_payload_addr   (io_axi_ar_payload_addr[31:0]           ), //i
    .io_axi_ar_payload_id     (io_axi_ar_payload_id[3:0]              ), //i
    .io_axi_ar_payload_region (io_axi_ar_payload_region[3:0]          ), //i
    .io_axi_ar_payload_len    (io_axi_ar_payload_len[7:0]             ), //i
    .io_axi_ar_payload_size   (io_axi_ar_payload_size[2:0]            ), //i
    .io_axi_ar_payload_burst  (io_axi_ar_payload_burst[1:0]           ), //i
    .io_axi_ar_payload_lock   (io_axi_ar_payload_lock                 ), //i
    .io_axi_ar_payload_cache  (io_axi_ar_payload_cache[3:0]           ), //i
    .io_axi_ar_payload_qos    (io_axi_ar_payload_qos[3:0]             ), //i
    .io_axi_ar_payload_prot   (io_axi_ar_payload_prot[2:0]            ), //i
    .io_axi_r_valid           (area_bridge_io_axi_r_valid             ), //o
    .io_axi_r_ready           (io_axi_r_ready                         ), //i
    .io_axi_r_payload_data    (area_bridge_io_axi_r_payload_data[63:0]), //o
    .io_axi_r_payload_id      (area_bridge_io_axi_r_payload_id[3:0]   ), //o
    .io_axi_r_payload_resp    (area_bridge_io_axi_r_payload_resp[1:0] ), //o
    .io_axi_r_payload_last    (area_bridge_io_axi_r_payload_last      ), //o
    .io_init_done             (area_ctrl_io_init_done                 ), //i
    .io_req_valid             (area_bridge_io_req_valid               ), //o
    .io_req_ready             (area_ctrl_io_req_ready                 ), //i
    .io_req_payload_write     (area_bridge_io_req_payload_write       ), //o
    .io_req_payload_addr      (area_bridge_io_req_payload_addr[26:0]  ), //o
    .io_req_payload_wdata     (area_bridge_io_req_payload_wdata[127:0]), //o
    .io_req_payload_wstrb     (area_bridge_io_req_payload_wstrb[15:0] ), //o
    .io_rsp_valid             (area_ctrl_io_rsp_valid                 ), //i
    .io_rsp_payload_rdata     (area_ctrl_io_rsp_payload_rdata[127:0]  ), //i
    .io_pclk                  (io_pclk                                ), //i
    ._zz_1                    (_zz_1                                  )  //i
  );
  Ddr3Controller area_ctrl (
    .io_pclk              (io_pclk                                ), //i
    .io_fclk              (io_fclk                                ), //i
    .io_ck                (io_ck                                  ), //i
    .io_resetn            (io_resetn                              ), //i
    .io_req_valid         (area_bridge_io_req_valid               ), //i
    .io_req_ready         (area_ctrl_io_req_ready                 ), //o
    .io_req_payload_write (area_bridge_io_req_payload_write       ), //i
    .io_req_payload_addr  (area_bridge_io_req_payload_addr[26:0]  ), //i
    .io_req_payload_wdata (area_bridge_io_req_payload_wdata[127:0]), //i
    .io_req_payload_wstrb (area_bridge_io_req_payload_wstrb[15:0] ), //i
    .io_rsp_valid         (area_ctrl_io_rsp_valid                 ), //o
    .io_rsp_payload_rdata (area_ctrl_io_rsp_payload_rdata[127:0]  ), //o
    .io_init_done         (area_ctrl_io_init_done                 ), //o
    .io_write_level_done  (area_ctrl_io_write_level_done          ), //o
    .io_read_calib_done   (area_ctrl_io_read_calib_done           ), //o
    .io_wstep             (area_ctrl_io_wstep[7:0]                ), //o
    .io_rclkpos           (area_ctrl_io_rclkpos[1:0]              ), //o
    .io_rclksel           (area_ctrl_io_rclksel[2:0]              ), //o
    .io_best_rot          (area_ctrl_io_best_rot[2:0]             ), //o
    .io_best_score        (area_ctrl_io_best_score[3:0]           ), //o
    .io_dbg_state         (area_ctrl_io_dbg_state[3:0]            ), //o
    .io_pad_DDR3_DQ       (io_pad_DDR3_DQ                         ), //~
    .io_pad_DDR3_DQS      (io_pad_DDR3_DQS                        ), //~
    .io_pad_DDR3_DM       (area_ctrl_io_pad_DDR3_DM[1:0]          ), //o
    .io_pad_DDR3_A        (area_ctrl_io_pad_DDR3_A[13:0]          ), //o
    .io_pad_DDR3_BA       (area_ctrl_io_pad_DDR3_BA[2:0]          ), //o
    .io_pad_DDR3_nRAS     (area_ctrl_io_pad_DDR3_nRAS             ), //o
    .io_pad_DDR3_nCAS     (area_ctrl_io_pad_DDR3_nCAS             ), //o
    .io_pad_DDR3_nWE      (area_ctrl_io_pad_DDR3_nWE              ), //o
    .io_pad_DDR3_nCS      (area_ctrl_io_pad_DDR3_nCS              ), //o
    .io_pad_DDR3_CK       (area_ctrl_io_pad_DDR3_CK               ), //o
    .io_pad_DDR3_CKE      (area_ctrl_io_pad_DDR3_CKE              ), //o
    .io_pad_DDR3_nRESET   (area_ctrl_io_pad_DDR3_nRESET           ), //o
    .io_pad_DDR3_ODT      (area_ctrl_io_pad_DDR3_ODT              )  //o
  );
  assign _zz_1 = (! io_resetn);
  assign io_pad_DDR3_DM = area_ctrl_io_pad_DDR3_DM;
  assign io_pad_DDR3_A = area_ctrl_io_pad_DDR3_A;
  assign io_pad_DDR3_BA = area_ctrl_io_pad_DDR3_BA;
  assign io_pad_DDR3_nRAS = area_ctrl_io_pad_DDR3_nRAS;
  assign io_pad_DDR3_nCAS = area_ctrl_io_pad_DDR3_nCAS;
  assign io_pad_DDR3_nWE = area_ctrl_io_pad_DDR3_nWE;
  assign io_pad_DDR3_nCS = area_ctrl_io_pad_DDR3_nCS;
  assign io_pad_DDR3_CK = area_ctrl_io_pad_DDR3_CK;
  assign io_pad_DDR3_CKE = area_ctrl_io_pad_DDR3_CKE;
  assign io_pad_DDR3_nRESET = area_ctrl_io_pad_DDR3_nRESET;
  assign io_pad_DDR3_ODT = area_ctrl_io_pad_DDR3_ODT;
  assign io_axi_aw_ready = area_bridge_io_axi_aw_ready;
  assign io_axi_w_ready = area_bridge_io_axi_w_ready;
  assign io_axi_b_valid = area_bridge_io_axi_b_valid;
  assign io_axi_b_payload_id = area_bridge_io_axi_b_payload_id;
  assign io_axi_b_payload_resp = area_bridge_io_axi_b_payload_resp;
  assign io_axi_ar_ready = area_bridge_io_axi_ar_ready;
  assign io_axi_r_valid = area_bridge_io_axi_r_valid;
  assign io_axi_r_payload_data = area_bridge_io_axi_r_payload_data;
  assign io_axi_r_payload_id = area_bridge_io_axi_r_payload_id;
  assign io_axi_r_payload_resp = area_bridge_io_axi_r_payload_resp;
  assign io_axi_r_payload_last = area_bridge_io_axi_r_payload_last;
  assign io_init_done = area_ctrl_io_init_done;
  assign io_write_level_done = area_ctrl_io_write_level_done;
  assign io_read_calib_done = area_ctrl_io_read_calib_done;
  assign io_wstep = area_ctrl_io_wstep;
  assign io_rclkpos = area_ctrl_io_rclkpos;
  assign io_rclksel = area_ctrl_io_rclksel;
  assign io_best_rot = area_ctrl_io_best_rot;
  assign io_best_score = area_ctrl_io_best_score;
  assign io_dbg_state = area_ctrl_io_dbg_state;

endmodule

module UartTx (
  input  wire          io_write_valid,
  output wire          io_write_ready,
  input  wire [7:0]    io_write_payload,
  output wire          io_txd,
  output wire          io_busy,
  input  wire          clkoutd,
  input  wire          _zz_1
);

  reg        [9:0]    bitCounter;
  wire                bitTick;
  reg        [3:0]    state;
  reg        [7:0]    shiftReg;
  reg                 txdReg;
  wire                when_UartTx_l40;

  assign bitTick = (bitCounter == 10'h292);
  assign io_busy = (state != 4'b0000);
  assign io_write_ready = (state == 4'b0000);
  assign io_txd = txdReg;
  assign when_UartTx_l40 = (state == 4'b0000);
  always @(posedge clkoutd or posedge _zz_1) begin
    if(_zz_1) begin
      bitCounter <= 10'h0;
      state <= 4'b0000;
      shiftReg <= 8'h0;
      txdReg <= 1'b1;
    end else begin
      if(bitTick) begin
        bitCounter <= 10'h0;
      end else begin
        bitCounter <= (bitCounter + 10'h001);
      end
      if(when_UartTx_l40) begin
        txdReg <= 1'b1;
        if(io_write_valid) begin
          shiftReg <= io_write_payload;
          state <= 4'b0001;
          bitCounter <= 10'h0;
        end
      end else begin
        if(bitTick) begin
          case(state)
            4'b0001 : begin
              txdReg <= 1'b0;
              state <= 4'b0010;
            end
            4'b0010 : begin
              txdReg <= shiftReg[0];
              state <= 4'b0011;
            end
            4'b0011 : begin
              txdReg <= shiftReg[1];
              state <= 4'b0100;
            end
            4'b0100 : begin
              txdReg <= shiftReg[2];
              state <= 4'b0101;
            end
            4'b0101 : begin
              txdReg <= shiftReg[3];
              state <= 4'b0110;
            end
            4'b0110 : begin
              txdReg <= shiftReg[4];
              state <= 4'b0111;
            end
            4'b0111 : begin
              txdReg <= shiftReg[5];
              state <= 4'b1000;
            end
            4'b1000 : begin
              txdReg <= shiftReg[6];
              state <= 4'b1001;
            end
            4'b1001 : begin
              txdReg <= shiftReg[7];
              state <= 4'b1010;
            end
            4'b1010 : begin
              txdReg <= 1'b1;
              state <= 4'b0000;
            end
            default : begin
            end
          endcase
        end
      end
    end
  end


endmodule

module Ddr3Controller (
  input  wire          io_pclk,
  input  wire          io_fclk,
  input  wire          io_ck,
  input  wire          io_resetn,
  input  wire          io_req_valid,
  output wire          io_req_ready,
  input  wire          io_req_payload_write,
  input  wire [26:0]   io_req_payload_addr,
  input  wire [127:0]  io_req_payload_wdata,
  input  wire [15:0]   io_req_payload_wstrb,
  output wire          io_rsp_valid,
  output wire [127:0]  io_rsp_payload_rdata,
  output wire          io_init_done,
  output wire          io_write_level_done,
  output wire          io_read_calib_done,
  output wire [7:0]    io_wstep,
  output wire [1:0]    io_rclkpos,
  output wire [2:0]    io_rclksel,
  output wire [2:0]    io_best_rot,
  output wire [3:0]    io_best_score,
  output wire [3:0]    io_dbg_state,
  inout  wire [15:0]   io_pad_DDR3_DQ,
  inout  wire [1:0]    io_pad_DDR3_DQS,
  output wire [1:0]    io_pad_DDR3_DM,
  output wire [13:0]   io_pad_DDR3_A,
  output wire [2:0]    io_pad_DDR3_BA,
  output wire          io_pad_DDR3_nRAS,
  output wire          io_pad_DDR3_nCAS,
  output wire          io_pad_DDR3_nWE,
  output wire          io_pad_DDR3_nCS,
  output wire          io_pad_DDR3_CK,
  output wire          io_pad_DDR3_CKE,
  output wire          io_pad_DDR3_nRESET,
  output wire          io_pad_DDR3_ODT
);

  wire                coreArea_core_io_req_ready;
  wire                coreArea_core_io_rsp_valid;
  wire       [127:0]  coreArea_core_io_rsp_payload_rdata;
  wire                coreArea_core_io_init_done;
  wire                coreArea_core_io_write_level_done;
  wire                coreArea_core_io_read_calib_done;
  wire       [7:0]    coreArea_core_io_wstep;
  wire       [1:0]    coreArea_core_io_rclkpos;
  wire       [2:0]    coreArea_core_io_rclksel;
  wire       [2:0]    coreArea_core_io_best_rot;
  wire       [3:0]    coreArea_core_io_best_score;
  wire       [3:0]    coreArea_core_io_dbg_state;
  wire                coreArea_core_io_phy_dqs_hold;
  wire       [7:0]    coreArea_core_io_phy_wstep;
  wire                coreArea_core_io_phy_rloadn;
  wire                coreArea_core_io_phy_rmove;
  wire                coreArea_core_io_phy_rdir;
  wire       [1:0]    coreArea_core_io_phy_rclkpos;
  wire       [2:0]    coreArea_core_io_phy_rclksel;
  wire       [3:0]    coreArea_core_io_phy_dqs_read;
  wire       [15:0]   coreArea_core_io_phy_dq_out_0;
  wire       [15:0]   coreArea_core_io_phy_dq_out_1;
  wire       [15:0]   coreArea_core_io_phy_dq_out_2;
  wire       [15:0]   coreArea_core_io_phy_dq_out_3;
  wire       [15:0]   coreArea_core_io_phy_dq_out_4;
  wire       [15:0]   coreArea_core_io_phy_dq_out_5;
  wire       [15:0]   coreArea_core_io_phy_dq_out_6;
  wire       [15:0]   coreArea_core_io_phy_dq_out_7;
  wire       [3:0]    coreArea_core_io_phy_dq_oen;
  wire       [7:0]    coreArea_core_io_phy_dqs_out;
  wire       [3:0]    coreArea_core_io_phy_dqs_oen;
  wire       [7:0]    coreArea_core_io_phy_dm_out;
  wire                coreArea_core_io_phy_nRAS_0;
  wire                coreArea_core_io_phy_nRAS_1;
  wire                coreArea_core_io_phy_nRAS_2;
  wire                coreArea_core_io_phy_nRAS_3;
  wire                coreArea_core_io_phy_nCAS_0;
  wire                coreArea_core_io_phy_nCAS_1;
  wire                coreArea_core_io_phy_nCAS_2;
  wire                coreArea_core_io_phy_nCAS_3;
  wire                coreArea_core_io_phy_nWE_0;
  wire                coreArea_core_io_phy_nWE_1;
  wire                coreArea_core_io_phy_nWE_2;
  wire                coreArea_core_io_phy_nWE_3;
  wire       [13:0]   coreArea_core_io_phy_A_0;
  wire       [13:0]   coreArea_core_io_phy_A_1;
  wire       [13:0]   coreArea_core_io_phy_A_2;
  wire       [13:0]   coreArea_core_io_phy_A_3;
  wire       [2:0]    coreArea_core_io_phy_BA_0;
  wire       [2:0]    coreArea_core_io_phy_BA_1;
  wire       [2:0]    coreArea_core_io_phy_BA_2;
  wire       [2:0]    coreArea_core_io_phy_BA_3;
  wire                coreArea_core_io_phy_CKE;
  wire                coreArea_core_io_phy_resetn_delay;
  wire                coreArea_core_io_phy_wser_rst;
  wire                phy_io_dlllock;
  wire                phy_io_rst_lock_n;
  wire       [1:0]    phy_io_rburst;
  wire       [1:0]    phy_io_rvalid;
  wire       [2:0]    phy_io_wpoint_0;
  wire       [2:0]    phy_io_wpoint_1;
  wire       [2:0]    phy_io_rpoint_0;
  wire       [2:0]    phy_io_rpoint_1;
  wire       [15:0]   phy_io_dq_in_0;
  wire       [15:0]   phy_io_dq_in_1;
  wire       [15:0]   phy_io_dq_in_2;
  wire       [15:0]   phy_io_dq_in_3;
  wire       [15:0]   phy_io_dq_in_4;
  wire       [15:0]   phy_io_dq_in_5;
  wire       [15:0]   phy_io_dq_in_6;
  wire       [15:0]   phy_io_dq_in_7;
  wire       [15:0]   phy_io_dq_raw;
  wire       [1:0]    phy_io_pad_DDR3_DM;
  wire       [13:0]   phy_io_pad_DDR3_A;
  wire       [2:0]    phy_io_pad_DDR3_BA;
  wire                phy_io_pad_DDR3_nRAS;
  wire                phy_io_pad_DDR3_nCAS;
  wire                phy_io_pad_DDR3_nWE;
  wire                phy_io_pad_DDR3_nCS;
  wire                phy_io_pad_DDR3_CK;
  wire                phy_io_pad_DDR3_CKE;
  wire                phy_io_pad_DDR3_nRESET;
  wire                phy_io_pad_DDR3_ODT;
  wire                _zz_when_Ddr3ControllerCore_l1997;

  Ddr3ControllerCore coreArea_core (
    .io_req_valid                      (io_req_valid                             ), //i
    .io_req_ready                      (coreArea_core_io_req_ready               ), //o
    .io_req_payload_write              (io_req_payload_write                     ), //i
    .io_req_payload_addr               (io_req_payload_addr[26:0]                ), //i
    .io_req_payload_wdata              (io_req_payload_wdata[127:0]              ), //i
    .io_req_payload_wstrb              (io_req_payload_wstrb[15:0]               ), //i
    .io_rsp_valid                      (coreArea_core_io_rsp_valid               ), //o
    .io_rsp_payload_rdata              (coreArea_core_io_rsp_payload_rdata[127:0]), //o
    .io_init_done                      (coreArea_core_io_init_done               ), //o
    .io_write_level_done               (coreArea_core_io_write_level_done        ), //o
    .io_read_calib_done                (coreArea_core_io_read_calib_done         ), //o
    .io_wstep                          (coreArea_core_io_wstep[7:0]              ), //o
    .io_rclkpos                        (coreArea_core_io_rclkpos[1:0]            ), //o
    .io_rclksel                        (coreArea_core_io_rclksel[2:0]            ), //o
    .io_best_rot                       (coreArea_core_io_best_rot[2:0]           ), //o
    .io_best_score                     (coreArea_core_io_best_score[3:0]         ), //o
    .io_dbg_state                      (coreArea_core_io_dbg_state[3:0]          ), //o
    .io_phy_dlllock                    (phy_io_dlllock                           ), //i
    .io_phy_rst_lock_n                 (phy_io_rst_lock_n                        ), //i
    .io_phy_rburst                     (phy_io_rburst[1:0]                       ), //i
    .io_phy_rvalid                     (phy_io_rvalid[1:0]                       ), //i
    .io_phy_wpoint_0                   (phy_io_wpoint_0[2:0]                     ), //i
    .io_phy_wpoint_1                   (phy_io_wpoint_1[2:0]                     ), //i
    .io_phy_rpoint_0                   (phy_io_rpoint_0[2:0]                     ), //i
    .io_phy_rpoint_1                   (phy_io_rpoint_1[2:0]                     ), //i
    .io_phy_dq_in_0                    (phy_io_dq_in_0[15:0]                     ), //i
    .io_phy_dq_in_1                    (phy_io_dq_in_1[15:0]                     ), //i
    .io_phy_dq_in_2                    (phy_io_dq_in_2[15:0]                     ), //i
    .io_phy_dq_in_3                    (phy_io_dq_in_3[15:0]                     ), //i
    .io_phy_dq_in_4                    (phy_io_dq_in_4[15:0]                     ), //i
    .io_phy_dq_in_5                    (phy_io_dq_in_5[15:0]                     ), //i
    .io_phy_dq_in_6                    (phy_io_dq_in_6[15:0]                     ), //i
    .io_phy_dq_in_7                    (phy_io_dq_in_7[15:0]                     ), //i
    .io_phy_dq_raw                     (phy_io_dq_raw[15:0]                      ), //i
    .io_phy_dqs_hold                   (coreArea_core_io_phy_dqs_hold            ), //o
    .io_phy_wstep                      (coreArea_core_io_phy_wstep[7:0]          ), //o
    .io_phy_rloadn                     (coreArea_core_io_phy_rloadn              ), //o
    .io_phy_rmove                      (coreArea_core_io_phy_rmove               ), //o
    .io_phy_rdir                       (coreArea_core_io_phy_rdir                ), //o
    .io_phy_rclkpos                    (coreArea_core_io_phy_rclkpos[1:0]        ), //o
    .io_phy_rclksel                    (coreArea_core_io_phy_rclksel[2:0]        ), //o
    .io_phy_dqs_read                   (coreArea_core_io_phy_dqs_read[3:0]       ), //o
    .io_phy_dq_out_0                   (coreArea_core_io_phy_dq_out_0[15:0]      ), //o
    .io_phy_dq_out_1                   (coreArea_core_io_phy_dq_out_1[15:0]      ), //o
    .io_phy_dq_out_2                   (coreArea_core_io_phy_dq_out_2[15:0]      ), //o
    .io_phy_dq_out_3                   (coreArea_core_io_phy_dq_out_3[15:0]      ), //o
    .io_phy_dq_out_4                   (coreArea_core_io_phy_dq_out_4[15:0]      ), //o
    .io_phy_dq_out_5                   (coreArea_core_io_phy_dq_out_5[15:0]      ), //o
    .io_phy_dq_out_6                   (coreArea_core_io_phy_dq_out_6[15:0]      ), //o
    .io_phy_dq_out_7                   (coreArea_core_io_phy_dq_out_7[15:0]      ), //o
    .io_phy_dq_oen                     (coreArea_core_io_phy_dq_oen[3:0]         ), //o
    .io_phy_dqs_out                    (coreArea_core_io_phy_dqs_out[7:0]        ), //o
    .io_phy_dqs_oen                    (coreArea_core_io_phy_dqs_oen[3:0]        ), //o
    .io_phy_dm_out                     (coreArea_core_io_phy_dm_out[7:0]         ), //o
    .io_phy_nRAS_0                     (coreArea_core_io_phy_nRAS_0              ), //o
    .io_phy_nRAS_1                     (coreArea_core_io_phy_nRAS_1              ), //o
    .io_phy_nRAS_2                     (coreArea_core_io_phy_nRAS_2              ), //o
    .io_phy_nRAS_3                     (coreArea_core_io_phy_nRAS_3              ), //o
    .io_phy_nCAS_0                     (coreArea_core_io_phy_nCAS_0              ), //o
    .io_phy_nCAS_1                     (coreArea_core_io_phy_nCAS_1              ), //o
    .io_phy_nCAS_2                     (coreArea_core_io_phy_nCAS_2              ), //o
    .io_phy_nCAS_3                     (coreArea_core_io_phy_nCAS_3              ), //o
    .io_phy_nWE_0                      (coreArea_core_io_phy_nWE_0               ), //o
    .io_phy_nWE_1                      (coreArea_core_io_phy_nWE_1               ), //o
    .io_phy_nWE_2                      (coreArea_core_io_phy_nWE_2               ), //o
    .io_phy_nWE_3                      (coreArea_core_io_phy_nWE_3               ), //o
    .io_phy_A_0                        (coreArea_core_io_phy_A_0[13:0]           ), //o
    .io_phy_A_1                        (coreArea_core_io_phy_A_1[13:0]           ), //o
    .io_phy_A_2                        (coreArea_core_io_phy_A_2[13:0]           ), //o
    .io_phy_A_3                        (coreArea_core_io_phy_A_3[13:0]           ), //o
    .io_phy_BA_0                       (coreArea_core_io_phy_BA_0[2:0]           ), //o
    .io_phy_BA_1                       (coreArea_core_io_phy_BA_1[2:0]           ), //o
    .io_phy_BA_2                       (coreArea_core_io_phy_BA_2[2:0]           ), //o
    .io_phy_BA_3                       (coreArea_core_io_phy_BA_3[2:0]           ), //o
    .io_phy_CKE                        (coreArea_core_io_phy_CKE                 ), //o
    .io_phy_resetn_delay               (coreArea_core_io_phy_resetn_delay        ), //o
    .io_phy_wser_rst                   (coreArea_core_io_phy_wser_rst            ), //o
    ._zz_when_Ddr3ControllerCore_l1997 (_zz_when_Ddr3ControllerCore_l1997        ), //i
    .io_pclk                           (io_pclk                                  )  //i
  );
  GowinDdr3Phy phy (
    .io_pclk            (io_pclk                            ), //i
    .io_fclk            (io_fclk                            ), //i
    .io_ck              (io_ck                              ), //i
    .io_resetn          (io_resetn                          ), //i
    .io_dqs_hold        (coreArea_core_io_phy_dqs_hold      ), //i
    .io_wstep           (coreArea_core_io_phy_wstep[7:0]    ), //i
    .io_rloadn          (coreArea_core_io_phy_rloadn        ), //i
    .io_rmove           (coreArea_core_io_phy_rmove         ), //i
    .io_rdir            (coreArea_core_io_phy_rdir          ), //i
    .io_rclkpos         (coreArea_core_io_phy_rclkpos[1:0]  ), //i
    .io_rclksel         (coreArea_core_io_phy_rclksel[2:0]  ), //i
    .io_dqs_read        (coreArea_core_io_phy_dqs_read[3:0] ), //i
    .io_dq_out_0        (coreArea_core_io_phy_dq_out_0[15:0]), //i
    .io_dq_out_1        (coreArea_core_io_phy_dq_out_1[15:0]), //i
    .io_dq_out_2        (coreArea_core_io_phy_dq_out_2[15:0]), //i
    .io_dq_out_3        (coreArea_core_io_phy_dq_out_3[15:0]), //i
    .io_dq_out_4        (coreArea_core_io_phy_dq_out_4[15:0]), //i
    .io_dq_out_5        (coreArea_core_io_phy_dq_out_5[15:0]), //i
    .io_dq_out_6        (coreArea_core_io_phy_dq_out_6[15:0]), //i
    .io_dq_out_7        (coreArea_core_io_phy_dq_out_7[15:0]), //i
    .io_dq_oen          (coreArea_core_io_phy_dq_oen[3:0]   ), //i
    .io_dqs_out         (coreArea_core_io_phy_dqs_out[7:0]  ), //i
    .io_dqs_oen         (coreArea_core_io_phy_dqs_oen[3:0]  ), //i
    .io_dm_out          (coreArea_core_io_phy_dm_out[7:0]   ), //i
    .io_nRAS_0          (coreArea_core_io_phy_nRAS_0        ), //i
    .io_nRAS_1          (coreArea_core_io_phy_nRAS_1        ), //i
    .io_nRAS_2          (coreArea_core_io_phy_nRAS_2        ), //i
    .io_nRAS_3          (coreArea_core_io_phy_nRAS_3        ), //i
    .io_nCAS_0          (coreArea_core_io_phy_nCAS_0        ), //i
    .io_nCAS_1          (coreArea_core_io_phy_nCAS_1        ), //i
    .io_nCAS_2          (coreArea_core_io_phy_nCAS_2        ), //i
    .io_nCAS_3          (coreArea_core_io_phy_nCAS_3        ), //i
    .io_nWE_0           (coreArea_core_io_phy_nWE_0         ), //i
    .io_nWE_1           (coreArea_core_io_phy_nWE_1         ), //i
    .io_nWE_2           (coreArea_core_io_phy_nWE_2         ), //i
    .io_nWE_3           (coreArea_core_io_phy_nWE_3         ), //i
    .io_A_0             (coreArea_core_io_phy_A_0[13:0]     ), //i
    .io_A_1             (coreArea_core_io_phy_A_1[13:0]     ), //i
    .io_A_2             (coreArea_core_io_phy_A_2[13:0]     ), //i
    .io_A_3             (coreArea_core_io_phy_A_3[13:0]     ), //i
    .io_BA_0            (coreArea_core_io_phy_BA_0[2:0]     ), //i
    .io_BA_1            (coreArea_core_io_phy_BA_1[2:0]     ), //i
    .io_BA_2            (coreArea_core_io_phy_BA_2[2:0]     ), //i
    .io_BA_3            (coreArea_core_io_phy_BA_3[2:0]     ), //i
    .io_CKE             (coreArea_core_io_phy_CKE           ), //i
    .io_resetn_delay    (coreArea_core_io_phy_resetn_delay  ), //i
    .io_wser_rst        (coreArea_core_io_phy_wser_rst      ), //i
    .io_dlllock         (phy_io_dlllock                     ), //o
    .io_rst_lock_n      (phy_io_rst_lock_n                  ), //o
    .io_rburst          (phy_io_rburst[1:0]                 ), //o
    .io_rvalid          (phy_io_rvalid[1:0]                 ), //o
    .io_wpoint_0        (phy_io_wpoint_0[2:0]               ), //o
    .io_wpoint_1        (phy_io_wpoint_1[2:0]               ), //o
    .io_rpoint_0        (phy_io_rpoint_0[2:0]               ), //o
    .io_rpoint_1        (phy_io_rpoint_1[2:0]               ), //o
    .io_dq_in_0         (phy_io_dq_in_0[15:0]               ), //o
    .io_dq_in_1         (phy_io_dq_in_1[15:0]               ), //o
    .io_dq_in_2         (phy_io_dq_in_2[15:0]               ), //o
    .io_dq_in_3         (phy_io_dq_in_3[15:0]               ), //o
    .io_dq_in_4         (phy_io_dq_in_4[15:0]               ), //o
    .io_dq_in_5         (phy_io_dq_in_5[15:0]               ), //o
    .io_dq_in_6         (phy_io_dq_in_6[15:0]               ), //o
    .io_dq_in_7         (phy_io_dq_in_7[15:0]               ), //o
    .io_dq_raw          (phy_io_dq_raw[15:0]                ), //o
    .io_pad_DDR3_DQ     (io_pad_DDR3_DQ                     ), //~
    .io_pad_DDR3_DQS    (io_pad_DDR3_DQS                    ), //~
    .io_pad_DDR3_DM     (phy_io_pad_DDR3_DM[1:0]            ), //o
    .io_pad_DDR3_A      (phy_io_pad_DDR3_A[13:0]            ), //o
    .io_pad_DDR3_BA     (phy_io_pad_DDR3_BA[2:0]            ), //o
    .io_pad_DDR3_nRAS   (phy_io_pad_DDR3_nRAS               ), //o
    .io_pad_DDR3_nCAS   (phy_io_pad_DDR3_nCAS               ), //o
    .io_pad_DDR3_nWE    (phy_io_pad_DDR3_nWE                ), //o
    .io_pad_DDR3_nCS    (phy_io_pad_DDR3_nCS                ), //o
    .io_pad_DDR3_CK     (phy_io_pad_DDR3_CK                 ), //o
    .io_pad_DDR3_CKE    (phy_io_pad_DDR3_CKE                ), //o
    .io_pad_DDR3_nRESET (phy_io_pad_DDR3_nRESET             ), //o
    .io_pad_DDR3_ODT    (phy_io_pad_DDR3_ODT                )  //o
  );
  assign _zz_when_Ddr3ControllerCore_l1997 = (! io_resetn);
  assign io_pad_DDR3_DM = phy_io_pad_DDR3_DM;
  assign io_pad_DDR3_A = phy_io_pad_DDR3_A;
  assign io_pad_DDR3_BA = phy_io_pad_DDR3_BA;
  assign io_pad_DDR3_nRAS = phy_io_pad_DDR3_nRAS;
  assign io_pad_DDR3_nCAS = phy_io_pad_DDR3_nCAS;
  assign io_pad_DDR3_nWE = phy_io_pad_DDR3_nWE;
  assign io_pad_DDR3_nCS = phy_io_pad_DDR3_nCS;
  assign io_pad_DDR3_CK = phy_io_pad_DDR3_CK;
  assign io_pad_DDR3_CKE = phy_io_pad_DDR3_CKE;
  assign io_pad_DDR3_nRESET = phy_io_pad_DDR3_nRESET;
  assign io_pad_DDR3_ODT = phy_io_pad_DDR3_ODT;
  assign io_req_ready = coreArea_core_io_req_ready;
  assign io_rsp_valid = coreArea_core_io_rsp_valid;
  assign io_rsp_payload_rdata = coreArea_core_io_rsp_payload_rdata;
  assign io_init_done = coreArea_core_io_init_done;
  assign io_write_level_done = coreArea_core_io_write_level_done;
  assign io_read_calib_done = coreArea_core_io_read_calib_done;
  assign io_wstep = coreArea_core_io_wstep;
  assign io_rclkpos = coreArea_core_io_rclkpos;
  assign io_rclksel = coreArea_core_io_rclksel;
  assign io_best_rot = coreArea_core_io_best_rot;
  assign io_best_score = coreArea_core_io_best_score;
  assign io_dbg_state = coreArea_core_io_dbg_state;

endmodule

module Ddr3Axi4Bridge (
  input  wire          io_axi_aw_valid,
  output wire          io_axi_aw_ready,
  input  wire [31:0]   io_axi_aw_payload_addr,
  input  wire [3:0]    io_axi_aw_payload_id,
  input  wire [3:0]    io_axi_aw_payload_region,
  input  wire [7:0]    io_axi_aw_payload_len,
  input  wire [2:0]    io_axi_aw_payload_size,
  input  wire [1:0]    io_axi_aw_payload_burst,
  input  wire [0:0]    io_axi_aw_payload_lock,
  input  wire [3:0]    io_axi_aw_payload_cache,
  input  wire [3:0]    io_axi_aw_payload_qos,
  input  wire [2:0]    io_axi_aw_payload_prot,
  input  wire          io_axi_w_valid,
  output wire          io_axi_w_ready,
  input  wire [63:0]   io_axi_w_payload_data,
  input  wire [7:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output wire          io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output wire [3:0]    io_axi_b_payload_id,
  output wire [1:0]    io_axi_b_payload_resp,
  input  wire          io_axi_ar_valid,
  output wire          io_axi_ar_ready,
  input  wire [31:0]   io_axi_ar_payload_addr,
  input  wire [3:0]    io_axi_ar_payload_id,
  input  wire [3:0]    io_axi_ar_payload_region,
  input  wire [7:0]    io_axi_ar_payload_len,
  input  wire [2:0]    io_axi_ar_payload_size,
  input  wire [1:0]    io_axi_ar_payload_burst,
  input  wire [0:0]    io_axi_ar_payload_lock,
  input  wire [3:0]    io_axi_ar_payload_cache,
  input  wire [3:0]    io_axi_ar_payload_qos,
  input  wire [2:0]    io_axi_ar_payload_prot,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [63:0]   io_axi_r_payload_data,
  output wire [3:0]    io_axi_r_payload_id,
  output wire [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  input  wire          io_init_done,
  output wire          io_req_valid,
  input  wire          io_req_ready,
  output wire          io_req_payload_write,
  output wire [26:0]   io_req_payload_addr,
  output wire [127:0]  io_req_payload_wdata,
  output wire [15:0]   io_req_payload_wstrb,
  input  wire          io_rsp_valid,
  input  wire [127:0]  io_rsp_payload_rdata,
  input  wire          io_pclk,
  input  wire          _zz_1
);
  localparam BridgeMode_IDLE = 2'd0;
  localparam BridgeMode_READ = 2'd1;
  localparam BridgeMode_WRITE = 2'd2;

  wire                rFifo_io_push_valid;
  reg                 rFifo_io_pop_ready;
  reg                 wFifo_io_push_valid;
  reg        [127:0]  wFifo_io_push_payload_data;
  reg        [15:0]   wFifo_io_push_payload_strb;
  wire                wFifo_io_pop_ready;
  wire                rFifo_io_push_ready;
  wire                rFifo_io_pop_valid;
  wire       [127:0]  rFifo_io_pop_payload;
  wire       [4:0]    rFifo_io_occupancy;
  wire                wFifo_io_push_ready;
  wire                wFifo_io_pop_valid;
  wire       [127:0]  wFifo_io_pop_payload_data;
  wire       [15:0]   wFifo_io_pop_payload_strb;
  wire       [4:0]    wFifo_io_occupancy;
  wire       [8:0]    _zz_when_Ddr3Axi4Bridge_l102;
  wire       [4:0]    _zz_when_Ddr3Axi4Bridge_l102_1;
  wire       [27:0]   _zz_outReq_payload_addr;
  wire       [27:0]   _zz_outReq_payload_addr_1;
  wire       [27:0]   _zz_outReq_payload_addr_2;
  wire       [4:0]    _zz_rSlotsUsed;
  wire       [4:0]    _zz_rSlotsUsed_1;
  wire       [0:0]    _zz_rSlotsUsed_2;
  wire       [4:0]    _zz_rSlotsUsed_3;
  wire       [0:0]    _zz_rSlotsUsed_4;
  wire       [8:0]    _zz_wPendingBlks;
  wire       [8:0]    _zz_wPendingBlks_1;
  wire       [0:0]    _zz_wPendingBlks_2;
  wire       [8:0]    _zz_wPendingBlks_3;
  wire       [0:0]    _zz_wPendingBlks_4;
  wire       [8:0]    _zz__zz_rCmdLeft;
  wire       [7:0]    _zz_rCmdLeft_1;
  wire       [8:0]    _zz_rCmdLeft_2;
  wire       [8:0]    _zz_rCmdLeft_3;
  wire       [8:0]    _zz_rCmdLeft_4;
  wire       [0:0]    _zz_rCmdLeft_5;
  wire                outReq_valid;
  wire                outReq_ready;
  wire                outReq_payload_write;
  wire       [26:0]   outReq_payload_addr;
  wire       [127:0]  outReq_payload_wdata;
  wire       [15:0]   outReq_payload_wstrb;
  wire                outReq_s2mPipe_valid;
  reg                 outReq_s2mPipe_ready;
  wire                outReq_s2mPipe_payload_write;
  wire       [26:0]   outReq_s2mPipe_payload_addr;
  wire       [127:0]  outReq_s2mPipe_payload_wdata;
  wire       [15:0]   outReq_s2mPipe_payload_wstrb;
  reg                 outReq_rValidN;
  reg                 outReq_rData_write;
  reg        [26:0]   outReq_rData_addr;
  reg        [127:0]  outReq_rData_wdata;
  reg        [15:0]   outReq_rData_wstrb;
  wire                outReq_s2mPipe_m2sPipe_valid;
  wire                outReq_s2mPipe_m2sPipe_ready;
  wire                outReq_s2mPipe_m2sPipe_payload_write;
  wire       [26:0]   outReq_s2mPipe_m2sPipe_payload_addr;
  wire       [127:0]  outReq_s2mPipe_m2sPipe_payload_wdata;
  wire       [15:0]   outReq_s2mPipe_m2sPipe_payload_wstrb;
  reg                 outReq_s2mPipe_rValid;
  reg                 outReq_s2mPipe_rData_write;
  reg        [26:0]   outReq_s2mPipe_rData_addr;
  reg        [127:0]  outReq_s2mPipe_rData_wdata;
  reg        [15:0]   outReq_s2mPipe_rData_wstrb;
  wire                when_Stream_l477;
  reg        [1:0]    mode;
  reg        [31:0]   rReqAddr;
  reg                 rIncr;
  reg        [8:0]    rCmdLeft;
  reg        [4:0]    rSlotsUsed;
  reg                 rIssuingChunk;
  reg        [3:0]    rId;
  reg        [8:0]    rBeatsLeft;
  reg                 rPhase64;
  reg                 rValidReg;
  reg        [63:0]   rOutData;
  reg                 rLastReg;
  wire                rConsume;
  wire                when_Ddr3Axi4Bridge_l68;
  wire                when_Ddr3Axi4Bridge_l73;
  wire       [8:0]    _zz_rBeatsLeft;
  wire                when_Ddr3Axi4Bridge_l83;
  wire                when_Ddr3Axi4Bridge_l85;
  wire                when_Ddr3Axi4Bridge_l100;
  wire                when_Ddr3Axi4Bridge_l101;
  wire                when_Ddr3Axi4Bridge_l102;
  wire                when_Ddr3Axi4Bridge_l106;
  wire                rdReqValid;
  reg        [31:0]   wReqAddr;
  reg                 wIncr;
  reg        [3:0]    wId;
  reg        [127:0]  wAsmData;
  reg        [15:0]   wAsmStrb;
  reg                 wPhase64;
  reg                 wLastSeen;
  reg                 wBValidReg;
  reg                 wDraining;
  reg        [8:0]    wPendingBlks;
  wire                when_Ddr3Axi4Bridge_l143;
  wire                when_Ddr3Axi4Bridge_l152;
  wire                when_Ddr3Axi4Bridge_l178;
  wire                when_Ddr3Axi4Bridge_l179;
  wire                when_Ddr3Axi4Bridge_l180;
  wire                when_Ddr3Axi4Bridge_l184;
  wire                wrReqValid;
  wire                rdSlotInc;
  wire                rdSlotDec;
  wire                wBlkInc;
  wire                wBlkDec;
  wire                when_Ddr3Axi4Bridge_l226;
  wire                when_Ddr3Axi4Bridge_l233;
  wire                when_Ddr3Axi4Bridge_l242;
  wire       [8:0]    _zz_rCmdLeft;
  wire                when_Ddr3Axi4Bridge_l253;
  wire                when_Ddr3Axi4Bridge_l272;
  wire                when_Ddr3Axi4Bridge_l278;
  wire                when_Ddr3Axi4Bridge_l281;
  `ifndef SYNTHESIS
  reg [39:0] mode_string;
  `endif


  assign _zz_when_Ddr3Axi4Bridge_l102_1 = (5'h10 - rSlotsUsed);
  assign _zz_when_Ddr3Axi4Bridge_l102 = {4'd0, _zz_when_Ddr3Axi4Bridge_l102_1};
  assign _zz_outReq_payload_addr = ((mode == BridgeMode_WRITE) ? _zz_outReq_payload_addr_1 : _zz_outReq_payload_addr_2);
  assign _zz_outReq_payload_addr_1 = (wReqAddr >>> 3'd4);
  assign _zz_outReq_payload_addr_2 = (rReqAddr >>> 3'd4);
  assign _zz_rSlotsUsed = (rSlotsUsed + _zz_rSlotsUsed_1);
  assign _zz_rSlotsUsed_2 = rdSlotInc;
  assign _zz_rSlotsUsed_1 = {4'd0, _zz_rSlotsUsed_2};
  assign _zz_rSlotsUsed_4 = rdSlotDec;
  assign _zz_rSlotsUsed_3 = {4'd0, _zz_rSlotsUsed_4};
  assign _zz_wPendingBlks = (wPendingBlks + _zz_wPendingBlks_1);
  assign _zz_wPendingBlks_2 = wBlkInc;
  assign _zz_wPendingBlks_1 = {8'd0, _zz_wPendingBlks_2};
  assign _zz_wPendingBlks_4 = wBlkDec;
  assign _zz_wPendingBlks_3 = {8'd0, _zz_wPendingBlks_4};
  assign _zz__zz_rCmdLeft = {1'd0, io_axi_ar_payload_len};
  assign _zz_rCmdLeft_1 = (_zz_rCmdLeft_2 >>> 1'd1);
  assign _zz_rCmdLeft_2 = (_zz_rCmdLeft_3 + 9'h001);
  assign _zz_rCmdLeft_3 = (_zz_rCmdLeft_4 + _zz_rCmdLeft);
  assign _zz_rCmdLeft_5 = io_axi_ar_payload_addr[3];
  assign _zz_rCmdLeft_4 = {8'd0, _zz_rCmdLeft_5};
  DistLowLatencyFifo rFifo (
    .io_push_valid   (rFifo_io_push_valid        ), //i
    .io_push_ready   (rFifo_io_push_ready        ), //o
    .io_push_payload (io_rsp_payload_rdata[127:0]), //i
    .io_pop_valid    (rFifo_io_pop_valid         ), //o
    .io_pop_ready    (rFifo_io_pop_ready         ), //i
    .io_pop_payload  (rFifo_io_pop_payload[127:0]), //o
    .io_occupancy    (rFifo_io_occupancy[4:0]    ), //o
    .io_pclk         (io_pclk                    ), //i
    ._zz_4           (_zz_1                      )  //i
  );
  DistLowLatencyFifo_1 wFifo (
    .io_push_valid        (wFifo_io_push_valid              ), //i
    .io_push_ready        (wFifo_io_push_ready              ), //o
    .io_push_payload_data (wFifo_io_push_payload_data[127:0]), //i
    .io_push_payload_strb (wFifo_io_push_payload_strb[15:0] ), //i
    .io_pop_valid         (wFifo_io_pop_valid               ), //o
    .io_pop_ready         (wFifo_io_pop_ready               ), //i
    .io_pop_payload_data  (wFifo_io_pop_payload_data[127:0] ), //o
    .io_pop_payload_strb  (wFifo_io_pop_payload_strb[15:0]  ), //o
    .io_occupancy         (wFifo_io_occupancy[4:0]          ), //o
    .io_pclk              (io_pclk                          ), //i
    ._zz_4                (_zz_1                            )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(mode)
      BridgeMode_IDLE : mode_string = "IDLE ";
      BridgeMode_READ : mode_string = "READ ";
      BridgeMode_WRITE : mode_string = "WRITE";
      default : mode_string = "?????";
    endcase
  end
  `endif

  assign outReq_ready = outReq_rValidN;
  assign outReq_s2mPipe_valid = (outReq_valid || (! outReq_rValidN));
  assign outReq_s2mPipe_payload_write = (outReq_rValidN ? outReq_payload_write : outReq_rData_write);
  assign outReq_s2mPipe_payload_addr = (outReq_rValidN ? outReq_payload_addr : outReq_rData_addr);
  assign outReq_s2mPipe_payload_wdata = (outReq_rValidN ? outReq_payload_wdata : outReq_rData_wdata);
  assign outReq_s2mPipe_payload_wstrb = (outReq_rValidN ? outReq_payload_wstrb : outReq_rData_wstrb);
  always @(*) begin
    outReq_s2mPipe_ready = outReq_s2mPipe_m2sPipe_ready;
    if(when_Stream_l477) begin
      outReq_s2mPipe_ready = 1'b1;
    end
  end

  assign when_Stream_l477 = (! outReq_s2mPipe_m2sPipe_valid);
  assign outReq_s2mPipe_m2sPipe_valid = outReq_s2mPipe_rValid;
  assign outReq_s2mPipe_m2sPipe_payload_write = outReq_s2mPipe_rData_write;
  assign outReq_s2mPipe_m2sPipe_payload_addr = outReq_s2mPipe_rData_addr;
  assign outReq_s2mPipe_m2sPipe_payload_wdata = outReq_s2mPipe_rData_wdata;
  assign outReq_s2mPipe_m2sPipe_payload_wstrb = outReq_s2mPipe_rData_wstrb;
  assign io_req_valid = outReq_s2mPipe_m2sPipe_valid;
  assign outReq_s2mPipe_m2sPipe_ready = io_req_ready;
  assign io_req_payload_write = outReq_s2mPipe_m2sPipe_payload_write;
  assign io_req_payload_addr = outReq_s2mPipe_m2sPipe_payload_addr;
  assign io_req_payload_wdata = outReq_s2mPipe_m2sPipe_payload_wdata;
  assign io_req_payload_wstrb = outReq_s2mPipe_m2sPipe_payload_wstrb;
  assign rFifo_io_push_valid = ((mode == BridgeMode_READ) && io_rsp_valid);
  assign rConsume = ((! rValidReg) || io_axi_r_ready);
  always @(*) begin
    rFifo_io_pop_ready = 1'b0;
    if(when_Ddr3Axi4Bridge_l73) begin
      if(when_Ddr3Axi4Bridge_l83) begin
        if(when_Ddr3Axi4Bridge_l85) begin
          rFifo_io_pop_ready = 1'b1;
        end
      end else begin
        rFifo_io_pop_ready = 1'b1;
      end
    end
  end

  assign when_Ddr3Axi4Bridge_l68 = (io_axi_r_ready && rValidReg);
  assign when_Ddr3Axi4Bridge_l73 = ((((mode == BridgeMode_READ) && (rBeatsLeft != 9'h0)) && rConsume) && rFifo_io_pop_valid);
  assign _zz_rBeatsLeft = (rBeatsLeft - 9'h001);
  assign when_Ddr3Axi4Bridge_l83 = (! rPhase64);
  assign when_Ddr3Axi4Bridge_l85 = (_zz_rBeatsLeft == 9'h0);
  assign when_Ddr3Axi4Bridge_l100 = (mode == BridgeMode_READ);
  assign when_Ddr3Axi4Bridge_l101 = (! rIssuingChunk);
  assign when_Ddr3Axi4Bridge_l102 = ((rCmdLeft != 9'h0) && ((rSlotsUsed <= 5'h08) || (rCmdLeft <= _zz_when_Ddr3Axi4Bridge_l102)));
  assign when_Ddr3Axi4Bridge_l106 = ((rCmdLeft == 9'h0) || (5'h0f <= rSlotsUsed));
  assign rdReqValid = ((((mode == BridgeMode_READ) && rIssuingChunk) && (rCmdLeft != 9'h0)) && (rSlotsUsed < 5'h10));
  assign io_axi_w_ready = (((mode == BridgeMode_WRITE) && (! wLastSeen)) && wFifo_io_push_ready);
  always @(*) begin
    wFifo_io_push_valid = 1'b0;
    if(when_Ddr3Axi4Bridge_l143) begin
      if(when_Ddr3Axi4Bridge_l152) begin
        if(io_axi_w_payload_last) begin
          wFifo_io_push_valid = 1'b1;
        end
      end else begin
        wFifo_io_push_valid = 1'b1;
      end
    end
  end

  always @(*) begin
    wFifo_io_push_payload_data = 128'h0;
    if(when_Ddr3Axi4Bridge_l143) begin
      if(when_Ddr3Axi4Bridge_l152) begin
        if(io_axi_w_payload_last) begin
          wFifo_io_push_payload_data = {64'h0,io_axi_w_payload_data[63 : 0]};
        end
      end else begin
        wFifo_io_push_payload_data = {io_axi_w_payload_data[63 : 0],wAsmData[63 : 0]};
      end
    end
  end

  always @(*) begin
    wFifo_io_push_payload_strb = 16'h0;
    if(when_Ddr3Axi4Bridge_l143) begin
      if(when_Ddr3Axi4Bridge_l152) begin
        if(io_axi_w_payload_last) begin
          wFifo_io_push_payload_strb = {8'h0,io_axi_w_payload_strb[7 : 0]};
        end
      end else begin
        wFifo_io_push_payload_strb = {io_axi_w_payload_strb[7 : 0],wAsmStrb[7 : 0]};
      end
    end
  end

  assign when_Ddr3Axi4Bridge_l143 = ((((mode == BridgeMode_WRITE) && (! wLastSeen)) && io_axi_w_valid) && wFifo_io_push_ready);
  assign when_Ddr3Axi4Bridge_l152 = (! wPhase64);
  assign when_Ddr3Axi4Bridge_l178 = ((mode == BridgeMode_WRITE) && (! wBValidReg));
  assign when_Ddr3Axi4Bridge_l179 = (! wDraining);
  assign when_Ddr3Axi4Bridge_l180 = (wFifo_io_pop_valid && (wLastSeen || (5'h0c <= wFifo_io_occupancy)));
  assign when_Ddr3Axi4Bridge_l184 = (! wFifo_io_pop_valid);
  assign wrReqValid = (((mode == BridgeMode_WRITE) && wDraining) && wFifo_io_pop_valid);
  assign wFifo_io_pop_ready = (((mode == BridgeMode_WRITE) && wDraining) && outReq_ready);
  assign outReq_valid = (rdReqValid || wrReqValid);
  assign outReq_payload_write = (mode == BridgeMode_WRITE);
  assign outReq_payload_addr = _zz_outReq_payload_addr[26:0];
  assign outReq_payload_wdata = wFifo_io_pop_payload_data;
  assign outReq_payload_wstrb = wFifo_io_pop_payload_strb;
  assign io_axi_ar_ready = (((mode == BridgeMode_IDLE) && io_init_done) && (! io_axi_aw_valid));
  assign io_axi_aw_ready = ((mode == BridgeMode_IDLE) && io_init_done);
  assign io_axi_r_valid = rValidReg;
  assign io_axi_r_payload_data = rOutData;
  assign io_axi_r_payload_id = rId;
  assign io_axi_r_payload_resp = 2'b00;
  assign io_axi_r_payload_last = rLastReg;
  assign io_axi_b_valid = wBValidReg;
  assign io_axi_b_payload_id = wId;
  assign io_axi_b_payload_resp = 2'b00;
  assign rdSlotInc = (rdReqValid && outReq_ready);
  assign rdSlotDec = (rFifo_io_pop_valid && rFifo_io_pop_ready);
  assign wBlkInc = (wFifo_io_push_valid && wFifo_io_push_ready);
  assign wBlkDec = (wrReqValid && outReq_ready);
  assign when_Ddr3Axi4Bridge_l226 = (rdReqValid && outReq_ready);
  assign when_Ddr3Axi4Bridge_l233 = (wrReqValid && outReq_ready);
  assign when_Ddr3Axi4Bridge_l242 = (io_axi_aw_valid && io_axi_aw_ready);
  assign _zz_rCmdLeft = (_zz__zz_rCmdLeft + 9'h001);
  assign when_Ddr3Axi4Bridge_l253 = (io_axi_ar_valid && io_axi_ar_ready);
  assign when_Ddr3Axi4Bridge_l272 = ((((rBeatsLeft == 9'h0) && (! rValidReg)) && (rCmdLeft == 9'h0)) && (rSlotsUsed == 5'h0));
  assign when_Ddr3Axi4Bridge_l278 = ((wLastSeen && (wPendingBlks == 9'h0)) && (! wBValidReg));
  assign when_Ddr3Axi4Bridge_l281 = (wBValidReg && io_axi_b_ready);
  always @(posedge io_pclk or posedge _zz_1) begin
    if(_zz_1) begin
      outReq_rValidN <= 1'b1;
      outReq_s2mPipe_rValid <= 1'b0;
      mode <= BridgeMode_IDLE;
      rReqAddr <= 32'h0;
      rIncr <= 1'b1;
      rCmdLeft <= 9'h0;
      rSlotsUsed <= 5'h0;
      rIssuingChunk <= 1'b0;
      rId <= 4'b0000;
      rBeatsLeft <= 9'h0;
      rPhase64 <= 1'b0;
      rValidReg <= 1'b0;
      rOutData <= 64'h0;
      rLastReg <= 1'b0;
      wReqAddr <= 32'h0;
      wIncr <= 1'b1;
      wId <= 4'b0000;
      wAsmData <= 128'h0;
      wAsmStrb <= 16'h0;
      wPhase64 <= 1'b0;
      wLastSeen <= 1'b0;
      wBValidReg <= 1'b0;
      wDraining <= 1'b0;
      wPendingBlks <= 9'h0;
    end else begin
      if(outReq_valid) begin
        outReq_rValidN <= 1'b0;
      end
      if(outReq_s2mPipe_ready) begin
        outReq_rValidN <= 1'b1;
      end
      if(outReq_s2mPipe_ready) begin
        outReq_s2mPipe_rValid <= outReq_s2mPipe_valid;
      end
      if(when_Ddr3Axi4Bridge_l68) begin
        rValidReg <= 1'b0;
        rLastReg <= 1'b0;
      end
      if(when_Ddr3Axi4Bridge_l73) begin
        rBeatsLeft <= _zz_rBeatsLeft;
        rValidReg <= 1'b1;
        rLastReg <= (_zz_rBeatsLeft == 9'h0);
        if(when_Ddr3Axi4Bridge_l83) begin
          rOutData <= rFifo_io_pop_payload[63 : 0];
          if(when_Ddr3Axi4Bridge_l85) begin
            rPhase64 <= 1'b0;
          end else begin
            rPhase64 <= 1'b1;
          end
        end else begin
          rOutData <= rFifo_io_pop_payload[127 : 64];
          rPhase64 <= 1'b0;
        end
      end
      if(when_Ddr3Axi4Bridge_l100) begin
        if(when_Ddr3Axi4Bridge_l101) begin
          if(when_Ddr3Axi4Bridge_l102) begin
            rIssuingChunk <= 1'b1;
          end
        end else begin
          if(when_Ddr3Axi4Bridge_l106) begin
            rIssuingChunk <= 1'b0;
          end
        end
      end else begin
        rIssuingChunk <= 1'b0;
      end
      if(when_Ddr3Axi4Bridge_l143) begin
        if(when_Ddr3Axi4Bridge_l152) begin
          if(io_axi_w_payload_last) begin
            wLastSeen <= 1'b1;
          end else begin
            wAsmData[63 : 0] <= io_axi_w_payload_data[63 : 0];
            wAsmStrb[7 : 0] <= io_axi_w_payload_strb[7 : 0];
            wAsmData[127 : 64] <= 64'h0;
            wAsmStrb[15 : 8] <= 8'h0;
            wPhase64 <= 1'b1;
          end
        end else begin
          wPhase64 <= 1'b0;
          if(io_axi_w_payload_last) begin
            wLastSeen <= 1'b1;
          end
        end
      end
      if(when_Ddr3Axi4Bridge_l178) begin
        if(when_Ddr3Axi4Bridge_l179) begin
          if(when_Ddr3Axi4Bridge_l180) begin
            wDraining <= 1'b1;
          end
        end else begin
          if(when_Ddr3Axi4Bridge_l184) begin
            wDraining <= 1'b0;
          end
        end
      end else begin
        wDraining <= 1'b0;
      end
      rSlotsUsed <= (_zz_rSlotsUsed - _zz_rSlotsUsed_3);
      wPendingBlks <= (_zz_wPendingBlks - _zz_wPendingBlks_3);
      if(when_Ddr3Axi4Bridge_l226) begin
        rCmdLeft <= (rCmdLeft - 9'h001);
        if(rIncr) begin
          rReqAddr <= (rReqAddr + 32'h00000010);
        end
      end
      if(when_Ddr3Axi4Bridge_l233) begin
        if(wIncr) begin
          wReqAddr <= (wReqAddr + 32'h00000010);
        end
      end
      case(mode)
        BridgeMode_IDLE : begin
          if(when_Ddr3Axi4Bridge_l242) begin
            wReqAddr <= io_axi_aw_payload_addr;
            wIncr <= (io_axi_aw_payload_burst != 2'b00);
            wId <= io_axi_aw_payload_id;
            wPhase64 <= (io_axi_aw_payload_addr[3] && 1'b1);
            wAsmData <= 128'h0;
            wAsmStrb <= 16'h0;
            wLastSeen <= 1'b0;
            wBValidReg <= 1'b0;
            wDraining <= 1'b0;
            mode <= BridgeMode_WRITE;
          end else begin
            if(when_Ddr3Axi4Bridge_l253) begin
              rReqAddr <= io_axi_ar_payload_addr;
              rIncr <= (io_axi_ar_payload_burst != 2'b00);
              rId <= io_axi_ar_payload_id;
              rBeatsLeft <= _zz_rCmdLeft;
              rCmdLeft <= {1'd0, _zz_rCmdLeft_1};
              rPhase64 <= (io_axi_ar_payload_addr[3] && 1'b1);
              rIssuingChunk <= 1'b0;
              mode <= BridgeMode_READ;
            end
          end
        end
        BridgeMode_READ : begin
          if(when_Ddr3Axi4Bridge_l272) begin
            mode <= BridgeMode_IDLE;
          end
        end
        default : begin
          if(when_Ddr3Axi4Bridge_l278) begin
            wBValidReg <= 1'b1;
          end
          if(when_Ddr3Axi4Bridge_l281) begin
            wBValidReg <= 1'b0;
            mode <= BridgeMode_IDLE;
          end
        end
      endcase
    end
  end

  always @(posedge io_pclk) begin
    if(outReq_ready) begin
      outReq_rData_write <= outReq_payload_write;
      outReq_rData_addr <= outReq_payload_addr;
      outReq_rData_wdata <= outReq_payload_wdata;
      outReq_rData_wstrb <= outReq_payload_wstrb;
    end
    if(outReq_s2mPipe_ready) begin
      outReq_s2mPipe_rData_write <= outReq_s2mPipe_payload_write;
      outReq_s2mPipe_rData_addr <= outReq_s2mPipe_payload_addr;
      outReq_s2mPipe_rData_wdata <= outReq_s2mPipe_payload_wdata;
      outReq_s2mPipe_rData_wstrb <= outReq_s2mPipe_payload_wstrb;
    end
  end


endmodule

module GowinDdr3Phy (
  input  wire          io_pclk,
  input  wire          io_fclk,
  input  wire          io_ck,
  input  wire          io_resetn,
  input  wire          io_dqs_hold,
  input  wire [7:0]    io_wstep,
  input  wire          io_rloadn,
  input  wire          io_rmove,
  input  wire          io_rdir,
  input  wire [1:0]    io_rclkpos,
  input  wire [2:0]    io_rclksel,
  input  wire [3:0]    io_dqs_read,
  input  wire [15:0]   io_dq_out_0,
  input  wire [15:0]   io_dq_out_1,
  input  wire [15:0]   io_dq_out_2,
  input  wire [15:0]   io_dq_out_3,
  input  wire [15:0]   io_dq_out_4,
  input  wire [15:0]   io_dq_out_5,
  input  wire [15:0]   io_dq_out_6,
  input  wire [15:0]   io_dq_out_7,
  input  wire [3:0]    io_dq_oen,
  input  wire [7:0]    io_dqs_out,
  input  wire [3:0]    io_dqs_oen,
  input  wire [7:0]    io_dm_out,
  input  wire          io_nRAS_0,
  input  wire          io_nRAS_1,
  input  wire          io_nRAS_2,
  input  wire          io_nRAS_3,
  input  wire          io_nCAS_0,
  input  wire          io_nCAS_1,
  input  wire          io_nCAS_2,
  input  wire          io_nCAS_3,
  input  wire          io_nWE_0,
  input  wire          io_nWE_1,
  input  wire          io_nWE_2,
  input  wire          io_nWE_3,
  input  wire [13:0]   io_A_0,
  input  wire [13:0]   io_A_1,
  input  wire [13:0]   io_A_2,
  input  wire [13:0]   io_A_3,
  input  wire [2:0]    io_BA_0,
  input  wire [2:0]    io_BA_1,
  input  wire [2:0]    io_BA_2,
  input  wire [2:0]    io_BA_3,
  input  wire          io_CKE,
  input  wire          io_resetn_delay,
  input  wire          io_wser_rst,
  output wire          io_dlllock,
  output wire          io_rst_lock_n,
  output wire [1:0]    io_rburst,
  output wire [1:0]    io_rvalid,
  output wire [2:0]    io_wpoint_0,
  output wire [2:0]    io_wpoint_1,
  output wire [2:0]    io_rpoint_0,
  output wire [2:0]    io_rpoint_1,
  output reg  [15:0]   io_dq_in_0,
  output reg  [15:0]   io_dq_in_1,
  output reg  [15:0]   io_dq_in_2,
  output reg  [15:0]   io_dq_in_3,
  output reg  [15:0]   io_dq_in_4,
  output reg  [15:0]   io_dq_in_5,
  output reg  [15:0]   io_dq_in_6,
  output reg  [15:0]   io_dq_in_7,
  output wire [15:0]   io_dq_raw,
  inout  wire [15:0]   io_pad_DDR3_DQ,
  inout  wire [1:0]    io_pad_DDR3_DQS,
  output reg  [1:0]    io_pad_DDR3_DM,
  output reg  [13:0]   io_pad_DDR3_A,
  output reg  [2:0]    io_pad_DDR3_BA,
  output wire          io_pad_DDR3_nRAS,
  output wire          io_pad_DDR3_nCAS,
  output wire          io_pad_DDR3_nWE,
  output wire          io_pad_DDR3_nCS,
  output wire          io_pad_DDR3_CK,
  output wire          io_pad_DDR3_CKE,
  output wire          io_pad_DDR3_nRESET,
  output wire          io_pad_DDR3_ODT
);

  wire                dll_1_RESET;
  wire                dQS_1_DQSIN;
  wire                oSER8_MEM_1_D0;
  wire                oSER8_MEM_1_D1;
  wire                oSER8_MEM_1_D2;
  wire                oSER8_MEM_1_D3;
  wire                oSER8_MEM_1_D4;
  wire                oSER8_MEM_1_D5;
  wire                oSER8_MEM_1_D6;
  wire                oSER8_MEM_1_D7;
  wire                oSER8_MEM_1_TX0;
  wire                oSER8_MEM_1_TX1;
  wire                oSER8_MEM_1_TX2;
  wire                oSER8_MEM_1_TX3;
  wire                iOBUF_1_I;
  wire                iOBUF_1_OEN;
  wire                oSER8_MEM_2_D0;
  wire                oSER8_MEM_2_D1;
  wire                oSER8_MEM_2_D2;
  wire                oSER8_MEM_2_D3;
  wire                oSER8_MEM_2_D4;
  wire                oSER8_MEM_2_D5;
  wire                oSER8_MEM_2_D6;
  wire                oSER8_MEM_2_D7;
  wire                dQS_2_DQSIN;
  wire                oSER8_MEM_3_D0;
  wire                oSER8_MEM_3_D1;
  wire                oSER8_MEM_3_D2;
  wire                oSER8_MEM_3_D3;
  wire                oSER8_MEM_3_D4;
  wire                oSER8_MEM_3_D5;
  wire                oSER8_MEM_3_D6;
  wire                oSER8_MEM_3_D7;
  wire                oSER8_MEM_3_TX0;
  wire                oSER8_MEM_3_TX1;
  wire                oSER8_MEM_3_TX2;
  wire                oSER8_MEM_3_TX3;
  wire                iOBUF_2_I;
  wire                iOBUF_2_OEN;
  wire                oSER8_MEM_4_D0;
  wire                oSER8_MEM_4_D1;
  wire                oSER8_MEM_4_D2;
  wire                oSER8_MEM_4_D3;
  wire                oSER8_MEM_4_D4;
  wire                oSER8_MEM_4_D5;
  wire                oSER8_MEM_4_D6;
  wire                oSER8_MEM_4_D7;
  wire                oSER8_MEM_5_D0;
  wire                oSER8_MEM_5_D1;
  wire                oSER8_MEM_5_D2;
  wire                oSER8_MEM_5_D3;
  wire                oSER8_MEM_5_D4;
  wire                oSER8_MEM_5_D5;
  wire                oSER8_MEM_5_D6;
  wire                oSER8_MEM_5_D7;
  wire                oSER8_MEM_5_TX0;
  wire                oSER8_MEM_5_TX1;
  wire                oSER8_MEM_5_TX2;
  wire                oSER8_MEM_5_TX3;
  wire                iOBUF_3_I;
  wire                iOBUF_3_OEN;
  wire                iDES8_MEM_1_D;
  wire                oSER8_MEM_6_D0;
  wire                oSER8_MEM_6_D1;
  wire                oSER8_MEM_6_D2;
  wire                oSER8_MEM_6_D3;
  wire                oSER8_MEM_6_D4;
  wire                oSER8_MEM_6_D5;
  wire                oSER8_MEM_6_D6;
  wire                oSER8_MEM_6_D7;
  wire                oSER8_MEM_6_TX0;
  wire                oSER8_MEM_6_TX1;
  wire                oSER8_MEM_6_TX2;
  wire                oSER8_MEM_6_TX3;
  wire                iOBUF_4_I;
  wire                iOBUF_4_OEN;
  wire                iDES8_MEM_2_D;
  wire                oSER8_MEM_7_D0;
  wire                oSER8_MEM_7_D1;
  wire                oSER8_MEM_7_D2;
  wire                oSER8_MEM_7_D3;
  wire                oSER8_MEM_7_D4;
  wire                oSER8_MEM_7_D5;
  wire                oSER8_MEM_7_D6;
  wire                oSER8_MEM_7_D7;
  wire                oSER8_MEM_7_TX0;
  wire                oSER8_MEM_7_TX1;
  wire                oSER8_MEM_7_TX2;
  wire                oSER8_MEM_7_TX3;
  wire                iOBUF_5_I;
  wire                iOBUF_5_OEN;
  wire                iDES8_MEM_3_D;
  wire                oSER8_MEM_8_D0;
  wire                oSER8_MEM_8_D1;
  wire                oSER8_MEM_8_D2;
  wire                oSER8_MEM_8_D3;
  wire                oSER8_MEM_8_D4;
  wire                oSER8_MEM_8_D5;
  wire                oSER8_MEM_8_D6;
  wire                oSER8_MEM_8_D7;
  wire                oSER8_MEM_8_TX0;
  wire                oSER8_MEM_8_TX1;
  wire                oSER8_MEM_8_TX2;
  wire                oSER8_MEM_8_TX3;
  wire                iOBUF_6_I;
  wire                iOBUF_6_OEN;
  wire                iDES8_MEM_4_D;
  wire                oSER8_MEM_9_D0;
  wire                oSER8_MEM_9_D1;
  wire                oSER8_MEM_9_D2;
  wire                oSER8_MEM_9_D3;
  wire                oSER8_MEM_9_D4;
  wire                oSER8_MEM_9_D5;
  wire                oSER8_MEM_9_D6;
  wire                oSER8_MEM_9_D7;
  wire                oSER8_MEM_9_TX0;
  wire                oSER8_MEM_9_TX1;
  wire                oSER8_MEM_9_TX2;
  wire                oSER8_MEM_9_TX3;
  wire                iOBUF_7_I;
  wire                iOBUF_7_OEN;
  wire                iDES8_MEM_5_D;
  wire                oSER8_MEM_10_D0;
  wire                oSER8_MEM_10_D1;
  wire                oSER8_MEM_10_D2;
  wire                oSER8_MEM_10_D3;
  wire                oSER8_MEM_10_D4;
  wire                oSER8_MEM_10_D5;
  wire                oSER8_MEM_10_D6;
  wire                oSER8_MEM_10_D7;
  wire                oSER8_MEM_10_TX0;
  wire                oSER8_MEM_10_TX1;
  wire                oSER8_MEM_10_TX2;
  wire                oSER8_MEM_10_TX3;
  wire                iOBUF_8_I;
  wire                iOBUF_8_OEN;
  wire                iDES8_MEM_6_D;
  wire                oSER8_MEM_11_D0;
  wire                oSER8_MEM_11_D1;
  wire                oSER8_MEM_11_D2;
  wire                oSER8_MEM_11_D3;
  wire                oSER8_MEM_11_D4;
  wire                oSER8_MEM_11_D5;
  wire                oSER8_MEM_11_D6;
  wire                oSER8_MEM_11_D7;
  wire                oSER8_MEM_11_TX0;
  wire                oSER8_MEM_11_TX1;
  wire                oSER8_MEM_11_TX2;
  wire                oSER8_MEM_11_TX3;
  wire                iOBUF_9_I;
  wire                iOBUF_9_OEN;
  wire                iDES8_MEM_7_D;
  wire                oSER8_MEM_12_D0;
  wire                oSER8_MEM_12_D1;
  wire                oSER8_MEM_12_D2;
  wire                oSER8_MEM_12_D3;
  wire                oSER8_MEM_12_D4;
  wire                oSER8_MEM_12_D5;
  wire                oSER8_MEM_12_D6;
  wire                oSER8_MEM_12_D7;
  wire                oSER8_MEM_12_TX0;
  wire                oSER8_MEM_12_TX1;
  wire                oSER8_MEM_12_TX2;
  wire                oSER8_MEM_12_TX3;
  wire                iOBUF_10_I;
  wire                iOBUF_10_OEN;
  wire                iDES8_MEM_8_D;
  wire                oSER8_MEM_13_D0;
  wire                oSER8_MEM_13_D1;
  wire                oSER8_MEM_13_D2;
  wire                oSER8_MEM_13_D3;
  wire                oSER8_MEM_13_D4;
  wire                oSER8_MEM_13_D5;
  wire                oSER8_MEM_13_D6;
  wire                oSER8_MEM_13_D7;
  wire                oSER8_MEM_13_TX0;
  wire                oSER8_MEM_13_TX1;
  wire                oSER8_MEM_13_TX2;
  wire                oSER8_MEM_13_TX3;
  wire                iOBUF_11_I;
  wire                iOBUF_11_OEN;
  wire                iDES8_MEM_9_D;
  wire                oSER8_MEM_14_D0;
  wire                oSER8_MEM_14_D1;
  wire                oSER8_MEM_14_D2;
  wire                oSER8_MEM_14_D3;
  wire                oSER8_MEM_14_D4;
  wire                oSER8_MEM_14_D5;
  wire                oSER8_MEM_14_D6;
  wire                oSER8_MEM_14_D7;
  wire                oSER8_MEM_14_TX0;
  wire                oSER8_MEM_14_TX1;
  wire                oSER8_MEM_14_TX2;
  wire                oSER8_MEM_14_TX3;
  wire                iOBUF_12_I;
  wire                iOBUF_12_OEN;
  wire                iDES8_MEM_10_D;
  wire                oSER8_MEM_15_D0;
  wire                oSER8_MEM_15_D1;
  wire                oSER8_MEM_15_D2;
  wire                oSER8_MEM_15_D3;
  wire                oSER8_MEM_15_D4;
  wire                oSER8_MEM_15_D5;
  wire                oSER8_MEM_15_D6;
  wire                oSER8_MEM_15_D7;
  wire                oSER8_MEM_15_TX0;
  wire                oSER8_MEM_15_TX1;
  wire                oSER8_MEM_15_TX2;
  wire                oSER8_MEM_15_TX3;
  wire                iOBUF_13_I;
  wire                iOBUF_13_OEN;
  wire                iDES8_MEM_11_D;
  wire                oSER8_MEM_16_D0;
  wire                oSER8_MEM_16_D1;
  wire                oSER8_MEM_16_D2;
  wire                oSER8_MEM_16_D3;
  wire                oSER8_MEM_16_D4;
  wire                oSER8_MEM_16_D5;
  wire                oSER8_MEM_16_D6;
  wire                oSER8_MEM_16_D7;
  wire                oSER8_MEM_16_TX0;
  wire                oSER8_MEM_16_TX1;
  wire                oSER8_MEM_16_TX2;
  wire                oSER8_MEM_16_TX3;
  wire                iOBUF_14_I;
  wire                iOBUF_14_OEN;
  wire                iDES8_MEM_12_D;
  wire                oSER8_MEM_17_D0;
  wire                oSER8_MEM_17_D1;
  wire                oSER8_MEM_17_D2;
  wire                oSER8_MEM_17_D3;
  wire                oSER8_MEM_17_D4;
  wire                oSER8_MEM_17_D5;
  wire                oSER8_MEM_17_D6;
  wire                oSER8_MEM_17_D7;
  wire                oSER8_MEM_17_TX0;
  wire                oSER8_MEM_17_TX1;
  wire                oSER8_MEM_17_TX2;
  wire                oSER8_MEM_17_TX3;
  wire                iOBUF_15_I;
  wire                iOBUF_15_OEN;
  wire                iDES8_MEM_13_D;
  wire                oSER8_MEM_18_D0;
  wire                oSER8_MEM_18_D1;
  wire                oSER8_MEM_18_D2;
  wire                oSER8_MEM_18_D3;
  wire                oSER8_MEM_18_D4;
  wire                oSER8_MEM_18_D5;
  wire                oSER8_MEM_18_D6;
  wire                oSER8_MEM_18_D7;
  wire                oSER8_MEM_18_TX0;
  wire                oSER8_MEM_18_TX1;
  wire                oSER8_MEM_18_TX2;
  wire                oSER8_MEM_18_TX3;
  wire                iOBUF_16_I;
  wire                iOBUF_16_OEN;
  wire                iDES8_MEM_14_D;
  wire                oSER8_MEM_19_D0;
  wire                oSER8_MEM_19_D1;
  wire                oSER8_MEM_19_D2;
  wire                oSER8_MEM_19_D3;
  wire                oSER8_MEM_19_D4;
  wire                oSER8_MEM_19_D5;
  wire                oSER8_MEM_19_D6;
  wire                oSER8_MEM_19_D7;
  wire                oSER8_MEM_19_TX0;
  wire                oSER8_MEM_19_TX1;
  wire                oSER8_MEM_19_TX2;
  wire                oSER8_MEM_19_TX3;
  wire                iOBUF_17_I;
  wire                iOBUF_17_OEN;
  wire                iDES8_MEM_15_D;
  wire                oSER8_MEM_20_D0;
  wire                oSER8_MEM_20_D1;
  wire                oSER8_MEM_20_D2;
  wire                oSER8_MEM_20_D3;
  wire                oSER8_MEM_20_D4;
  wire                oSER8_MEM_20_D5;
  wire                oSER8_MEM_20_D6;
  wire                oSER8_MEM_20_D7;
  wire                oSER8_MEM_20_TX0;
  wire                oSER8_MEM_20_TX1;
  wire                oSER8_MEM_20_TX2;
  wire                oSER8_MEM_20_TX3;
  wire                iOBUF_18_I;
  wire                iOBUF_18_OEN;
  wire                iDES8_MEM_16_D;
  wire                oSER8_4_D0;
  wire                oSER8_4_D1;
  wire                oSER8_4_D2;
  wire                oSER8_4_D3;
  wire                oSER8_4_D4;
  wire                oSER8_4_D5;
  wire                oSER8_4_D6;
  wire                oSER8_4_D7;
  wire                oSER8_5_D0;
  wire                oSER8_5_D1;
  wire                oSER8_5_D2;
  wire                oSER8_5_D3;
  wire                oSER8_5_D4;
  wire                oSER8_5_D5;
  wire                oSER8_5_D6;
  wire                oSER8_5_D7;
  wire                oSER8_6_D0;
  wire                oSER8_6_D1;
  wire                oSER8_6_D2;
  wire                oSER8_6_D3;
  wire                oSER8_6_D4;
  wire                oSER8_6_D5;
  wire                oSER8_6_D6;
  wire                oSER8_6_D7;
  wire                oSER8_7_D0;
  wire                oSER8_7_D1;
  wire                oSER8_7_D2;
  wire                oSER8_7_D3;
  wire                oSER8_7_D4;
  wire                oSER8_7_D5;
  wire                oSER8_7_D6;
  wire                oSER8_7_D7;
  wire                oSER8_8_D0;
  wire                oSER8_8_D1;
  wire                oSER8_8_D2;
  wire                oSER8_8_D3;
  wire                oSER8_8_D4;
  wire                oSER8_8_D5;
  wire                oSER8_8_D6;
  wire                oSER8_8_D7;
  wire                oSER8_9_D0;
  wire                oSER8_9_D1;
  wire                oSER8_9_D2;
  wire                oSER8_9_D3;
  wire                oSER8_9_D4;
  wire                oSER8_9_D5;
  wire                oSER8_9_D6;
  wire                oSER8_9_D7;
  wire                oSER8_10_D0;
  wire                oSER8_10_D1;
  wire                oSER8_10_D2;
  wire                oSER8_10_D3;
  wire                oSER8_10_D4;
  wire                oSER8_10_D5;
  wire                oSER8_10_D6;
  wire                oSER8_10_D7;
  wire                oSER8_11_D0;
  wire                oSER8_11_D1;
  wire                oSER8_11_D2;
  wire                oSER8_11_D3;
  wire                oSER8_11_D4;
  wire                oSER8_11_D5;
  wire                oSER8_11_D6;
  wire                oSER8_11_D7;
  wire                oSER8_12_D0;
  wire                oSER8_12_D1;
  wire                oSER8_12_D2;
  wire                oSER8_12_D3;
  wire                oSER8_12_D4;
  wire                oSER8_12_D5;
  wire                oSER8_12_D6;
  wire                oSER8_12_D7;
  wire                oSER8_13_D0;
  wire                oSER8_13_D1;
  wire                oSER8_13_D2;
  wire                oSER8_13_D3;
  wire                oSER8_13_D4;
  wire                oSER8_13_D5;
  wire                oSER8_13_D6;
  wire                oSER8_13_D7;
  wire                oSER8_14_D0;
  wire                oSER8_14_D1;
  wire                oSER8_14_D2;
  wire                oSER8_14_D3;
  wire                oSER8_14_D4;
  wire                oSER8_14_D5;
  wire                oSER8_14_D6;
  wire                oSER8_14_D7;
  wire                oSER8_15_D0;
  wire                oSER8_15_D1;
  wire                oSER8_15_D2;
  wire                oSER8_15_D3;
  wire                oSER8_15_D4;
  wire                oSER8_15_D5;
  wire                oSER8_15_D6;
  wire                oSER8_15_D7;
  wire                oSER8_16_D0;
  wire                oSER8_16_D1;
  wire                oSER8_16_D2;
  wire                oSER8_16_D3;
  wire                oSER8_16_D4;
  wire                oSER8_16_D5;
  wire                oSER8_16_D6;
  wire                oSER8_16_D7;
  wire                oSER8_17_D0;
  wire                oSER8_17_D1;
  wire                oSER8_17_D2;
  wire                oSER8_17_D3;
  wire                oSER8_17_D4;
  wire                oSER8_17_D5;
  wire                oSER8_17_D6;
  wire                oSER8_17_D7;
  wire                oSER8_18_D0;
  wire                oSER8_18_D1;
  wire                oSER8_18_D2;
  wire                oSER8_18_D3;
  wire                oSER8_18_D4;
  wire                oSER8_18_D5;
  wire                oSER8_18_D6;
  wire                oSER8_18_D7;
  wire                oSER8_19_D0;
  wire                oSER8_19_D1;
  wire                oSER8_19_D2;
  wire                oSER8_19_D3;
  wire                oSER8_19_D4;
  wire                oSER8_19_D5;
  wire                oSER8_19_D6;
  wire                oSER8_19_D7;
  wire                oSER8_20_D0;
  wire                oSER8_20_D1;
  wire                oSER8_20_D2;
  wire                oSER8_20_D3;
  wire                oSER8_20_D4;
  wire                oSER8_20_D5;
  wire                oSER8_20_D6;
  wire                oSER8_20_D7;
  wire       [7:0]    dll_1_STEP;
  wire                dll_1_LOCK;
  wire                dQS_1_DQSR90;
  wire       [2:0]    dQS_1_WPOINT;
  wire       [2:0]    dQS_1_RPOINT;
  wire                dQS_1_DQSW0;
  wire                dQS_1_DQSW270;
  wire                dQS_1_RBURST;
  wire                dQS_1_RVALID;
  wire                oSER8_MEM_1_Q0;
  wire                oSER8_MEM_1_Q1;
  wire                iOBUF_1_O;
  wire                oSER8_MEM_2_Q0;
  wire                oSER8_MEM_2_Q1;
  wire                dQS_2_DQSR90;
  wire       [2:0]    dQS_2_WPOINT;
  wire       [2:0]    dQS_2_RPOINT;
  wire                dQS_2_DQSW0;
  wire                dQS_2_DQSW270;
  wire                dQS_2_RBURST;
  wire                dQS_2_RVALID;
  wire                oSER8_MEM_3_Q0;
  wire                oSER8_MEM_3_Q1;
  wire                iOBUF_2_O;
  wire                oSER8_MEM_4_Q0;
  wire                oSER8_MEM_4_Q1;
  wire                oSER8_MEM_5_Q0;
  wire                oSER8_MEM_5_Q1;
  wire                iOBUF_3_O;
  wire                iDES8_MEM_1_Q0;
  wire                iDES8_MEM_1_Q1;
  wire                iDES8_MEM_1_Q2;
  wire                iDES8_MEM_1_Q3;
  wire                iDES8_MEM_1_Q4;
  wire                iDES8_MEM_1_Q5;
  wire                iDES8_MEM_1_Q6;
  wire                iDES8_MEM_1_Q7;
  wire                oSER8_MEM_6_Q0;
  wire                oSER8_MEM_6_Q1;
  wire                iOBUF_4_O;
  wire                iDES8_MEM_2_Q0;
  wire                iDES8_MEM_2_Q1;
  wire                iDES8_MEM_2_Q2;
  wire                iDES8_MEM_2_Q3;
  wire                iDES8_MEM_2_Q4;
  wire                iDES8_MEM_2_Q5;
  wire                iDES8_MEM_2_Q6;
  wire                iDES8_MEM_2_Q7;
  wire                oSER8_MEM_7_Q0;
  wire                oSER8_MEM_7_Q1;
  wire                iOBUF_5_O;
  wire                iDES8_MEM_3_Q0;
  wire                iDES8_MEM_3_Q1;
  wire                iDES8_MEM_3_Q2;
  wire                iDES8_MEM_3_Q3;
  wire                iDES8_MEM_3_Q4;
  wire                iDES8_MEM_3_Q5;
  wire                iDES8_MEM_3_Q6;
  wire                iDES8_MEM_3_Q7;
  wire                oSER8_MEM_8_Q0;
  wire                oSER8_MEM_8_Q1;
  wire                iOBUF_6_O;
  wire                iDES8_MEM_4_Q0;
  wire                iDES8_MEM_4_Q1;
  wire                iDES8_MEM_4_Q2;
  wire                iDES8_MEM_4_Q3;
  wire                iDES8_MEM_4_Q4;
  wire                iDES8_MEM_4_Q5;
  wire                iDES8_MEM_4_Q6;
  wire                iDES8_MEM_4_Q7;
  wire                oSER8_MEM_9_Q0;
  wire                oSER8_MEM_9_Q1;
  wire                iOBUF_7_O;
  wire                iDES8_MEM_5_Q0;
  wire                iDES8_MEM_5_Q1;
  wire                iDES8_MEM_5_Q2;
  wire                iDES8_MEM_5_Q3;
  wire                iDES8_MEM_5_Q4;
  wire                iDES8_MEM_5_Q5;
  wire                iDES8_MEM_5_Q6;
  wire                iDES8_MEM_5_Q7;
  wire                oSER8_MEM_10_Q0;
  wire                oSER8_MEM_10_Q1;
  wire                iOBUF_8_O;
  wire                iDES8_MEM_6_Q0;
  wire                iDES8_MEM_6_Q1;
  wire                iDES8_MEM_6_Q2;
  wire                iDES8_MEM_6_Q3;
  wire                iDES8_MEM_6_Q4;
  wire                iDES8_MEM_6_Q5;
  wire                iDES8_MEM_6_Q6;
  wire                iDES8_MEM_6_Q7;
  wire                oSER8_MEM_11_Q0;
  wire                oSER8_MEM_11_Q1;
  wire                iOBUF_9_O;
  wire                iDES8_MEM_7_Q0;
  wire                iDES8_MEM_7_Q1;
  wire                iDES8_MEM_7_Q2;
  wire                iDES8_MEM_7_Q3;
  wire                iDES8_MEM_7_Q4;
  wire                iDES8_MEM_7_Q5;
  wire                iDES8_MEM_7_Q6;
  wire                iDES8_MEM_7_Q7;
  wire                oSER8_MEM_12_Q0;
  wire                oSER8_MEM_12_Q1;
  wire                iOBUF_10_O;
  wire                iDES8_MEM_8_Q0;
  wire                iDES8_MEM_8_Q1;
  wire                iDES8_MEM_8_Q2;
  wire                iDES8_MEM_8_Q3;
  wire                iDES8_MEM_8_Q4;
  wire                iDES8_MEM_8_Q5;
  wire                iDES8_MEM_8_Q6;
  wire                iDES8_MEM_8_Q7;
  wire                oSER8_MEM_13_Q0;
  wire                oSER8_MEM_13_Q1;
  wire                iOBUF_11_O;
  wire                iDES8_MEM_9_Q0;
  wire                iDES8_MEM_9_Q1;
  wire                iDES8_MEM_9_Q2;
  wire                iDES8_MEM_9_Q3;
  wire                iDES8_MEM_9_Q4;
  wire                iDES8_MEM_9_Q5;
  wire                iDES8_MEM_9_Q6;
  wire                iDES8_MEM_9_Q7;
  wire                oSER8_MEM_14_Q0;
  wire                oSER8_MEM_14_Q1;
  wire                iOBUF_12_O;
  wire                iDES8_MEM_10_Q0;
  wire                iDES8_MEM_10_Q1;
  wire                iDES8_MEM_10_Q2;
  wire                iDES8_MEM_10_Q3;
  wire                iDES8_MEM_10_Q4;
  wire                iDES8_MEM_10_Q5;
  wire                iDES8_MEM_10_Q6;
  wire                iDES8_MEM_10_Q7;
  wire                oSER8_MEM_15_Q0;
  wire                oSER8_MEM_15_Q1;
  wire                iOBUF_13_O;
  wire                iDES8_MEM_11_Q0;
  wire                iDES8_MEM_11_Q1;
  wire                iDES8_MEM_11_Q2;
  wire                iDES8_MEM_11_Q3;
  wire                iDES8_MEM_11_Q4;
  wire                iDES8_MEM_11_Q5;
  wire                iDES8_MEM_11_Q6;
  wire                iDES8_MEM_11_Q7;
  wire                oSER8_MEM_16_Q0;
  wire                oSER8_MEM_16_Q1;
  wire                iOBUF_14_O;
  wire                iDES8_MEM_12_Q0;
  wire                iDES8_MEM_12_Q1;
  wire                iDES8_MEM_12_Q2;
  wire                iDES8_MEM_12_Q3;
  wire                iDES8_MEM_12_Q4;
  wire                iDES8_MEM_12_Q5;
  wire                iDES8_MEM_12_Q6;
  wire                iDES8_MEM_12_Q7;
  wire                oSER8_MEM_17_Q0;
  wire                oSER8_MEM_17_Q1;
  wire                iOBUF_15_O;
  wire                iDES8_MEM_13_Q0;
  wire                iDES8_MEM_13_Q1;
  wire                iDES8_MEM_13_Q2;
  wire                iDES8_MEM_13_Q3;
  wire                iDES8_MEM_13_Q4;
  wire                iDES8_MEM_13_Q5;
  wire                iDES8_MEM_13_Q6;
  wire                iDES8_MEM_13_Q7;
  wire                oSER8_MEM_18_Q0;
  wire                oSER8_MEM_18_Q1;
  wire                iOBUF_16_O;
  wire                iDES8_MEM_14_Q0;
  wire                iDES8_MEM_14_Q1;
  wire                iDES8_MEM_14_Q2;
  wire                iDES8_MEM_14_Q3;
  wire                iDES8_MEM_14_Q4;
  wire                iDES8_MEM_14_Q5;
  wire                iDES8_MEM_14_Q6;
  wire                iDES8_MEM_14_Q7;
  wire                oSER8_MEM_19_Q0;
  wire                oSER8_MEM_19_Q1;
  wire                iOBUF_17_O;
  wire                iDES8_MEM_15_Q0;
  wire                iDES8_MEM_15_Q1;
  wire                iDES8_MEM_15_Q2;
  wire                iDES8_MEM_15_Q3;
  wire                iDES8_MEM_15_Q4;
  wire                iDES8_MEM_15_Q5;
  wire                iDES8_MEM_15_Q6;
  wire                iDES8_MEM_15_Q7;
  wire                oSER8_MEM_20_Q0;
  wire                oSER8_MEM_20_Q1;
  wire                iOBUF_18_O;
  wire                iDES8_MEM_16_Q0;
  wire                iDES8_MEM_16_Q1;
  wire                iDES8_MEM_16_Q2;
  wire                iDES8_MEM_16_Q3;
  wire                iDES8_MEM_16_Q4;
  wire                iDES8_MEM_16_Q5;
  wire                iDES8_MEM_16_Q6;
  wire                iDES8_MEM_16_Q7;
  wire                oSER8_1_Q0;
  wire                oSER8_1_Q1;
  wire                oSER8_2_Q0;
  wire                oSER8_2_Q1;
  wire                oSER8_3_Q0;
  wire                oSER8_3_Q1;
  wire                oSER8_4_Q0;
  wire                oSER8_4_Q1;
  wire                oSER8_5_Q0;
  wire                oSER8_5_Q1;
  wire                oSER8_6_Q0;
  wire                oSER8_6_Q1;
  wire                oSER8_7_Q0;
  wire                oSER8_7_Q1;
  wire                oSER8_8_Q0;
  wire                oSER8_8_Q1;
  wire                oSER8_9_Q0;
  wire                oSER8_9_Q1;
  wire                oSER8_10_Q0;
  wire                oSER8_10_Q1;
  wire                oSER8_11_Q0;
  wire                oSER8_11_Q1;
  wire                oSER8_12_Q0;
  wire                oSER8_12_Q1;
  wire                oSER8_13_Q0;
  wire                oSER8_13_Q1;
  wire                oSER8_14_Q0;
  wire                oSER8_14_Q1;
  wire                oSER8_15_Q0;
  wire                oSER8_15_Q1;
  wire                oSER8_16_Q0;
  wire                oSER8_16_Q1;
  wire                oSER8_17_Q0;
  wire                oSER8_17_Q1;
  wire                oSER8_18_Q0;
  wire                oSER8_18_Q1;
  wire                oSER8_19_Q0;
  wire                oSER8_19_Q1;
  wire                oSER8_20_Q0;
  wire                oSER8_20_Q1;
  wire                raw_rst_n;
  wire                _zz_1;
  reg        [3:0]    pclkRstArea_holdCnt;
  wire                when_GowinDdr3Phy_l93;
  reg                 pclkRstArea_rst_pclk_n;
  reg                 pclkRstArea_rst_cmd_p;
  reg                 pclkRstArea_rst_io_p;
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  (* async_reg = "true" *) reg                 fclkRstArea_s0_cmd;
  (* async_reg = "true" *) reg                 fclkRstArea_s0_io;
  (* async_reg = "true" *) reg                 fclkRstArea_s1_cmd;
  (* async_reg = "true" *) reg                 fclkRstArea_s0_io_regNext;
  (* syn_keep = 1 *) reg                 fclkRstArea_rst_dqs0;
  (* syn_keep = 1 *) reg                 fclkRstArea_rst_dqs1;
  (* syn_keep = 1 *) reg                 fclkRstArea_rst_dq0a;
  (* syn_keep = 1 *) reg                 fclkRstArea_rst_dq0b;
  (* syn_keep = 1 *) reg                 fclkRstArea_rst_dq1a;
  (* syn_keep = 1 *) reg                 fclkRstArea_rst_dq1b;
  (* syn_keep = 1 , async_reg = "true" *) reg                 fclkRstArea_rst_cmd_a;
  (* syn_keep = 1 , async_reg = "true" *) reg                 fclkRstArea_rst_cmd_b;
  wire       [2:0]    dqs_waddr_0;
  wire       [2:0]    dqs_waddr_1;
  wire       [2:0]    dqs_raddr_0;
  wire       [2:0]    dqs_raddr_1;
  wire                clk_dqsr_0;
  wire                clk_dqsr_1;
  wire                clk_dqsw_0;
  wire                clk_dqsw_1;
  wire                clk_dqsw270_0;
  wire                clk_dqsw270_1;
  reg        [1:0]    rburst;
  reg        [1:0]    rvalid;
  reg        [1:0]    dqs_pad_in;
  reg        [1:0]    dqs_buf;
  reg        [1:0]    dqs_buf_oen;
  reg        [15:0]   dq_buf;
  reg        [15:0]   dq_buf_oen;
  reg        [15:0]   dq_pad_in;

  DLL #(
    .SCAL_EN  ("true"),
    .CODESCAL ("101" )
  ) dll_1 (
    .CLKIN    (io_fclk        ), //i
    .RESET    (dll_1_RESET    ), //i
    .STOP     (1'b0           ), //i
    .UPDNCNTL (1'b0           ), //i
    .STEP     (dll_1_STEP[7:0]), //o
    .LOCK     (dll_1_LOCK     )  //o
  );
  DQS #(
    .DQS_MODE ("X4"   ),
    .HWL      ("false")
  ) dQS_1 (
    .FCLK    (io_fclk             ), //i
    .PCLK    (io_pclk             ), //i
    .DQSIN   (dQS_1_DQSIN         ), //i
    .RESET   (fclkRstArea_rst_dqs0), //i
    .HOLD    (io_dqs_hold         ), //i
    .RLOADN  (io_rloadn           ), //i
    .WLOADN  (1'b0                ), //i
    .RMOVE   (io_rmove            ), //i
    .WMOVE   (1'b0                ), //i
    .RDIR    (io_rdir             ), //i
    .DLLSTEP (dll_1_STEP[7:0]     ), //i
    .WSTEP   (io_wstep[7:0]       ), //i
    .RCLKSEL (io_rclksel[2:0]     ), //i
    .READ    (io_dqs_read[3:0]    ), //i
    .DQSR90  (dQS_1_DQSR90        ), //o
    .WPOINT  (dQS_1_WPOINT[2:0]   ), //o
    .RPOINT  (dQS_1_RPOINT[2:0]   ), //o
    .DQSW0   (dQS_1_DQSW0         ), //o
    .DQSW270 (dQS_1_DQSW270       ), //o
    .RBURST  (dQS_1_RBURST        ), //o
    .RVALID  (dQS_1_RVALID        )  //o
  );
  OSER8_MEM oSER8_MEM_1 (
    .D0    (oSER8_MEM_1_D0      ), //i
    .D1    (oSER8_MEM_1_D1      ), //i
    .D2    (oSER8_MEM_1_D2      ), //i
    .D3    (oSER8_MEM_1_D3      ), //i
    .D4    (oSER8_MEM_1_D4      ), //i
    .D5    (oSER8_MEM_1_D5      ), //i
    .D6    (oSER8_MEM_1_D6      ), //i
    .D7    (oSER8_MEM_1_D7      ), //i
    .TX0   (oSER8_MEM_1_TX0     ), //i
    .TX1   (oSER8_MEM_1_TX1     ), //i
    .TX2   (oSER8_MEM_1_TX2     ), //i
    .TX3   (oSER8_MEM_1_TX3     ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw_0          ), //i
    .RESET (fclkRstArea_rst_dqs0), //i
    .Q0    (oSER8_MEM_1_Q0      ), //o
    .Q1    (oSER8_MEM_1_Q1      )  //o
  );
  IOBUF iOBUF_1 (
    .I   (iOBUF_1_I         ), //i
    .OEN (iOBUF_1_OEN       ), //i
    .O   (iOBUF_1_O         ), //o
    .IO  (io_pad_DDR3_DQS[0])  //~
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_2 (
    .D0    (oSER8_MEM_2_D0      ), //i
    .D1    (oSER8_MEM_2_D1      ), //i
    .D2    (oSER8_MEM_2_D2      ), //i
    .D3    (oSER8_MEM_2_D3      ), //i
    .D4    (oSER8_MEM_2_D4      ), //i
    .D5    (oSER8_MEM_2_D5      ), //i
    .D6    (oSER8_MEM_2_D6      ), //i
    .D7    (oSER8_MEM_2_D7      ), //i
    .TX0   (1'b0                ), //i
    .TX1   (1'b0                ), //i
    .TX2   (1'b0                ), //i
    .TX3   (1'b0                ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_0       ), //i
    .RESET (fclkRstArea_rst_dqs0), //i
    .Q0    (oSER8_MEM_2_Q0      ), //o
    .Q1    (oSER8_MEM_2_Q1      )  //o
  );
  DQS #(
    .DQS_MODE ("X4"   ),
    .HWL      ("false")
  ) dQS_2 (
    .FCLK    (io_fclk             ), //i
    .PCLK    (io_pclk             ), //i
    .DQSIN   (dQS_2_DQSIN         ), //i
    .RESET   (fclkRstArea_rst_dqs1), //i
    .HOLD    (io_dqs_hold         ), //i
    .RLOADN  (io_rloadn           ), //i
    .WLOADN  (1'b0                ), //i
    .RMOVE   (io_rmove            ), //i
    .WMOVE   (1'b0                ), //i
    .RDIR    (io_rdir             ), //i
    .DLLSTEP (dll_1_STEP[7:0]     ), //i
    .WSTEP   (io_wstep[7:0]       ), //i
    .RCLKSEL (io_rclksel[2:0]     ), //i
    .READ    (io_dqs_read[3:0]    ), //i
    .DQSR90  (dQS_2_DQSR90        ), //o
    .WPOINT  (dQS_2_WPOINT[2:0]   ), //o
    .RPOINT  (dQS_2_RPOINT[2:0]   ), //o
    .DQSW0   (dQS_2_DQSW0         ), //o
    .DQSW270 (dQS_2_DQSW270       ), //o
    .RBURST  (dQS_2_RBURST        ), //o
    .RVALID  (dQS_2_RVALID        )  //o
  );
  OSER8_MEM oSER8_MEM_3 (
    .D0    (oSER8_MEM_3_D0      ), //i
    .D1    (oSER8_MEM_3_D1      ), //i
    .D2    (oSER8_MEM_3_D2      ), //i
    .D3    (oSER8_MEM_3_D3      ), //i
    .D4    (oSER8_MEM_3_D4      ), //i
    .D5    (oSER8_MEM_3_D5      ), //i
    .D6    (oSER8_MEM_3_D6      ), //i
    .D7    (oSER8_MEM_3_D7      ), //i
    .TX0   (oSER8_MEM_3_TX0     ), //i
    .TX1   (oSER8_MEM_3_TX1     ), //i
    .TX2   (oSER8_MEM_3_TX2     ), //i
    .TX3   (oSER8_MEM_3_TX3     ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw_1          ), //i
    .RESET (fclkRstArea_rst_dqs1), //i
    .Q0    (oSER8_MEM_3_Q0      ), //o
    .Q1    (oSER8_MEM_3_Q1      )  //o
  );
  IOBUF iOBUF_2 (
    .I   (iOBUF_2_I         ), //i
    .OEN (iOBUF_2_OEN       ), //i
    .O   (iOBUF_2_O         ), //o
    .IO  (io_pad_DDR3_DQS[1])  //~
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_4 (
    .D0    (oSER8_MEM_4_D0      ), //i
    .D1    (oSER8_MEM_4_D1      ), //i
    .D2    (oSER8_MEM_4_D2      ), //i
    .D3    (oSER8_MEM_4_D3      ), //i
    .D4    (oSER8_MEM_4_D4      ), //i
    .D5    (oSER8_MEM_4_D5      ), //i
    .D6    (oSER8_MEM_4_D6      ), //i
    .D7    (oSER8_MEM_4_D7      ), //i
    .TX0   (1'b0                ), //i
    .TX1   (1'b0                ), //i
    .TX2   (1'b0                ), //i
    .TX3   (1'b0                ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_1       ), //i
    .RESET (fclkRstArea_rst_dqs1), //i
    .Q0    (oSER8_MEM_4_Q0      ), //o
    .Q1    (oSER8_MEM_4_Q1      )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_5 (
    .D0    (oSER8_MEM_5_D0      ), //i
    .D1    (oSER8_MEM_5_D1      ), //i
    .D2    (oSER8_MEM_5_D2      ), //i
    .D3    (oSER8_MEM_5_D3      ), //i
    .D4    (oSER8_MEM_5_D4      ), //i
    .D5    (oSER8_MEM_5_D5      ), //i
    .D6    (oSER8_MEM_5_D6      ), //i
    .D7    (oSER8_MEM_5_D7      ), //i
    .TX0   (oSER8_MEM_5_TX0     ), //i
    .TX1   (oSER8_MEM_5_TX1     ), //i
    .TX2   (oSER8_MEM_5_TX2     ), //i
    .TX3   (oSER8_MEM_5_TX3     ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_0       ), //i
    .RESET (fclkRstArea_rst_dq0a), //i
    .Q0    (oSER8_MEM_5_Q0      ), //o
    .Q1    (oSER8_MEM_5_Q1      )  //o
  );
  IOBUF iOBUF_3 (
    .I   (iOBUF_3_I        ), //i
    .OEN (iOBUF_3_OEN      ), //i
    .O   (iOBUF_3_O        ), //o
    .IO  (io_pad_DDR3_DQ[0])  //~
  );
  IDES8_MEM iDES8_MEM_1 (
    .D     (iDES8_MEM_1_D       ), //i
    .ICLK  (clk_dqsr_0          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq0a), //i
    .WADDR (dqs_waddr_0[2:0]    ), //i
    .RADDR (dqs_raddr_0[2:0]    ), //i
    .Q0    (iDES8_MEM_1_Q0      ), //o
    .Q1    (iDES8_MEM_1_Q1      ), //o
    .Q2    (iDES8_MEM_1_Q2      ), //o
    .Q3    (iDES8_MEM_1_Q3      ), //o
    .Q4    (iDES8_MEM_1_Q4      ), //o
    .Q5    (iDES8_MEM_1_Q5      ), //o
    .Q6    (iDES8_MEM_1_Q6      ), //o
    .Q7    (iDES8_MEM_1_Q7      )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_6 (
    .D0    (oSER8_MEM_6_D0      ), //i
    .D1    (oSER8_MEM_6_D1      ), //i
    .D2    (oSER8_MEM_6_D2      ), //i
    .D3    (oSER8_MEM_6_D3      ), //i
    .D4    (oSER8_MEM_6_D4      ), //i
    .D5    (oSER8_MEM_6_D5      ), //i
    .D6    (oSER8_MEM_6_D6      ), //i
    .D7    (oSER8_MEM_6_D7      ), //i
    .TX0   (oSER8_MEM_6_TX0     ), //i
    .TX1   (oSER8_MEM_6_TX1     ), //i
    .TX2   (oSER8_MEM_6_TX2     ), //i
    .TX3   (oSER8_MEM_6_TX3     ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_0       ), //i
    .RESET (fclkRstArea_rst_dq0a), //i
    .Q0    (oSER8_MEM_6_Q0      ), //o
    .Q1    (oSER8_MEM_6_Q1      )  //o
  );
  IOBUF iOBUF_4 (
    .I   (iOBUF_4_I        ), //i
    .OEN (iOBUF_4_OEN      ), //i
    .O   (iOBUF_4_O        ), //o
    .IO  (io_pad_DDR3_DQ[1])  //~
  );
  IDES8_MEM iDES8_MEM_2 (
    .D     (iDES8_MEM_2_D       ), //i
    .ICLK  (clk_dqsr_0          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq0a), //i
    .WADDR (dqs_waddr_0[2:0]    ), //i
    .RADDR (dqs_raddr_0[2:0]    ), //i
    .Q0    (iDES8_MEM_2_Q0      ), //o
    .Q1    (iDES8_MEM_2_Q1      ), //o
    .Q2    (iDES8_MEM_2_Q2      ), //o
    .Q3    (iDES8_MEM_2_Q3      ), //o
    .Q4    (iDES8_MEM_2_Q4      ), //o
    .Q5    (iDES8_MEM_2_Q5      ), //o
    .Q6    (iDES8_MEM_2_Q6      ), //o
    .Q7    (iDES8_MEM_2_Q7      )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_7 (
    .D0    (oSER8_MEM_7_D0      ), //i
    .D1    (oSER8_MEM_7_D1      ), //i
    .D2    (oSER8_MEM_7_D2      ), //i
    .D3    (oSER8_MEM_7_D3      ), //i
    .D4    (oSER8_MEM_7_D4      ), //i
    .D5    (oSER8_MEM_7_D5      ), //i
    .D6    (oSER8_MEM_7_D6      ), //i
    .D7    (oSER8_MEM_7_D7      ), //i
    .TX0   (oSER8_MEM_7_TX0     ), //i
    .TX1   (oSER8_MEM_7_TX1     ), //i
    .TX2   (oSER8_MEM_7_TX2     ), //i
    .TX3   (oSER8_MEM_7_TX3     ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_0       ), //i
    .RESET (fclkRstArea_rst_dq0a), //i
    .Q0    (oSER8_MEM_7_Q0      ), //o
    .Q1    (oSER8_MEM_7_Q1      )  //o
  );
  IOBUF iOBUF_5 (
    .I   (iOBUF_5_I        ), //i
    .OEN (iOBUF_5_OEN      ), //i
    .O   (iOBUF_5_O        ), //o
    .IO  (io_pad_DDR3_DQ[2])  //~
  );
  IDES8_MEM iDES8_MEM_3 (
    .D     (iDES8_MEM_3_D       ), //i
    .ICLK  (clk_dqsr_0          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq0a), //i
    .WADDR (dqs_waddr_0[2:0]    ), //i
    .RADDR (dqs_raddr_0[2:0]    ), //i
    .Q0    (iDES8_MEM_3_Q0      ), //o
    .Q1    (iDES8_MEM_3_Q1      ), //o
    .Q2    (iDES8_MEM_3_Q2      ), //o
    .Q3    (iDES8_MEM_3_Q3      ), //o
    .Q4    (iDES8_MEM_3_Q4      ), //o
    .Q5    (iDES8_MEM_3_Q5      ), //o
    .Q6    (iDES8_MEM_3_Q6      ), //o
    .Q7    (iDES8_MEM_3_Q7      )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_8 (
    .D0    (oSER8_MEM_8_D0      ), //i
    .D1    (oSER8_MEM_8_D1      ), //i
    .D2    (oSER8_MEM_8_D2      ), //i
    .D3    (oSER8_MEM_8_D3      ), //i
    .D4    (oSER8_MEM_8_D4      ), //i
    .D5    (oSER8_MEM_8_D5      ), //i
    .D6    (oSER8_MEM_8_D6      ), //i
    .D7    (oSER8_MEM_8_D7      ), //i
    .TX0   (oSER8_MEM_8_TX0     ), //i
    .TX1   (oSER8_MEM_8_TX1     ), //i
    .TX2   (oSER8_MEM_8_TX2     ), //i
    .TX3   (oSER8_MEM_8_TX3     ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_0       ), //i
    .RESET (fclkRstArea_rst_dq0a), //i
    .Q0    (oSER8_MEM_8_Q0      ), //o
    .Q1    (oSER8_MEM_8_Q1      )  //o
  );
  IOBUF iOBUF_6 (
    .I   (iOBUF_6_I        ), //i
    .OEN (iOBUF_6_OEN      ), //i
    .O   (iOBUF_6_O        ), //o
    .IO  (io_pad_DDR3_DQ[3])  //~
  );
  IDES8_MEM iDES8_MEM_4 (
    .D     (iDES8_MEM_4_D       ), //i
    .ICLK  (clk_dqsr_0          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq0a), //i
    .WADDR (dqs_waddr_0[2:0]    ), //i
    .RADDR (dqs_raddr_0[2:0]    ), //i
    .Q0    (iDES8_MEM_4_Q0      ), //o
    .Q1    (iDES8_MEM_4_Q1      ), //o
    .Q2    (iDES8_MEM_4_Q2      ), //o
    .Q3    (iDES8_MEM_4_Q3      ), //o
    .Q4    (iDES8_MEM_4_Q4      ), //o
    .Q5    (iDES8_MEM_4_Q5      ), //o
    .Q6    (iDES8_MEM_4_Q6      ), //o
    .Q7    (iDES8_MEM_4_Q7      )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_9 (
    .D0    (oSER8_MEM_9_D0      ), //i
    .D1    (oSER8_MEM_9_D1      ), //i
    .D2    (oSER8_MEM_9_D2      ), //i
    .D3    (oSER8_MEM_9_D3      ), //i
    .D4    (oSER8_MEM_9_D4      ), //i
    .D5    (oSER8_MEM_9_D5      ), //i
    .D6    (oSER8_MEM_9_D6      ), //i
    .D7    (oSER8_MEM_9_D7      ), //i
    .TX0   (oSER8_MEM_9_TX0     ), //i
    .TX1   (oSER8_MEM_9_TX1     ), //i
    .TX2   (oSER8_MEM_9_TX2     ), //i
    .TX3   (oSER8_MEM_9_TX3     ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_0       ), //i
    .RESET (fclkRstArea_rst_dq0b), //i
    .Q0    (oSER8_MEM_9_Q0      ), //o
    .Q1    (oSER8_MEM_9_Q1      )  //o
  );
  IOBUF iOBUF_7 (
    .I   (iOBUF_7_I        ), //i
    .OEN (iOBUF_7_OEN      ), //i
    .O   (iOBUF_7_O        ), //o
    .IO  (io_pad_DDR3_DQ[4])  //~
  );
  IDES8_MEM iDES8_MEM_5 (
    .D     (iDES8_MEM_5_D       ), //i
    .ICLK  (clk_dqsr_0          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq0b), //i
    .WADDR (dqs_waddr_0[2:0]    ), //i
    .RADDR (dqs_raddr_0[2:0]    ), //i
    .Q0    (iDES8_MEM_5_Q0      ), //o
    .Q1    (iDES8_MEM_5_Q1      ), //o
    .Q2    (iDES8_MEM_5_Q2      ), //o
    .Q3    (iDES8_MEM_5_Q3      ), //o
    .Q4    (iDES8_MEM_5_Q4      ), //o
    .Q5    (iDES8_MEM_5_Q5      ), //o
    .Q6    (iDES8_MEM_5_Q6      ), //o
    .Q7    (iDES8_MEM_5_Q7      )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_10 (
    .D0    (oSER8_MEM_10_D0     ), //i
    .D1    (oSER8_MEM_10_D1     ), //i
    .D2    (oSER8_MEM_10_D2     ), //i
    .D3    (oSER8_MEM_10_D3     ), //i
    .D4    (oSER8_MEM_10_D4     ), //i
    .D5    (oSER8_MEM_10_D5     ), //i
    .D6    (oSER8_MEM_10_D6     ), //i
    .D7    (oSER8_MEM_10_D7     ), //i
    .TX0   (oSER8_MEM_10_TX0    ), //i
    .TX1   (oSER8_MEM_10_TX1    ), //i
    .TX2   (oSER8_MEM_10_TX2    ), //i
    .TX3   (oSER8_MEM_10_TX3    ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_0       ), //i
    .RESET (fclkRstArea_rst_dq0b), //i
    .Q0    (oSER8_MEM_10_Q0     ), //o
    .Q1    (oSER8_MEM_10_Q1     )  //o
  );
  IOBUF iOBUF_8 (
    .I   (iOBUF_8_I        ), //i
    .OEN (iOBUF_8_OEN      ), //i
    .O   (iOBUF_8_O        ), //o
    .IO  (io_pad_DDR3_DQ[5])  //~
  );
  IDES8_MEM iDES8_MEM_6 (
    .D     (iDES8_MEM_6_D       ), //i
    .ICLK  (clk_dqsr_0          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq0b), //i
    .WADDR (dqs_waddr_0[2:0]    ), //i
    .RADDR (dqs_raddr_0[2:0]    ), //i
    .Q0    (iDES8_MEM_6_Q0      ), //o
    .Q1    (iDES8_MEM_6_Q1      ), //o
    .Q2    (iDES8_MEM_6_Q2      ), //o
    .Q3    (iDES8_MEM_6_Q3      ), //o
    .Q4    (iDES8_MEM_6_Q4      ), //o
    .Q5    (iDES8_MEM_6_Q5      ), //o
    .Q6    (iDES8_MEM_6_Q6      ), //o
    .Q7    (iDES8_MEM_6_Q7      )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_11 (
    .D0    (oSER8_MEM_11_D0     ), //i
    .D1    (oSER8_MEM_11_D1     ), //i
    .D2    (oSER8_MEM_11_D2     ), //i
    .D3    (oSER8_MEM_11_D3     ), //i
    .D4    (oSER8_MEM_11_D4     ), //i
    .D5    (oSER8_MEM_11_D5     ), //i
    .D6    (oSER8_MEM_11_D6     ), //i
    .D7    (oSER8_MEM_11_D7     ), //i
    .TX0   (oSER8_MEM_11_TX0    ), //i
    .TX1   (oSER8_MEM_11_TX1    ), //i
    .TX2   (oSER8_MEM_11_TX2    ), //i
    .TX3   (oSER8_MEM_11_TX3    ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_0       ), //i
    .RESET (fclkRstArea_rst_dq0b), //i
    .Q0    (oSER8_MEM_11_Q0     ), //o
    .Q1    (oSER8_MEM_11_Q1     )  //o
  );
  IOBUF iOBUF_9 (
    .I   (iOBUF_9_I        ), //i
    .OEN (iOBUF_9_OEN      ), //i
    .O   (iOBUF_9_O        ), //o
    .IO  (io_pad_DDR3_DQ[6])  //~
  );
  IDES8_MEM iDES8_MEM_7 (
    .D     (iDES8_MEM_7_D       ), //i
    .ICLK  (clk_dqsr_0          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq0b), //i
    .WADDR (dqs_waddr_0[2:0]    ), //i
    .RADDR (dqs_raddr_0[2:0]    ), //i
    .Q0    (iDES8_MEM_7_Q0      ), //o
    .Q1    (iDES8_MEM_7_Q1      ), //o
    .Q2    (iDES8_MEM_7_Q2      ), //o
    .Q3    (iDES8_MEM_7_Q3      ), //o
    .Q4    (iDES8_MEM_7_Q4      ), //o
    .Q5    (iDES8_MEM_7_Q5      ), //o
    .Q6    (iDES8_MEM_7_Q6      ), //o
    .Q7    (iDES8_MEM_7_Q7      )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_12 (
    .D0    (oSER8_MEM_12_D0     ), //i
    .D1    (oSER8_MEM_12_D1     ), //i
    .D2    (oSER8_MEM_12_D2     ), //i
    .D3    (oSER8_MEM_12_D3     ), //i
    .D4    (oSER8_MEM_12_D4     ), //i
    .D5    (oSER8_MEM_12_D5     ), //i
    .D6    (oSER8_MEM_12_D6     ), //i
    .D7    (oSER8_MEM_12_D7     ), //i
    .TX0   (oSER8_MEM_12_TX0    ), //i
    .TX1   (oSER8_MEM_12_TX1    ), //i
    .TX2   (oSER8_MEM_12_TX2    ), //i
    .TX3   (oSER8_MEM_12_TX3    ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_0       ), //i
    .RESET (fclkRstArea_rst_dq0b), //i
    .Q0    (oSER8_MEM_12_Q0     ), //o
    .Q1    (oSER8_MEM_12_Q1     )  //o
  );
  IOBUF iOBUF_10 (
    .I   (iOBUF_10_I       ), //i
    .OEN (iOBUF_10_OEN     ), //i
    .O   (iOBUF_10_O       ), //o
    .IO  (io_pad_DDR3_DQ[7])  //~
  );
  IDES8_MEM iDES8_MEM_8 (
    .D     (iDES8_MEM_8_D       ), //i
    .ICLK  (clk_dqsr_0          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq0b), //i
    .WADDR (dqs_waddr_0[2:0]    ), //i
    .RADDR (dqs_raddr_0[2:0]    ), //i
    .Q0    (iDES8_MEM_8_Q0      ), //o
    .Q1    (iDES8_MEM_8_Q1      ), //o
    .Q2    (iDES8_MEM_8_Q2      ), //o
    .Q3    (iDES8_MEM_8_Q3      ), //o
    .Q4    (iDES8_MEM_8_Q4      ), //o
    .Q5    (iDES8_MEM_8_Q5      ), //o
    .Q6    (iDES8_MEM_8_Q6      ), //o
    .Q7    (iDES8_MEM_8_Q7      )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_13 (
    .D0    (oSER8_MEM_13_D0     ), //i
    .D1    (oSER8_MEM_13_D1     ), //i
    .D2    (oSER8_MEM_13_D2     ), //i
    .D3    (oSER8_MEM_13_D3     ), //i
    .D4    (oSER8_MEM_13_D4     ), //i
    .D5    (oSER8_MEM_13_D5     ), //i
    .D6    (oSER8_MEM_13_D6     ), //i
    .D7    (oSER8_MEM_13_D7     ), //i
    .TX0   (oSER8_MEM_13_TX0    ), //i
    .TX1   (oSER8_MEM_13_TX1    ), //i
    .TX2   (oSER8_MEM_13_TX2    ), //i
    .TX3   (oSER8_MEM_13_TX3    ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_1       ), //i
    .RESET (fclkRstArea_rst_dq1a), //i
    .Q0    (oSER8_MEM_13_Q0     ), //o
    .Q1    (oSER8_MEM_13_Q1     )  //o
  );
  IOBUF iOBUF_11 (
    .I   (iOBUF_11_I       ), //i
    .OEN (iOBUF_11_OEN     ), //i
    .O   (iOBUF_11_O       ), //o
    .IO  (io_pad_DDR3_DQ[8])  //~
  );
  IDES8_MEM iDES8_MEM_9 (
    .D     (iDES8_MEM_9_D       ), //i
    .ICLK  (clk_dqsr_1          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq1a), //i
    .WADDR (dqs_waddr_1[2:0]    ), //i
    .RADDR (dqs_raddr_1[2:0]    ), //i
    .Q0    (iDES8_MEM_9_Q0      ), //o
    .Q1    (iDES8_MEM_9_Q1      ), //o
    .Q2    (iDES8_MEM_9_Q2      ), //o
    .Q3    (iDES8_MEM_9_Q3      ), //o
    .Q4    (iDES8_MEM_9_Q4      ), //o
    .Q5    (iDES8_MEM_9_Q5      ), //o
    .Q6    (iDES8_MEM_9_Q6      ), //o
    .Q7    (iDES8_MEM_9_Q7      )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_14 (
    .D0    (oSER8_MEM_14_D0     ), //i
    .D1    (oSER8_MEM_14_D1     ), //i
    .D2    (oSER8_MEM_14_D2     ), //i
    .D3    (oSER8_MEM_14_D3     ), //i
    .D4    (oSER8_MEM_14_D4     ), //i
    .D5    (oSER8_MEM_14_D5     ), //i
    .D6    (oSER8_MEM_14_D6     ), //i
    .D7    (oSER8_MEM_14_D7     ), //i
    .TX0   (oSER8_MEM_14_TX0    ), //i
    .TX1   (oSER8_MEM_14_TX1    ), //i
    .TX2   (oSER8_MEM_14_TX2    ), //i
    .TX3   (oSER8_MEM_14_TX3    ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_1       ), //i
    .RESET (fclkRstArea_rst_dq1a), //i
    .Q0    (oSER8_MEM_14_Q0     ), //o
    .Q1    (oSER8_MEM_14_Q1     )  //o
  );
  IOBUF iOBUF_12 (
    .I   (iOBUF_12_I       ), //i
    .OEN (iOBUF_12_OEN     ), //i
    .O   (iOBUF_12_O       ), //o
    .IO  (io_pad_DDR3_DQ[9])  //~
  );
  IDES8_MEM iDES8_MEM_10 (
    .D     (iDES8_MEM_10_D      ), //i
    .ICLK  (clk_dqsr_1          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq1a), //i
    .WADDR (dqs_waddr_1[2:0]    ), //i
    .RADDR (dqs_raddr_1[2:0]    ), //i
    .Q0    (iDES8_MEM_10_Q0     ), //o
    .Q1    (iDES8_MEM_10_Q1     ), //o
    .Q2    (iDES8_MEM_10_Q2     ), //o
    .Q3    (iDES8_MEM_10_Q3     ), //o
    .Q4    (iDES8_MEM_10_Q4     ), //o
    .Q5    (iDES8_MEM_10_Q5     ), //o
    .Q6    (iDES8_MEM_10_Q6     ), //o
    .Q7    (iDES8_MEM_10_Q7     )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_15 (
    .D0    (oSER8_MEM_15_D0     ), //i
    .D1    (oSER8_MEM_15_D1     ), //i
    .D2    (oSER8_MEM_15_D2     ), //i
    .D3    (oSER8_MEM_15_D3     ), //i
    .D4    (oSER8_MEM_15_D4     ), //i
    .D5    (oSER8_MEM_15_D5     ), //i
    .D6    (oSER8_MEM_15_D6     ), //i
    .D7    (oSER8_MEM_15_D7     ), //i
    .TX0   (oSER8_MEM_15_TX0    ), //i
    .TX1   (oSER8_MEM_15_TX1    ), //i
    .TX2   (oSER8_MEM_15_TX2    ), //i
    .TX3   (oSER8_MEM_15_TX3    ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_1       ), //i
    .RESET (fclkRstArea_rst_dq1a), //i
    .Q0    (oSER8_MEM_15_Q0     ), //o
    .Q1    (oSER8_MEM_15_Q1     )  //o
  );
  IOBUF iOBUF_13 (
    .I   (iOBUF_13_I        ), //i
    .OEN (iOBUF_13_OEN      ), //i
    .O   (iOBUF_13_O        ), //o
    .IO  (io_pad_DDR3_DQ[10])  //~
  );
  IDES8_MEM iDES8_MEM_11 (
    .D     (iDES8_MEM_11_D      ), //i
    .ICLK  (clk_dqsr_1          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq1a), //i
    .WADDR (dqs_waddr_1[2:0]    ), //i
    .RADDR (dqs_raddr_1[2:0]    ), //i
    .Q0    (iDES8_MEM_11_Q0     ), //o
    .Q1    (iDES8_MEM_11_Q1     ), //o
    .Q2    (iDES8_MEM_11_Q2     ), //o
    .Q3    (iDES8_MEM_11_Q3     ), //o
    .Q4    (iDES8_MEM_11_Q4     ), //o
    .Q5    (iDES8_MEM_11_Q5     ), //o
    .Q6    (iDES8_MEM_11_Q6     ), //o
    .Q7    (iDES8_MEM_11_Q7     )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_16 (
    .D0    (oSER8_MEM_16_D0     ), //i
    .D1    (oSER8_MEM_16_D1     ), //i
    .D2    (oSER8_MEM_16_D2     ), //i
    .D3    (oSER8_MEM_16_D3     ), //i
    .D4    (oSER8_MEM_16_D4     ), //i
    .D5    (oSER8_MEM_16_D5     ), //i
    .D6    (oSER8_MEM_16_D6     ), //i
    .D7    (oSER8_MEM_16_D7     ), //i
    .TX0   (oSER8_MEM_16_TX0    ), //i
    .TX1   (oSER8_MEM_16_TX1    ), //i
    .TX2   (oSER8_MEM_16_TX2    ), //i
    .TX3   (oSER8_MEM_16_TX3    ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_1       ), //i
    .RESET (fclkRstArea_rst_dq1a), //i
    .Q0    (oSER8_MEM_16_Q0     ), //o
    .Q1    (oSER8_MEM_16_Q1     )  //o
  );
  IOBUF iOBUF_14 (
    .I   (iOBUF_14_I        ), //i
    .OEN (iOBUF_14_OEN      ), //i
    .O   (iOBUF_14_O        ), //o
    .IO  (io_pad_DDR3_DQ[11])  //~
  );
  IDES8_MEM iDES8_MEM_12 (
    .D     (iDES8_MEM_12_D      ), //i
    .ICLK  (clk_dqsr_1          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq1a), //i
    .WADDR (dqs_waddr_1[2:0]    ), //i
    .RADDR (dqs_raddr_1[2:0]    ), //i
    .Q0    (iDES8_MEM_12_Q0     ), //o
    .Q1    (iDES8_MEM_12_Q1     ), //o
    .Q2    (iDES8_MEM_12_Q2     ), //o
    .Q3    (iDES8_MEM_12_Q3     ), //o
    .Q4    (iDES8_MEM_12_Q4     ), //o
    .Q5    (iDES8_MEM_12_Q5     ), //o
    .Q6    (iDES8_MEM_12_Q6     ), //o
    .Q7    (iDES8_MEM_12_Q7     )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_17 (
    .D0    (oSER8_MEM_17_D0     ), //i
    .D1    (oSER8_MEM_17_D1     ), //i
    .D2    (oSER8_MEM_17_D2     ), //i
    .D3    (oSER8_MEM_17_D3     ), //i
    .D4    (oSER8_MEM_17_D4     ), //i
    .D5    (oSER8_MEM_17_D5     ), //i
    .D6    (oSER8_MEM_17_D6     ), //i
    .D7    (oSER8_MEM_17_D7     ), //i
    .TX0   (oSER8_MEM_17_TX0    ), //i
    .TX1   (oSER8_MEM_17_TX1    ), //i
    .TX2   (oSER8_MEM_17_TX2    ), //i
    .TX3   (oSER8_MEM_17_TX3    ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_1       ), //i
    .RESET (fclkRstArea_rst_dq1b), //i
    .Q0    (oSER8_MEM_17_Q0     ), //o
    .Q1    (oSER8_MEM_17_Q1     )  //o
  );
  IOBUF iOBUF_15 (
    .I   (iOBUF_15_I        ), //i
    .OEN (iOBUF_15_OEN      ), //i
    .O   (iOBUF_15_O        ), //o
    .IO  (io_pad_DDR3_DQ[12])  //~
  );
  IDES8_MEM iDES8_MEM_13 (
    .D     (iDES8_MEM_13_D      ), //i
    .ICLK  (clk_dqsr_1          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq1b), //i
    .WADDR (dqs_waddr_1[2:0]    ), //i
    .RADDR (dqs_raddr_1[2:0]    ), //i
    .Q0    (iDES8_MEM_13_Q0     ), //o
    .Q1    (iDES8_MEM_13_Q1     ), //o
    .Q2    (iDES8_MEM_13_Q2     ), //o
    .Q3    (iDES8_MEM_13_Q3     ), //o
    .Q4    (iDES8_MEM_13_Q4     ), //o
    .Q5    (iDES8_MEM_13_Q5     ), //o
    .Q6    (iDES8_MEM_13_Q6     ), //o
    .Q7    (iDES8_MEM_13_Q7     )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_18 (
    .D0    (oSER8_MEM_18_D0     ), //i
    .D1    (oSER8_MEM_18_D1     ), //i
    .D2    (oSER8_MEM_18_D2     ), //i
    .D3    (oSER8_MEM_18_D3     ), //i
    .D4    (oSER8_MEM_18_D4     ), //i
    .D5    (oSER8_MEM_18_D5     ), //i
    .D6    (oSER8_MEM_18_D6     ), //i
    .D7    (oSER8_MEM_18_D7     ), //i
    .TX0   (oSER8_MEM_18_TX0    ), //i
    .TX1   (oSER8_MEM_18_TX1    ), //i
    .TX2   (oSER8_MEM_18_TX2    ), //i
    .TX3   (oSER8_MEM_18_TX3    ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_1       ), //i
    .RESET (fclkRstArea_rst_dq1b), //i
    .Q0    (oSER8_MEM_18_Q0     ), //o
    .Q1    (oSER8_MEM_18_Q1     )  //o
  );
  IOBUF iOBUF_16 (
    .I   (iOBUF_16_I        ), //i
    .OEN (iOBUF_16_OEN      ), //i
    .O   (iOBUF_16_O        ), //o
    .IO  (io_pad_DDR3_DQ[13])  //~
  );
  IDES8_MEM iDES8_MEM_14 (
    .D     (iDES8_MEM_14_D      ), //i
    .ICLK  (clk_dqsr_1          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq1b), //i
    .WADDR (dqs_waddr_1[2:0]    ), //i
    .RADDR (dqs_raddr_1[2:0]    ), //i
    .Q0    (iDES8_MEM_14_Q0     ), //o
    .Q1    (iDES8_MEM_14_Q1     ), //o
    .Q2    (iDES8_MEM_14_Q2     ), //o
    .Q3    (iDES8_MEM_14_Q3     ), //o
    .Q4    (iDES8_MEM_14_Q4     ), //o
    .Q5    (iDES8_MEM_14_Q5     ), //o
    .Q6    (iDES8_MEM_14_Q6     ), //o
    .Q7    (iDES8_MEM_14_Q7     )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_19 (
    .D0    (oSER8_MEM_19_D0     ), //i
    .D1    (oSER8_MEM_19_D1     ), //i
    .D2    (oSER8_MEM_19_D2     ), //i
    .D3    (oSER8_MEM_19_D3     ), //i
    .D4    (oSER8_MEM_19_D4     ), //i
    .D5    (oSER8_MEM_19_D5     ), //i
    .D6    (oSER8_MEM_19_D6     ), //i
    .D7    (oSER8_MEM_19_D7     ), //i
    .TX0   (oSER8_MEM_19_TX0    ), //i
    .TX1   (oSER8_MEM_19_TX1    ), //i
    .TX2   (oSER8_MEM_19_TX2    ), //i
    .TX3   (oSER8_MEM_19_TX3    ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_1       ), //i
    .RESET (fclkRstArea_rst_dq1b), //i
    .Q0    (oSER8_MEM_19_Q0     ), //o
    .Q1    (oSER8_MEM_19_Q1     )  //o
  );
  IOBUF iOBUF_17 (
    .I   (iOBUF_17_I        ), //i
    .OEN (iOBUF_17_OEN      ), //i
    .O   (iOBUF_17_O        ), //o
    .IO  (io_pad_DDR3_DQ[14])  //~
  );
  IDES8_MEM iDES8_MEM_15 (
    .D     (iDES8_MEM_15_D      ), //i
    .ICLK  (clk_dqsr_1          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq1b), //i
    .WADDR (dqs_waddr_1[2:0]    ), //i
    .RADDR (dqs_raddr_1[2:0]    ), //i
    .Q0    (iDES8_MEM_15_Q0     ), //o
    .Q1    (iDES8_MEM_15_Q1     ), //o
    .Q2    (iDES8_MEM_15_Q2     ), //o
    .Q3    (iDES8_MEM_15_Q3     ), //o
    .Q4    (iDES8_MEM_15_Q4     ), //o
    .Q5    (iDES8_MEM_15_Q5     ), //o
    .Q6    (iDES8_MEM_15_Q6     ), //o
    .Q7    (iDES8_MEM_15_Q7     )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_20 (
    .D0    (oSER8_MEM_20_D0     ), //i
    .D1    (oSER8_MEM_20_D1     ), //i
    .D2    (oSER8_MEM_20_D2     ), //i
    .D3    (oSER8_MEM_20_D3     ), //i
    .D4    (oSER8_MEM_20_D4     ), //i
    .D5    (oSER8_MEM_20_D5     ), //i
    .D6    (oSER8_MEM_20_D6     ), //i
    .D7    (oSER8_MEM_20_D7     ), //i
    .TX0   (oSER8_MEM_20_TX0    ), //i
    .TX1   (oSER8_MEM_20_TX1    ), //i
    .TX2   (oSER8_MEM_20_TX2    ), //i
    .TX3   (oSER8_MEM_20_TX3    ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .TCLK  (clk_dqsw270_1       ), //i
    .RESET (fclkRstArea_rst_dq1b), //i
    .Q0    (oSER8_MEM_20_Q0     ), //o
    .Q1    (oSER8_MEM_20_Q1     )  //o
  );
  IOBUF iOBUF_18 (
    .I   (iOBUF_18_I        ), //i
    .OEN (iOBUF_18_OEN      ), //i
    .O   (iOBUF_18_O        ), //o
    .IO  (io_pad_DDR3_DQ[15])  //~
  );
  IDES8_MEM iDES8_MEM_16 (
    .D     (iDES8_MEM_16_D      ), //i
    .ICLK  (clk_dqsr_1          ), //i
    .FCLK  (io_fclk             ), //i
    .PCLK  (io_pclk             ), //i
    .CALIB (1'b0                ), //i
    .RESET (fclkRstArea_rst_dq1b), //i
    .WADDR (dqs_waddr_1[2:0]    ), //i
    .RADDR (dqs_raddr_1[2:0]    ), //i
    .Q0    (iDES8_MEM_16_Q0     ), //o
    .Q1    (iDES8_MEM_16_Q1     ), //o
    .Q2    (iDES8_MEM_16_Q2     ), //o
    .Q3    (iDES8_MEM_16_Q3     ), //o
    .Q4    (iDES8_MEM_16_Q4     ), //o
    .Q5    (iDES8_MEM_16_Q5     ), //o
    .Q6    (iDES8_MEM_16_Q6     ), //o
    .Q7    (iDES8_MEM_16_Q7     )  //o
  );
  OSER8 oSER8_1 (
    .D0    (io_nRAS_0            ), //i
    .D1    (io_nRAS_0            ), //i
    .D2    (io_nRAS_1            ), //i
    .D3    (io_nRAS_1            ), //i
    .D4    (io_nRAS_2            ), //i
    .D5    (io_nRAS_2            ), //i
    .D6    (io_nRAS_3            ), //i
    .D7    (io_nRAS_3            ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_a), //i
    .Q0    (oSER8_1_Q0           ), //o
    .Q1    (oSER8_1_Q1           )  //o
  );
  OSER8 oSER8_2 (
    .D0    (io_nCAS_0            ), //i
    .D1    (io_nCAS_0            ), //i
    .D2    (io_nCAS_1            ), //i
    .D3    (io_nCAS_1            ), //i
    .D4    (io_nCAS_2            ), //i
    .D5    (io_nCAS_2            ), //i
    .D6    (io_nCAS_3            ), //i
    .D7    (io_nCAS_3            ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_a), //i
    .Q0    (oSER8_2_Q0           ), //o
    .Q1    (oSER8_2_Q1           )  //o
  );
  OSER8 oSER8_3 (
    .D0    (io_nWE_0             ), //i
    .D1    (io_nWE_0             ), //i
    .D2    (io_nWE_1             ), //i
    .D3    (io_nWE_1             ), //i
    .D4    (io_nWE_2             ), //i
    .D5    (io_nWE_2             ), //i
    .D6    (io_nWE_3             ), //i
    .D7    (io_nWE_3             ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_a), //i
    .Q0    (oSER8_3_Q0           ), //o
    .Q1    (oSER8_3_Q1           )  //o
  );
  OSER8 oSER8_4 (
    .D0    (oSER8_4_D0           ), //i
    .D1    (oSER8_4_D1           ), //i
    .D2    (oSER8_4_D2           ), //i
    .D3    (oSER8_4_D3           ), //i
    .D4    (oSER8_4_D4           ), //i
    .D5    (oSER8_4_D5           ), //i
    .D6    (oSER8_4_D6           ), //i
    .D7    (oSER8_4_D7           ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_a), //i
    .Q0    (oSER8_4_Q0           ), //o
    .Q1    (oSER8_4_Q1           )  //o
  );
  OSER8 oSER8_5 (
    .D0    (oSER8_5_D0           ), //i
    .D1    (oSER8_5_D1           ), //i
    .D2    (oSER8_5_D2           ), //i
    .D3    (oSER8_5_D3           ), //i
    .D4    (oSER8_5_D4           ), //i
    .D5    (oSER8_5_D5           ), //i
    .D6    (oSER8_5_D6           ), //i
    .D7    (oSER8_5_D7           ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_a), //i
    .Q0    (oSER8_5_Q0           ), //o
    .Q1    (oSER8_5_Q1           )  //o
  );
  OSER8 oSER8_6 (
    .D0    (oSER8_6_D0           ), //i
    .D1    (oSER8_6_D1           ), //i
    .D2    (oSER8_6_D2           ), //i
    .D3    (oSER8_6_D3           ), //i
    .D4    (oSER8_6_D4           ), //i
    .D5    (oSER8_6_D5           ), //i
    .D6    (oSER8_6_D6           ), //i
    .D7    (oSER8_6_D7           ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_a), //i
    .Q0    (oSER8_6_Q0           ), //o
    .Q1    (oSER8_6_Q1           )  //o
  );
  OSER8 oSER8_7 (
    .D0    (oSER8_7_D0           ), //i
    .D1    (oSER8_7_D1           ), //i
    .D2    (oSER8_7_D2           ), //i
    .D3    (oSER8_7_D3           ), //i
    .D4    (oSER8_7_D4           ), //i
    .D5    (oSER8_7_D5           ), //i
    .D6    (oSER8_7_D6           ), //i
    .D7    (oSER8_7_D7           ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_a), //i
    .Q0    (oSER8_7_Q0           ), //o
    .Q1    (oSER8_7_Q1           )  //o
  );
  OSER8 oSER8_8 (
    .D0    (oSER8_8_D0           ), //i
    .D1    (oSER8_8_D1           ), //i
    .D2    (oSER8_8_D2           ), //i
    .D3    (oSER8_8_D3           ), //i
    .D4    (oSER8_8_D4           ), //i
    .D5    (oSER8_8_D5           ), //i
    .D6    (oSER8_8_D6           ), //i
    .D7    (oSER8_8_D7           ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_a), //i
    .Q0    (oSER8_8_Q0           ), //o
    .Q1    (oSER8_8_Q1           )  //o
  );
  OSER8 oSER8_9 (
    .D0    (oSER8_9_D0           ), //i
    .D1    (oSER8_9_D1           ), //i
    .D2    (oSER8_9_D2           ), //i
    .D3    (oSER8_9_D3           ), //i
    .D4    (oSER8_9_D4           ), //i
    .D5    (oSER8_9_D5           ), //i
    .D6    (oSER8_9_D6           ), //i
    .D7    (oSER8_9_D7           ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_a), //i
    .Q0    (oSER8_9_Q0           ), //o
    .Q1    (oSER8_9_Q1           )  //o
  );
  OSER8 oSER8_10 (
    .D0    (oSER8_10_D0          ), //i
    .D1    (oSER8_10_D1          ), //i
    .D2    (oSER8_10_D2          ), //i
    .D3    (oSER8_10_D3          ), //i
    .D4    (oSER8_10_D4          ), //i
    .D5    (oSER8_10_D5          ), //i
    .D6    (oSER8_10_D6          ), //i
    .D7    (oSER8_10_D7          ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_a), //i
    .Q0    (oSER8_10_Q0          ), //o
    .Q1    (oSER8_10_Q1          )  //o
  );
  OSER8 oSER8_11 (
    .D0    (oSER8_11_D0          ), //i
    .D1    (oSER8_11_D1          ), //i
    .D2    (oSER8_11_D2          ), //i
    .D3    (oSER8_11_D3          ), //i
    .D4    (oSER8_11_D4          ), //i
    .D5    (oSER8_11_D5          ), //i
    .D6    (oSER8_11_D6          ), //i
    .D7    (oSER8_11_D7          ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_b), //i
    .Q0    (oSER8_11_Q0          ), //o
    .Q1    (oSER8_11_Q1          )  //o
  );
  OSER8 oSER8_12 (
    .D0    (oSER8_12_D0          ), //i
    .D1    (oSER8_12_D1          ), //i
    .D2    (oSER8_12_D2          ), //i
    .D3    (oSER8_12_D3          ), //i
    .D4    (oSER8_12_D4          ), //i
    .D5    (oSER8_12_D5          ), //i
    .D6    (oSER8_12_D6          ), //i
    .D7    (oSER8_12_D7          ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_b), //i
    .Q0    (oSER8_12_Q0          ), //o
    .Q1    (oSER8_12_Q1          )  //o
  );
  OSER8 oSER8_13 (
    .D0    (oSER8_13_D0          ), //i
    .D1    (oSER8_13_D1          ), //i
    .D2    (oSER8_13_D2          ), //i
    .D3    (oSER8_13_D3          ), //i
    .D4    (oSER8_13_D4          ), //i
    .D5    (oSER8_13_D5          ), //i
    .D6    (oSER8_13_D6          ), //i
    .D7    (oSER8_13_D7          ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_b), //i
    .Q0    (oSER8_13_Q0          ), //o
    .Q1    (oSER8_13_Q1          )  //o
  );
  OSER8 oSER8_14 (
    .D0    (oSER8_14_D0          ), //i
    .D1    (oSER8_14_D1          ), //i
    .D2    (oSER8_14_D2          ), //i
    .D3    (oSER8_14_D3          ), //i
    .D4    (oSER8_14_D4          ), //i
    .D5    (oSER8_14_D5          ), //i
    .D6    (oSER8_14_D6          ), //i
    .D7    (oSER8_14_D7          ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_b), //i
    .Q0    (oSER8_14_Q0          ), //o
    .Q1    (oSER8_14_Q1          )  //o
  );
  OSER8 oSER8_15 (
    .D0    (oSER8_15_D0          ), //i
    .D1    (oSER8_15_D1          ), //i
    .D2    (oSER8_15_D2          ), //i
    .D3    (oSER8_15_D3          ), //i
    .D4    (oSER8_15_D4          ), //i
    .D5    (oSER8_15_D5          ), //i
    .D6    (oSER8_15_D6          ), //i
    .D7    (oSER8_15_D7          ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_b), //i
    .Q0    (oSER8_15_Q0          ), //o
    .Q1    (oSER8_15_Q1          )  //o
  );
  OSER8 oSER8_16 (
    .D0    (oSER8_16_D0          ), //i
    .D1    (oSER8_16_D1          ), //i
    .D2    (oSER8_16_D2          ), //i
    .D3    (oSER8_16_D3          ), //i
    .D4    (oSER8_16_D4          ), //i
    .D5    (oSER8_16_D5          ), //i
    .D6    (oSER8_16_D6          ), //i
    .D7    (oSER8_16_D7          ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_b), //i
    .Q0    (oSER8_16_Q0          ), //o
    .Q1    (oSER8_16_Q1          )  //o
  );
  OSER8 oSER8_17 (
    .D0    (oSER8_17_D0          ), //i
    .D1    (oSER8_17_D1          ), //i
    .D2    (oSER8_17_D2          ), //i
    .D3    (oSER8_17_D3          ), //i
    .D4    (oSER8_17_D4          ), //i
    .D5    (oSER8_17_D5          ), //i
    .D6    (oSER8_17_D6          ), //i
    .D7    (oSER8_17_D7          ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_b), //i
    .Q0    (oSER8_17_Q0          ), //o
    .Q1    (oSER8_17_Q1          )  //o
  );
  OSER8 oSER8_18 (
    .D0    (oSER8_18_D0          ), //i
    .D1    (oSER8_18_D1          ), //i
    .D2    (oSER8_18_D2          ), //i
    .D3    (oSER8_18_D3          ), //i
    .D4    (oSER8_18_D4          ), //i
    .D5    (oSER8_18_D5          ), //i
    .D6    (oSER8_18_D6          ), //i
    .D7    (oSER8_18_D7          ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_b), //i
    .Q0    (oSER8_18_Q0          ), //o
    .Q1    (oSER8_18_Q1          )  //o
  );
  OSER8 oSER8_19 (
    .D0    (oSER8_19_D0          ), //i
    .D1    (oSER8_19_D1          ), //i
    .D2    (oSER8_19_D2          ), //i
    .D3    (oSER8_19_D3          ), //i
    .D4    (oSER8_19_D4          ), //i
    .D5    (oSER8_19_D5          ), //i
    .D6    (oSER8_19_D6          ), //i
    .D7    (oSER8_19_D7          ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_b), //i
    .Q0    (oSER8_19_Q0          ), //o
    .Q1    (oSER8_19_Q1          )  //o
  );
  OSER8 oSER8_20 (
    .D0    (oSER8_20_D0          ), //i
    .D1    (oSER8_20_D1          ), //i
    .D2    (oSER8_20_D2          ), //i
    .D3    (oSER8_20_D3          ), //i
    .D4    (oSER8_20_D4          ), //i
    .D5    (oSER8_20_D5          ), //i
    .D6    (oSER8_20_D6          ), //i
    .D7    (oSER8_20_D7          ), //i
    .TX0   (1'b0                 ), //i
    .TX1   (1'b0                 ), //i
    .TX2   (1'b0                 ), //i
    .TX3   (1'b0                 ), //i
    .FCLK  (io_fclk              ), //i
    .PCLK  (io_pclk              ), //i
    .RESET (fclkRstArea_rst_cmd_b), //i
    .Q0    (oSER8_20_Q0          ), //o
    .Q1    (oSER8_20_Q1          )  //o
  );
  assign dll_1_RESET = (! io_resetn);
  assign io_dlllock = dll_1_LOCK;
  assign raw_rst_n = (io_resetn && dll_1_LOCK);
  assign _zz_1 = (! raw_rst_n);
  assign when_GowinDdr3Phy_l93 = (pclkRstArea_holdCnt != 4'b1111);
  assign _zz_2 = (! raw_rst_n);
  assign _zz_3 = (! raw_rst_n);
  assign _zz_4 = (! raw_rst_n);
  assign io_rst_lock_n = pclkRstArea_rst_pclk_n;
  assign io_pad_DDR3_nRESET = (pclkRstArea_rst_pclk_n && io_resetn_delay);
  assign io_pad_DDR3_ODT = 1'b1;
  assign io_pad_DDR3_CK = io_ck;
  assign io_pad_DDR3_nCS = 1'b0;
  assign io_pad_DDR3_CKE = io_CKE;
  assign dQS_1_DQSIN = dqs_pad_in[0];
  assign clk_dqsr_0 = dQS_1_DQSR90;
  assign dqs_waddr_0 = dQS_1_WPOINT;
  assign dqs_raddr_0 = dQS_1_RPOINT;
  assign clk_dqsw_0 = dQS_1_DQSW0;
  assign clk_dqsw270_0 = dQS_1_DQSW270;
  always @(*) begin
    rburst[0] = dQS_1_RBURST;
    rburst[1] = dQS_2_RBURST;
  end

  always @(*) begin
    rvalid[0] = dQS_1_RVALID;
    rvalid[1] = dQS_2_RVALID;
  end

  assign oSER8_MEM_1_D0 = io_dqs_out[0];
  assign oSER8_MEM_1_D1 = io_dqs_out[1];
  assign oSER8_MEM_1_D2 = io_dqs_out[2];
  assign oSER8_MEM_1_D3 = io_dqs_out[3];
  assign oSER8_MEM_1_D4 = io_dqs_out[4];
  assign oSER8_MEM_1_D5 = io_dqs_out[5];
  assign oSER8_MEM_1_D6 = io_dqs_out[6];
  assign oSER8_MEM_1_D7 = io_dqs_out[7];
  assign oSER8_MEM_1_TX0 = io_dqs_oen[0];
  assign oSER8_MEM_1_TX1 = io_dqs_oen[1];
  assign oSER8_MEM_1_TX2 = io_dqs_oen[2];
  assign oSER8_MEM_1_TX3 = io_dqs_oen[3];
  always @(*) begin
    dqs_buf[0] = oSER8_MEM_1_Q0;
    dqs_buf[1] = oSER8_MEM_3_Q0;
  end

  always @(*) begin
    dqs_buf_oen[0] = oSER8_MEM_1_Q1;
    dqs_buf_oen[1] = oSER8_MEM_3_Q1;
  end

  assign iOBUF_1_I = dqs_buf[0];
  assign iOBUF_1_OEN = dqs_buf_oen[0];
  always @(*) begin
    dqs_pad_in[0] = iOBUF_1_O;
    dqs_pad_in[1] = iOBUF_2_O;
  end

  assign oSER8_MEM_2_D0 = io_dm_out[0];
  assign oSER8_MEM_2_D1 = io_dm_out[1];
  assign oSER8_MEM_2_D2 = io_dm_out[2];
  assign oSER8_MEM_2_D3 = io_dm_out[3];
  assign oSER8_MEM_2_D4 = io_dm_out[4];
  assign oSER8_MEM_2_D5 = io_dm_out[5];
  assign oSER8_MEM_2_D6 = io_dm_out[6];
  assign oSER8_MEM_2_D7 = io_dm_out[7];
  always @(*) begin
    io_pad_DDR3_DM[0] = oSER8_MEM_2_Q0;
    io_pad_DDR3_DM[1] = oSER8_MEM_4_Q0;
  end

  assign dQS_2_DQSIN = dqs_pad_in[1];
  assign clk_dqsr_1 = dQS_2_DQSR90;
  assign dqs_waddr_1 = dQS_2_WPOINT;
  assign dqs_raddr_1 = dQS_2_RPOINT;
  assign clk_dqsw_1 = dQS_2_DQSW0;
  assign clk_dqsw270_1 = dQS_2_DQSW270;
  assign oSER8_MEM_3_D0 = io_dqs_out[0];
  assign oSER8_MEM_3_D1 = io_dqs_out[1];
  assign oSER8_MEM_3_D2 = io_dqs_out[2];
  assign oSER8_MEM_3_D3 = io_dqs_out[3];
  assign oSER8_MEM_3_D4 = io_dqs_out[4];
  assign oSER8_MEM_3_D5 = io_dqs_out[5];
  assign oSER8_MEM_3_D6 = io_dqs_out[6];
  assign oSER8_MEM_3_D7 = io_dqs_out[7];
  assign oSER8_MEM_3_TX0 = io_dqs_oen[0];
  assign oSER8_MEM_3_TX1 = io_dqs_oen[1];
  assign oSER8_MEM_3_TX2 = io_dqs_oen[2];
  assign oSER8_MEM_3_TX3 = io_dqs_oen[3];
  assign iOBUF_2_I = dqs_buf[1];
  assign iOBUF_2_OEN = dqs_buf_oen[1];
  assign oSER8_MEM_4_D0 = io_dm_out[0];
  assign oSER8_MEM_4_D1 = io_dm_out[1];
  assign oSER8_MEM_4_D2 = io_dm_out[2];
  assign oSER8_MEM_4_D3 = io_dm_out[3];
  assign oSER8_MEM_4_D4 = io_dm_out[4];
  assign oSER8_MEM_4_D5 = io_dm_out[5];
  assign oSER8_MEM_4_D6 = io_dm_out[6];
  assign oSER8_MEM_4_D7 = io_dm_out[7];
  assign io_rburst = rburst;
  assign io_rvalid = rvalid;
  assign io_wpoint_0 = dqs_waddr_0;
  assign io_wpoint_1 = dqs_waddr_1;
  assign io_rpoint_0 = dqs_raddr_0;
  assign io_rpoint_1 = dqs_raddr_1;
  assign oSER8_MEM_5_D0 = io_dq_out_0[0];
  assign oSER8_MEM_5_D1 = io_dq_out_1[0];
  assign oSER8_MEM_5_D2 = io_dq_out_2[0];
  assign oSER8_MEM_5_D3 = io_dq_out_3[0];
  assign oSER8_MEM_5_D4 = io_dq_out_4[0];
  assign oSER8_MEM_5_D5 = io_dq_out_5[0];
  assign oSER8_MEM_5_D6 = io_dq_out_6[0];
  assign oSER8_MEM_5_D7 = io_dq_out_7[0];
  assign oSER8_MEM_5_TX0 = io_dq_oen[0];
  assign oSER8_MEM_5_TX1 = io_dq_oen[1];
  assign oSER8_MEM_5_TX2 = io_dq_oen[2];
  assign oSER8_MEM_5_TX3 = io_dq_oen[3];
  always @(*) begin
    dq_buf[0] = oSER8_MEM_5_Q0;
    dq_buf[1] = oSER8_MEM_6_Q0;
    dq_buf[2] = oSER8_MEM_7_Q0;
    dq_buf[3] = oSER8_MEM_8_Q0;
    dq_buf[4] = oSER8_MEM_9_Q0;
    dq_buf[5] = oSER8_MEM_10_Q0;
    dq_buf[6] = oSER8_MEM_11_Q0;
    dq_buf[7] = oSER8_MEM_12_Q0;
    dq_buf[8] = oSER8_MEM_13_Q0;
    dq_buf[9] = oSER8_MEM_14_Q0;
    dq_buf[10] = oSER8_MEM_15_Q0;
    dq_buf[11] = oSER8_MEM_16_Q0;
    dq_buf[12] = oSER8_MEM_17_Q0;
    dq_buf[13] = oSER8_MEM_18_Q0;
    dq_buf[14] = oSER8_MEM_19_Q0;
    dq_buf[15] = oSER8_MEM_20_Q0;
  end

  always @(*) begin
    dq_buf_oen[0] = oSER8_MEM_5_Q1;
    dq_buf_oen[1] = oSER8_MEM_6_Q1;
    dq_buf_oen[2] = oSER8_MEM_7_Q1;
    dq_buf_oen[3] = oSER8_MEM_8_Q1;
    dq_buf_oen[4] = oSER8_MEM_9_Q1;
    dq_buf_oen[5] = oSER8_MEM_10_Q1;
    dq_buf_oen[6] = oSER8_MEM_11_Q1;
    dq_buf_oen[7] = oSER8_MEM_12_Q1;
    dq_buf_oen[8] = oSER8_MEM_13_Q1;
    dq_buf_oen[9] = oSER8_MEM_14_Q1;
    dq_buf_oen[10] = oSER8_MEM_15_Q1;
    dq_buf_oen[11] = oSER8_MEM_16_Q1;
    dq_buf_oen[12] = oSER8_MEM_17_Q1;
    dq_buf_oen[13] = oSER8_MEM_18_Q1;
    dq_buf_oen[14] = oSER8_MEM_19_Q1;
    dq_buf_oen[15] = oSER8_MEM_20_Q1;
  end

  assign iOBUF_3_I = dq_buf[0];
  assign iOBUF_3_OEN = dq_buf_oen[0];
  always @(*) begin
    dq_pad_in[0] = iOBUF_3_O;
    dq_pad_in[1] = iOBUF_4_O;
    dq_pad_in[2] = iOBUF_5_O;
    dq_pad_in[3] = iOBUF_6_O;
    dq_pad_in[4] = iOBUF_7_O;
    dq_pad_in[5] = iOBUF_8_O;
    dq_pad_in[6] = iOBUF_9_O;
    dq_pad_in[7] = iOBUF_10_O;
    dq_pad_in[8] = iOBUF_11_O;
    dq_pad_in[9] = iOBUF_12_O;
    dq_pad_in[10] = iOBUF_13_O;
    dq_pad_in[11] = iOBUF_14_O;
    dq_pad_in[12] = iOBUF_15_O;
    dq_pad_in[13] = iOBUF_16_O;
    dq_pad_in[14] = iOBUF_17_O;
    dq_pad_in[15] = iOBUF_18_O;
  end

  assign iDES8_MEM_1_D = dq_pad_in[0];
  always @(*) begin
    io_dq_in_0[0] = iDES8_MEM_1_Q0;
    io_dq_in_0[1] = iDES8_MEM_2_Q0;
    io_dq_in_0[2] = iDES8_MEM_3_Q0;
    io_dq_in_0[3] = iDES8_MEM_4_Q0;
    io_dq_in_0[4] = iDES8_MEM_5_Q0;
    io_dq_in_0[5] = iDES8_MEM_6_Q0;
    io_dq_in_0[6] = iDES8_MEM_7_Q0;
    io_dq_in_0[7] = iDES8_MEM_8_Q0;
    io_dq_in_0[8] = iDES8_MEM_9_Q0;
    io_dq_in_0[9] = iDES8_MEM_10_Q0;
    io_dq_in_0[10] = iDES8_MEM_11_Q0;
    io_dq_in_0[11] = iDES8_MEM_12_Q0;
    io_dq_in_0[12] = iDES8_MEM_13_Q0;
    io_dq_in_0[13] = iDES8_MEM_14_Q0;
    io_dq_in_0[14] = iDES8_MEM_15_Q0;
    io_dq_in_0[15] = iDES8_MEM_16_Q0;
  end

  always @(*) begin
    io_dq_in_1[0] = iDES8_MEM_1_Q1;
    io_dq_in_1[1] = iDES8_MEM_2_Q1;
    io_dq_in_1[2] = iDES8_MEM_3_Q1;
    io_dq_in_1[3] = iDES8_MEM_4_Q1;
    io_dq_in_1[4] = iDES8_MEM_5_Q1;
    io_dq_in_1[5] = iDES8_MEM_6_Q1;
    io_dq_in_1[6] = iDES8_MEM_7_Q1;
    io_dq_in_1[7] = iDES8_MEM_8_Q1;
    io_dq_in_1[8] = iDES8_MEM_9_Q1;
    io_dq_in_1[9] = iDES8_MEM_10_Q1;
    io_dq_in_1[10] = iDES8_MEM_11_Q1;
    io_dq_in_1[11] = iDES8_MEM_12_Q1;
    io_dq_in_1[12] = iDES8_MEM_13_Q1;
    io_dq_in_1[13] = iDES8_MEM_14_Q1;
    io_dq_in_1[14] = iDES8_MEM_15_Q1;
    io_dq_in_1[15] = iDES8_MEM_16_Q1;
  end

  always @(*) begin
    io_dq_in_2[0] = iDES8_MEM_1_Q2;
    io_dq_in_2[1] = iDES8_MEM_2_Q2;
    io_dq_in_2[2] = iDES8_MEM_3_Q2;
    io_dq_in_2[3] = iDES8_MEM_4_Q2;
    io_dq_in_2[4] = iDES8_MEM_5_Q2;
    io_dq_in_2[5] = iDES8_MEM_6_Q2;
    io_dq_in_2[6] = iDES8_MEM_7_Q2;
    io_dq_in_2[7] = iDES8_MEM_8_Q2;
    io_dq_in_2[8] = iDES8_MEM_9_Q2;
    io_dq_in_2[9] = iDES8_MEM_10_Q2;
    io_dq_in_2[10] = iDES8_MEM_11_Q2;
    io_dq_in_2[11] = iDES8_MEM_12_Q2;
    io_dq_in_2[12] = iDES8_MEM_13_Q2;
    io_dq_in_2[13] = iDES8_MEM_14_Q2;
    io_dq_in_2[14] = iDES8_MEM_15_Q2;
    io_dq_in_2[15] = iDES8_MEM_16_Q2;
  end

  always @(*) begin
    io_dq_in_3[0] = iDES8_MEM_1_Q3;
    io_dq_in_3[1] = iDES8_MEM_2_Q3;
    io_dq_in_3[2] = iDES8_MEM_3_Q3;
    io_dq_in_3[3] = iDES8_MEM_4_Q3;
    io_dq_in_3[4] = iDES8_MEM_5_Q3;
    io_dq_in_3[5] = iDES8_MEM_6_Q3;
    io_dq_in_3[6] = iDES8_MEM_7_Q3;
    io_dq_in_3[7] = iDES8_MEM_8_Q3;
    io_dq_in_3[8] = iDES8_MEM_9_Q3;
    io_dq_in_3[9] = iDES8_MEM_10_Q3;
    io_dq_in_3[10] = iDES8_MEM_11_Q3;
    io_dq_in_3[11] = iDES8_MEM_12_Q3;
    io_dq_in_3[12] = iDES8_MEM_13_Q3;
    io_dq_in_3[13] = iDES8_MEM_14_Q3;
    io_dq_in_3[14] = iDES8_MEM_15_Q3;
    io_dq_in_3[15] = iDES8_MEM_16_Q3;
  end

  always @(*) begin
    io_dq_in_4[0] = iDES8_MEM_1_Q4;
    io_dq_in_4[1] = iDES8_MEM_2_Q4;
    io_dq_in_4[2] = iDES8_MEM_3_Q4;
    io_dq_in_4[3] = iDES8_MEM_4_Q4;
    io_dq_in_4[4] = iDES8_MEM_5_Q4;
    io_dq_in_4[5] = iDES8_MEM_6_Q4;
    io_dq_in_4[6] = iDES8_MEM_7_Q4;
    io_dq_in_4[7] = iDES8_MEM_8_Q4;
    io_dq_in_4[8] = iDES8_MEM_9_Q4;
    io_dq_in_4[9] = iDES8_MEM_10_Q4;
    io_dq_in_4[10] = iDES8_MEM_11_Q4;
    io_dq_in_4[11] = iDES8_MEM_12_Q4;
    io_dq_in_4[12] = iDES8_MEM_13_Q4;
    io_dq_in_4[13] = iDES8_MEM_14_Q4;
    io_dq_in_4[14] = iDES8_MEM_15_Q4;
    io_dq_in_4[15] = iDES8_MEM_16_Q4;
  end

  always @(*) begin
    io_dq_in_5[0] = iDES8_MEM_1_Q5;
    io_dq_in_5[1] = iDES8_MEM_2_Q5;
    io_dq_in_5[2] = iDES8_MEM_3_Q5;
    io_dq_in_5[3] = iDES8_MEM_4_Q5;
    io_dq_in_5[4] = iDES8_MEM_5_Q5;
    io_dq_in_5[5] = iDES8_MEM_6_Q5;
    io_dq_in_5[6] = iDES8_MEM_7_Q5;
    io_dq_in_5[7] = iDES8_MEM_8_Q5;
    io_dq_in_5[8] = iDES8_MEM_9_Q5;
    io_dq_in_5[9] = iDES8_MEM_10_Q5;
    io_dq_in_5[10] = iDES8_MEM_11_Q5;
    io_dq_in_5[11] = iDES8_MEM_12_Q5;
    io_dq_in_5[12] = iDES8_MEM_13_Q5;
    io_dq_in_5[13] = iDES8_MEM_14_Q5;
    io_dq_in_5[14] = iDES8_MEM_15_Q5;
    io_dq_in_5[15] = iDES8_MEM_16_Q5;
  end

  always @(*) begin
    io_dq_in_6[0] = iDES8_MEM_1_Q6;
    io_dq_in_6[1] = iDES8_MEM_2_Q6;
    io_dq_in_6[2] = iDES8_MEM_3_Q6;
    io_dq_in_6[3] = iDES8_MEM_4_Q6;
    io_dq_in_6[4] = iDES8_MEM_5_Q6;
    io_dq_in_6[5] = iDES8_MEM_6_Q6;
    io_dq_in_6[6] = iDES8_MEM_7_Q6;
    io_dq_in_6[7] = iDES8_MEM_8_Q6;
    io_dq_in_6[8] = iDES8_MEM_9_Q6;
    io_dq_in_6[9] = iDES8_MEM_10_Q6;
    io_dq_in_6[10] = iDES8_MEM_11_Q6;
    io_dq_in_6[11] = iDES8_MEM_12_Q6;
    io_dq_in_6[12] = iDES8_MEM_13_Q6;
    io_dq_in_6[13] = iDES8_MEM_14_Q6;
    io_dq_in_6[14] = iDES8_MEM_15_Q6;
    io_dq_in_6[15] = iDES8_MEM_16_Q6;
  end

  always @(*) begin
    io_dq_in_7[0] = iDES8_MEM_1_Q7;
    io_dq_in_7[1] = iDES8_MEM_2_Q7;
    io_dq_in_7[2] = iDES8_MEM_3_Q7;
    io_dq_in_7[3] = iDES8_MEM_4_Q7;
    io_dq_in_7[4] = iDES8_MEM_5_Q7;
    io_dq_in_7[5] = iDES8_MEM_6_Q7;
    io_dq_in_7[6] = iDES8_MEM_7_Q7;
    io_dq_in_7[7] = iDES8_MEM_8_Q7;
    io_dq_in_7[8] = iDES8_MEM_9_Q7;
    io_dq_in_7[9] = iDES8_MEM_10_Q7;
    io_dq_in_7[10] = iDES8_MEM_11_Q7;
    io_dq_in_7[11] = iDES8_MEM_12_Q7;
    io_dq_in_7[12] = iDES8_MEM_13_Q7;
    io_dq_in_7[13] = iDES8_MEM_14_Q7;
    io_dq_in_7[14] = iDES8_MEM_15_Q7;
    io_dq_in_7[15] = iDES8_MEM_16_Q7;
  end

  assign oSER8_MEM_6_D0 = io_dq_out_0[1];
  assign oSER8_MEM_6_D1 = io_dq_out_1[1];
  assign oSER8_MEM_6_D2 = io_dq_out_2[1];
  assign oSER8_MEM_6_D3 = io_dq_out_3[1];
  assign oSER8_MEM_6_D4 = io_dq_out_4[1];
  assign oSER8_MEM_6_D5 = io_dq_out_5[1];
  assign oSER8_MEM_6_D6 = io_dq_out_6[1];
  assign oSER8_MEM_6_D7 = io_dq_out_7[1];
  assign oSER8_MEM_6_TX0 = io_dq_oen[0];
  assign oSER8_MEM_6_TX1 = io_dq_oen[1];
  assign oSER8_MEM_6_TX2 = io_dq_oen[2];
  assign oSER8_MEM_6_TX3 = io_dq_oen[3];
  assign iOBUF_4_I = dq_buf[1];
  assign iOBUF_4_OEN = dq_buf_oen[1];
  assign iDES8_MEM_2_D = dq_pad_in[1];
  assign oSER8_MEM_7_D0 = io_dq_out_0[2];
  assign oSER8_MEM_7_D1 = io_dq_out_1[2];
  assign oSER8_MEM_7_D2 = io_dq_out_2[2];
  assign oSER8_MEM_7_D3 = io_dq_out_3[2];
  assign oSER8_MEM_7_D4 = io_dq_out_4[2];
  assign oSER8_MEM_7_D5 = io_dq_out_5[2];
  assign oSER8_MEM_7_D6 = io_dq_out_6[2];
  assign oSER8_MEM_7_D7 = io_dq_out_7[2];
  assign oSER8_MEM_7_TX0 = io_dq_oen[0];
  assign oSER8_MEM_7_TX1 = io_dq_oen[1];
  assign oSER8_MEM_7_TX2 = io_dq_oen[2];
  assign oSER8_MEM_7_TX3 = io_dq_oen[3];
  assign iOBUF_5_I = dq_buf[2];
  assign iOBUF_5_OEN = dq_buf_oen[2];
  assign iDES8_MEM_3_D = dq_pad_in[2];
  assign oSER8_MEM_8_D0 = io_dq_out_0[3];
  assign oSER8_MEM_8_D1 = io_dq_out_1[3];
  assign oSER8_MEM_8_D2 = io_dq_out_2[3];
  assign oSER8_MEM_8_D3 = io_dq_out_3[3];
  assign oSER8_MEM_8_D4 = io_dq_out_4[3];
  assign oSER8_MEM_8_D5 = io_dq_out_5[3];
  assign oSER8_MEM_8_D6 = io_dq_out_6[3];
  assign oSER8_MEM_8_D7 = io_dq_out_7[3];
  assign oSER8_MEM_8_TX0 = io_dq_oen[0];
  assign oSER8_MEM_8_TX1 = io_dq_oen[1];
  assign oSER8_MEM_8_TX2 = io_dq_oen[2];
  assign oSER8_MEM_8_TX3 = io_dq_oen[3];
  assign iOBUF_6_I = dq_buf[3];
  assign iOBUF_6_OEN = dq_buf_oen[3];
  assign iDES8_MEM_4_D = dq_pad_in[3];
  assign oSER8_MEM_9_D0 = io_dq_out_0[4];
  assign oSER8_MEM_9_D1 = io_dq_out_1[4];
  assign oSER8_MEM_9_D2 = io_dq_out_2[4];
  assign oSER8_MEM_9_D3 = io_dq_out_3[4];
  assign oSER8_MEM_9_D4 = io_dq_out_4[4];
  assign oSER8_MEM_9_D5 = io_dq_out_5[4];
  assign oSER8_MEM_9_D6 = io_dq_out_6[4];
  assign oSER8_MEM_9_D7 = io_dq_out_7[4];
  assign oSER8_MEM_9_TX0 = io_dq_oen[0];
  assign oSER8_MEM_9_TX1 = io_dq_oen[1];
  assign oSER8_MEM_9_TX2 = io_dq_oen[2];
  assign oSER8_MEM_9_TX3 = io_dq_oen[3];
  assign iOBUF_7_I = dq_buf[4];
  assign iOBUF_7_OEN = dq_buf_oen[4];
  assign iDES8_MEM_5_D = dq_pad_in[4];
  assign oSER8_MEM_10_D0 = io_dq_out_0[5];
  assign oSER8_MEM_10_D1 = io_dq_out_1[5];
  assign oSER8_MEM_10_D2 = io_dq_out_2[5];
  assign oSER8_MEM_10_D3 = io_dq_out_3[5];
  assign oSER8_MEM_10_D4 = io_dq_out_4[5];
  assign oSER8_MEM_10_D5 = io_dq_out_5[5];
  assign oSER8_MEM_10_D6 = io_dq_out_6[5];
  assign oSER8_MEM_10_D7 = io_dq_out_7[5];
  assign oSER8_MEM_10_TX0 = io_dq_oen[0];
  assign oSER8_MEM_10_TX1 = io_dq_oen[1];
  assign oSER8_MEM_10_TX2 = io_dq_oen[2];
  assign oSER8_MEM_10_TX3 = io_dq_oen[3];
  assign iOBUF_8_I = dq_buf[5];
  assign iOBUF_8_OEN = dq_buf_oen[5];
  assign iDES8_MEM_6_D = dq_pad_in[5];
  assign oSER8_MEM_11_D0 = io_dq_out_0[6];
  assign oSER8_MEM_11_D1 = io_dq_out_1[6];
  assign oSER8_MEM_11_D2 = io_dq_out_2[6];
  assign oSER8_MEM_11_D3 = io_dq_out_3[6];
  assign oSER8_MEM_11_D4 = io_dq_out_4[6];
  assign oSER8_MEM_11_D5 = io_dq_out_5[6];
  assign oSER8_MEM_11_D6 = io_dq_out_6[6];
  assign oSER8_MEM_11_D7 = io_dq_out_7[6];
  assign oSER8_MEM_11_TX0 = io_dq_oen[0];
  assign oSER8_MEM_11_TX1 = io_dq_oen[1];
  assign oSER8_MEM_11_TX2 = io_dq_oen[2];
  assign oSER8_MEM_11_TX3 = io_dq_oen[3];
  assign iOBUF_9_I = dq_buf[6];
  assign iOBUF_9_OEN = dq_buf_oen[6];
  assign iDES8_MEM_7_D = dq_pad_in[6];
  assign oSER8_MEM_12_D0 = io_dq_out_0[7];
  assign oSER8_MEM_12_D1 = io_dq_out_1[7];
  assign oSER8_MEM_12_D2 = io_dq_out_2[7];
  assign oSER8_MEM_12_D3 = io_dq_out_3[7];
  assign oSER8_MEM_12_D4 = io_dq_out_4[7];
  assign oSER8_MEM_12_D5 = io_dq_out_5[7];
  assign oSER8_MEM_12_D6 = io_dq_out_6[7];
  assign oSER8_MEM_12_D7 = io_dq_out_7[7];
  assign oSER8_MEM_12_TX0 = io_dq_oen[0];
  assign oSER8_MEM_12_TX1 = io_dq_oen[1];
  assign oSER8_MEM_12_TX2 = io_dq_oen[2];
  assign oSER8_MEM_12_TX3 = io_dq_oen[3];
  assign iOBUF_10_I = dq_buf[7];
  assign iOBUF_10_OEN = dq_buf_oen[7];
  assign iDES8_MEM_8_D = dq_pad_in[7];
  assign oSER8_MEM_13_D0 = io_dq_out_0[8];
  assign oSER8_MEM_13_D1 = io_dq_out_1[8];
  assign oSER8_MEM_13_D2 = io_dq_out_2[8];
  assign oSER8_MEM_13_D3 = io_dq_out_3[8];
  assign oSER8_MEM_13_D4 = io_dq_out_4[8];
  assign oSER8_MEM_13_D5 = io_dq_out_5[8];
  assign oSER8_MEM_13_D6 = io_dq_out_6[8];
  assign oSER8_MEM_13_D7 = io_dq_out_7[8];
  assign oSER8_MEM_13_TX0 = io_dq_oen[0];
  assign oSER8_MEM_13_TX1 = io_dq_oen[1];
  assign oSER8_MEM_13_TX2 = io_dq_oen[2];
  assign oSER8_MEM_13_TX3 = io_dq_oen[3];
  assign iOBUF_11_I = dq_buf[8];
  assign iOBUF_11_OEN = dq_buf_oen[8];
  assign iDES8_MEM_9_D = dq_pad_in[8];
  assign oSER8_MEM_14_D0 = io_dq_out_0[9];
  assign oSER8_MEM_14_D1 = io_dq_out_1[9];
  assign oSER8_MEM_14_D2 = io_dq_out_2[9];
  assign oSER8_MEM_14_D3 = io_dq_out_3[9];
  assign oSER8_MEM_14_D4 = io_dq_out_4[9];
  assign oSER8_MEM_14_D5 = io_dq_out_5[9];
  assign oSER8_MEM_14_D6 = io_dq_out_6[9];
  assign oSER8_MEM_14_D7 = io_dq_out_7[9];
  assign oSER8_MEM_14_TX0 = io_dq_oen[0];
  assign oSER8_MEM_14_TX1 = io_dq_oen[1];
  assign oSER8_MEM_14_TX2 = io_dq_oen[2];
  assign oSER8_MEM_14_TX3 = io_dq_oen[3];
  assign iOBUF_12_I = dq_buf[9];
  assign iOBUF_12_OEN = dq_buf_oen[9];
  assign iDES8_MEM_10_D = dq_pad_in[9];
  assign oSER8_MEM_15_D0 = io_dq_out_0[10];
  assign oSER8_MEM_15_D1 = io_dq_out_1[10];
  assign oSER8_MEM_15_D2 = io_dq_out_2[10];
  assign oSER8_MEM_15_D3 = io_dq_out_3[10];
  assign oSER8_MEM_15_D4 = io_dq_out_4[10];
  assign oSER8_MEM_15_D5 = io_dq_out_5[10];
  assign oSER8_MEM_15_D6 = io_dq_out_6[10];
  assign oSER8_MEM_15_D7 = io_dq_out_7[10];
  assign oSER8_MEM_15_TX0 = io_dq_oen[0];
  assign oSER8_MEM_15_TX1 = io_dq_oen[1];
  assign oSER8_MEM_15_TX2 = io_dq_oen[2];
  assign oSER8_MEM_15_TX3 = io_dq_oen[3];
  assign iOBUF_13_I = dq_buf[10];
  assign iOBUF_13_OEN = dq_buf_oen[10];
  assign iDES8_MEM_11_D = dq_pad_in[10];
  assign oSER8_MEM_16_D0 = io_dq_out_0[11];
  assign oSER8_MEM_16_D1 = io_dq_out_1[11];
  assign oSER8_MEM_16_D2 = io_dq_out_2[11];
  assign oSER8_MEM_16_D3 = io_dq_out_3[11];
  assign oSER8_MEM_16_D4 = io_dq_out_4[11];
  assign oSER8_MEM_16_D5 = io_dq_out_5[11];
  assign oSER8_MEM_16_D6 = io_dq_out_6[11];
  assign oSER8_MEM_16_D7 = io_dq_out_7[11];
  assign oSER8_MEM_16_TX0 = io_dq_oen[0];
  assign oSER8_MEM_16_TX1 = io_dq_oen[1];
  assign oSER8_MEM_16_TX2 = io_dq_oen[2];
  assign oSER8_MEM_16_TX3 = io_dq_oen[3];
  assign iOBUF_14_I = dq_buf[11];
  assign iOBUF_14_OEN = dq_buf_oen[11];
  assign iDES8_MEM_12_D = dq_pad_in[11];
  assign oSER8_MEM_17_D0 = io_dq_out_0[12];
  assign oSER8_MEM_17_D1 = io_dq_out_1[12];
  assign oSER8_MEM_17_D2 = io_dq_out_2[12];
  assign oSER8_MEM_17_D3 = io_dq_out_3[12];
  assign oSER8_MEM_17_D4 = io_dq_out_4[12];
  assign oSER8_MEM_17_D5 = io_dq_out_5[12];
  assign oSER8_MEM_17_D6 = io_dq_out_6[12];
  assign oSER8_MEM_17_D7 = io_dq_out_7[12];
  assign oSER8_MEM_17_TX0 = io_dq_oen[0];
  assign oSER8_MEM_17_TX1 = io_dq_oen[1];
  assign oSER8_MEM_17_TX2 = io_dq_oen[2];
  assign oSER8_MEM_17_TX3 = io_dq_oen[3];
  assign iOBUF_15_I = dq_buf[12];
  assign iOBUF_15_OEN = dq_buf_oen[12];
  assign iDES8_MEM_13_D = dq_pad_in[12];
  assign oSER8_MEM_18_D0 = io_dq_out_0[13];
  assign oSER8_MEM_18_D1 = io_dq_out_1[13];
  assign oSER8_MEM_18_D2 = io_dq_out_2[13];
  assign oSER8_MEM_18_D3 = io_dq_out_3[13];
  assign oSER8_MEM_18_D4 = io_dq_out_4[13];
  assign oSER8_MEM_18_D5 = io_dq_out_5[13];
  assign oSER8_MEM_18_D6 = io_dq_out_6[13];
  assign oSER8_MEM_18_D7 = io_dq_out_7[13];
  assign oSER8_MEM_18_TX0 = io_dq_oen[0];
  assign oSER8_MEM_18_TX1 = io_dq_oen[1];
  assign oSER8_MEM_18_TX2 = io_dq_oen[2];
  assign oSER8_MEM_18_TX3 = io_dq_oen[3];
  assign iOBUF_16_I = dq_buf[13];
  assign iOBUF_16_OEN = dq_buf_oen[13];
  assign iDES8_MEM_14_D = dq_pad_in[13];
  assign oSER8_MEM_19_D0 = io_dq_out_0[14];
  assign oSER8_MEM_19_D1 = io_dq_out_1[14];
  assign oSER8_MEM_19_D2 = io_dq_out_2[14];
  assign oSER8_MEM_19_D3 = io_dq_out_3[14];
  assign oSER8_MEM_19_D4 = io_dq_out_4[14];
  assign oSER8_MEM_19_D5 = io_dq_out_5[14];
  assign oSER8_MEM_19_D6 = io_dq_out_6[14];
  assign oSER8_MEM_19_D7 = io_dq_out_7[14];
  assign oSER8_MEM_19_TX0 = io_dq_oen[0];
  assign oSER8_MEM_19_TX1 = io_dq_oen[1];
  assign oSER8_MEM_19_TX2 = io_dq_oen[2];
  assign oSER8_MEM_19_TX3 = io_dq_oen[3];
  assign iOBUF_17_I = dq_buf[14];
  assign iOBUF_17_OEN = dq_buf_oen[14];
  assign iDES8_MEM_15_D = dq_pad_in[14];
  assign oSER8_MEM_20_D0 = io_dq_out_0[15];
  assign oSER8_MEM_20_D1 = io_dq_out_1[15];
  assign oSER8_MEM_20_D2 = io_dq_out_2[15];
  assign oSER8_MEM_20_D3 = io_dq_out_3[15];
  assign oSER8_MEM_20_D4 = io_dq_out_4[15];
  assign oSER8_MEM_20_D5 = io_dq_out_5[15];
  assign oSER8_MEM_20_D6 = io_dq_out_6[15];
  assign oSER8_MEM_20_D7 = io_dq_out_7[15];
  assign oSER8_MEM_20_TX0 = io_dq_oen[0];
  assign oSER8_MEM_20_TX1 = io_dq_oen[1];
  assign oSER8_MEM_20_TX2 = io_dq_oen[2];
  assign oSER8_MEM_20_TX3 = io_dq_oen[3];
  assign iOBUF_18_I = dq_buf[15];
  assign iOBUF_18_OEN = dq_buf_oen[15];
  assign iDES8_MEM_16_D = dq_pad_in[15];
  assign io_dq_raw = dq_pad_in;
  assign io_pad_DDR3_nRAS = oSER8_1_Q0;
  assign io_pad_DDR3_nCAS = oSER8_2_Q0;
  assign io_pad_DDR3_nWE = oSER8_3_Q0;
  assign oSER8_4_D0 = io_A_0[0];
  assign oSER8_4_D1 = io_A_0[0];
  assign oSER8_4_D2 = io_A_1[0];
  assign oSER8_4_D3 = io_A_1[0];
  assign oSER8_4_D4 = io_A_2[0];
  assign oSER8_4_D5 = io_A_2[0];
  assign oSER8_4_D6 = io_A_3[0];
  assign oSER8_4_D7 = io_A_3[0];
  always @(*) begin
    io_pad_DDR3_A[0] = oSER8_4_Q0;
    io_pad_DDR3_A[1] = oSER8_5_Q0;
    io_pad_DDR3_A[2] = oSER8_6_Q0;
    io_pad_DDR3_A[3] = oSER8_7_Q0;
    io_pad_DDR3_A[4] = oSER8_8_Q0;
    io_pad_DDR3_A[5] = oSER8_9_Q0;
    io_pad_DDR3_A[6] = oSER8_10_Q0;
    io_pad_DDR3_A[7] = oSER8_11_Q0;
    io_pad_DDR3_A[8] = oSER8_12_Q0;
    io_pad_DDR3_A[9] = oSER8_13_Q0;
    io_pad_DDR3_A[10] = oSER8_14_Q0;
    io_pad_DDR3_A[11] = oSER8_15_Q0;
    io_pad_DDR3_A[12] = oSER8_16_Q0;
    io_pad_DDR3_A[13] = oSER8_17_Q0;
  end

  assign oSER8_5_D0 = io_A_0[1];
  assign oSER8_5_D1 = io_A_0[1];
  assign oSER8_5_D2 = io_A_1[1];
  assign oSER8_5_D3 = io_A_1[1];
  assign oSER8_5_D4 = io_A_2[1];
  assign oSER8_5_D5 = io_A_2[1];
  assign oSER8_5_D6 = io_A_3[1];
  assign oSER8_5_D7 = io_A_3[1];
  assign oSER8_6_D0 = io_A_0[2];
  assign oSER8_6_D1 = io_A_0[2];
  assign oSER8_6_D2 = io_A_1[2];
  assign oSER8_6_D3 = io_A_1[2];
  assign oSER8_6_D4 = io_A_2[2];
  assign oSER8_6_D5 = io_A_2[2];
  assign oSER8_6_D6 = io_A_3[2];
  assign oSER8_6_D7 = io_A_3[2];
  assign oSER8_7_D0 = io_A_0[3];
  assign oSER8_7_D1 = io_A_0[3];
  assign oSER8_7_D2 = io_A_1[3];
  assign oSER8_7_D3 = io_A_1[3];
  assign oSER8_7_D4 = io_A_2[3];
  assign oSER8_7_D5 = io_A_2[3];
  assign oSER8_7_D6 = io_A_3[3];
  assign oSER8_7_D7 = io_A_3[3];
  assign oSER8_8_D0 = io_A_0[4];
  assign oSER8_8_D1 = io_A_0[4];
  assign oSER8_8_D2 = io_A_1[4];
  assign oSER8_8_D3 = io_A_1[4];
  assign oSER8_8_D4 = io_A_2[4];
  assign oSER8_8_D5 = io_A_2[4];
  assign oSER8_8_D6 = io_A_3[4];
  assign oSER8_8_D7 = io_A_3[4];
  assign oSER8_9_D0 = io_A_0[5];
  assign oSER8_9_D1 = io_A_0[5];
  assign oSER8_9_D2 = io_A_1[5];
  assign oSER8_9_D3 = io_A_1[5];
  assign oSER8_9_D4 = io_A_2[5];
  assign oSER8_9_D5 = io_A_2[5];
  assign oSER8_9_D6 = io_A_3[5];
  assign oSER8_9_D7 = io_A_3[5];
  assign oSER8_10_D0 = io_A_0[6];
  assign oSER8_10_D1 = io_A_0[6];
  assign oSER8_10_D2 = io_A_1[6];
  assign oSER8_10_D3 = io_A_1[6];
  assign oSER8_10_D4 = io_A_2[6];
  assign oSER8_10_D5 = io_A_2[6];
  assign oSER8_10_D6 = io_A_3[6];
  assign oSER8_10_D7 = io_A_3[6];
  assign oSER8_11_D0 = io_A_0[7];
  assign oSER8_11_D1 = io_A_0[7];
  assign oSER8_11_D2 = io_A_1[7];
  assign oSER8_11_D3 = io_A_1[7];
  assign oSER8_11_D4 = io_A_2[7];
  assign oSER8_11_D5 = io_A_2[7];
  assign oSER8_11_D6 = io_A_3[7];
  assign oSER8_11_D7 = io_A_3[7];
  assign oSER8_12_D0 = io_A_0[8];
  assign oSER8_12_D1 = io_A_0[8];
  assign oSER8_12_D2 = io_A_1[8];
  assign oSER8_12_D3 = io_A_1[8];
  assign oSER8_12_D4 = io_A_2[8];
  assign oSER8_12_D5 = io_A_2[8];
  assign oSER8_12_D6 = io_A_3[8];
  assign oSER8_12_D7 = io_A_3[8];
  assign oSER8_13_D0 = io_A_0[9];
  assign oSER8_13_D1 = io_A_0[9];
  assign oSER8_13_D2 = io_A_1[9];
  assign oSER8_13_D3 = io_A_1[9];
  assign oSER8_13_D4 = io_A_2[9];
  assign oSER8_13_D5 = io_A_2[9];
  assign oSER8_13_D6 = io_A_3[9];
  assign oSER8_13_D7 = io_A_3[9];
  assign oSER8_14_D0 = io_A_0[10];
  assign oSER8_14_D1 = io_A_0[10];
  assign oSER8_14_D2 = io_A_1[10];
  assign oSER8_14_D3 = io_A_1[10];
  assign oSER8_14_D4 = io_A_2[10];
  assign oSER8_14_D5 = io_A_2[10];
  assign oSER8_14_D6 = io_A_3[10];
  assign oSER8_14_D7 = io_A_3[10];
  assign oSER8_15_D0 = io_A_0[11];
  assign oSER8_15_D1 = io_A_0[11];
  assign oSER8_15_D2 = io_A_1[11];
  assign oSER8_15_D3 = io_A_1[11];
  assign oSER8_15_D4 = io_A_2[11];
  assign oSER8_15_D5 = io_A_2[11];
  assign oSER8_15_D6 = io_A_3[11];
  assign oSER8_15_D7 = io_A_3[11];
  assign oSER8_16_D0 = io_A_0[12];
  assign oSER8_16_D1 = io_A_0[12];
  assign oSER8_16_D2 = io_A_1[12];
  assign oSER8_16_D3 = io_A_1[12];
  assign oSER8_16_D4 = io_A_2[12];
  assign oSER8_16_D5 = io_A_2[12];
  assign oSER8_16_D6 = io_A_3[12];
  assign oSER8_16_D7 = io_A_3[12];
  assign oSER8_17_D0 = io_A_0[13];
  assign oSER8_17_D1 = io_A_0[13];
  assign oSER8_17_D2 = io_A_1[13];
  assign oSER8_17_D3 = io_A_1[13];
  assign oSER8_17_D4 = io_A_2[13];
  assign oSER8_17_D5 = io_A_2[13];
  assign oSER8_17_D6 = io_A_3[13];
  assign oSER8_17_D7 = io_A_3[13];
  assign oSER8_18_D0 = io_BA_0[0];
  assign oSER8_18_D1 = io_BA_0[0];
  assign oSER8_18_D2 = io_BA_1[0];
  assign oSER8_18_D3 = io_BA_1[0];
  assign oSER8_18_D4 = io_BA_2[0];
  assign oSER8_18_D5 = io_BA_2[0];
  assign oSER8_18_D6 = io_BA_3[0];
  assign oSER8_18_D7 = io_BA_3[0];
  always @(*) begin
    io_pad_DDR3_BA[0] = oSER8_18_Q0;
    io_pad_DDR3_BA[1] = oSER8_19_Q0;
    io_pad_DDR3_BA[2] = oSER8_20_Q0;
  end

  assign oSER8_19_D0 = io_BA_0[1];
  assign oSER8_19_D1 = io_BA_0[1];
  assign oSER8_19_D2 = io_BA_1[1];
  assign oSER8_19_D3 = io_BA_1[1];
  assign oSER8_19_D4 = io_BA_2[1];
  assign oSER8_19_D5 = io_BA_2[1];
  assign oSER8_19_D6 = io_BA_3[1];
  assign oSER8_19_D7 = io_BA_3[1];
  assign oSER8_20_D0 = io_BA_0[2];
  assign oSER8_20_D1 = io_BA_0[2];
  assign oSER8_20_D2 = io_BA_1[2];
  assign oSER8_20_D3 = io_BA_1[2];
  assign oSER8_20_D4 = io_BA_2[2];
  assign oSER8_20_D5 = io_BA_2[2];
  assign oSER8_20_D6 = io_BA_3[2];
  assign oSER8_20_D7 = io_BA_3[2];
  always @(posedge io_pclk or posedge _zz_1) begin
    if(_zz_1) begin
      pclkRstArea_holdCnt <= 4'b0000;
      pclkRstArea_rst_pclk_n <= 1'b0;
      pclkRstArea_rst_cmd_p <= 1'b1;
      pclkRstArea_rst_io_p <= 1'b1;
    end else begin
      if(when_GowinDdr3Phy_l93) begin
        pclkRstArea_holdCnt <= (pclkRstArea_holdCnt + 4'b0001);
      end
      pclkRstArea_rst_pclk_n <= (pclkRstArea_holdCnt == 4'b1111);
      pclkRstArea_rst_cmd_p <= (pclkRstArea_holdCnt != 4'b1111);
      pclkRstArea_rst_io_p <= ((pclkRstArea_holdCnt != 4'b1111) || io_wser_rst);
    end
  end

  always @(posedge io_fclk or posedge _zz_2) begin
    if(_zz_2) begin
      fclkRstArea_s0_cmd <= 1'b1;
      fclkRstArea_s0_io <= 1'b1;
    end else begin
      fclkRstArea_s0_cmd <= pclkRstArea_rst_cmd_p;
      fclkRstArea_s0_io <= pclkRstArea_rst_io_p;
    end
  end

  always @(negedge io_fclk or posedge _zz_3) begin
    if(_zz_3) begin
      fclkRstArea_s1_cmd <= 1'b1;
      fclkRstArea_s0_io_regNext <= 1'b1;
      fclkRstArea_rst_dqs0 <= 1'b1;
      fclkRstArea_rst_dqs1 <= 1'b1;
      fclkRstArea_rst_dq0a <= 1'b1;
      fclkRstArea_rst_dq0b <= 1'b1;
      fclkRstArea_rst_dq1a <= 1'b1;
      fclkRstArea_rst_dq1b <= 1'b1;
    end else begin
      fclkRstArea_s1_cmd <= fclkRstArea_s0_cmd;
      fclkRstArea_s0_io_regNext <= fclkRstArea_s0_io;
      fclkRstArea_rst_dqs0 <= fclkRstArea_s0_io_regNext;
      fclkRstArea_rst_dqs1 <= fclkRstArea_s0_io_regNext;
      fclkRstArea_rst_dq0a <= fclkRstArea_s0_io_regNext;
      fclkRstArea_rst_dq0b <= fclkRstArea_s0_io_regNext;
      fclkRstArea_rst_dq1a <= fclkRstArea_s0_io_regNext;
      fclkRstArea_rst_dq1b <= fclkRstArea_s0_io_regNext;
    end
  end

  always @(posedge io_ck or posedge _zz_4) begin
    if(_zz_4) begin
      fclkRstArea_rst_cmd_a <= 1'b1;
      fclkRstArea_rst_cmd_b <= 1'b1;
    end else begin
      fclkRstArea_rst_cmd_a <= fclkRstArea_s1_cmd;
      fclkRstArea_rst_cmd_b <= fclkRstArea_s1_cmd;
    end
  end


endmodule

module Ddr3ControllerCore (
  input  wire          io_req_valid,
  output wire          io_req_ready,
  input  wire          io_req_payload_write,
  input  wire [26:0]   io_req_payload_addr,
  input  wire [127:0]  io_req_payload_wdata,
  input  wire [15:0]   io_req_payload_wstrb,
  output wire          io_rsp_valid,
  output wire [127:0]  io_rsp_payload_rdata,
  output wire          io_init_done,
  output wire          io_write_level_done,
  output wire          io_read_calib_done,
  output wire [7:0]    io_wstep,
  output wire [1:0]    io_rclkpos,
  output wire [2:0]    io_rclksel,
  output wire [2:0]    io_best_rot,
  output wire [3:0]    io_best_score,
  output wire [3:0]    io_dbg_state,
  input  wire          io_phy_dlllock,
  input  wire          io_phy_rst_lock_n,
  input  wire [1:0]    io_phy_rburst,
  input  wire [1:0]    io_phy_rvalid,
  input  wire [2:0]    io_phy_wpoint_0,
  input  wire [2:0]    io_phy_wpoint_1,
  input  wire [2:0]    io_phy_rpoint_0,
  input  wire [2:0]    io_phy_rpoint_1,
  input  wire [15:0]   io_phy_dq_in_0,
  input  wire [15:0]   io_phy_dq_in_1,
  input  wire [15:0]   io_phy_dq_in_2,
  input  wire [15:0]   io_phy_dq_in_3,
  input  wire [15:0]   io_phy_dq_in_4,
  input  wire [15:0]   io_phy_dq_in_5,
  input  wire [15:0]   io_phy_dq_in_6,
  input  wire [15:0]   io_phy_dq_in_7,
  input  wire [15:0]   io_phy_dq_raw,
  output wire          io_phy_dqs_hold,
  output wire [7:0]    io_phy_wstep,
  output wire          io_phy_rloadn,
  output wire          io_phy_rmove,
  output wire          io_phy_rdir,
  output wire [1:0]    io_phy_rclkpos,
  output wire [2:0]    io_phy_rclksel,
  output wire [3:0]    io_phy_dqs_read,
  output wire [15:0]   io_phy_dq_out_0,
  output wire [15:0]   io_phy_dq_out_1,
  output wire [15:0]   io_phy_dq_out_2,
  output wire [15:0]   io_phy_dq_out_3,
  output wire [15:0]   io_phy_dq_out_4,
  output wire [15:0]   io_phy_dq_out_5,
  output wire [15:0]   io_phy_dq_out_6,
  output wire [15:0]   io_phy_dq_out_7,
  output wire [3:0]    io_phy_dq_oen,
  output wire [7:0]    io_phy_dqs_out,
  output wire [3:0]    io_phy_dqs_oen,
  output wire [7:0]    io_phy_dm_out,
  output wire          io_phy_nRAS_0,
  output wire          io_phy_nRAS_1,
  output wire          io_phy_nRAS_2,
  output wire          io_phy_nRAS_3,
  output wire          io_phy_nCAS_0,
  output wire          io_phy_nCAS_1,
  output wire          io_phy_nCAS_2,
  output wire          io_phy_nCAS_3,
  output wire          io_phy_nWE_0,
  output wire          io_phy_nWE_1,
  output wire          io_phy_nWE_2,
  output wire          io_phy_nWE_3,
  output wire [13:0]   io_phy_A_0,
  output wire [13:0]   io_phy_A_1,
  output wire [13:0]   io_phy_A_2,
  output wire [13:0]   io_phy_A_3,
  output wire [2:0]    io_phy_BA_0,
  output wire [2:0]    io_phy_BA_1,
  output wire [2:0]    io_phy_BA_2,
  output wire [2:0]    io_phy_BA_3,
  output wire          io_phy_CKE,
  output wire          io_phy_resetn_delay,
  output wire          io_phy_wser_rst,
  input  wire          _zz_when_Ddr3ControllerCore_l1997,
  input  wire          io_pclk
);
  localparam Ddr3State_RST_WAIT = 4'd0;
  localparam Ddr3State_CKE_WAIT = 4'd1;
  localparam Ddr3State_CONFIG_1 = 4'd2;
  localparam Ddr3State_ZQCL = 4'd3;
  localparam Ddr3State_WRITE_LEVELING = 4'd4;
  localparam Ddr3State_READ_CALIB = 4'd5;
  localparam Ddr3State_IDLE = 4'd6;
  localparam Ddr3State_READ = 4'd7;
  localparam Ddr3State_WRITE = 4'd8;
  localparam Ddr3State_PRECHARGE = 4'd9;
  localparam Ddr3State_REFRESH = 4'd10;

  wire       [3:0]    _zz_rotScorer_rotScores_0;
  wire       [3:0]    _zz_rotScorer_rotScores_0_1;
  wire       [3:0]    _zz_rotScorer_rotScores_0_2;
  wire       [3:0]    _zz_rotScorer_rotScores_0_3;
  wire       [3:0]    _zz_rotScorer_rotScores_0_4;
  wire       [3:0]    _zz_rotScorer_rotScores_0_5;
  wire       [3:0]    _zz_rotScorer_rotScores_0_6;
  wire       [3:0]    _zz_rotScorer_rotScores_0_7;
  wire       [0:0]    _zz_rotScorer_rotScores_0_8;
  wire       [3:0]    _zz_rotScorer_rotScores_0_9;
  wire       [0:0]    _zz_rotScorer_rotScores_0_10;
  wire       [3:0]    _zz_rotScorer_rotScores_0_11;
  wire       [0:0]    _zz_rotScorer_rotScores_0_12;
  wire       [3:0]    _zz_rotScorer_rotScores_0_13;
  wire       [0:0]    _zz_rotScorer_rotScores_0_14;
  wire       [3:0]    _zz_rotScorer_rotScores_0_15;
  wire       [0:0]    _zz_rotScorer_rotScores_0_16;
  wire       [3:0]    _zz_rotScorer_rotScores_0_17;
  wire       [0:0]    _zz_rotScorer_rotScores_0_18;
  wire       [3:0]    _zz_rotScorer_rotScores_0_19;
  wire       [0:0]    _zz_rotScorer_rotScores_0_20;
  wire       [3:0]    _zz_rotScorer_rotScores_0_21;
  wire       [0:0]    _zz_rotScorer_rotScores_0_22;
  wire       [3:0]    _zz_rotScorer_rotScores_1;
  wire       [3:0]    _zz_rotScorer_rotScores_1_1;
  wire       [3:0]    _zz_rotScorer_rotScores_1_2;
  wire       [3:0]    _zz_rotScorer_rotScores_1_3;
  wire       [3:0]    _zz_rotScorer_rotScores_1_4;
  wire       [3:0]    _zz_rotScorer_rotScores_1_5;
  wire       [3:0]    _zz_rotScorer_rotScores_1_6;
  wire       [3:0]    _zz_rotScorer_rotScores_1_7;
  wire       [0:0]    _zz_rotScorer_rotScores_1_8;
  wire       [3:0]    _zz_rotScorer_rotScores_1_9;
  wire       [0:0]    _zz_rotScorer_rotScores_1_10;
  wire       [3:0]    _zz_rotScorer_rotScores_1_11;
  wire       [0:0]    _zz_rotScorer_rotScores_1_12;
  wire       [3:0]    _zz_rotScorer_rotScores_1_13;
  wire       [0:0]    _zz_rotScorer_rotScores_1_14;
  wire       [3:0]    _zz_rotScorer_rotScores_1_15;
  wire       [0:0]    _zz_rotScorer_rotScores_1_16;
  wire       [3:0]    _zz_rotScorer_rotScores_1_17;
  wire       [0:0]    _zz_rotScorer_rotScores_1_18;
  wire       [3:0]    _zz_rotScorer_rotScores_1_19;
  wire       [0:0]    _zz_rotScorer_rotScores_1_20;
  wire       [3:0]    _zz_rotScorer_rotScores_1_21;
  wire       [0:0]    _zz_rotScorer_rotScores_1_22;
  wire       [3:0]    _zz_rotScorer_rotScores_2;
  wire       [3:0]    _zz_rotScorer_rotScores_2_1;
  wire       [3:0]    _zz_rotScorer_rotScores_2_2;
  wire       [3:0]    _zz_rotScorer_rotScores_2_3;
  wire       [3:0]    _zz_rotScorer_rotScores_2_4;
  wire       [3:0]    _zz_rotScorer_rotScores_2_5;
  wire       [3:0]    _zz_rotScorer_rotScores_2_6;
  wire       [3:0]    _zz_rotScorer_rotScores_2_7;
  wire       [0:0]    _zz_rotScorer_rotScores_2_8;
  wire       [3:0]    _zz_rotScorer_rotScores_2_9;
  wire       [0:0]    _zz_rotScorer_rotScores_2_10;
  wire       [3:0]    _zz_rotScorer_rotScores_2_11;
  wire       [0:0]    _zz_rotScorer_rotScores_2_12;
  wire       [3:0]    _zz_rotScorer_rotScores_2_13;
  wire       [0:0]    _zz_rotScorer_rotScores_2_14;
  wire       [3:0]    _zz_rotScorer_rotScores_2_15;
  wire       [0:0]    _zz_rotScorer_rotScores_2_16;
  wire       [3:0]    _zz_rotScorer_rotScores_2_17;
  wire       [0:0]    _zz_rotScorer_rotScores_2_18;
  wire       [3:0]    _zz_rotScorer_rotScores_2_19;
  wire       [0:0]    _zz_rotScorer_rotScores_2_20;
  wire       [3:0]    _zz_rotScorer_rotScores_2_21;
  wire       [0:0]    _zz_rotScorer_rotScores_2_22;
  wire       [3:0]    _zz_rotScorer_rotScores_3;
  wire       [3:0]    _zz_rotScorer_rotScores_3_1;
  wire       [3:0]    _zz_rotScorer_rotScores_3_2;
  wire       [3:0]    _zz_rotScorer_rotScores_3_3;
  wire       [3:0]    _zz_rotScorer_rotScores_3_4;
  wire       [3:0]    _zz_rotScorer_rotScores_3_5;
  wire       [3:0]    _zz_rotScorer_rotScores_3_6;
  wire       [3:0]    _zz_rotScorer_rotScores_3_7;
  wire       [0:0]    _zz_rotScorer_rotScores_3_8;
  wire       [3:0]    _zz_rotScorer_rotScores_3_9;
  wire       [0:0]    _zz_rotScorer_rotScores_3_10;
  wire       [3:0]    _zz_rotScorer_rotScores_3_11;
  wire       [0:0]    _zz_rotScorer_rotScores_3_12;
  wire       [3:0]    _zz_rotScorer_rotScores_3_13;
  wire       [0:0]    _zz_rotScorer_rotScores_3_14;
  wire       [3:0]    _zz_rotScorer_rotScores_3_15;
  wire       [0:0]    _zz_rotScorer_rotScores_3_16;
  wire       [3:0]    _zz_rotScorer_rotScores_3_17;
  wire       [0:0]    _zz_rotScorer_rotScores_3_18;
  wire       [3:0]    _zz_rotScorer_rotScores_3_19;
  wire       [0:0]    _zz_rotScorer_rotScores_3_20;
  wire       [3:0]    _zz_rotScorer_rotScores_3_21;
  wire       [0:0]    _zz_rotScorer_rotScores_3_22;
  wire       [3:0]    _zz_rotScorer_rotScores_4;
  wire       [3:0]    _zz_rotScorer_rotScores_4_1;
  wire       [3:0]    _zz_rotScorer_rotScores_4_2;
  wire       [3:0]    _zz_rotScorer_rotScores_4_3;
  wire       [3:0]    _zz_rotScorer_rotScores_4_4;
  wire       [3:0]    _zz_rotScorer_rotScores_4_5;
  wire       [3:0]    _zz_rotScorer_rotScores_4_6;
  wire       [3:0]    _zz_rotScorer_rotScores_4_7;
  wire       [0:0]    _zz_rotScorer_rotScores_4_8;
  wire       [3:0]    _zz_rotScorer_rotScores_4_9;
  wire       [0:0]    _zz_rotScorer_rotScores_4_10;
  wire       [3:0]    _zz_rotScorer_rotScores_4_11;
  wire       [0:0]    _zz_rotScorer_rotScores_4_12;
  wire       [3:0]    _zz_rotScorer_rotScores_4_13;
  wire       [0:0]    _zz_rotScorer_rotScores_4_14;
  wire       [3:0]    _zz_rotScorer_rotScores_4_15;
  wire       [0:0]    _zz_rotScorer_rotScores_4_16;
  wire       [3:0]    _zz_rotScorer_rotScores_4_17;
  wire       [0:0]    _zz_rotScorer_rotScores_4_18;
  wire       [3:0]    _zz_rotScorer_rotScores_4_19;
  wire       [0:0]    _zz_rotScorer_rotScores_4_20;
  wire       [3:0]    _zz_rotScorer_rotScores_4_21;
  wire       [0:0]    _zz_rotScorer_rotScores_4_22;
  wire       [3:0]    _zz_rotScorer_rotScores_5;
  wire       [3:0]    _zz_rotScorer_rotScores_5_1;
  wire       [3:0]    _zz_rotScorer_rotScores_5_2;
  wire       [3:0]    _zz_rotScorer_rotScores_5_3;
  wire       [3:0]    _zz_rotScorer_rotScores_5_4;
  wire       [3:0]    _zz_rotScorer_rotScores_5_5;
  wire       [3:0]    _zz_rotScorer_rotScores_5_6;
  wire       [3:0]    _zz_rotScorer_rotScores_5_7;
  wire       [0:0]    _zz_rotScorer_rotScores_5_8;
  wire       [3:0]    _zz_rotScorer_rotScores_5_9;
  wire       [0:0]    _zz_rotScorer_rotScores_5_10;
  wire       [3:0]    _zz_rotScorer_rotScores_5_11;
  wire       [0:0]    _zz_rotScorer_rotScores_5_12;
  wire       [3:0]    _zz_rotScorer_rotScores_5_13;
  wire       [0:0]    _zz_rotScorer_rotScores_5_14;
  wire       [3:0]    _zz_rotScorer_rotScores_5_15;
  wire       [0:0]    _zz_rotScorer_rotScores_5_16;
  wire       [3:0]    _zz_rotScorer_rotScores_5_17;
  wire       [0:0]    _zz_rotScorer_rotScores_5_18;
  wire       [3:0]    _zz_rotScorer_rotScores_5_19;
  wire       [0:0]    _zz_rotScorer_rotScores_5_20;
  wire       [3:0]    _zz_rotScorer_rotScores_5_21;
  wire       [0:0]    _zz_rotScorer_rotScores_5_22;
  wire       [3:0]    _zz_rotScorer_rotScores_6;
  wire       [3:0]    _zz_rotScorer_rotScores_6_1;
  wire       [3:0]    _zz_rotScorer_rotScores_6_2;
  wire       [3:0]    _zz_rotScorer_rotScores_6_3;
  wire       [3:0]    _zz_rotScorer_rotScores_6_4;
  wire       [3:0]    _zz_rotScorer_rotScores_6_5;
  wire       [3:0]    _zz_rotScorer_rotScores_6_6;
  wire       [3:0]    _zz_rotScorer_rotScores_6_7;
  wire       [0:0]    _zz_rotScorer_rotScores_6_8;
  wire       [3:0]    _zz_rotScorer_rotScores_6_9;
  wire       [0:0]    _zz_rotScorer_rotScores_6_10;
  wire       [3:0]    _zz_rotScorer_rotScores_6_11;
  wire       [0:0]    _zz_rotScorer_rotScores_6_12;
  wire       [3:0]    _zz_rotScorer_rotScores_6_13;
  wire       [0:0]    _zz_rotScorer_rotScores_6_14;
  wire       [3:0]    _zz_rotScorer_rotScores_6_15;
  wire       [0:0]    _zz_rotScorer_rotScores_6_16;
  wire       [3:0]    _zz_rotScorer_rotScores_6_17;
  wire       [0:0]    _zz_rotScorer_rotScores_6_18;
  wire       [3:0]    _zz_rotScorer_rotScores_6_19;
  wire       [0:0]    _zz_rotScorer_rotScores_6_20;
  wire       [3:0]    _zz_rotScorer_rotScores_6_21;
  wire       [0:0]    _zz_rotScorer_rotScores_6_22;
  wire       [3:0]    _zz_rotScorer_rotScores_7;
  wire       [3:0]    _zz_rotScorer_rotScores_7_1;
  wire       [3:0]    _zz_rotScorer_rotScores_7_2;
  wire       [3:0]    _zz_rotScorer_rotScores_7_3;
  wire       [3:0]    _zz_rotScorer_rotScores_7_4;
  wire       [3:0]    _zz_rotScorer_rotScores_7_5;
  wire       [3:0]    _zz_rotScorer_rotScores_7_6;
  wire       [3:0]    _zz_rotScorer_rotScores_7_7;
  wire       [0:0]    _zz_rotScorer_rotScores_7_8;
  wire       [3:0]    _zz_rotScorer_rotScores_7_9;
  wire       [0:0]    _zz_rotScorer_rotScores_7_10;
  wire       [3:0]    _zz_rotScorer_rotScores_7_11;
  wire       [0:0]    _zz_rotScorer_rotScores_7_12;
  wire       [3:0]    _zz_rotScorer_rotScores_7_13;
  wire       [0:0]    _zz_rotScorer_rotScores_7_14;
  wire       [3:0]    _zz_rotScorer_rotScores_7_15;
  wire       [0:0]    _zz_rotScorer_rotScores_7_16;
  wire       [3:0]    _zz_rotScorer_rotScores_7_17;
  wire       [0:0]    _zz_rotScorer_rotScores_7_18;
  wire       [3:0]    _zz_rotScorer_rotScores_7_19;
  wire       [0:0]    _zz_rotScorer_rotScores_7_20;
  wire       [3:0]    _zz_rotScorer_rotScores_7_21;
  wire       [0:0]    _zz_rotScorer_rotScores_7_22;
  wire       [6:0]    _zz_rdCyc;
  wire       [1:0]    _zz_rdCyc_1;
  wire       [0:0]    _zz_rotSplit;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l406;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l410;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l410_1;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l410_2;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l410_3;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l410_4;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l410_5;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l410_6;
  wire       [6:0]    _zz_cycle_1;
  wire       [16:0]   _zz_tick_counter;
  wire       [12:0]   _zz_A_0_1;
  wire       [12:0]   _zz_A_0_2;
  wire       [12:0]   _zz_A_0_3;
  wire       [12:0]   _zz_A_0_4;
  wire       [13:0]   _zz_A_0_5;
  wire       [0:0]    _zz_A_0_6;
  wire       [12:0]   _zz_A_0_7;
  wire       [12:0]   _zz_A_0_8;
  wire       [7:0]    _zz_wstep;
  wire       [7:0]    _zz_wstep_1;
  wire       [8:0]    _zz_wstep_2;
  wire       [8:0]    _zz_wstep_3;
  wire       [8:0]    _zz_wstep_4;
  wire       [7:0]    _zz_wstep_5;
  wire       [12:0]   _zz_A_0_9;
  wire       [2:0]    _zz_when_Ddr3ControllerCore_l554;
  wire       [2:0]    _zz_when_Ddr3ControllerCore_l554_1;
  wire       [0:0]    _zz_when_Ddr3ControllerCore_l554_2;
  wire       [12:0]   _zz_A_0_10;
  wire       [0:0]    _zz_A_0_11;
  wire       [13:0]   _zz_A_2_2;
  wire       [0:0]    _zz_A_2_3;
  wire       [13:0]   _zz_A_2_4;
  wire       [0:0]    _zz_A_2_5;
  wire       [0:0]    _zz_A_0_12;
  wire       [1:0]    _zz_rclkpos;
  wire       [0:0]    _zz_A_0_13;
  wire       [2:0]    _zz_rclksel;
  wire       [1:0]    _zz_rclkpos_1;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l1094;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l1106;
  wire       [7:0]    _zz_wstep_6;
  wire       [7:0]    _zz_wstep_7;
  wire       [0:0]    _zz_A_0_14;
  wire       [0:0]    _zz_A_0_15;
  wire       [0:0]    _zz_A_0_16;
  wire       [0:0]    _zz_A_0_17;
  wire       [15:0]   _zz_A_0_18;
  wire       [0:0]    _zz_A_0_19;
  wire       [15:0]   _zz_A_0_20;
  wire       [0:0]    _zz_A_0_21;
  wire       [15:0]   _zz__zz_A_2;
  wire       [9:0]    _zz__zz_A_2_1;
  wire       [5:0]    _zz_rdRspLeft;
  wire       [5:0]    _zz_rdRspLeft_1;
  wire       [0:0]    _zz_rdRspLeft_2;
  wire       [5:0]    _zz_rdRspLeft_3;
  wire       [0:0]    _zz_rdRspLeft_4;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l1468_1;
  wire       [15:0]   _zz_A_2_6;
  wire       [15:0]   _zz_A_2_7;
  wire       [15:0]   _zz_A_2_8;
  wire       [15:0]   _zz_A_2_9;
  wire       [3:0]    _zz__zz_rdataVec_0;
  wire       [3:0]    _zz__zz_rdataVec_0_1;
  reg        [15:0]   _zz_rdataVec_0_1;
  reg        [15:0]   _zz_rdataVec_0_2;
  wire       [3:0]    _zz__zz_rdataVec_1;
  wire       [3:0]    _zz__zz_rdataVec_1_1;
  reg        [15:0]   _zz_rdataVec_1_1;
  reg        [15:0]   _zz_rdataVec_1_2;
  wire       [3:0]    _zz__zz_rdataVec_2;
  wire       [3:0]    _zz__zz_rdataVec_2_1;
  reg        [15:0]   _zz_rdataVec_2_1;
  reg        [15:0]   _zz_rdataVec_2_2;
  wire       [3:0]    _zz__zz_rdataVec_3;
  wire       [3:0]    _zz__zz_rdataVec_3_1;
  reg        [15:0]   _zz_rdataVec_3_1;
  reg        [15:0]   _zz_rdataVec_3_2;
  wire       [3:0]    _zz__zz_rdataVec_4;
  wire       [3:0]    _zz__zz_rdataVec_4_1;
  reg        [15:0]   _zz_rdataVec_4_1;
  reg        [15:0]   _zz_rdataVec_4_2;
  wire       [3:0]    _zz__zz_rdataVec_5;
  wire       [3:0]    _zz__zz_rdataVec_5_1;
  reg        [15:0]   _zz_rdataVec_5_1;
  reg        [15:0]   _zz_rdataVec_5_2;
  wire       [3:0]    _zz__zz_rdataVec_6;
  wire       [3:0]    _zz__zz_rdataVec_6_1;
  reg        [15:0]   _zz_rdataVec_6_1;
  reg        [15:0]   _zz_rdataVec_6_2;
  wire       [3:0]    _zz__zz_rdataVec_7;
  wire       [3:0]    _zz__zz_rdataVec_7_1;
  reg        [15:0]   _zz_rdataVec_7_1;
  reg        [15:0]   _zz_rdataVec_7_2;
  wire       [2:0]    CMD_SetModeReg;
  wire       [2:0]    CMD_AutoRefresh;
  wire       [2:0]    CMD_PreCharge;
  wire       [2:0]    CMD_BankActivate;
  wire       [2:0]    CMD_Write;
  wire       [2:0]    CMD_Read;
  wire       [2:0]    CMD_ZQCL;
  wire       [2:0]    CMD_NOP;
  wire       [1:0]    M_BL;
  wire       [3:0]    M_CAS;
  wire       [2:0]    M_CWL;
  wire       [2:0]    M_WR;
  wire                M_DLLReset;
  wire       [2:0]    M_RTT_NOM;
  wire       [1:0]    M_RTT_WR;
  wire       [1:0]    M_DRIVE;
  wire       [1:0]    M_AL;
  wire       [15:0]   MR0;
  wire       [15:0]   MR1;
  wire       [15:0]   MR2;
  wire       [15:0]   MR2_RTT_WR;
  wire       [15:0]   MR3;
  reg        [3:0]    state;
  reg        [6:0]    cycle;
  reg        [16:0]   tick_counter;
  reg                 tick;
  reg                 resetn_delay;
  reg                 CKE;
  reg                 busy;
  reg                 data_ready;
  reg                 init_done_latched;
  reg                 rowOpen;
  reg        [2:0]    openBank;
  reg        [13:0]   openRow;
  reg                 prechForReq;
  reg                 wrStreamOpen;
  reg                 wrHavePending;
  reg        [5:0]    wrExtraCnt;
  reg        [3:0]    wrCooldown;
  reg                 st1Valid;
  reg                 st2Valid;
  reg                 st3Valid;
  reg                 st1Req_write;
  reg        [26:0]   st1Req_addr;
  reg        [127:0]  st1Req_wdata;
  reg        [15:0]   st1Req_wstrb;
  reg                 st2Req_write;
  reg        [26:0]   st2Req_addr;
  reg        [127:0]  st2Req_wdata;
  reg        [15:0]   st2Req_wstrb;
  reg                 st3Req_write;
  reg        [26:0]   st3Req_addr;
  reg        [127:0]  st3Req_wdata;
  reg        [15:0]   st3Req_wstrb;
  reg                 rdStreamOpen;
  reg                 rdHavePending;
  reg        [5:0]    rdExtraCnt;
  reg        [5:0]    rdRspLeft;
  reg                 wlevel_done;
  reg        [3:0]    wlevel_cnt;
  reg        [8:0]    wlevel_tries;
  reg        [2:0]    wlVoteN;
  reg        [2:0]    wlVoteCnt;
  reg        [2:0]    wlVoteCnt0;
  reg        [2:0]    wlVoteCnt1;
  reg                 wlLockedR;
  reg        [7:0]    wlLockedStepR;
  reg        [7:0]    wstep;
  reg                 rcalib_done;
  reg        [3:0]    rcalib_cnt;
  reg        [9:0]    rcalib_tries;
  reg        [1:0]    rclkpos;
  reg        [2:0]    rclksel;
  reg        [1:0]    rburst_seen;
  reg                 dqs_hold;
  wire       [127:0]  trainPat;
  wire       [127:0]  poisonPat;
  reg                 training;
  reg                 trainDone;
  reg                 needPoison;
  reg        [127:0]  rotScorer_trainLatch;
  wire       [15:0]   rotScorer_latchBeats_0;
  wire       [15:0]   rotScorer_latchBeats_1;
  wire       [15:0]   rotScorer_latchBeats_2;
  wire       [15:0]   rotScorer_latchBeats_3;
  wire       [15:0]   rotScorer_latchBeats_4;
  wire       [15:0]   rotScorer_latchBeats_5;
  wire       [15:0]   rotScorer_latchBeats_6;
  wire       [15:0]   rotScorer_latchBeats_7;
  wire       [15:0]   rotScorer_patBeats_0;
  wire       [15:0]   rotScorer_patBeats_1;
  wire       [15:0]   rotScorer_patBeats_2;
  wire       [15:0]   rotScorer_patBeats_3;
  wire       [15:0]   rotScorer_patBeats_4;
  wire       [15:0]   rotScorer_patBeats_5;
  wire       [15:0]   rotScorer_patBeats_6;
  wire       [15:0]   rotScorer_patBeats_7;
  wire       [3:0]    rotScorer_rotScores_0;
  wire       [3:0]    rotScorer_rotScores_1;
  wire       [3:0]    rotScorer_rotScores_2;
  wire       [3:0]    rotScorer_rotScores_3;
  wire       [3:0]    rotScorer_rotScores_4;
  wire       [3:0]    rotScorer_rotScores_5;
  wire       [3:0]    rotScorer_rotScores_6;
  wire       [3:0]    rotScorer_rotScores_7;
  reg        [3:0]    rotScorer_rotScoresReg_0;
  reg        [3:0]    rotScorer_rotScoresReg_1;
  reg        [3:0]    rotScorer_rotScoresReg_2;
  reg        [3:0]    rotScorer_rotScoresReg_3;
  reg        [3:0]    rotScorer_rotScoresReg_4;
  reg        [3:0]    rotScorer_rotScoresReg_5;
  reg        [3:0]    rotScorer_rotScoresReg_6;
  reg        [3:0]    rotScorer_rotScoresReg_7;
  wire       [3:0]    rotScorer_treeS1_0;
  wire       [3:0]    rotScorer_treeS1_1;
  wire       [3:0]    rotScorer_treeS1_2;
  wire       [3:0]    rotScorer_treeS1_3;
  wire       [2:0]    rotScorer_treeI1_0;
  wire       [2:0]    rotScorer_treeI1_1;
  wire       [2:0]    rotScorer_treeI1_2;
  wire       [2:0]    rotScorer_treeI1_3;
  wire                _zz_rotScorer_treeS1_0;
  wire                _zz_rotScorer_treeS1_1;
  wire                _zz_rotScorer_treeS1_2;
  wire                _zz_rotScorer_treeS1_3;
  wire       [3:0]    rotScorer_treeS2_0;
  wire       [3:0]    rotScorer_treeS2_1;
  wire       [2:0]    rotScorer_treeI2_0;
  wire       [2:0]    rotScorer_treeI2_1;
  wire                _zz_rotScorer_treeS2_0;
  wire                _zz_rotScorer_treeS2_1;
  wire                rotScorer_betterTop;
  wire       [3:0]    rotScorer_topScore;
  wire       [2:0]    rotScorer_topIdx;
  reg        [3:0]    rotScorer_sweepScore;
  reg        [2:0]    rotScorer_sweepRot;
  reg        [2:0]    wserRstCnt;
  reg                 wser_rst;
  reg        [3:0]    bestCnt;
  reg        [1:0]    bestPos;
  reg        [2:0]    bestSel;
  reg        [2:0]    bestRot;
  reg        [1:0]    wrMode;
  reg                 shiftCalDone;
  reg        [1:0]    tryMode;
  reg                 wCalDone;
  reg        [1:0]    wTry;
  reg        [7:0]    wBase;
  reg        [7:0]    bestWstep;
  reg        [3:0]    best0;
  reg        [1:0]    best0Pos;
  reg        [2:0]    best0Sel;
  reg        [2:0]    best0Rot;
  reg        [1:0]    bestMode;
  reg        [3:0]    bestWCnt;
  reg        [1:0]    bestWPos;
  reg        [2:0]    bestWSel;
  reg        [2:0]    bestWRot;
  reg        [1:0]    bestWMode;
  reg                 dllSweepOn;
  reg                 dllSweepDone;
  reg        [3:0]    bestCntDll;
  reg                 needFinalSurvey;
  reg                 s0Side;
  reg        [6:0]    s0Mag;
  reg                 s1Side;
  reg        [6:0]    s1Mag;
  reg                 s2Side;
  reg        [6:0]    s2Mag;
  reg                 bestSide;
  reg        [6:0]    bestMag;
  reg                 scanOn;
  reg                 scSide;
  reg        [6:0]    scMag;
  reg        [3:0]    bestSurveyCnt;
  reg                 bestSurveySide;
  reg        [6:0]    bestSurveyMag;
  reg        [1:0]    anchorLeft;
  reg                 aligning;
  reg        [1:0]    settleLeft;
  reg        [1:0]    pinLeft;
  reg                 bistReturn;
  reg        [6:0]    sweepMag0;
  reg        [6:0]    sweepMagN;
  wire       [6:0]    winEndRaw;
  wire       [6:0]    winEnd;
  wire                winDoneNow;
  reg                 applyArmed;
  reg        [7:0]    navigateLeft;
  reg                 rmove;
  reg                 rdir;
  reg        [10:0]   refresh_timer;
  reg                 refresh_due;
  wire                when_Ddr3ControllerCore_l280;
  wire                when_Ddr3ControllerCore_l281;
  reg                 reqReg_write;
  reg        [26:0]   reqReg_addr;
  reg        [127:0]  reqReg_wdata;
  reg        [15:0]   reqReg_wstrb;
  reg                 nRAS_0;
  reg                 nRAS_1;
  reg                 nRAS_2;
  reg                 nRAS_3;
  reg                 nCAS_0;
  reg                 nCAS_1;
  reg                 nCAS_2;
  reg                 nCAS_3;
  reg                 nWE_0;
  reg                 nWE_1;
  reg                 nWE_2;
  reg                 nWE_3;
  reg        [13:0]   A_0;
  reg        [13:0]   A_1;
  reg        [13:0]   A_2;
  reg        [13:0]   A_3;
  reg        [2:0]    BA_0;
  reg        [2:0]    BA_1;
  reg        [2:0]    BA_2;
  reg        [2:0]    BA_3;
  reg        [15:0]   dq_out_0;
  reg        [15:0]   dq_out_1;
  reg        [15:0]   dq_out_2;
  reg        [15:0]   dq_out_3;
  reg        [15:0]   dq_out_4;
  reg        [15:0]   dq_out_5;
  reg        [15:0]   dq_out_6;
  reg        [15:0]   dq_out_7;
  reg        [3:0]    dq_oen;
  reg        [7:0]    dqs_out;
  reg        [3:0]    dqs_oen;
  reg        [7:0]    dm_out;
  wire                when_Ddr3ControllerCore_l364;
  wire                when_Ddr3ControllerCore_l365;
  wire       [6:0]    rdCyc;
  wire       [6:0]    rotSplit;
  reg        [3:0]    dqs_read;
  wire                when_Ddr3ControllerCore_l406;
  wire                when_Ddr3ControllerCore_l410;
  wire       [13:0]   inRow;
  wire       [2:0]    inBank;
  wire                inSameRow;
  wire                canAcceptWrStream;
  wire                canAcceptRdStream;
  wire                acceptReq;
  wire                when_Ddr3ControllerCore_l449;
  wire                when_Ddr3ControllerCore_l454;
  wire                when_Ddr3ControllerCore_l469;
  wire       [15:0]   _zz_A_0;
  wire                when_Ddr3ControllerCore_l576;
  wire                when_Ddr3ControllerCore_l541;
  wire                when_Ddr3ControllerCore_l550;
  wire                when_Ddr3ControllerCore_l565;
  wire                when_Ddr3ControllerCore_l554;
  wire                when_Ddr3ControllerCore_l712;
  wire                when_Ddr3ControllerCore_l717;
  wire                when_Ddr3ControllerCore_l737;
  wire                when_Ddr3ControllerCore_l739;
  wire                when_Ddr3ControllerCore_l751;
  wire                when_Ddr3ControllerCore_l775;
  wire                when_Ddr3ControllerCore_l776;
  wire                when_Ddr3ControllerCore_l791;
  wire                when_Ddr3ControllerCore_l816;
  wire                when_Ddr3ControllerCore_l834;
  wire                when_Ddr3ControllerCore_l859;
  wire                when_Ddr3ControllerCore_l864;
  wire                when_Ddr3ControllerCore_l874;
  wire                when_Ddr3ControllerCore_l899;
  wire                when_Ddr3ControllerCore_l935;
  wire                when_Ddr3ControllerCore_l941;
  wire                when_Ddr3ControllerCore_l963;
  wire                when_Ddr3ControllerCore_l982;
  wire                when_Ddr3ControllerCore_l987;
  wire                when_Ddr3ControllerCore_l1012;
  wire                when_Ddr3ControllerCore_l1019;
  wire                when_Ddr3ControllerCore_l1023;
  wire                when_Ddr3ControllerCore_l1030;
  wire                when_Ddr3ControllerCore_l1038;
  wire                when_Ddr3ControllerCore_l1040;
  wire                when_Ddr3ControllerCore_l1046;
  wire                when_Ddr3ControllerCore_l1053;
  wire       [1:0]    _zz_wrMode;
  wire                when_Ddr3ControllerCore_l1061;
  wire                when_Ddr3ControllerCore_l1078;
  wire                when_Ddr3ControllerCore_l1085;
  wire                when_Ddr3ControllerCore_l1094;
  wire       [6:0]    _zz_s0Mag;
  wire                when_Ddr3ControllerCore_l1106;
  wire       [6:0]    _zz_s0Mag_1;
  wire                when_Ddr3ControllerCore_l1099;
  wire                when_Ddr3ControllerCore_l1135;
  wire                when_Ddr3ControllerCore_l1172;
  wire                when_Ddr3ControllerCore_l1217;
  wire                when_Ddr3ControllerCore_l1219;
  wire                when_Ddr3ControllerCore_l1220;
  wire                when_Ddr3ControllerCore_l1228;
  wire                when_Ddr3ControllerCore_l1249;
  wire       [13:0]   _zz_openRow;
  wire       [2:0]    _zz_openBank;
  wire                _zz_cycle;
  wire                when_Ddr3ControllerCore_l1353;
  wire                when_Ddr3ControllerCore_l1362;
  wire                when_Ddr3ControllerCore_l1394;
  wire       [13:0]   _zz_openRow_1;
  wire       [2:0]    _zz_openBank_1;
  wire       [2:0]    _zz_BA_2;
  wire       [15:0]   _zz_A_2;
  wire                when_Ddr3ControllerCore_l1440;
  wire                when_Ddr3ControllerCore_l1444;
  wire                when_Ddr3ControllerCore_l1450;
  wire                when_Ddr3ControllerCore_l1449;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l1468;
  wire                _zz_data_ready;
  wire                when_Ddr3ControllerCore_l1468;
  wire       [9:0]    _zz_A_2_1;
  wire       [2:0]    _zz_BA_2_1;
  wire                when_Ddr3ControllerCore_l1483;
  wire                when_Ddr3ControllerCore_l1489;
  wire                when_Ddr3ControllerCore_l1524;
  wire                when_Ddr3ControllerCore_l1610;
  wire                when_Ddr3ControllerCore_l1642;
  wire                when_Ddr3ControllerCore_l1660;
  wire                when_Ddr3ControllerCore_l1672;
  wire                when_Ddr3ControllerCore_l1683;
  wire                when_Ddr3ControllerCore_l1713;
  wire                when_Ddr3ControllerCore_l1749;
  wire                when_Ddr3ControllerCore_l1752;
  wire                when_Ddr3ControllerCore_l1762;
  wire                when_Ddr3ControllerCore_l1783;
  wire                when_Ddr3ControllerCore_l1793;
  wire                when_Ddr3ControllerCore_l1821;
  wire                when_Ddr3ControllerCore_l1825;
  wire                when_Ddr3ControllerCore_l1834;
  reg        [15:0]   dqPrevVec_0;
  reg        [15:0]   dqPrevVec_1;
  reg        [15:0]   dqPrevVec_2;
  reg        [15:0]   dqPrevVec_3;
  reg        [15:0]   dqPrevVec_4;
  reg        [15:0]   dqPrevVec_5;
  reg        [15:0]   dqPrevVec_6;
  reg        [15:0]   dqPrevVec_7;
  wire                needRotSplit;
  wire       [15:0]   rdataVec_0;
  wire       [15:0]   rdataVec_1;
  wire       [15:0]   rdataVec_2;
  wire       [15:0]   rdataVec_3;
  wire       [15:0]   rdataVec_4;
  wire       [15:0]   rdataVec_5;
  wire       [15:0]   rdataVec_6;
  wire       [15:0]   rdataVec_7;
  wire       [2:0]    _zz_rdataVec_0;
  wire       [2:0]    _zz_rdataVec_1;
  wire       [2:0]    _zz_rdataVec_2;
  wire       [2:0]    _zz_rdataVec_3;
  wire       [2:0]    _zz_rdataVec_4;
  wire       [2:0]    _zz_rdataVec_5;
  wire       [2:0]    _zz_rdataVec_6;
  wire       [2:0]    _zz_rdataVec_7;
  wire                when_Ddr3ControllerCore_l1997;
  `ifndef SYNTHESIS
  reg [111:0] state_string;
  `endif


  assign _zz_rotScorer_rotScores_0 = (_zz_rotScorer_rotScores_0_1 + _zz_rotScorer_rotScores_0_19);
  assign _zz_rotScorer_rotScores_0_1 = (_zz_rotScorer_rotScores_0_2 + _zz_rotScorer_rotScores_0_17);
  assign _zz_rotScorer_rotScores_0_2 = (_zz_rotScorer_rotScores_0_3 + _zz_rotScorer_rotScores_0_15);
  assign _zz_rotScorer_rotScores_0_3 = (_zz_rotScorer_rotScores_0_4 + _zz_rotScorer_rotScores_0_13);
  assign _zz_rotScorer_rotScores_0_4 = (_zz_rotScorer_rotScores_0_5 + _zz_rotScorer_rotScores_0_11);
  assign _zz_rotScorer_rotScores_0_5 = (_zz_rotScorer_rotScores_0_6 + _zz_rotScorer_rotScores_0_9);
  assign _zz_rotScorer_rotScores_0_6 = (4'b0000 + _zz_rotScorer_rotScores_0_7);
  assign _zz_rotScorer_rotScores_0_8 = (rotScorer_latchBeats_0 == rotScorer_patBeats_0);
  assign _zz_rotScorer_rotScores_0_7 = {3'd0, _zz_rotScorer_rotScores_0_8};
  assign _zz_rotScorer_rotScores_0_10 = (rotScorer_latchBeats_1 == rotScorer_patBeats_1);
  assign _zz_rotScorer_rotScores_0_9 = {3'd0, _zz_rotScorer_rotScores_0_10};
  assign _zz_rotScorer_rotScores_0_12 = (rotScorer_latchBeats_2 == rotScorer_patBeats_2);
  assign _zz_rotScorer_rotScores_0_11 = {3'd0, _zz_rotScorer_rotScores_0_12};
  assign _zz_rotScorer_rotScores_0_14 = (rotScorer_latchBeats_3 == rotScorer_patBeats_3);
  assign _zz_rotScorer_rotScores_0_13 = {3'd0, _zz_rotScorer_rotScores_0_14};
  assign _zz_rotScorer_rotScores_0_16 = (rotScorer_latchBeats_4 == rotScorer_patBeats_4);
  assign _zz_rotScorer_rotScores_0_15 = {3'd0, _zz_rotScorer_rotScores_0_16};
  assign _zz_rotScorer_rotScores_0_18 = (rotScorer_latchBeats_5 == rotScorer_patBeats_5);
  assign _zz_rotScorer_rotScores_0_17 = {3'd0, _zz_rotScorer_rotScores_0_18};
  assign _zz_rotScorer_rotScores_0_20 = (rotScorer_latchBeats_6 == rotScorer_patBeats_6);
  assign _zz_rotScorer_rotScores_0_19 = {3'd0, _zz_rotScorer_rotScores_0_20};
  assign _zz_rotScorer_rotScores_0_22 = (rotScorer_latchBeats_7 == rotScorer_patBeats_7);
  assign _zz_rotScorer_rotScores_0_21 = {3'd0, _zz_rotScorer_rotScores_0_22};
  assign _zz_rotScorer_rotScores_1 = (_zz_rotScorer_rotScores_1_1 + _zz_rotScorer_rotScores_1_19);
  assign _zz_rotScorer_rotScores_1_1 = (_zz_rotScorer_rotScores_1_2 + _zz_rotScorer_rotScores_1_17);
  assign _zz_rotScorer_rotScores_1_2 = (_zz_rotScorer_rotScores_1_3 + _zz_rotScorer_rotScores_1_15);
  assign _zz_rotScorer_rotScores_1_3 = (_zz_rotScorer_rotScores_1_4 + _zz_rotScorer_rotScores_1_13);
  assign _zz_rotScorer_rotScores_1_4 = (_zz_rotScorer_rotScores_1_5 + _zz_rotScorer_rotScores_1_11);
  assign _zz_rotScorer_rotScores_1_5 = (_zz_rotScorer_rotScores_1_6 + _zz_rotScorer_rotScores_1_9);
  assign _zz_rotScorer_rotScores_1_6 = (4'b0000 + _zz_rotScorer_rotScores_1_7);
  assign _zz_rotScorer_rotScores_1_8 = (rotScorer_latchBeats_0 == rotScorer_patBeats_1);
  assign _zz_rotScorer_rotScores_1_7 = {3'd0, _zz_rotScorer_rotScores_1_8};
  assign _zz_rotScorer_rotScores_1_10 = (rotScorer_latchBeats_1 == rotScorer_patBeats_2);
  assign _zz_rotScorer_rotScores_1_9 = {3'd0, _zz_rotScorer_rotScores_1_10};
  assign _zz_rotScorer_rotScores_1_12 = (rotScorer_latchBeats_2 == rotScorer_patBeats_3);
  assign _zz_rotScorer_rotScores_1_11 = {3'd0, _zz_rotScorer_rotScores_1_12};
  assign _zz_rotScorer_rotScores_1_14 = (rotScorer_latchBeats_3 == rotScorer_patBeats_4);
  assign _zz_rotScorer_rotScores_1_13 = {3'd0, _zz_rotScorer_rotScores_1_14};
  assign _zz_rotScorer_rotScores_1_16 = (rotScorer_latchBeats_4 == rotScorer_patBeats_5);
  assign _zz_rotScorer_rotScores_1_15 = {3'd0, _zz_rotScorer_rotScores_1_16};
  assign _zz_rotScorer_rotScores_1_18 = (rotScorer_latchBeats_5 == rotScorer_patBeats_6);
  assign _zz_rotScorer_rotScores_1_17 = {3'd0, _zz_rotScorer_rotScores_1_18};
  assign _zz_rotScorer_rotScores_1_20 = (rotScorer_latchBeats_6 == rotScorer_patBeats_7);
  assign _zz_rotScorer_rotScores_1_19 = {3'd0, _zz_rotScorer_rotScores_1_20};
  assign _zz_rotScorer_rotScores_1_22 = (rotScorer_latchBeats_7 == rotScorer_patBeats_0);
  assign _zz_rotScorer_rotScores_1_21 = {3'd0, _zz_rotScorer_rotScores_1_22};
  assign _zz_rotScorer_rotScores_2 = (_zz_rotScorer_rotScores_2_1 + _zz_rotScorer_rotScores_2_19);
  assign _zz_rotScorer_rotScores_2_1 = (_zz_rotScorer_rotScores_2_2 + _zz_rotScorer_rotScores_2_17);
  assign _zz_rotScorer_rotScores_2_2 = (_zz_rotScorer_rotScores_2_3 + _zz_rotScorer_rotScores_2_15);
  assign _zz_rotScorer_rotScores_2_3 = (_zz_rotScorer_rotScores_2_4 + _zz_rotScorer_rotScores_2_13);
  assign _zz_rotScorer_rotScores_2_4 = (_zz_rotScorer_rotScores_2_5 + _zz_rotScorer_rotScores_2_11);
  assign _zz_rotScorer_rotScores_2_5 = (_zz_rotScorer_rotScores_2_6 + _zz_rotScorer_rotScores_2_9);
  assign _zz_rotScorer_rotScores_2_6 = (4'b0000 + _zz_rotScorer_rotScores_2_7);
  assign _zz_rotScorer_rotScores_2_8 = (rotScorer_latchBeats_0 == rotScorer_patBeats_2);
  assign _zz_rotScorer_rotScores_2_7 = {3'd0, _zz_rotScorer_rotScores_2_8};
  assign _zz_rotScorer_rotScores_2_10 = (rotScorer_latchBeats_1 == rotScorer_patBeats_3);
  assign _zz_rotScorer_rotScores_2_9 = {3'd0, _zz_rotScorer_rotScores_2_10};
  assign _zz_rotScorer_rotScores_2_12 = (rotScorer_latchBeats_2 == rotScorer_patBeats_4);
  assign _zz_rotScorer_rotScores_2_11 = {3'd0, _zz_rotScorer_rotScores_2_12};
  assign _zz_rotScorer_rotScores_2_14 = (rotScorer_latchBeats_3 == rotScorer_patBeats_5);
  assign _zz_rotScorer_rotScores_2_13 = {3'd0, _zz_rotScorer_rotScores_2_14};
  assign _zz_rotScorer_rotScores_2_16 = (rotScorer_latchBeats_4 == rotScorer_patBeats_6);
  assign _zz_rotScorer_rotScores_2_15 = {3'd0, _zz_rotScorer_rotScores_2_16};
  assign _zz_rotScorer_rotScores_2_18 = (rotScorer_latchBeats_5 == rotScorer_patBeats_7);
  assign _zz_rotScorer_rotScores_2_17 = {3'd0, _zz_rotScorer_rotScores_2_18};
  assign _zz_rotScorer_rotScores_2_20 = (rotScorer_latchBeats_6 == rotScorer_patBeats_0);
  assign _zz_rotScorer_rotScores_2_19 = {3'd0, _zz_rotScorer_rotScores_2_20};
  assign _zz_rotScorer_rotScores_2_22 = (rotScorer_latchBeats_7 == rotScorer_patBeats_1);
  assign _zz_rotScorer_rotScores_2_21 = {3'd0, _zz_rotScorer_rotScores_2_22};
  assign _zz_rotScorer_rotScores_3 = (_zz_rotScorer_rotScores_3_1 + _zz_rotScorer_rotScores_3_19);
  assign _zz_rotScorer_rotScores_3_1 = (_zz_rotScorer_rotScores_3_2 + _zz_rotScorer_rotScores_3_17);
  assign _zz_rotScorer_rotScores_3_2 = (_zz_rotScorer_rotScores_3_3 + _zz_rotScorer_rotScores_3_15);
  assign _zz_rotScorer_rotScores_3_3 = (_zz_rotScorer_rotScores_3_4 + _zz_rotScorer_rotScores_3_13);
  assign _zz_rotScorer_rotScores_3_4 = (_zz_rotScorer_rotScores_3_5 + _zz_rotScorer_rotScores_3_11);
  assign _zz_rotScorer_rotScores_3_5 = (_zz_rotScorer_rotScores_3_6 + _zz_rotScorer_rotScores_3_9);
  assign _zz_rotScorer_rotScores_3_6 = (4'b0000 + _zz_rotScorer_rotScores_3_7);
  assign _zz_rotScorer_rotScores_3_8 = (rotScorer_latchBeats_0 == rotScorer_patBeats_3);
  assign _zz_rotScorer_rotScores_3_7 = {3'd0, _zz_rotScorer_rotScores_3_8};
  assign _zz_rotScorer_rotScores_3_10 = (rotScorer_latchBeats_1 == rotScorer_patBeats_4);
  assign _zz_rotScorer_rotScores_3_9 = {3'd0, _zz_rotScorer_rotScores_3_10};
  assign _zz_rotScorer_rotScores_3_12 = (rotScorer_latchBeats_2 == rotScorer_patBeats_5);
  assign _zz_rotScorer_rotScores_3_11 = {3'd0, _zz_rotScorer_rotScores_3_12};
  assign _zz_rotScorer_rotScores_3_14 = (rotScorer_latchBeats_3 == rotScorer_patBeats_6);
  assign _zz_rotScorer_rotScores_3_13 = {3'd0, _zz_rotScorer_rotScores_3_14};
  assign _zz_rotScorer_rotScores_3_16 = (rotScorer_latchBeats_4 == rotScorer_patBeats_7);
  assign _zz_rotScorer_rotScores_3_15 = {3'd0, _zz_rotScorer_rotScores_3_16};
  assign _zz_rotScorer_rotScores_3_18 = (rotScorer_latchBeats_5 == rotScorer_patBeats_0);
  assign _zz_rotScorer_rotScores_3_17 = {3'd0, _zz_rotScorer_rotScores_3_18};
  assign _zz_rotScorer_rotScores_3_20 = (rotScorer_latchBeats_6 == rotScorer_patBeats_1);
  assign _zz_rotScorer_rotScores_3_19 = {3'd0, _zz_rotScorer_rotScores_3_20};
  assign _zz_rotScorer_rotScores_3_22 = (rotScorer_latchBeats_7 == rotScorer_patBeats_2);
  assign _zz_rotScorer_rotScores_3_21 = {3'd0, _zz_rotScorer_rotScores_3_22};
  assign _zz_rotScorer_rotScores_4 = (_zz_rotScorer_rotScores_4_1 + _zz_rotScorer_rotScores_4_19);
  assign _zz_rotScorer_rotScores_4_1 = (_zz_rotScorer_rotScores_4_2 + _zz_rotScorer_rotScores_4_17);
  assign _zz_rotScorer_rotScores_4_2 = (_zz_rotScorer_rotScores_4_3 + _zz_rotScorer_rotScores_4_15);
  assign _zz_rotScorer_rotScores_4_3 = (_zz_rotScorer_rotScores_4_4 + _zz_rotScorer_rotScores_4_13);
  assign _zz_rotScorer_rotScores_4_4 = (_zz_rotScorer_rotScores_4_5 + _zz_rotScorer_rotScores_4_11);
  assign _zz_rotScorer_rotScores_4_5 = (_zz_rotScorer_rotScores_4_6 + _zz_rotScorer_rotScores_4_9);
  assign _zz_rotScorer_rotScores_4_6 = (4'b0000 + _zz_rotScorer_rotScores_4_7);
  assign _zz_rotScorer_rotScores_4_8 = (rotScorer_latchBeats_0 == rotScorer_patBeats_4);
  assign _zz_rotScorer_rotScores_4_7 = {3'd0, _zz_rotScorer_rotScores_4_8};
  assign _zz_rotScorer_rotScores_4_10 = (rotScorer_latchBeats_1 == rotScorer_patBeats_5);
  assign _zz_rotScorer_rotScores_4_9 = {3'd0, _zz_rotScorer_rotScores_4_10};
  assign _zz_rotScorer_rotScores_4_12 = (rotScorer_latchBeats_2 == rotScorer_patBeats_6);
  assign _zz_rotScorer_rotScores_4_11 = {3'd0, _zz_rotScorer_rotScores_4_12};
  assign _zz_rotScorer_rotScores_4_14 = (rotScorer_latchBeats_3 == rotScorer_patBeats_7);
  assign _zz_rotScorer_rotScores_4_13 = {3'd0, _zz_rotScorer_rotScores_4_14};
  assign _zz_rotScorer_rotScores_4_16 = (rotScorer_latchBeats_4 == rotScorer_patBeats_0);
  assign _zz_rotScorer_rotScores_4_15 = {3'd0, _zz_rotScorer_rotScores_4_16};
  assign _zz_rotScorer_rotScores_4_18 = (rotScorer_latchBeats_5 == rotScorer_patBeats_1);
  assign _zz_rotScorer_rotScores_4_17 = {3'd0, _zz_rotScorer_rotScores_4_18};
  assign _zz_rotScorer_rotScores_4_20 = (rotScorer_latchBeats_6 == rotScorer_patBeats_2);
  assign _zz_rotScorer_rotScores_4_19 = {3'd0, _zz_rotScorer_rotScores_4_20};
  assign _zz_rotScorer_rotScores_4_22 = (rotScorer_latchBeats_7 == rotScorer_patBeats_3);
  assign _zz_rotScorer_rotScores_4_21 = {3'd0, _zz_rotScorer_rotScores_4_22};
  assign _zz_rotScorer_rotScores_5 = (_zz_rotScorer_rotScores_5_1 + _zz_rotScorer_rotScores_5_19);
  assign _zz_rotScorer_rotScores_5_1 = (_zz_rotScorer_rotScores_5_2 + _zz_rotScorer_rotScores_5_17);
  assign _zz_rotScorer_rotScores_5_2 = (_zz_rotScorer_rotScores_5_3 + _zz_rotScorer_rotScores_5_15);
  assign _zz_rotScorer_rotScores_5_3 = (_zz_rotScorer_rotScores_5_4 + _zz_rotScorer_rotScores_5_13);
  assign _zz_rotScorer_rotScores_5_4 = (_zz_rotScorer_rotScores_5_5 + _zz_rotScorer_rotScores_5_11);
  assign _zz_rotScorer_rotScores_5_5 = (_zz_rotScorer_rotScores_5_6 + _zz_rotScorer_rotScores_5_9);
  assign _zz_rotScorer_rotScores_5_6 = (4'b0000 + _zz_rotScorer_rotScores_5_7);
  assign _zz_rotScorer_rotScores_5_8 = (rotScorer_latchBeats_0 == rotScorer_patBeats_5);
  assign _zz_rotScorer_rotScores_5_7 = {3'd0, _zz_rotScorer_rotScores_5_8};
  assign _zz_rotScorer_rotScores_5_10 = (rotScorer_latchBeats_1 == rotScorer_patBeats_6);
  assign _zz_rotScorer_rotScores_5_9 = {3'd0, _zz_rotScorer_rotScores_5_10};
  assign _zz_rotScorer_rotScores_5_12 = (rotScorer_latchBeats_2 == rotScorer_patBeats_7);
  assign _zz_rotScorer_rotScores_5_11 = {3'd0, _zz_rotScorer_rotScores_5_12};
  assign _zz_rotScorer_rotScores_5_14 = (rotScorer_latchBeats_3 == rotScorer_patBeats_0);
  assign _zz_rotScorer_rotScores_5_13 = {3'd0, _zz_rotScorer_rotScores_5_14};
  assign _zz_rotScorer_rotScores_5_16 = (rotScorer_latchBeats_4 == rotScorer_patBeats_1);
  assign _zz_rotScorer_rotScores_5_15 = {3'd0, _zz_rotScorer_rotScores_5_16};
  assign _zz_rotScorer_rotScores_5_18 = (rotScorer_latchBeats_5 == rotScorer_patBeats_2);
  assign _zz_rotScorer_rotScores_5_17 = {3'd0, _zz_rotScorer_rotScores_5_18};
  assign _zz_rotScorer_rotScores_5_20 = (rotScorer_latchBeats_6 == rotScorer_patBeats_3);
  assign _zz_rotScorer_rotScores_5_19 = {3'd0, _zz_rotScorer_rotScores_5_20};
  assign _zz_rotScorer_rotScores_5_22 = (rotScorer_latchBeats_7 == rotScorer_patBeats_4);
  assign _zz_rotScorer_rotScores_5_21 = {3'd0, _zz_rotScorer_rotScores_5_22};
  assign _zz_rotScorer_rotScores_6 = (_zz_rotScorer_rotScores_6_1 + _zz_rotScorer_rotScores_6_19);
  assign _zz_rotScorer_rotScores_6_1 = (_zz_rotScorer_rotScores_6_2 + _zz_rotScorer_rotScores_6_17);
  assign _zz_rotScorer_rotScores_6_2 = (_zz_rotScorer_rotScores_6_3 + _zz_rotScorer_rotScores_6_15);
  assign _zz_rotScorer_rotScores_6_3 = (_zz_rotScorer_rotScores_6_4 + _zz_rotScorer_rotScores_6_13);
  assign _zz_rotScorer_rotScores_6_4 = (_zz_rotScorer_rotScores_6_5 + _zz_rotScorer_rotScores_6_11);
  assign _zz_rotScorer_rotScores_6_5 = (_zz_rotScorer_rotScores_6_6 + _zz_rotScorer_rotScores_6_9);
  assign _zz_rotScorer_rotScores_6_6 = (4'b0000 + _zz_rotScorer_rotScores_6_7);
  assign _zz_rotScorer_rotScores_6_8 = (rotScorer_latchBeats_0 == rotScorer_patBeats_6);
  assign _zz_rotScorer_rotScores_6_7 = {3'd0, _zz_rotScorer_rotScores_6_8};
  assign _zz_rotScorer_rotScores_6_10 = (rotScorer_latchBeats_1 == rotScorer_patBeats_7);
  assign _zz_rotScorer_rotScores_6_9 = {3'd0, _zz_rotScorer_rotScores_6_10};
  assign _zz_rotScorer_rotScores_6_12 = (rotScorer_latchBeats_2 == rotScorer_patBeats_0);
  assign _zz_rotScorer_rotScores_6_11 = {3'd0, _zz_rotScorer_rotScores_6_12};
  assign _zz_rotScorer_rotScores_6_14 = (rotScorer_latchBeats_3 == rotScorer_patBeats_1);
  assign _zz_rotScorer_rotScores_6_13 = {3'd0, _zz_rotScorer_rotScores_6_14};
  assign _zz_rotScorer_rotScores_6_16 = (rotScorer_latchBeats_4 == rotScorer_patBeats_2);
  assign _zz_rotScorer_rotScores_6_15 = {3'd0, _zz_rotScorer_rotScores_6_16};
  assign _zz_rotScorer_rotScores_6_18 = (rotScorer_latchBeats_5 == rotScorer_patBeats_3);
  assign _zz_rotScorer_rotScores_6_17 = {3'd0, _zz_rotScorer_rotScores_6_18};
  assign _zz_rotScorer_rotScores_6_20 = (rotScorer_latchBeats_6 == rotScorer_patBeats_4);
  assign _zz_rotScorer_rotScores_6_19 = {3'd0, _zz_rotScorer_rotScores_6_20};
  assign _zz_rotScorer_rotScores_6_22 = (rotScorer_latchBeats_7 == rotScorer_patBeats_5);
  assign _zz_rotScorer_rotScores_6_21 = {3'd0, _zz_rotScorer_rotScores_6_22};
  assign _zz_rotScorer_rotScores_7 = (_zz_rotScorer_rotScores_7_1 + _zz_rotScorer_rotScores_7_19);
  assign _zz_rotScorer_rotScores_7_1 = (_zz_rotScorer_rotScores_7_2 + _zz_rotScorer_rotScores_7_17);
  assign _zz_rotScorer_rotScores_7_2 = (_zz_rotScorer_rotScores_7_3 + _zz_rotScorer_rotScores_7_15);
  assign _zz_rotScorer_rotScores_7_3 = (_zz_rotScorer_rotScores_7_4 + _zz_rotScorer_rotScores_7_13);
  assign _zz_rotScorer_rotScores_7_4 = (_zz_rotScorer_rotScores_7_5 + _zz_rotScorer_rotScores_7_11);
  assign _zz_rotScorer_rotScores_7_5 = (_zz_rotScorer_rotScores_7_6 + _zz_rotScorer_rotScores_7_9);
  assign _zz_rotScorer_rotScores_7_6 = (4'b0000 + _zz_rotScorer_rotScores_7_7);
  assign _zz_rotScorer_rotScores_7_8 = (rotScorer_latchBeats_0 == rotScorer_patBeats_7);
  assign _zz_rotScorer_rotScores_7_7 = {3'd0, _zz_rotScorer_rotScores_7_8};
  assign _zz_rotScorer_rotScores_7_10 = (rotScorer_latchBeats_1 == rotScorer_patBeats_0);
  assign _zz_rotScorer_rotScores_7_9 = {3'd0, _zz_rotScorer_rotScores_7_10};
  assign _zz_rotScorer_rotScores_7_12 = (rotScorer_latchBeats_2 == rotScorer_patBeats_1);
  assign _zz_rotScorer_rotScores_7_11 = {3'd0, _zz_rotScorer_rotScores_7_12};
  assign _zz_rotScorer_rotScores_7_14 = (rotScorer_latchBeats_3 == rotScorer_patBeats_2);
  assign _zz_rotScorer_rotScores_7_13 = {3'd0, _zz_rotScorer_rotScores_7_14};
  assign _zz_rotScorer_rotScores_7_16 = (rotScorer_latchBeats_4 == rotScorer_patBeats_3);
  assign _zz_rotScorer_rotScores_7_15 = {3'd0, _zz_rotScorer_rotScores_7_16};
  assign _zz_rotScorer_rotScores_7_18 = (rotScorer_latchBeats_5 == rotScorer_patBeats_4);
  assign _zz_rotScorer_rotScores_7_17 = {3'd0, _zz_rotScorer_rotScores_7_18};
  assign _zz_rotScorer_rotScores_7_20 = (rotScorer_latchBeats_6 == rotScorer_patBeats_5);
  assign _zz_rotScorer_rotScores_7_19 = {3'd0, _zz_rotScorer_rotScores_7_20};
  assign _zz_rotScorer_rotScores_7_22 = (rotScorer_latchBeats_7 == rotScorer_patBeats_6);
  assign _zz_rotScorer_rotScores_7_21 = {3'd0, _zz_rotScorer_rotScores_7_22};
  assign _zz_rdCyc_1 = rclkpos;
  assign _zz_rdCyc = {5'd0, _zz_rdCyc_1};
  assign _zz_rotSplit = (bestRot != 3'b000);
  assign _zz_when_Ddr3ControllerCore_l406 = (rdCyc + 7'h07);
  assign _zz_when_Ddr3ControllerCore_l410 = (_zz_when_Ddr3ControllerCore_l410_1 + _zz_when_Ddr3ControllerCore_l410_3);
  assign _zz_when_Ddr3ControllerCore_l410_1 = (_zz_when_Ddr3ControllerCore_l410_2 + rotSplit);
  assign _zz_when_Ddr3ControllerCore_l410_2 = (rdCyc + 7'h07);
  assign _zz_when_Ddr3ControllerCore_l410_3 = {1'd0, rdExtraCnt};
  assign _zz_when_Ddr3ControllerCore_l410_4 = (_zz_when_Ddr3ControllerCore_l410_5 + _zz_when_Ddr3ControllerCore_l410_6);
  assign _zz_when_Ddr3ControllerCore_l410_5 = (7'h0a + rotSplit);
  assign _zz_when_Ddr3ControllerCore_l410_6 = {1'd0, rdExtraCnt};
  assign _zz_cycle_1 = (cycle + 7'h01);
  assign _zz_tick_counter = (tick_counter - 17'h00001);
  assign _zz_A_0_1 = MR2[12 : 0];
  assign _zz_A_0_2 = MR3[12 : 0];
  assign _zz_A_0_3 = MR1[12 : 0];
  assign _zz_A_0_4 = MR0[12 : 0];
  assign _zz_A_0_6 = 1'b1;
  assign _zz_A_0_5 = {13'd0, _zz_A_0_6};
  assign _zz_A_0_7 = _zz_A_0[12 : 0];
  assign _zz_A_0_8 = MR1[12 : 0];
  assign _zz_wstep = (wstep + 8'h01);
  assign _zz_wstep_2 = ($signed(_zz_wstep_3) + $signed(9'h0));
  assign _zz_wstep_1 = _zz_wstep_2[7 : 0];
  assign _zz_wstep_3 = _zz_wstep_4;
  assign _zz_wstep_5 = wstep;
  assign _zz_wstep_4 = {1'd0, _zz_wstep_5};
  assign _zz_A_0_9 = MR1[12 : 0];
  assign _zz_when_Ddr3ControllerCore_l554 = (wlVoteCnt + _zz_when_Ddr3ControllerCore_l554_1);
  assign _zz_when_Ddr3ControllerCore_l554_2 = when_Ddr3ControllerCore_l576;
  assign _zz_when_Ddr3ControllerCore_l554_1 = {2'd0, _zz_when_Ddr3ControllerCore_l554_2};
  assign _zz_A_0_10 = MR2_RTT_WR[12 : 0];
  assign _zz_A_0_11 = 1'b0;
  assign _zz_A_2_3 = 1'b1;
  assign _zz_A_2_2 = {13'd0, _zz_A_2_3};
  assign _zz_A_2_5 = 1'b1;
  assign _zz_A_2_4 = {13'd0, _zz_A_2_5};
  assign _zz_A_0_12 = 1'b0;
  assign _zz_rclkpos = (rclkpos + 2'b01);
  assign _zz_A_0_13 = 1'b0;
  assign _zz_rclksel = (rclksel + 3'b001);
  assign _zz_rclkpos_1 = (rclkpos + 2'b01);
  assign _zz_when_Ddr3ControllerCore_l1094 = (scMag + 7'h02);
  assign _zz_when_Ddr3ControllerCore_l1106 = (scMag + 7'h02);
  assign _zz_wstep_6 = (wstep - 8'h06);
  assign _zz_wstep_7 = (wBase + 8'h06);
  assign _zz_A_0_14 = 1'b0;
  assign _zz_A_0_15 = 1'b0;
  assign _zz_A_0_16 = 1'b0;
  assign _zz_A_0_17 = 1'b0;
  assign _zz_A_0_18 = 16'h0400;
  assign _zz_A_0_19 = 1'b0;
  assign _zz_A_0_20 = 16'h0400;
  assign _zz_A_0_21 = 1'b0;
  assign _zz__zz_A_2_1 = {reqReg_addr[6 : 0],3'b000};
  assign _zz__zz_A_2 = {6'd0, _zz__zz_A_2_1};
  assign _zz_rdRspLeft = (rdRspLeft + _zz_rdRspLeft_1);
  assign _zz_rdRspLeft_2 = when_Ddr3ControllerCore_l1450;
  assign _zz_rdRspLeft_1 = {5'd0, _zz_rdRspLeft_2};
  assign _zz_rdRspLeft_4 = _zz_data_ready;
  assign _zz_rdRspLeft_3 = {5'd0, _zz_rdRspLeft_4};
  assign _zz_when_Ddr3ControllerCore_l1468_1 = (_zz_when_Ddr3ControllerCore_l1468 + 7'h02);
  assign _zz_A_2_6 = (_zz_A_2_7 | 16'h1400);
  assign _zz_A_2_7 = {6'd0, _zz_A_2_1};
  assign _zz_A_2_8 = (_zz_A_2_9 | 16'h1000);
  assign _zz_A_2_9 = {6'd0, _zz_A_2_1};
  assign _zz__zz_rdataVec_0 = (4'b0000 - _zz__zz_rdataVec_0_1);
  assign _zz__zz_rdataVec_0_1 = {1'd0, bestRot};
  assign _zz__zz_rdataVec_1 = (4'b0001 - _zz__zz_rdataVec_1_1);
  assign _zz__zz_rdataVec_1_1 = {1'd0, bestRot};
  assign _zz__zz_rdataVec_2 = (4'b0010 - _zz__zz_rdataVec_2_1);
  assign _zz__zz_rdataVec_2_1 = {1'd0, bestRot};
  assign _zz__zz_rdataVec_3 = (4'b0011 - _zz__zz_rdataVec_3_1);
  assign _zz__zz_rdataVec_3_1 = {1'd0, bestRot};
  assign _zz__zz_rdataVec_4 = (4'b0100 - _zz__zz_rdataVec_4_1);
  assign _zz__zz_rdataVec_4_1 = {1'd0, bestRot};
  assign _zz__zz_rdataVec_5 = (4'b0101 - _zz__zz_rdataVec_5_1);
  assign _zz__zz_rdataVec_5_1 = {1'd0, bestRot};
  assign _zz__zz_rdataVec_6 = (4'b0110 - _zz__zz_rdataVec_6_1);
  assign _zz__zz_rdataVec_6_1 = {1'd0, bestRot};
  assign _zz__zz_rdataVec_7 = (4'b0111 - _zz__zz_rdataVec_7_1);
  assign _zz__zz_rdataVec_7_1 = {1'd0, bestRot};
  always @(*) begin
    case(_zz_rdataVec_0)
      3'b000 : begin
        _zz_rdataVec_0_1 = dqPrevVec_0;
        _zz_rdataVec_0_2 = io_phy_dq_in_0;
      end
      3'b001 : begin
        _zz_rdataVec_0_1 = dqPrevVec_1;
        _zz_rdataVec_0_2 = io_phy_dq_in_1;
      end
      3'b010 : begin
        _zz_rdataVec_0_1 = dqPrevVec_2;
        _zz_rdataVec_0_2 = io_phy_dq_in_2;
      end
      3'b011 : begin
        _zz_rdataVec_0_1 = dqPrevVec_3;
        _zz_rdataVec_0_2 = io_phy_dq_in_3;
      end
      3'b100 : begin
        _zz_rdataVec_0_1 = dqPrevVec_4;
        _zz_rdataVec_0_2 = io_phy_dq_in_4;
      end
      3'b101 : begin
        _zz_rdataVec_0_1 = dqPrevVec_5;
        _zz_rdataVec_0_2 = io_phy_dq_in_5;
      end
      3'b110 : begin
        _zz_rdataVec_0_1 = dqPrevVec_6;
        _zz_rdataVec_0_2 = io_phy_dq_in_6;
      end
      default : begin
        _zz_rdataVec_0_1 = dqPrevVec_7;
        _zz_rdataVec_0_2 = io_phy_dq_in_7;
      end
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_1)
      3'b000 : begin
        _zz_rdataVec_1_1 = dqPrevVec_0;
        _zz_rdataVec_1_2 = io_phy_dq_in_0;
      end
      3'b001 : begin
        _zz_rdataVec_1_1 = dqPrevVec_1;
        _zz_rdataVec_1_2 = io_phy_dq_in_1;
      end
      3'b010 : begin
        _zz_rdataVec_1_1 = dqPrevVec_2;
        _zz_rdataVec_1_2 = io_phy_dq_in_2;
      end
      3'b011 : begin
        _zz_rdataVec_1_1 = dqPrevVec_3;
        _zz_rdataVec_1_2 = io_phy_dq_in_3;
      end
      3'b100 : begin
        _zz_rdataVec_1_1 = dqPrevVec_4;
        _zz_rdataVec_1_2 = io_phy_dq_in_4;
      end
      3'b101 : begin
        _zz_rdataVec_1_1 = dqPrevVec_5;
        _zz_rdataVec_1_2 = io_phy_dq_in_5;
      end
      3'b110 : begin
        _zz_rdataVec_1_1 = dqPrevVec_6;
        _zz_rdataVec_1_2 = io_phy_dq_in_6;
      end
      default : begin
        _zz_rdataVec_1_1 = dqPrevVec_7;
        _zz_rdataVec_1_2 = io_phy_dq_in_7;
      end
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_2)
      3'b000 : begin
        _zz_rdataVec_2_1 = dqPrevVec_0;
        _zz_rdataVec_2_2 = io_phy_dq_in_0;
      end
      3'b001 : begin
        _zz_rdataVec_2_1 = dqPrevVec_1;
        _zz_rdataVec_2_2 = io_phy_dq_in_1;
      end
      3'b010 : begin
        _zz_rdataVec_2_1 = dqPrevVec_2;
        _zz_rdataVec_2_2 = io_phy_dq_in_2;
      end
      3'b011 : begin
        _zz_rdataVec_2_1 = dqPrevVec_3;
        _zz_rdataVec_2_2 = io_phy_dq_in_3;
      end
      3'b100 : begin
        _zz_rdataVec_2_1 = dqPrevVec_4;
        _zz_rdataVec_2_2 = io_phy_dq_in_4;
      end
      3'b101 : begin
        _zz_rdataVec_2_1 = dqPrevVec_5;
        _zz_rdataVec_2_2 = io_phy_dq_in_5;
      end
      3'b110 : begin
        _zz_rdataVec_2_1 = dqPrevVec_6;
        _zz_rdataVec_2_2 = io_phy_dq_in_6;
      end
      default : begin
        _zz_rdataVec_2_1 = dqPrevVec_7;
        _zz_rdataVec_2_2 = io_phy_dq_in_7;
      end
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_3)
      3'b000 : begin
        _zz_rdataVec_3_1 = dqPrevVec_0;
        _zz_rdataVec_3_2 = io_phy_dq_in_0;
      end
      3'b001 : begin
        _zz_rdataVec_3_1 = dqPrevVec_1;
        _zz_rdataVec_3_2 = io_phy_dq_in_1;
      end
      3'b010 : begin
        _zz_rdataVec_3_1 = dqPrevVec_2;
        _zz_rdataVec_3_2 = io_phy_dq_in_2;
      end
      3'b011 : begin
        _zz_rdataVec_3_1 = dqPrevVec_3;
        _zz_rdataVec_3_2 = io_phy_dq_in_3;
      end
      3'b100 : begin
        _zz_rdataVec_3_1 = dqPrevVec_4;
        _zz_rdataVec_3_2 = io_phy_dq_in_4;
      end
      3'b101 : begin
        _zz_rdataVec_3_1 = dqPrevVec_5;
        _zz_rdataVec_3_2 = io_phy_dq_in_5;
      end
      3'b110 : begin
        _zz_rdataVec_3_1 = dqPrevVec_6;
        _zz_rdataVec_3_2 = io_phy_dq_in_6;
      end
      default : begin
        _zz_rdataVec_3_1 = dqPrevVec_7;
        _zz_rdataVec_3_2 = io_phy_dq_in_7;
      end
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_4)
      3'b000 : begin
        _zz_rdataVec_4_1 = dqPrevVec_0;
        _zz_rdataVec_4_2 = io_phy_dq_in_0;
      end
      3'b001 : begin
        _zz_rdataVec_4_1 = dqPrevVec_1;
        _zz_rdataVec_4_2 = io_phy_dq_in_1;
      end
      3'b010 : begin
        _zz_rdataVec_4_1 = dqPrevVec_2;
        _zz_rdataVec_4_2 = io_phy_dq_in_2;
      end
      3'b011 : begin
        _zz_rdataVec_4_1 = dqPrevVec_3;
        _zz_rdataVec_4_2 = io_phy_dq_in_3;
      end
      3'b100 : begin
        _zz_rdataVec_4_1 = dqPrevVec_4;
        _zz_rdataVec_4_2 = io_phy_dq_in_4;
      end
      3'b101 : begin
        _zz_rdataVec_4_1 = dqPrevVec_5;
        _zz_rdataVec_4_2 = io_phy_dq_in_5;
      end
      3'b110 : begin
        _zz_rdataVec_4_1 = dqPrevVec_6;
        _zz_rdataVec_4_2 = io_phy_dq_in_6;
      end
      default : begin
        _zz_rdataVec_4_1 = dqPrevVec_7;
        _zz_rdataVec_4_2 = io_phy_dq_in_7;
      end
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_5)
      3'b000 : begin
        _zz_rdataVec_5_1 = dqPrevVec_0;
        _zz_rdataVec_5_2 = io_phy_dq_in_0;
      end
      3'b001 : begin
        _zz_rdataVec_5_1 = dqPrevVec_1;
        _zz_rdataVec_5_2 = io_phy_dq_in_1;
      end
      3'b010 : begin
        _zz_rdataVec_5_1 = dqPrevVec_2;
        _zz_rdataVec_5_2 = io_phy_dq_in_2;
      end
      3'b011 : begin
        _zz_rdataVec_5_1 = dqPrevVec_3;
        _zz_rdataVec_5_2 = io_phy_dq_in_3;
      end
      3'b100 : begin
        _zz_rdataVec_5_1 = dqPrevVec_4;
        _zz_rdataVec_5_2 = io_phy_dq_in_4;
      end
      3'b101 : begin
        _zz_rdataVec_5_1 = dqPrevVec_5;
        _zz_rdataVec_5_2 = io_phy_dq_in_5;
      end
      3'b110 : begin
        _zz_rdataVec_5_1 = dqPrevVec_6;
        _zz_rdataVec_5_2 = io_phy_dq_in_6;
      end
      default : begin
        _zz_rdataVec_5_1 = dqPrevVec_7;
        _zz_rdataVec_5_2 = io_phy_dq_in_7;
      end
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_6)
      3'b000 : begin
        _zz_rdataVec_6_1 = dqPrevVec_0;
        _zz_rdataVec_6_2 = io_phy_dq_in_0;
      end
      3'b001 : begin
        _zz_rdataVec_6_1 = dqPrevVec_1;
        _zz_rdataVec_6_2 = io_phy_dq_in_1;
      end
      3'b010 : begin
        _zz_rdataVec_6_1 = dqPrevVec_2;
        _zz_rdataVec_6_2 = io_phy_dq_in_2;
      end
      3'b011 : begin
        _zz_rdataVec_6_1 = dqPrevVec_3;
        _zz_rdataVec_6_2 = io_phy_dq_in_3;
      end
      3'b100 : begin
        _zz_rdataVec_6_1 = dqPrevVec_4;
        _zz_rdataVec_6_2 = io_phy_dq_in_4;
      end
      3'b101 : begin
        _zz_rdataVec_6_1 = dqPrevVec_5;
        _zz_rdataVec_6_2 = io_phy_dq_in_5;
      end
      3'b110 : begin
        _zz_rdataVec_6_1 = dqPrevVec_6;
        _zz_rdataVec_6_2 = io_phy_dq_in_6;
      end
      default : begin
        _zz_rdataVec_6_1 = dqPrevVec_7;
        _zz_rdataVec_6_2 = io_phy_dq_in_7;
      end
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_7)
      3'b000 : begin
        _zz_rdataVec_7_1 = dqPrevVec_0;
        _zz_rdataVec_7_2 = io_phy_dq_in_0;
      end
      3'b001 : begin
        _zz_rdataVec_7_1 = dqPrevVec_1;
        _zz_rdataVec_7_2 = io_phy_dq_in_1;
      end
      3'b010 : begin
        _zz_rdataVec_7_1 = dqPrevVec_2;
        _zz_rdataVec_7_2 = io_phy_dq_in_2;
      end
      3'b011 : begin
        _zz_rdataVec_7_1 = dqPrevVec_3;
        _zz_rdataVec_7_2 = io_phy_dq_in_3;
      end
      3'b100 : begin
        _zz_rdataVec_7_1 = dqPrevVec_4;
        _zz_rdataVec_7_2 = io_phy_dq_in_4;
      end
      3'b101 : begin
        _zz_rdataVec_7_1 = dqPrevVec_5;
        _zz_rdataVec_7_2 = io_phy_dq_in_5;
      end
      3'b110 : begin
        _zz_rdataVec_7_1 = dqPrevVec_6;
        _zz_rdataVec_7_2 = io_phy_dq_in_6;
      end
      default : begin
        _zz_rdataVec_7_1 = dqPrevVec_7;
        _zz_rdataVec_7_2 = io_phy_dq_in_7;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(state)
      Ddr3State_RST_WAIT : state_string = "RST_WAIT      ";
      Ddr3State_CKE_WAIT : state_string = "CKE_WAIT      ";
      Ddr3State_CONFIG_1 : state_string = "CONFIG_1      ";
      Ddr3State_ZQCL : state_string = "ZQCL          ";
      Ddr3State_WRITE_LEVELING : state_string = "WRITE_LEVELING";
      Ddr3State_READ_CALIB : state_string = "READ_CALIB    ";
      Ddr3State_IDLE : state_string = "IDLE          ";
      Ddr3State_READ : state_string = "READ          ";
      Ddr3State_WRITE : state_string = "WRITE         ";
      Ddr3State_PRECHARGE : state_string = "PRECHARGE     ";
      Ddr3State_REFRESH : state_string = "REFRESH       ";
      default : state_string = "??????????????";
    endcase
  end
  `endif

  assign CMD_SetModeReg = 3'b000;
  assign CMD_AutoRefresh = 3'b001;
  assign CMD_PreCharge = 3'b010;
  assign CMD_BankActivate = 3'b011;
  assign CMD_Write = 3'b100;
  assign CMD_Read = 3'b101;
  assign CMD_ZQCL = 3'b110;
  assign CMD_NOP = 3'b111;
  assign M_BL = 2'b01;
  assign M_CAS = 4'b0100;
  assign M_CWL = 3'b000;
  assign M_WR = 3'b010;
  assign M_DLLReset = 1'b1;
  assign M_RTT_NOM = 3'b000;
  assign M_RTT_WR = 2'b01;
  assign M_DRIVE = 2'b00;
  assign M_AL = 2'b00;
  assign MR0 = {{{{{{{{3'b000,1'b0},M_WR},M_DLLReset},1'b0},M_CAS[3 : 1]},1'b0},M_CAS[0]},M_BL};
  assign MR1 = {{{{{{{{{3'b001,3'b000},M_RTT_NOM[2]},2'b00},M_RTT_NOM[1]},M_DRIVE[1]},M_AL},M_RTT_NOM[0]},M_DRIVE[0]},1'b0};
  assign MR2 = {{{3'b010,7'h0},M_CWL},3'b000};
  assign MR2_RTT_WR = {{{{{3'b010,2'b00},M_RTT_WR},3'b000},M_CWL},3'b000};
  assign MR3 = {3'b011,13'h0};
  assign trainPat = 128'ha707a606a505a404a303a202a101a000;
  assign poisonPat = (~ trainPat);
  assign rotScorer_latchBeats_0 = rotScorer_trainLatch[15 : 0];
  assign rotScorer_patBeats_0 = trainPat[15 : 0];
  assign rotScorer_latchBeats_1 = rotScorer_trainLatch[31 : 16];
  assign rotScorer_patBeats_1 = trainPat[31 : 16];
  assign rotScorer_latchBeats_2 = rotScorer_trainLatch[47 : 32];
  assign rotScorer_patBeats_2 = trainPat[47 : 32];
  assign rotScorer_latchBeats_3 = rotScorer_trainLatch[63 : 48];
  assign rotScorer_patBeats_3 = trainPat[63 : 48];
  assign rotScorer_latchBeats_4 = rotScorer_trainLatch[79 : 64];
  assign rotScorer_patBeats_4 = trainPat[79 : 64];
  assign rotScorer_latchBeats_5 = rotScorer_trainLatch[95 : 80];
  assign rotScorer_patBeats_5 = trainPat[95 : 80];
  assign rotScorer_latchBeats_6 = rotScorer_trainLatch[111 : 96];
  assign rotScorer_patBeats_6 = trainPat[111 : 96];
  assign rotScorer_latchBeats_7 = rotScorer_trainLatch[127 : 112];
  assign rotScorer_patBeats_7 = trainPat[127 : 112];
  assign rotScorer_rotScores_0 = (_zz_rotScorer_rotScores_0 + _zz_rotScorer_rotScores_0_21);
  assign rotScorer_rotScores_1 = (_zz_rotScorer_rotScores_1 + _zz_rotScorer_rotScores_1_21);
  assign rotScorer_rotScores_2 = (_zz_rotScorer_rotScores_2 + _zz_rotScorer_rotScores_2_21);
  assign rotScorer_rotScores_3 = (_zz_rotScorer_rotScores_3 + _zz_rotScorer_rotScores_3_21);
  assign rotScorer_rotScores_4 = (_zz_rotScorer_rotScores_4 + _zz_rotScorer_rotScores_4_21);
  assign rotScorer_rotScores_5 = (_zz_rotScorer_rotScores_5 + _zz_rotScorer_rotScores_5_21);
  assign rotScorer_rotScores_6 = (_zz_rotScorer_rotScores_6 + _zz_rotScorer_rotScores_6_21);
  assign rotScorer_rotScores_7 = (_zz_rotScorer_rotScores_7 + _zz_rotScorer_rotScores_7_21);
  assign _zz_rotScorer_treeS1_0 = (rotScorer_rotScoresReg_0 < rotScorer_rotScoresReg_1);
  assign rotScorer_treeS1_0 = (_zz_rotScorer_treeS1_0 ? rotScorer_rotScoresReg_1 : rotScorer_rotScoresReg_0);
  assign rotScorer_treeI1_0 = (_zz_rotScorer_treeS1_0 ? 3'b001 : 3'b000);
  assign _zz_rotScorer_treeS1_1 = (rotScorer_rotScoresReg_2 < rotScorer_rotScoresReg_3);
  assign rotScorer_treeS1_1 = (_zz_rotScorer_treeS1_1 ? rotScorer_rotScoresReg_3 : rotScorer_rotScoresReg_2);
  assign rotScorer_treeI1_1 = (_zz_rotScorer_treeS1_1 ? 3'b011 : 3'b010);
  assign _zz_rotScorer_treeS1_2 = (rotScorer_rotScoresReg_4 < rotScorer_rotScoresReg_5);
  assign rotScorer_treeS1_2 = (_zz_rotScorer_treeS1_2 ? rotScorer_rotScoresReg_5 : rotScorer_rotScoresReg_4);
  assign rotScorer_treeI1_2 = (_zz_rotScorer_treeS1_2 ? 3'b101 : 3'b100);
  assign _zz_rotScorer_treeS1_3 = (rotScorer_rotScoresReg_6 < rotScorer_rotScoresReg_7);
  assign rotScorer_treeS1_3 = (_zz_rotScorer_treeS1_3 ? rotScorer_rotScoresReg_7 : rotScorer_rotScoresReg_6);
  assign rotScorer_treeI1_3 = (_zz_rotScorer_treeS1_3 ? 3'b111 : 3'b110);
  assign _zz_rotScorer_treeS2_0 = (rotScorer_treeS1_0 < rotScorer_treeS1_1);
  assign rotScorer_treeS2_0 = (_zz_rotScorer_treeS2_0 ? rotScorer_treeS1_1 : rotScorer_treeS1_0);
  assign rotScorer_treeI2_0 = (_zz_rotScorer_treeS2_0 ? rotScorer_treeI1_1 : rotScorer_treeI1_0);
  assign _zz_rotScorer_treeS2_1 = (rotScorer_treeS1_2 < rotScorer_treeS1_3);
  assign rotScorer_treeS2_1 = (_zz_rotScorer_treeS2_1 ? rotScorer_treeS1_3 : rotScorer_treeS1_2);
  assign rotScorer_treeI2_1 = (_zz_rotScorer_treeS2_1 ? rotScorer_treeI1_3 : rotScorer_treeI1_2);
  assign rotScorer_betterTop = (rotScorer_treeS2_0 < rotScorer_treeS2_1);
  assign rotScorer_topScore = (rotScorer_betterTop ? rotScorer_treeS2_1 : rotScorer_treeS2_0);
  assign rotScorer_topIdx = (rotScorer_betterTop ? rotScorer_treeI2_1 : rotScorer_treeI2_0);
  assign winEndRaw = (sweepMag0 + sweepMagN);
  assign winEnd = (((sweepMagN == 7'h0) || (7'h40 < winEndRaw)) ? 7'h40 : winEndRaw[6 : 0]);
  assign winDoneNow = (((sweepMagN != 7'h0) && (! s2Side)) && (s2Mag == winEnd));
  assign when_Ddr3ControllerCore_l280 = ((((state == Ddr3State_IDLE) || (state == Ddr3State_READ)) || (state == Ddr3State_WRITE)) || (state == Ddr3State_PRECHARGE));
  assign when_Ddr3ControllerCore_l281 = (refresh_timer == 11'h250);
  assign when_Ddr3ControllerCore_l364 = io_phy_rburst[0];
  assign when_Ddr3ControllerCore_l365 = io_phy_rburst[1];
  assign rdCyc = (_zz_rdCyc + 7'h01);
  assign rotSplit = {6'd0, _zz_rotSplit};
  assign when_Ddr3ControllerCore_l406 = ((state == Ddr3State_READ_CALIB) && (((rdCyc <= cycle) && (cycle <= _zz_when_Ddr3ControllerCore_l406)) && (cycle <= 7'h0a)));
  assign when_Ddr3ControllerCore_l410 = ((state == Ddr3State_READ) && (((rdCyc <= cycle) && (cycle <= _zz_when_Ddr3ControllerCore_l410)) && (cycle <= _zz_when_Ddr3ControllerCore_l410_4)));
  assign inRow = io_req_payload_addr[20 : 7];
  assign inBank = io_req_payload_addr[23 : 21];
  assign inSameRow = ((inBank == openBank) && (inRow == openRow));
  assign canAcceptWrStream = ((((((((state == Ddr3State_WRITE) && (! trainDone)) && wrStreamOpen) && (! refresh_due)) && (wrExtraCnt < 6'h1f)) && (7'h01 <= cycle)) && io_req_payload_write) && inSameRow);
  assign canAcceptRdStream = (((((((state == Ddr3State_READ) && rdStreamOpen) && (! refresh_due)) && (rdExtraCnt < 6'h1f)) && (7'h02 <= cycle)) && (! io_req_payload_write)) && inSameRow);
  assign acceptReq = (((((state == Ddr3State_IDLE) && (! busy)) && (! refresh_due)) || canAcceptWrStream) || canAcceptRdStream);
  assign io_req_ready = acceptReq;
  assign when_Ddr3ControllerCore_l449 = (wserRstCnt != 3'b000);
  assign when_Ddr3ControllerCore_l454 = (! (wserRstCnt != 3'b000));
  assign when_Ddr3ControllerCore_l469 = (tick_counter == 17'h0000f);
  assign _zz_A_0 = (MR1 | 16'h0084);
  assign when_Ddr3ControllerCore_l576 = (io_phy_dq_raw[0] && io_phy_dq_raw[8]);
  assign when_Ddr3ControllerCore_l541 = (wlVoteN == 3'b011);
  assign when_Ddr3ControllerCore_l550 = (wlevel_tries == 9'h1ff);
  assign when_Ddr3ControllerCore_l565 = ((wlevel_cnt == 4'b0001) && (8'h08 <= wstep));
  assign when_Ddr3ControllerCore_l554 = (! (3'b010 <= _zz_when_Ddr3ControllerCore_l554));
  assign when_Ddr3ControllerCore_l712 = ((((! aligning) && (anchorLeft == 2'b00)) && (settleLeft == 2'b00)) && (pinLeft == 2'b00));
  assign when_Ddr3ControllerCore_l717 = ((((! aligning) && (anchorLeft == 2'b00)) && (settleLeft == 2'b00)) && (pinLeft == 2'b00));
  assign when_Ddr3ControllerCore_l737 = (scanOn && ((aligning || (anchorLeft != 2'b00)) || (settleLeft != 2'b00)));
  assign when_Ddr3ControllerCore_l739 = (anchorLeft != 2'b00);
  assign when_Ddr3ControllerCore_l751 = (navigateLeft != 8'h0);
  assign when_Ddr3ControllerCore_l775 = (((aligning || (anchorLeft != 2'b00)) || (settleLeft != 2'b00)) || (pinLeft != 2'b00));
  assign when_Ddr3ControllerCore_l776 = (anchorLeft != 2'b00);
  assign when_Ddr3ControllerCore_l791 = (navigateLeft != 8'h0);
  assign when_Ddr3ControllerCore_l816 = (pinLeft != 2'b00);
  assign when_Ddr3ControllerCore_l834 = ((settleLeft == 2'b01) && applyArmed);
  assign when_Ddr3ControllerCore_l859 = (settleLeft == 2'b00);
  assign when_Ddr3ControllerCore_l864 = (bestCntDll < rotScorer_sweepScore);
  assign when_Ddr3ControllerCore_l874 = (bestCntDll == 4'b1000);
  assign when_Ddr3ControllerCore_l899 = ((s2Side && (s2Mag == 7'h40)) && (rclkpos == 2'b11));
  assign when_Ddr3ControllerCore_l935 = (rclkpos == 2'b11);
  assign when_Ddr3ControllerCore_l941 = (((! s2Side) && (s2Mag == 7'h40)) && (! winDoneNow));
  assign when_Ddr3ControllerCore_l963 = ((s0Mag != 7'h40) && (! winDoneNow));
  assign when_Ddr3ControllerCore_l982 = (! training);
  assign when_Ddr3ControllerCore_l987 = (! winDoneNow);
  assign when_Ddr3ControllerCore_l1012 = (bestCnt < rotScorer_sweepScore);
  assign when_Ddr3ControllerCore_l1019 = (rclksel == 3'b111);
  assign when_Ddr3ControllerCore_l1023 = (rcalib_tries == 10'h028);
  assign when_Ddr3ControllerCore_l1030 = ((! training) && (! dllSweepDone));
  assign when_Ddr3ControllerCore_l1038 = ((! scanOn) && (! shiftCalDone));
  assign when_Ddr3ControllerCore_l1040 = ((bestCnt == 4'b1000) && ((tryMode == 2'b00) || (! 1'b0)));
  assign when_Ddr3ControllerCore_l1046 = ((tryMode == 2'b00) || (best0 < bestCnt));
  assign when_Ddr3ControllerCore_l1053 = (tryMode < 2'b11);
  assign _zz_wrMode = (tryMode + 2'b01);
  assign when_Ddr3ControllerCore_l1061 = (bestCnt <= best0);
  assign when_Ddr3ControllerCore_l1078 = (bestSurveyCnt < bestCnt);
  assign when_Ddr3ControllerCore_l1085 = (bestCnt == 4'b1000);
  assign when_Ddr3ControllerCore_l1094 = ((! scSide) && (_zz_when_Ddr3ControllerCore_l1094 <= 7'h40));
  assign _zz_s0Mag = (scMag + 7'h02);
  assign when_Ddr3ControllerCore_l1106 = (_zz_when_Ddr3ControllerCore_l1106 <= 7'h40);
  assign _zz_s0Mag_1 = (scMag + 7'h02);
  assign when_Ddr3ControllerCore_l1099 = (! scSide);
  assign when_Ddr3ControllerCore_l1135 = (sweepMagN != 7'h0);
  assign when_Ddr3ControllerCore_l1172 = (bestCnt == 4'b1000);
  assign when_Ddr3ControllerCore_l1217 = (! training);
  assign when_Ddr3ControllerCore_l1219 = ((bestCnt < 4'b1000) && (wTry < 2'b10));
  assign when_Ddr3ControllerCore_l1220 = ((wTry == 2'b00) || (bestWCnt < bestCnt));
  assign when_Ddr3ControllerCore_l1228 = (wTry == 2'b00);
  assign when_Ddr3ControllerCore_l1249 = ((wTry == 2'b10) && (bestCnt < bestWCnt));
  assign _zz_openRow = io_req_payload_addr[20 : 7];
  assign _zz_openBank = io_req_payload_addr[23 : 21];
  assign _zz_cycle = ((rowOpen && (_zz_openBank == openBank)) && (_zz_openRow == openRow));
  assign when_Ddr3ControllerCore_l1353 = (rowOpen && (! _zz_cycle));
  assign when_Ddr3ControllerCore_l1362 = (! rowOpen);
  assign when_Ddr3ControllerCore_l1394 = (cycle == 7'h02);
  assign _zz_openRow_1 = reqReg_addr[20 : 7];
  assign _zz_openBank_1 = reqReg_addr[23 : 21];
  assign _zz_BA_2 = reqReg_addr[23 : 21];
  assign _zz_A_2 = (_zz__zz_A_2 | 16'h1000);
  assign when_Ddr3ControllerCore_l1440 = (cycle == 7'h01);
  assign when_Ddr3ControllerCore_l1444 = ((cycle == 7'h02) || rdHavePending);
  assign when_Ddr3ControllerCore_l1450 = (canAcceptRdStream && io_req_valid);
  assign when_Ddr3ControllerCore_l1449 = (7'h02 <= cycle);
  assign _zz_when_Ddr3ControllerCore_l1468 = (7'h09 + rotSplit);
  assign _zz_data_ready = ((_zz_when_Ddr3ControllerCore_l1468 <= cycle) && (rdRspLeft != 6'h0));
  assign when_Ddr3ControllerCore_l1468 = (((((! rdStreamOpen) && (! rdHavePending)) && (rdRspLeft == 6'h0)) && (! data_ready)) && (_zz_when_Ddr3ControllerCore_l1468_1 <= cycle));
  assign _zz_A_2_1 = {reqReg_addr[6 : 0],3'b000};
  assign _zz_BA_2_1 = reqReg_addr[23 : 21];
  assign when_Ddr3ControllerCore_l1483 = (cycle == 7'h01);
  assign when_Ddr3ControllerCore_l1489 = (cycle == 7'h02);
  assign when_Ddr3ControllerCore_l1524 = (cycle == 7'h03);
  assign when_Ddr3ControllerCore_l1610 = (cycle == 7'h04);
  assign when_Ddr3ControllerCore_l1642 = (cycle == ((2'b10 <= wrMode) ? 7'h08 : 7'h07));
  assign when_Ddr3ControllerCore_l1660 = ((cycle == 7'h01) || wrHavePending);
  assign when_Ddr3ControllerCore_l1672 = (canAcceptWrStream && io_req_valid);
  assign when_Ddr3ControllerCore_l1683 = (st1Valid && (! st2Valid));
  assign when_Ddr3ControllerCore_l1713 = (st1Valid && (! st2Valid));
  assign when_Ddr3ControllerCore_l1749 = (st1Valid && (! st2Valid));
  assign when_Ddr3ControllerCore_l1752 = (st2Valid && (! st3Valid));
  assign when_Ddr3ControllerCore_l1762 = (st3Valid && st2Valid);
  assign when_Ddr3ControllerCore_l1783 = (st2Valid && (! st3Valid));
  assign when_Ddr3ControllerCore_l1793 = (st3Valid && st2Valid);
  assign when_Ddr3ControllerCore_l1821 = (wrCooldown != 4'b0000);
  assign when_Ddr3ControllerCore_l1825 = (((((! when_Ddr3ControllerCore_l1660) && (! st1Valid)) && (! st2Valid)) && (! st3Valid)) && (wrCooldown == 4'b0000));
  assign when_Ddr3ControllerCore_l1834 = (cycle == 7'h10);
  assign needRotSplit = (bestRot != 3'b000);
  assign _zz_rdataVec_0 = _zz__zz_rdataVec_0[2 : 0];
  assign rdataVec_0 = ((needRotSplit && (3'b000 < bestRot)) ? _zz_rdataVec_0_1 : _zz_rdataVec_0_2);
  assign _zz_rdataVec_1 = _zz__zz_rdataVec_1[2 : 0];
  assign rdataVec_1 = ((needRotSplit && (3'b001 < bestRot)) ? _zz_rdataVec_1_1 : _zz_rdataVec_1_2);
  assign _zz_rdataVec_2 = _zz__zz_rdataVec_2[2 : 0];
  assign rdataVec_2 = ((needRotSplit && (3'b010 < bestRot)) ? _zz_rdataVec_2_1 : _zz_rdataVec_2_2);
  assign _zz_rdataVec_3 = _zz__zz_rdataVec_3[2 : 0];
  assign rdataVec_3 = ((needRotSplit && (3'b011 < bestRot)) ? _zz_rdataVec_3_1 : _zz_rdataVec_3_2);
  assign _zz_rdataVec_4 = _zz__zz_rdataVec_4[2 : 0];
  assign rdataVec_4 = ((needRotSplit && (3'b100 < bestRot)) ? _zz_rdataVec_4_1 : _zz_rdataVec_4_2);
  assign _zz_rdataVec_5 = _zz__zz_rdataVec_5[2 : 0];
  assign rdataVec_5 = ((needRotSplit && (3'b101 < bestRot)) ? _zz_rdataVec_5_1 : _zz_rdataVec_5_2);
  assign _zz_rdataVec_6 = _zz__zz_rdataVec_6[2 : 0];
  assign rdataVec_6 = ((needRotSplit && (3'b110 < bestRot)) ? _zz_rdataVec_6_1 : _zz_rdataVec_6_2);
  assign _zz_rdataVec_7 = _zz__zz_rdataVec_7[2 : 0];
  assign rdataVec_7 = ((needRotSplit && (3'b111 < bestRot)) ? _zz_rdataVec_7_1 : _zz_rdataVec_7_2);
  assign io_rsp_valid = data_ready;
  assign io_rsp_payload_rdata = {{{{{{{rdataVec_7,rdataVec_6},rdataVec_5},rdataVec_4},rdataVec_3},rdataVec_2},rdataVec_1},rdataVec_0};
  assign io_phy_dqs_hold = dqs_hold;
  assign io_phy_wstep = wstep;
  assign io_phy_rloadn = 1'b0;
  assign io_phy_rmove = rmove;
  assign io_phy_rdir = rdir;
  assign io_phy_rclkpos = rclkpos;
  assign io_phy_rclksel = rclksel;
  assign io_phy_dqs_read = dqs_read;
  assign io_phy_dq_out_0 = dq_out_0;
  assign io_phy_dq_out_1 = dq_out_1;
  assign io_phy_dq_out_2 = dq_out_2;
  assign io_phy_dq_out_3 = dq_out_3;
  assign io_phy_dq_out_4 = dq_out_4;
  assign io_phy_dq_out_5 = dq_out_5;
  assign io_phy_dq_out_6 = dq_out_6;
  assign io_phy_dq_out_7 = dq_out_7;
  assign io_phy_dq_oen = dq_oen;
  assign io_phy_dqs_out = dqs_out;
  assign io_phy_dqs_oen = dqs_oen;
  assign io_phy_dm_out = dm_out;
  assign io_phy_nRAS_0 = nRAS_0;
  assign io_phy_nRAS_1 = nRAS_1;
  assign io_phy_nRAS_2 = nRAS_2;
  assign io_phy_nRAS_3 = nRAS_3;
  assign io_phy_nCAS_0 = nCAS_0;
  assign io_phy_nCAS_1 = nCAS_1;
  assign io_phy_nCAS_2 = nCAS_2;
  assign io_phy_nCAS_3 = nCAS_3;
  assign io_phy_nWE_0 = nWE_0;
  assign io_phy_nWE_1 = nWE_1;
  assign io_phy_nWE_2 = nWE_2;
  assign io_phy_nWE_3 = nWE_3;
  assign io_phy_A_0 = A_0;
  assign io_phy_A_1 = A_1;
  assign io_phy_A_2 = A_2;
  assign io_phy_A_3 = A_3;
  assign io_phy_BA_0 = BA_0;
  assign io_phy_BA_1 = BA_1;
  assign io_phy_BA_2 = BA_2;
  assign io_phy_BA_3 = BA_3;
  assign io_phy_CKE = CKE;
  assign io_phy_resetn_delay = resetn_delay;
  assign io_phy_wser_rst = wser_rst;
  assign when_Ddr3ControllerCore_l1997 = (((((io_phy_rst_lock_n && (! _zz_when_Ddr3ControllerCore_l1997)) && (! busy)) && (state == Ddr3State_IDLE)) && wlevel_done) && rcalib_done);
  assign io_init_done = init_done_latched;
  assign io_write_level_done = wlevel_done;
  assign io_read_calib_done = rcalib_done;
  assign io_wstep = wstep;
  assign io_rclkpos = rclkpos;
  assign io_rclksel = rclksel;
  assign io_best_rot = bestRot;
  assign io_best_score = bestCnt;
  assign io_dbg_state = state;
  always @(posedge io_pclk or posedge _zz_when_Ddr3ControllerCore_l1997) begin
    if(_zz_when_Ddr3ControllerCore_l1997) begin
      state <= Ddr3State_RST_WAIT;
      cycle <= 7'h0;
      tick_counter <= 17'h0ea60;
      tick <= 1'b0;
      resetn_delay <= 1'b0;
      CKE <= 1'b0;
      busy <= 1'b1;
      data_ready <= 1'b0;
      init_done_latched <= 1'b0;
      rowOpen <= 1'b0;
      openBank <= 3'b000;
      openRow <= 14'h0;
      prechForReq <= 1'b0;
      wrStreamOpen <= 1'b0;
      wrHavePending <= 1'b0;
      wrExtraCnt <= 6'h0;
      wrCooldown <= 4'b0000;
      st1Valid <= 1'b0;
      st2Valid <= 1'b0;
      st3Valid <= 1'b0;
      rdStreamOpen <= 1'b0;
      rdHavePending <= 1'b0;
      rdExtraCnt <= 6'h0;
      rdRspLeft <= 6'h0;
      wlevel_done <= 1'b0;
      wlevel_cnt <= 4'b0000;
      wlevel_tries <= 9'h0;
      wlVoteN <= 3'b000;
      wlVoteCnt <= 3'b000;
      wlVoteCnt0 <= 3'b000;
      wlVoteCnt1 <= 3'b000;
      wlLockedR <= 1'b0;
      wlLockedStepR <= 8'h0;
      wstep <= 8'h0;
      rcalib_done <= 1'b0;
      rcalib_cnt <= 4'b0000;
      rcalib_tries <= 10'h0;
      rclkpos <= 2'b00;
      rclksel <= 3'b000;
      rburst_seen <= 2'b00;
      dqs_hold <= 1'b0;
      training <= 1'b1;
      trainDone <= 1'b0;
      needPoison <= 1'b0;
      rotScorer_trainLatch <= 128'h0;
      rotScorer_rotScoresReg_0 <= 4'b0000;
      rotScorer_rotScoresReg_1 <= 4'b0000;
      rotScorer_rotScoresReg_2 <= 4'b0000;
      rotScorer_rotScoresReg_3 <= 4'b0000;
      rotScorer_rotScoresReg_4 <= 4'b0000;
      rotScorer_rotScoresReg_5 <= 4'b0000;
      rotScorer_rotScoresReg_6 <= 4'b0000;
      rotScorer_rotScoresReg_7 <= 4'b0000;
      rotScorer_sweepScore <= 4'b0000;
      rotScorer_sweepRot <= 3'b000;
      wserRstCnt <= 3'b000;
      wser_rst <= 1'b0;
      bestCnt <= 4'b0000;
      bestPos <= 2'b00;
      bestSel <= 3'b000;
      bestRot <= 3'b000;
      wrMode <= 2'b00;
      shiftCalDone <= 1'b0;
      tryMode <= 2'b00;
      wCalDone <= 1'b0;
      wTry <= 2'b00;
      wBase <= 8'h0;
      bestWstep <= 8'h0;
      best0 <= 4'b0000;
      best0Pos <= 2'b00;
      best0Sel <= 3'b000;
      best0Rot <= 3'b000;
      bestMode <= 2'b00;
      bestWCnt <= 4'b0000;
      bestWPos <= 2'b00;
      bestWSel <= 3'b000;
      bestWRot <= 3'b000;
      bestWMode <= 2'b00;
      dllSweepOn <= 1'b0;
      dllSweepDone <= 1'b0;
      bestCntDll <= 4'b0000;
      needFinalSurvey <= 1'b0;
      s0Side <= 1'b0;
      s0Mag <= 7'h0;
      s1Side <= 1'b0;
      s1Mag <= 7'h0;
      s2Side <= 1'b0;
      s2Mag <= 7'h0;
      bestSide <= 1'b0;
      bestMag <= 7'h0;
      scanOn <= 1'b0;
      scSide <= 1'b0;
      scMag <= 7'h0;
      bestSurveyCnt <= 4'b0000;
      bestSurveySide <= 1'b0;
      bestSurveyMag <= 7'h0;
      anchorLeft <= 2'b00;
      aligning <= 1'b0;
      settleLeft <= 2'b00;
      pinLeft <= 2'b00;
      bistReturn <= 1'b0;
      sweepMag0 <= 7'h0;
      sweepMagN <= 7'h0;
      applyArmed <= 1'b0;
      navigateLeft <= 8'h0;
      rmove <= 1'b0;
      rdir <= 1'b0;
      refresh_timer <= 11'h0;
      refresh_due <= 1'b0;
      nRAS_0 <= 1'b1;
      nRAS_1 <= 1'b1;
      nRAS_2 <= 1'b1;
      nRAS_3 <= 1'b1;
      nCAS_0 <= 1'b1;
      nCAS_1 <= 1'b1;
      nCAS_2 <= 1'b1;
      nCAS_3 <= 1'b1;
      nWE_0 <= 1'b1;
      nWE_1 <= 1'b1;
      nWE_2 <= 1'b1;
      nWE_3 <= 1'b1;
      A_0 <= 14'h0;
      A_1 <= 14'h0;
      A_2 <= 14'h0;
      A_3 <= 14'h0;
      BA_0 <= 3'b000;
      BA_1 <= 3'b000;
      BA_2 <= 3'b000;
      BA_3 <= 3'b000;
      dq_out_0 <= 16'h0;
      dq_out_1 <= 16'h0;
      dq_out_2 <= 16'h0;
      dq_out_3 <= 16'h0;
      dq_out_4 <= 16'h0;
      dq_out_5 <= 16'h0;
      dq_out_6 <= 16'h0;
      dq_out_7 <= 16'h0;
      dq_oen <= 4'b1111;
      dqs_out <= 8'h0;
      dqs_oen <= 4'b1111;
      dm_out <= 8'hff;
      dqs_read <= 4'b0000;
      dqPrevVec_0 <= 16'h0;
      dqPrevVec_1 <= 16'h0;
      dqPrevVec_2 <= 16'h0;
      dqPrevVec_3 <= 16'h0;
      dqPrevVec_4 <= 16'h0;
      dqPrevVec_5 <= 16'h0;
      dqPrevVec_6 <= 16'h0;
      dqPrevVec_7 <= 16'h0;
    end else begin
      sweepMag0 <= 7'h0;
      sweepMagN <= 7'h0;
      if(when_Ddr3ControllerCore_l280) begin
        if(when_Ddr3ControllerCore_l281) begin
          refresh_due <= 1'b1;
          refresh_timer <= 11'h0;
        end else begin
          refresh_timer <= (refresh_timer + 11'h001);
        end
      end
      if(when_Ddr3ControllerCore_l364) begin
        rburst_seen[0] <= 1'b1;
      end
      if(when_Ddr3ControllerCore_l365) begin
        rburst_seen[1] <= 1'b1;
      end
      dqs_read <= 4'b0000;
      if(when_Ddr3ControllerCore_l406) begin
        dqs_read <= 4'b1111;
      end
      if(when_Ddr3ControllerCore_l410) begin
        dqs_read <= 4'b1111;
      end
      if(io_phy_rst_lock_n) begin
        nRAS_0 <= 1'b1;
        nCAS_0 <= 1'b1;
        nWE_0 <= 1'b1;
        A_0 <= 14'h0;
        BA_0 <= 3'b000;
        nRAS_1 <= 1'b1;
        nCAS_1 <= 1'b1;
        nWE_1 <= 1'b1;
        A_1 <= 14'h0;
        BA_1 <= 3'b000;
        nRAS_2 <= 1'b1;
        nCAS_2 <= 1'b1;
        nWE_2 <= 1'b1;
        A_2 <= 14'h0;
        BA_2 <= 3'b000;
        nRAS_3 <= 1'b1;
        nCAS_3 <= 1'b1;
        nWE_3 <= 1'b1;
        A_3 <= 14'h0;
        BA_3 <= 3'b000;
        dm_out <= 8'hff;
        dqs_oen <= 4'b1111;
        dq_oen <= 4'b1111;
        dqs_out <= 8'h0;
        dqs_hold <= 1'b0;
        wser_rst <= 1'b0;
        if(when_Ddr3ControllerCore_l449) begin
          wserRstCnt <= (wserRstCnt - 3'b001);
          wser_rst <= (3'b010 < wserRstCnt);
        end
        if(when_Ddr3ControllerCore_l454) begin
          cycle <= ((cycle == 7'h7f) ? 7'h7f : _zz_cycle_1);
          tick <= (tick_counter == 17'h00001);
          tick_counter <= ((tick_counter == 17'h0) ? 17'h0 : _zz_tick_counter);
          case(state)
            Ddr3State_RST_WAIT : begin
              if(tick) begin
                resetn_delay <= 1'b1;
                tick_counter <= 17'h09484;
                state <= Ddr3State_CKE_WAIT;
              end
            end
            Ddr3State_CKE_WAIT : begin
              if(when_Ddr3ControllerCore_l469) begin
                CKE <= 1'b1;
              end
              if(tick) begin
                state <= Ddr3State_CONFIG_1;
                cycle <= 7'h0;
              end
            end
            Ddr3State_CONFIG_1 : begin
              case(cycle)
                7'h0 : begin
                  nRAS_0 <= CMD_SetModeReg[2];
                  nCAS_0 <= CMD_SetModeReg[1];
                  nWE_0 <= CMD_SetModeReg[0];
                  BA_0 <= MR2[15 : 13];
                  A_0 <= {1'd0, _zz_A_0_1};
                end
                7'h02 : begin
                  nRAS_0 <= CMD_SetModeReg[2];
                  nCAS_0 <= CMD_SetModeReg[1];
                  nWE_0 <= CMD_SetModeReg[0];
                  BA_0 <= MR3[15 : 13];
                  A_0 <= {1'd0, _zz_A_0_2};
                end
                7'h04 : begin
                  nRAS_0 <= CMD_SetModeReg[2];
                  nCAS_0 <= CMD_SetModeReg[1];
                  nWE_0 <= CMD_SetModeReg[0];
                  BA_0 <= MR1[15 : 13];
                  A_0 <= {1'd0, _zz_A_0_3};
                end
                7'h06 : begin
                  nRAS_0 <= CMD_SetModeReg[2];
                  nCAS_0 <= CMD_SetModeReg[1];
                  nWE_0 <= CMD_SetModeReg[0];
                  BA_0 <= MR0[15 : 13];
                  A_0 <= {1'd0, _zz_A_0_4};
                end
                7'h0a : begin
                  nRAS_0 <= CMD_ZQCL[2];
                  nCAS_0 <= CMD_ZQCL[1];
                  nWE_0 <= CMD_ZQCL[0];
                  BA_0 <= 3'b000;
                  A_0 <= (_zz_A_0_5 <<< 10);
                  tick_counter <= 17'h00202;
                  state <= Ddr3State_ZQCL;
                end
                default : begin
                end
              endcase
            end
            Ddr3State_ZQCL : begin
              if(tick) begin
                state <= Ddr3State_WRITE_LEVELING;
                cycle <= 7'h0;
              end
            end
            Ddr3State_WRITE_LEVELING : begin
              case(cycle)
                7'h0 : begin
                  nRAS_0 <= CMD_SetModeReg[2];
                  nCAS_0 <= CMD_SetModeReg[1];
                  nWE_0 <= CMD_SetModeReg[0];
                  BA_0 <= _zz_A_0[15 : 13];
                  A_0 <= {1'd0, _zz_A_0_7};
                  wlevel_cnt <= 4'b0000;
                  wlVoteN <= 3'b000;
                  wlVoteCnt <= 3'b000;
                end
                7'h0a, 7'h0c, 7'h0d, 7'h0e, 7'h0f, 7'h10 : begin
                  dqs_out <= 8'h0;
                  dqs_oen <= 4'b0000;
                end
                7'h0b : begin
                  dqs_out <= 8'h55;
                  dqs_oen <= 4'b0000;
                end
                7'h11 : begin
                  dqs_out <= 8'h0;
                  dqs_oen <= 4'b0000;
                  if(when_Ddr3ControllerCore_l541) begin
                    wlVoteN <= 3'b000;
                    wlVoteCnt <= 3'b000;
                    wlevel_tries <= (wlevel_tries + 9'h001);
                    if(when_Ddr3ControllerCore_l550) begin
                      wlevel_done <= 1'b1;
                      wstep <= 8'hff;
                      nRAS_0 <= CMD_SetModeReg[2];
                      nCAS_0 <= CMD_SetModeReg[1];
                      nWE_0 <= CMD_SetModeReg[0];
                      BA_0 <= MR1[15 : 13];
                      A_0 <= {1'd0, _zz_A_0_8};
                    end else begin
                      if(when_Ddr3ControllerCore_l554) begin
                        wstep <= _zz_wstep;
                        wlevel_cnt <= 4'b0000;
                        cycle <= 7'h0a;
                      end else begin
                        wlevel_cnt <= (wlevel_cnt + 4'b0001);
                        if(when_Ddr3ControllerCore_l565) begin
                          wlevel_done <= 1'b1;
                          wstep <= _zz_wstep_1;
                          nRAS_0 <= CMD_SetModeReg[2];
                          nCAS_0 <= CMD_SetModeReg[1];
                          nWE_0 <= CMD_SetModeReg[0];
                          BA_0 <= MR1[15 : 13];
                          A_0 <= {1'd0, _zz_A_0_9};
                        end else begin
                          cycle <= 7'h0a;
                        end
                      end
                    end
                  end else begin
                    if(when_Ddr3ControllerCore_l576) begin
                      wlVoteCnt <= (wlVoteCnt + 3'b001);
                    end
                    wlVoteN <= (wlVoteN + 3'b001);
                    cycle <= 7'h0a;
                  end
                end
                7'h13 : begin
                  nRAS_0 <= CMD_SetModeReg[2];
                  nCAS_0 <= CMD_SetModeReg[1];
                  nWE_0 <= CMD_SetModeReg[0];
                  BA_0 <= MR2_RTT_WR[15 : 13];
                  A_0 <= {1'd0, _zz_A_0_10};
                end
                7'h16 : begin
                  wserRstCnt <= 3'b101;
                  state <= Ddr3State_READ_CALIB;
                  cycle <= 7'h0;
                end
                default : begin
                end
              endcase
            end
            Ddr3State_READ_CALIB : begin
              case(cycle)
                7'h0 : begin
                  nRAS_0 <= CMD_BankActivate[2];
                  nCAS_0 <= CMD_BankActivate[1];
                  nWE_0 <= CMD_BankActivate[0];
                  BA_0 <= 3'b000;
                  A_0 <= {13'd0, _zz_A_0_11};
                  dqs_hold <= 1'b1;
                  if(bistReturn) begin
                    bistReturn <= 1'b0;
                  end else begin
                    if(training) begin
                      shiftCalDone <= 1'b0;
                      tryMode <= 2'b00;
                      wrMode <= 2'b00;
                      bestMode <= 2'b00;
                      wCalDone <= 1'b0;
                      wTry <= 2'b00;
                      wBase <= 8'h0;
                      bestWstep <= 8'h0;
                      bestWCnt <= 4'b0000;
                      bestWPos <= 2'b00;
                      bestWSel <= 3'b000;
                      bestWRot <= 3'b000;
                      bestWMode <= 2'b00;
                    end
                    rcalib_cnt <= 4'b0000;
                    rcalib_tries <= 10'h0;
                    bestCnt <= 4'b0000;
                    bestPos <= rclkpos;
                    bestSel <= rclksel;
                    bestRot <= 3'b000;
                    dllSweepOn <= 1'b0;
                    bestCntDll <= 4'b0000;
                    s0Side <= 1'b0;
                    s0Mag <= 7'h0;
                    s1Side <= 1'b0;
                    s1Mag <= 7'h0;
                    s2Side <= 1'b0;
                    s2Mag <= 7'h0;
                    bestSide <= 1'b0;
                    bestMag <= 7'h0;
                    scanOn <= 1'b0;
                    scSide <= 1'b0;
                    scMag <= 7'h0;
                    bestSurveyCnt <= 4'b0000;
                    bestSurveySide <= 1'b0;
                    bestSurveyMag <= 7'h0;
                    anchorLeft <= 2'b00;
                    aligning <= 1'b0;
                    settleLeft <= 2'b00;
                    pinLeft <= 2'b00;
                    applyArmed <= 1'b0;
                    navigateLeft <= 8'h0;
                  end
                end
                7'h01 : begin
                  nRAS_2 <= CMD_Read[2];
                  nCAS_2 <= CMD_Read[1];
                  nWE_2 <= CMD_Read[0];
                  BA_2 <= 3'b000;
                  A_2 <= (_zz_A_2_2 <<< 12);
                  rburst_seen <= 2'b00;
                end
                7'h02 : begin
                  nRAS_2 <= CMD_Read[2];
                  nCAS_2 <= CMD_Read[1];
                  nWE_2 <= CMD_Read[0];
                  BA_2 <= 3'b000;
                  A_2 <= (_zz_A_2_4 <<< 12);
                end
                7'h0a : begin
                  rotScorer_trainLatch <= {{{{{{{io_phy_dq_in_7,io_phy_dq_in_6},io_phy_dq_in_5},io_phy_dq_in_4},io_phy_dq_in_3},io_phy_dq_in_2},io_phy_dq_in_1},io_phy_dq_in_0};
                end
                7'h0c : begin
                  rotScorer_rotScoresReg_0 <= rotScorer_rotScores_0;
                  rotScorer_rotScoresReg_1 <= rotScorer_rotScores_1;
                  rotScorer_rotScoresReg_2 <= rotScorer_rotScores_2;
                  rotScorer_rotScoresReg_3 <= rotScorer_rotScores_3;
                  rotScorer_rotScoresReg_4 <= rotScorer_rotScores_4;
                  rotScorer_rotScoresReg_5 <= rotScorer_rotScores_5;
                  rotScorer_rotScoresReg_6 <= rotScorer_rotScores_6;
                  rotScorer_rotScoresReg_7 <= rotScorer_rotScores_7;
                end
                7'h0d : begin
                  rotScorer_sweepScore <= rotScorer_topScore;
                  rotScorer_sweepRot <= rotScorer_topIdx;
                end
                7'h0e : begin
                  if(when_Ddr3ControllerCore_l712) begin
                    `ifndef SYNTHESIS
                      `ifdef FORMAL
                        assert(1'b0); // Ddr3ControllerCore.scala:L713
                      `else
                        if(!1'b0) begin
                          $display("NOTE RCALIB chk pos=%x sel=%x seen=%x score=%x rot=%x latch=%x best=%x tries=%x", rclkpos, rclksel, rburst_seen, rotScorer_sweepScore, rotScorer_sweepRot, rotScorer_trainLatch, bestCnt, rcalib_tries); // Ddr3ControllerCore.scala:L713
                        end
                      `endif
                    `endif
                  end
                  rcalib_cnt <= 4'b0000;
                  if(when_Ddr3ControllerCore_l717) begin
                    rcalib_tries <= (rcalib_tries + 10'h001);
                  end
                  if(when_Ddr3ControllerCore_l737) begin
                    rmove <= 1'b0;
                    if(when_Ddr3ControllerCore_l739) begin
                      anchorLeft <= (anchorLeft - 2'b01);
                      cycle <= 7'h01;
                    end else begin
                      if(aligning) begin
                        if(when_Ddr3ControllerCore_l751) begin
                          rdir <= s0Side;
                          rmove <= navigateLeft[0];
                          navigateLeft <= (navigateLeft - 8'h01);
                          cycle <= 7'h01;
                        end else begin
                          settleLeft <= 2'b10;
                          aligning <= 1'b0;
                          cycle <= 7'h01;
                        end
                      end else begin
                        settleLeft <= (settleLeft - 2'b01);
                        cycle <= 7'h01;
                      end
                    end
                  end else begin
                    if(dllSweepOn) begin
                      rmove <= 1'b0;
                      if(when_Ddr3ControllerCore_l775) begin
                        if(when_Ddr3ControllerCore_l776) begin
                          anchorLeft <= (anchorLeft - 2'b01);
                          cycle <= 7'h01;
                        end else begin
                          if(aligning) begin
                            if(when_Ddr3ControllerCore_l791) begin
                              rdir <= (applyArmed ? bestSide : s0Side);
                              rmove <= navigateLeft[0];
                              navigateLeft <= (navigateLeft - 8'h01);
                              cycle <= 7'h01;
                            end else begin
                              settleLeft <= 2'b10;
                              aligning <= 1'b0;
                              cycle <= 7'h01;
                            end
                          end else begin
                            if(when_Ddr3ControllerCore_l816) begin
                              dqs_hold <= 1'b1;
                              s1Side <= s0Side;
                              s1Mag <= s0Mag;
                              s2Side <= s1Side;
                              s2Mag <= s1Mag;
                              pinLeft <= (pinLeft - 2'b01);
                              cycle <= 7'h01;
                            end else begin
                              settleLeft <= (settleLeft - 2'b01);
                              s1Side <= s0Side;
                              s1Mag <= s0Mag;
                              s2Side <= s1Side;
                              s2Mag <= s1Mag;
                              if(when_Ddr3ControllerCore_l834) begin
                                rclkpos <= bestPos;
                                needFinalSurvey <= 1'b1;
                                dllSweepDone <= 1'b1;
                                dllSweepOn <= 1'b0;
                                applyArmed <= 1'b0;
                                `ifndef SYNTHESIS
                                  `ifdef FORMAL
                                    assert(1'b0); // Ddr3ControllerCore.scala:L844
                                  `else
                                    if(!1'b0) begin
                                      $display("NOTE RCALIB dll side=%x mag=%x pos=%x score=%x", bestSide, bestMag, bestPos, bestCntDll); // Ddr3ControllerCore.scala:L844
                                    end
                                  `endif
                                `endif
                                nRAS_0 <= CMD_PreCharge[2];
                                nCAS_0 <= CMD_PreCharge[1];
                                nWE_0 <= CMD_PreCharge[0];
                                BA_0 <= 3'b000;
                                A_0 <= {13'd0, _zz_A_0_12};
                              end else begin
                                cycle <= 7'h01;
                              end
                            end
                          end
                        end
                      end else begin
                        if(when_Ddr3ControllerCore_l859) begin
                          if(when_Ddr3ControllerCore_l864) begin
                            bestCntDll <= rotScorer_sweepScore;
                            bestMag <= s2Mag;
                            bestSide <= s2Side;
                            bestPos <= rclkpos;
                            bestSel <= rclksel;
                            bestRot <= rotScorer_sweepRot;
                          end
                          if(when_Ddr3ControllerCore_l874) begin
                            aligning <= 1'b1;
                            anchorLeft <= 2'b10;
                            navigateLeft <= ({1'd0,bestMag} <<< 1'd1);
                            applyArmed <= 1'b1;
                            s0Side <= bestSide;
                            s0Mag <= bestMag;
                            s1Side <= bestSide;
                            s1Mag <= bestMag;
                            s2Side <= bestSide;
                            s2Mag <= bestMag;
                            `ifndef SYNTHESIS
                              `ifdef FORMAL
                                assert(1'b0); // Ddr3ControllerCore.scala:L889
                              `else
                                if(!1'b0) begin
                                  $display("NOTE RCALIB dll side=%x mag=%x pos=%x score=%x", bestSide, bestMag, bestPos, bestCntDll); // Ddr3ControllerCore.scala:L889
                                end
                              `endif
                            `endif
                            cycle <= 7'h01;
                          end else begin
                            if(when_Ddr3ControllerCore_l899) begin
                              aligning <= 1'b1;
                              anchorLeft <= 2'b10;
                              navigateLeft <= ({1'd0,bestMag} <<< 1'd1);
                              applyArmed <= 1'b1;
                              s0Side <= bestSide;
                              s0Mag <= bestMag;
                              s1Side <= bestSide;
                              s1Mag <= bestMag;
                              s2Side <= bestSide;
                              s2Mag <= bestMag;
                              `ifndef SYNTHESIS
                                `ifdef FORMAL
                                  assert(1'b0); // Ddr3ControllerCore.scala:L912
                                `else
                                  if(!1'b0) begin
                                    $display("NOTE RCALIB dll side=%x mag=%x pos=%x score=%x", bestSide, bestMag, bestPos, bestCntDll); // Ddr3ControllerCore.scala:L912
                                  end
                                `endif
                              `endif
                              cycle <= 7'h01;
                            end else begin
                              s1Side <= s0Side;
                              s1Mag <= s0Mag;
                              s2Side <= s1Side;
                              s2Mag <= s1Mag;
                              rclkpos <= _zz_rclkpos;
                              rdir <= s0Side;
                              if(when_Ddr3ControllerCore_l935) begin
                                if(when_Ddr3ControllerCore_l941) begin
                                  s0Side <= 1'b1;
                                  s0Mag <= 7'h01;
                                  s1Side <= 1'b1;
                                  s1Mag <= 7'h01;
                                  s2Side <= 1'b1;
                                  s2Mag <= 7'h01;
                                  aligning <= 1'b1;
                                  anchorLeft <= 2'b10;
                                  navigateLeft <= 8'h02;
                                  applyArmed <= 1'b0;
                                  `ifndef SYNTHESIS
                                    `ifdef FORMAL
                                      assert(1'b0); // Ddr3ControllerCore.scala:L953
                                    `else
                                      if(!1'b0) begin
                                        $display("NOTE RCALIB dll side switch to minus"); // Ddr3ControllerCore.scala:L953
                                      end
                                    `endif
                                  `endif
                                end else begin
                                  if(when_Ddr3ControllerCore_l963) begin
                                    s0Mag <= (s0Mag + 7'h01);
                                    rmove <= 1'b1;
                                    pinLeft <= 2'b10;
                                  end
                                end
                              end
                              if(winDoneNow) begin
                                dllSweepOn <= 1'b0;
                                `ifndef SYNTHESIS
                                  `ifdef FORMAL
                                    assert(1'b0); // Ddr3ControllerCore.scala:L980
                                  `else
                                    if(!1'b0) begin
                                      $display("NOTE RCALIB window side=%x mag=%x pos=%x rot=%x score=%x", bestSide, bestMag, bestPos, bestRot, bestCntDll); // Ddr3ControllerCore.scala:L980
                                    end
                                  `endif
                                `endif
                                if(when_Ddr3ControllerCore_l982) begin
                                  rcalib_done <= 1'b1;
                                end
                                nRAS_0 <= CMD_PreCharge[2];
                                nCAS_0 <= CMD_PreCharge[1];
                                nWE_0 <= CMD_PreCharge[0];
                                BA_0 <= 3'b000;
                                A_0 <= {13'd0, _zz_A_0_13};
                              end
                              if(when_Ddr3ControllerCore_l987) begin
                                trainDone <= 1'b1;
                                needPoison <= 1'b0;
                                bistReturn <= 1'b1;
                                state <= Ddr3State_WRITE;
                                cycle <= 7'h0;
                              end
                            end
                          end
                        end
                      end
                    end else begin
                      if(when_Ddr3ControllerCore_l1012) begin
                        bestCnt <= rotScorer_sweepScore;
                        bestPos <= rclkpos;
                        bestSel <= rclksel;
                        bestRot <= rotScorer_sweepRot;
                      end
                      rclksel <= _zz_rclksel;
                      if(when_Ddr3ControllerCore_l1019) begin
                        rclkpos <= _zz_rclkpos_1;
                      end
                      if(when_Ddr3ControllerCore_l1023) begin
                        rclkpos <= bestPos;
                        rclksel <= bestSel;
                        if(when_Ddr3ControllerCore_l1030) begin
                          if(when_Ddr3ControllerCore_l1038) begin
                            if(when_Ddr3ControllerCore_l1040) begin
                              shiftCalDone <= 1'b1;
                              dllSweepDone <= 1'b1;
                              rcalib_tries <= 10'h028;
                              trainDone <= 1'b1;
                              needPoison <= 1'b0;
                              bistReturn <= 1'b1;
                              state <= Ddr3State_WRITE;
                              cycle <= 7'h0;
                            end else begin
                              if(when_Ddr3ControllerCore_l1046) begin
                                best0 <= bestCnt;
                                bestMode <= wrMode;
                                best0Pos <= bestPos;
                                best0Sel <= bestSel;
                                best0Rot <= bestRot;
                              end
                              if(when_Ddr3ControllerCore_l1053) begin
                                tryMode <= _zz_wrMode;
                                wrMode <= _zz_wrMode;
                                rcalib_tries <= 10'h0;
                                bestCnt <= 4'b0000;
                                trainDone <= 1'b1;
                                needPoison <= 1'b0;
                                bistReturn <= 1'b1;
                                state <= Ddr3State_WRITE;
                                cycle <= 7'h0;
                              end else begin
                                if(when_Ddr3ControllerCore_l1061) begin
                                  bestCnt <= best0;
                                  bestPos <= best0Pos;
                                  bestSel <= best0Sel;
                                  bestRot <= best0Rot;
                                  wrMode <= bestMode;
                                end
                                shiftCalDone <= 1'b1;
                                dllSweepDone <= 1'b1;
                                rcalib_tries <= 10'h028;
                                trainDone <= 1'b1;
                                needPoison <= 1'b0;
                                bistReturn <= 1'b1;
                                state <= Ddr3State_WRITE;
                                cycle <= 7'h0;
                              end
                            end
                          end
                          if(scanOn) begin
                            if(when_Ddr3ControllerCore_l1078) begin
                              bestSurveyCnt <= bestCnt;
                              bestSurveySide <= scSide;
                              bestSurveyMag <= scMag;
                            end
                            if(when_Ddr3ControllerCore_l1085) begin
                              `ifndef SYNTHESIS
                                `ifdef FORMAL
                                  assert(1'b0); // Ddr3ControllerCore.scala:L1087
                                `else
                                  if(!1'b0) begin
                                    $display("NOTE RCALIB scan sweep at side=%x mag=%x score=%x", scSide, scMag, bestCnt); // Ddr3ControllerCore.scala:L1087
                                  end
                                `endif
                              `endif
                              scanOn <= 1'b0;
                              dllSweepOn <= 1'b1;
                              bestCntDll <= 4'b0000;
                              bestSide <= 1'b0;
                              bestMag <= 7'h0;
                              rcalib_tries <= 10'h0;
                              rclksel[0] <= 1'b0;
                              s0Side <= scSide;
                              s0Mag <= scMag;
                              s1Side <= scSide;
                              s1Mag <= scMag;
                              s2Side <= scSide;
                              s2Mag <= scMag;
                              rclkpos <= 2'b00;
                              aligning <= 1'b1;
                              anchorLeft <= 2'b10;
                              navigateLeft <= ({1'd0,scMag} <<< 1'd1);
                              applyArmed <= 1'b0;
                              cycle <= 7'h01;
                            end else begin
                              if(when_Ddr3ControllerCore_l1094) begin
                                scMag <= (scMag + 7'h02);
                                rcalib_tries <= 10'h0;
                                bestCnt <= 4'b0000;
                                s0Side <= 1'b0;
                                s0Mag <= _zz_s0Mag;
                                s1Side <= 1'b0;
                                s1Mag <= _zz_s0Mag;
                                s2Side <= 1'b0;
                                s2Mag <= _zz_s0Mag;
                                rclkpos <= 2'b00;
                                aligning <= 1'b1;
                                anchorLeft <= 2'b10;
                                navigateLeft <= ({1'd0,_zz_s0Mag} <<< 1'd1);
                                applyArmed <= 1'b0;
                                cycle <= 7'h01;
                              end else begin
                                if(when_Ddr3ControllerCore_l1099) begin
                                  scSide <= 1'b1;
                                  scMag <= 7'h02;
                                  rcalib_tries <= 10'h0;
                                  bestCnt <= 4'b0000;
                                  s0Side <= 1'b1;
                                  s0Mag <= 7'h02;
                                  s1Side <= 1'b1;
                                  s1Mag <= 7'h02;
                                  s2Side <= 1'b1;
                                  s2Mag <= 7'h02;
                                  rclkpos <= 2'b00;
                                  aligning <= 1'b1;
                                  anchorLeft <= 2'b10;
                                  navigateLeft <= ({1'd0,7'h02} <<< 1'd1);
                                  applyArmed <= 1'b0;
                                  cycle <= 7'h01;
                                end else begin
                                  if(when_Ddr3ControllerCore_l1106) begin
                                    scMag <= (scMag + 7'h02);
                                    rcalib_tries <= 10'h0;
                                    bestCnt <= 4'b0000;
                                    s0Side <= 1'b1;
                                    s0Mag <= _zz_s0Mag_1;
                                    s1Side <= 1'b1;
                                    s1Mag <= _zz_s0Mag_1;
                                    s2Side <= 1'b1;
                                    s2Mag <= _zz_s0Mag_1;
                                    rclkpos <= 2'b00;
                                    aligning <= 1'b1;
                                    anchorLeft <= 2'b10;
                                    navigateLeft <= ({1'd0,_zz_s0Mag_1} <<< 1'd1);
                                    applyArmed <= 1'b0;
                                    cycle <= 7'h01;
                                  end else begin
                                    `ifndef SYNTHESIS
                                      `ifdef FORMAL
                                        assert(1'b0); // Ddr3ControllerCore.scala:L1114
                                      `else
                                        if(!1'b0) begin
                                          $display("NOTE RCALIB scan done best side=%x mag=%x score=%x", bestSurveySide, bestSurveyMag, bestSurveyCnt); // Ddr3ControllerCore.scala:L1114
                                        end
                                      `endif
                                    `endif
                                    scanOn <= 1'b0;
                                    dllSweepOn <= 1'b1;
                                    bestCntDll <= 4'b0000;
                                    bestSide <= 1'b0;
                                    bestMag <= 7'h0;
                                    rcalib_tries <= 10'h0;
                                    rclksel[0] <= 1'b0;
                                    s0Side <= bestSurveySide;
                                    s0Mag <= bestSurveyMag;
                                    s1Side <= bestSurveySide;
                                    s1Mag <= bestSurveyMag;
                                    s2Side <= bestSurveySide;
                                    s2Mag <= bestSurveyMag;
                                    rclkpos <= 2'b00;
                                    aligning <= 1'b1;
                                    anchorLeft <= 2'b10;
                                    navigateLeft <= ({1'd0,bestSurveyMag} <<< 1'd1);
                                    applyArmed <= 1'b0;
                                    cycle <= 7'h01;
                                  end
                                end
                              end
                            end
                          end else begin
                            if(shiftCalDone) begin
                              bestSurveyCnt <= bestCnt;
                              bestSurveySide <= 1'b0;
                              bestSurveyMag <= 7'h0;
                              rclksel[0] <= 1'b0;
                              if(when_Ddr3ControllerCore_l1135) begin
                                dllSweepOn <= 1'b1;
                                bestCntDll <= 4'b0000;
                                bestSide <= 1'b0;
                                bestMag <= 7'h0;
                                rcalib_tries <= 10'h0;
                                s0Side <= 1'b0;
                                s0Mag <= sweepMag0;
                                s1Side <= 1'b0;
                                s1Mag <= sweepMag0;
                                s2Side <= 1'b0;
                                s2Mag <= sweepMag0;
                                rclkpos <= 2'b00;
                                aligning <= 1'b1;
                                anchorLeft <= 2'b10;
                                navigateLeft <= ({1'd0,sweepMag0} <<< 1'd1);
                                applyArmed <= 1'b0;
                                `ifndef SYNTHESIS
                                  `ifdef FORMAL
                                    assert(1'b0); // Ddr3ControllerCore.scala:L1164
                                  `else
                                    if(!1'b0) begin
                                      $display("NOTE RCALIB window start mag0=%x n=%x", sweepMag0, sweepMagN); // Ddr3ControllerCore.scala:L1164
                                    end
                                  `endif
                                `endif
                                cycle <= 7'h01;
                              end else begin
                                if(when_Ddr3ControllerCore_l1172) begin
                                  dllSweepOn <= 1'b1;
                                  bestCntDll <= 4'b0000;
                                  bestSide <= 1'b0;
                                  bestMag <= 7'h0;
                                  rcalib_tries <= 10'h0;
                                  trainDone <= 1'b1;
                                  needPoison <= 1'b0;
                                  bistReturn <= 1'b1;
                                  state <= Ddr3State_WRITE;
                                  cycle <= 7'h0;
                                end else begin
                                  scanOn <= 1'b1;
                                  scSide <= 1'b0;
                                  scMag <= 7'h02;
                                  rcalib_tries <= 10'h0;
                                  bestCnt <= 4'b0000;
                                  `ifndef SYNTHESIS
                                    `ifdef FORMAL
                                      assert(1'b0); // Ddr3ControllerCore.scala:L1201
                                    `else
                                      if(!1'b0) begin
                                        $display("NOTE RCALIB scan start"); // Ddr3ControllerCore.scala:L1201
                                      end
                                    `endif
                                  `endif
                                  s0Side <= 1'b0;
                                  s0Mag <= 7'h02;
                                  s1Side <= 1'b0;
                                  s1Mag <= 7'h02;
                                  s2Side <= 1'b0;
                                  s2Mag <= 7'h02;
                                  rclkpos <= 2'b00;
                                  aligning <= 1'b1;
                                  anchorLeft <= 2'b10;
                                  navigateLeft <= ({1'd0,7'h02} <<< 1'd1);
                                  applyArmed <= 1'b0;
                                  cycle <= 7'h01;
                                end
                              end
                            end
                          end
                        end else begin
                          dllSweepOn <= 1'b0;
                          `ifndef SYNTHESIS
                            `ifdef FORMAL
                              assert(1'b0); // Ddr3ControllerCore.scala:L1210
                            `else
                              if(!1'b0) begin
                                $display("NOTE RCALIB lock best pos=%x sel=%x rot=%x score=%x", bestPos, bestSel, bestRot, bestCnt); // Ddr3ControllerCore.scala:L1210
                              end
                            `endif
                          `endif
                          if(when_Ddr3ControllerCore_l1217) begin
                            if(when_Ddr3ControllerCore_l1219) begin
                              if(when_Ddr3ControllerCore_l1220) begin
                                bestWCnt <= bestCnt;
                                bestWstep <= wstep;
                                bestWPos <= bestPos;
                                bestWSel <= bestSel;
                                bestWRot <= bestRot;
                                bestWMode <= wrMode;
                              end
                              if(when_Ddr3ControllerCore_l1228) begin
                                wBase <= wstep;
                                wTry <= 2'b01;
                                wstep <= _zz_wstep_6;
                              end else begin
                                wTry <= 2'b10;
                                wstep <= _zz_wstep_7;
                              end
                              wserRstCnt <= 3'b101;
                              dllSweepDone <= 1'b0;
                              scanOn <= 1'b0;
                              shiftCalDone <= 1'b0;
                              tryMode <= 2'b00;
                              wrMode <= 2'b00;
                              bestCnt <= 4'b0000;
                              rcalib_tries <= 10'h0;
                              rclkpos <= 2'b00;
                              rclksel <= 3'b000;
                              bestRot <= 3'b000;
                              trainDone <= 1'b1;
                              needPoison <= 1'b0;
                              bistReturn <= 1'b1;
                              state <= Ddr3State_WRITE;
                              cycle <= 7'h0;
                            end else begin
                              if(when_Ddr3ControllerCore_l1249) begin
                                bestCnt <= bestWCnt;
                                wstep <= bestWstep;
                                wserRstCnt <= 3'b101;
                                rclkpos <= bestWPos;
                                rclksel <= bestWSel;
                                bestPos <= bestWPos;
                                bestSel <= bestWSel;
                                bestRot <= bestWRot;
                                wrMode <= bestWMode;
                              end
                              rcalib_done <= 1'b1;
                              nRAS_0 <= CMD_PreCharge[2];
                              nCAS_0 <= CMD_PreCharge[1];
                              nWE_0 <= CMD_PreCharge[0];
                              BA_0 <= 3'b000;
                              A_0 <= {13'd0, _zz_A_0_14};
                            end
                          end else begin
                            nRAS_0 <= CMD_PreCharge[2];
                            nCAS_0 <= CMD_PreCharge[1];
                            nWE_0 <= CMD_PreCharge[0];
                            BA_0 <= 3'b000;
                            A_0 <= {13'd0, _zz_A_0_15};
                          end
                        end
                      end else begin
                        trainDone <= 1'b1;
                        needPoison <= 1'b0;
                        bistReturn <= 1'b1;
                        state <= Ddr3State_WRITE;
                        cycle <= 7'h0;
                      end
                    end
                  end
                end
                7'h0f : begin
                  busy <= 1'b0;
                  state <= Ddr3State_IDLE;
                end
                default : begin
                end
              endcase
            end
            Ddr3State_IDLE : begin
              if(training) begin
                training <= 1'b0;
                trainDone <= 1'b1;
                needPoison <= 1'b1;
                nRAS_0 <= CMD_BankActivate[2];
                nCAS_0 <= CMD_BankActivate[1];
                nWE_0 <= CMD_BankActivate[0];
                BA_0 <= 3'b000;
                A_0 <= {13'd0, _zz_A_0_16};
                state <= Ddr3State_WRITE;
                cycle <= 7'h01;
                busy <= 1'b1;
              end else begin
                if(needPoison) begin
                  needPoison <= 1'b0;
                  trainDone <= 1'b1;
                  nRAS_0 <= CMD_BankActivate[2];
                  nCAS_0 <= CMD_BankActivate[1];
                  nWE_0 <= CMD_BankActivate[0];
                  BA_0 <= 3'b000;
                  A_0 <= {13'd0, _zz_A_0_17};
                  state <= Ddr3State_WRITE;
                  cycle <= 7'h01;
                  busy <= 1'b1;
                end else begin
                  if(refresh_due) begin
                    if(rowOpen) begin
                      nRAS_0 <= CMD_PreCharge[2];
                      nCAS_0 <= CMD_PreCharge[1];
                      nWE_0 <= CMD_PreCharge[0];
                      BA_0 <= 3'b000;
                      A_0 <= _zz_A_0_18[13:0];
                      rowOpen <= 1'b0;
                      prechForReq <= 1'b0;
                      state <= Ddr3State_PRECHARGE;
                      cycle <= 7'h01;
                      busy <= 1'b1;
                    end else begin
                      nRAS_0 <= CMD_AutoRefresh[2];
                      nCAS_0 <= CMD_AutoRefresh[1];
                      nWE_0 <= CMD_AutoRefresh[0];
                      BA_0 <= 3'b000;
                      A_0 <= {13'd0, _zz_A_0_19};
                      state <= Ddr3State_REFRESH;
                      cycle <= 7'h01;
                      busy <= 1'b1;
                      refresh_due <= 1'b0;
                    end
                  end else begin
                    if(needFinalSurvey) begin
                      needFinalSurvey <= 1'b0;
                      state <= Ddr3State_READ_CALIB;
                      cycle <= 7'h0;
                    end else begin
                      if(io_req_valid) begin
                        if(when_Ddr3ControllerCore_l1353) begin
                          nRAS_0 <= CMD_PreCharge[2];
                          nCAS_0 <= CMD_PreCharge[1];
                          nWE_0 <= CMD_PreCharge[0];
                          BA_0 <= 3'b000;
                          A_0 <= _zz_A_0_20[13:0];
                          rowOpen <= 1'b0;
                          prechForReq <= 1'b1;
                          state <= Ddr3State_PRECHARGE;
                          cycle <= 7'h01;
                          busy <= 1'b1;
                        end else begin
                          if(when_Ddr3ControllerCore_l1362) begin
                            nRAS_0 <= CMD_BankActivate[2];
                            nCAS_0 <= CMD_BankActivate[1];
                            nWE_0 <= CMD_BankActivate[0];
                            BA_0 <= _zz_openBank;
                            A_0 <= _zz_openRow;
                            rowOpen <= 1'b1;
                            openBank <= _zz_openBank;
                            openRow <= _zz_openRow;
                          end
                          busy <= 1'b1;
                          if(io_req_payload_write) begin
                            wrStreamOpen <= 1'b1;
                            wrHavePending <= 1'b0;
                            wrExtraCnt <= 6'h0;
                            wrCooldown <= 4'b0000;
                            st1Valid <= 1'b0;
                            st2Valid <= 1'b0;
                            st3Valid <= 1'b0;
                            state <= Ddr3State_WRITE;
                            cycle <= (_zz_cycle ? 7'h01 : 7'h01);
                          end else begin
                            dqs_hold <= 1'b1;
                            rdStreamOpen <= 1'b1;
                            rdHavePending <= 1'b0;
                            rdExtraCnt <= 6'h0;
                            rdRspLeft <= 6'h01;
                            state <= Ddr3State_READ;
                            cycle <= (_zz_cycle ? 7'h01 : 7'h01);
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
            Ddr3State_PRECHARGE : begin
              if(when_Ddr3ControllerCore_l1394) begin
                if(prechForReq) begin
                  prechForReq <= 1'b0;
                  nRAS_0 <= CMD_BankActivate[2];
                  nCAS_0 <= CMD_BankActivate[1];
                  nWE_0 <= CMD_BankActivate[0];
                  BA_0 <= _zz_openBank_1;
                  A_0 <= _zz_openRow_1;
                  rowOpen <= 1'b1;
                  openBank <= _zz_openBank_1;
                  openRow <= _zz_openRow_1;
                  if(reqReg_write) begin
                    wrStreamOpen <= 1'b1;
                    wrHavePending <= 1'b0;
                    wrExtraCnt <= 6'h0;
                    wrCooldown <= 4'b0000;
                    st1Valid <= 1'b0;
                    st2Valid <= 1'b0;
                    st3Valid <= 1'b0;
                    state <= Ddr3State_WRITE;
                    cycle <= 7'h01;
                  end else begin
                    dqs_hold <= 1'b1;
                    rdStreamOpen <= 1'b1;
                    rdHavePending <= 1'b0;
                    rdExtraCnt <= 6'h0;
                    rdRspLeft <= 6'h01;
                    state <= Ddr3State_READ;
                    cycle <= 7'h01;
                  end
                end else begin
                  nRAS_0 <= CMD_AutoRefresh[2];
                  nCAS_0 <= CMD_AutoRefresh[1];
                  nWE_0 <= CMD_AutoRefresh[0];
                  BA_0 <= 3'b000;
                  A_0 <= {13'd0, _zz_A_0_21};
                  refresh_due <= 1'b0;
                  state <= Ddr3State_REFRESH;
                  cycle <= 7'h01;
                end
              end
            end
            Ddr3State_READ : begin
              if(when_Ddr3ControllerCore_l1440) begin
                nRAS_2 <= CMD_Read[2];
                nCAS_2 <= CMD_Read[1];
                nWE_2 <= CMD_Read[0];
                BA_2 <= _zz_BA_2;
                A_2 <= _zz_A_2[13:0];
              end
              if(when_Ddr3ControllerCore_l1444) begin
                nRAS_2 <= CMD_Read[2];
                nCAS_2 <= CMD_Read[1];
                nWE_2 <= CMD_Read[0];
                BA_2 <= _zz_BA_2;
                A_2 <= _zz_A_2[13:0];
              end
              if(when_Ddr3ControllerCore_l1449) begin
                if(when_Ddr3ControllerCore_l1450) begin
                  rdHavePending <= 1'b1;
                  rdExtraCnt <= (rdExtraCnt + 6'h01);
                end else begin
                  rdHavePending <= 1'b0;
                  rdStreamOpen <= 1'b0;
                end
              end else begin
                rdHavePending <= 1'b0;
              end
              data_ready <= _zz_data_ready;
              rdRspLeft <= (_zz_rdRspLeft - _zz_rdRspLeft_3);
              if(when_Ddr3ControllerCore_l1468) begin
                busy <= 1'b0;
                state <= Ddr3State_IDLE;
              end
            end
            Ddr3State_WRITE : begin
              if(trainDone) begin
                if(when_Ddr3ControllerCore_l1483) begin
                  nRAS_2 <= CMD_Write[2];
                  nCAS_2 <= CMD_Write[1];
                  nWE_2 <= CMD_Write[0];
                  BA_2 <= _zz_BA_2_1;
                  A_2 <= _zz_A_2_6[13:0];
                end
                if(when_Ddr3ControllerCore_l1489) begin
                  case(wrMode)
                    2'b00 : begin
                      dqs_out <= 8'h40;
                      dqs_oen <= 4'b0011;
                      dq_oen <= 4'b0111;
                      dq_out_6 <= 16'h0;
                      dq_out_7 <= reqReg_wdata[15 : 0];
                      dm_out[6] <= 1'b1;
                      dm_out[7] <= (! (|reqReg_wstrb[1 : 0]));
                    end
                    2'b01 : begin
                      dqs_out <= 8'h40;
                      dqs_oen <= 4'b0011;
                      dq_oen <= 4'b0011;
                      dq_out_4 <= 16'h0;
                      dq_out_5 <= reqReg_wdata[15 : 0];
                      dq_out_6 <= reqReg_wdata[31 : 16];
                      dq_out_7 <= reqReg_wdata[47 : 32];
                      dm_out[4] <= 1'b1;
                      dm_out[5] <= (! (|reqReg_wstrb[1 : 0]));
                      dm_out[6] <= (! (|reqReg_wstrb[3 : 2]));
                      dm_out[7] <= (! (|reqReg_wstrb[5 : 4]));
                    end
                    2'b10 : begin
                      dqs_out <= 8'h0;
                      dqs_oen <= 4'b0111;
                    end
                    default : begin
                    end
                  endcase
                end
                if(when_Ddr3ControllerCore_l1524) begin
                  case(wrMode)
                    2'b00 : begin
                      dqs_out <= 8'h55;
                      dqs_oen <= 4'b0000;
                      dq_oen <= 4'b0000;
                      dq_out_0 <= reqReg_wdata[31 : 16];
                      dq_out_1 <= reqReg_wdata[47 : 32];
                      dq_out_2 <= reqReg_wdata[63 : 48];
                      dq_out_3 <= reqReg_wdata[79 : 64];
                      dq_out_4 <= reqReg_wdata[95 : 80];
                      dq_out_5 <= reqReg_wdata[111 : 96];
                      dq_out_6 <= reqReg_wdata[127 : 112];
                      dq_out_7 <= 16'h0;
                      dm_out[0] <= (! (|reqReg_wstrb[3 : 2]));
                      dm_out[1] <= (! (|reqReg_wstrb[5 : 4]));
                      dm_out[2] <= (! (|reqReg_wstrb[7 : 6]));
                      dm_out[3] <= (! (|reqReg_wstrb[9 : 8]));
                      dm_out[4] <= (! (|reqReg_wstrb[11 : 10]));
                      dm_out[5] <= (! (|reqReg_wstrb[13 : 12]));
                      dm_out[6] <= (! (|reqReg_wstrb[15 : 14]));
                      dm_out[7] <= 1'b1;
                    end
                    2'b01 : begin
                      dqs_out <= 8'h55;
                      dqs_oen <= 4'b0000;
                      dq_oen <= 4'b0000;
                      dq_out_0 <= reqReg_wdata[63 : 48];
                      dq_out_1 <= reqReg_wdata[79 : 64];
                      dq_out_2 <= reqReg_wdata[95 : 80];
                      dq_out_3 <= reqReg_wdata[111 : 96];
                      dq_out_4 <= reqReg_wdata[127 : 112];
                      dq_out_5 <= 16'h0;
                      dq_out_6 <= 16'h0;
                      dq_out_7 <= 16'h0;
                      dm_out[0] <= (! (|reqReg_wstrb[7 : 6]));
                      dm_out[1] <= (! (|reqReg_wstrb[9 : 8]));
                      dm_out[2] <= (! (|reqReg_wstrb[11 : 10]));
                      dm_out[3] <= (! (|reqReg_wstrb[13 : 12]));
                      dm_out[4] <= (! (|reqReg_wstrb[15 : 14]));
                      dm_out[5] <= 1'b1;
                      dm_out[6] <= 1'b1;
                      dm_out[7] <= 1'b1;
                    end
                    2'b10 : begin
                      dqs_out <= 8'h55;
                      dqs_oen <= 4'b0000;
                      dq_oen <= 4'b0000;
                      dq_out_0 <= 16'h0;
                      dq_out_1 <= reqReg_wdata[15 : 0];
                      dq_out_2 <= reqReg_wdata[31 : 16];
                      dq_out_3 <= reqReg_wdata[47 : 32];
                      dq_out_4 <= reqReg_wdata[63 : 48];
                      dq_out_5 <= reqReg_wdata[79 : 64];
                      dq_out_6 <= reqReg_wdata[95 : 80];
                      dq_out_7 <= reqReg_wdata[111 : 96];
                      dm_out[0] <= 1'b1;
                      dm_out[1] <= (! (|reqReg_wstrb[1 : 0]));
                      dm_out[2] <= (! (|reqReg_wstrb[3 : 2]));
                      dm_out[3] <= (! (|reqReg_wstrb[5 : 4]));
                      dm_out[4] <= (! (|reqReg_wstrb[7 : 6]));
                      dm_out[5] <= (! (|reqReg_wstrb[9 : 8]));
                      dm_out[6] <= (! (|reqReg_wstrb[11 : 10]));
                      dm_out[7] <= (! (|reqReg_wstrb[13 : 12]));
                    end
                    default : begin
                      dqs_out <= 8'h54;
                      dqs_oen <= 4'b0000;
                      dq_oen <= 4'b0001;
                      dq_out_2 <= 16'h0;
                      dq_out_3 <= reqReg_wdata[15 : 0];
                      dq_out_4 <= reqReg_wdata[31 : 16];
                      dq_out_5 <= reqReg_wdata[47 : 32];
                      dq_out_6 <= reqReg_wdata[63 : 48];
                      dq_out_7 <= reqReg_wdata[79 : 64];
                      dm_out[2] <= 1'b1;
                      dm_out[3] <= (! (|reqReg_wstrb[1 : 0]));
                      dm_out[4] <= (! (|reqReg_wstrb[3 : 2]));
                      dm_out[5] <= (! (|reqReg_wstrb[5 : 4]));
                      dm_out[6] <= (! (|reqReg_wstrb[7 : 6]));
                      dm_out[7] <= (! (|reqReg_wstrb[9 : 8]));
                    end
                  endcase
                end
                if(when_Ddr3ControllerCore_l1610) begin
                  case(wrMode)
                    2'b00, 2'b01 : begin
                      dqs_out <= 8'h0;
                      dqs_oen <= 4'b1110;
                      dq_oen <= 4'b1111;
                    end
                    2'b10 : begin
                      dqs_out <= 8'h01;
                      dqs_oen <= 4'b1100;
                      dq_oen <= 4'b1110;
                      dq_out_0 <= reqReg_wdata[127 : 112];
                      dq_out_1 <= 16'h0;
                      dm_out[0] <= (! (|reqReg_wstrb[15 : 14]));
                      dm_out[1] <= 1'b1;
                    end
                    default : begin
                      dqs_out <= 8'h05;
                      dqs_oen <= 4'b1000;
                      dq_oen <= 4'b1100;
                      dq_out_0 <= reqReg_wdata[95 : 80];
                      dq_out_1 <= reqReg_wdata[111 : 96];
                      dq_out_2 <= reqReg_wdata[127 : 112];
                      dq_out_3 <= 16'h0;
                      dm_out[0] <= (! (|reqReg_wstrb[11 : 10]));
                      dm_out[1] <= (! (|reqReg_wstrb[13 : 12]));
                      dm_out[2] <= (! (|reqReg_wstrb[15 : 14]));
                      dm_out[3] <= 1'b1;
                    end
                  endcase
                end
                if(when_Ddr3ControllerCore_l1642) begin
                  trainDone <= 1'b0;
                  if(needPoison) begin
                    state <= Ddr3State_IDLE;
                    cycle <= 7'h0;
                  end else begin
                    state <= Ddr3State_READ_CALIB;
                    cycle <= 7'h0;
                  end
                end
              end else begin
                if(when_Ddr3ControllerCore_l1660) begin
                  nRAS_2 <= CMD_Write[2];
                  nCAS_2 <= CMD_Write[1];
                  nWE_2 <= CMD_Write[0];
                  BA_2 <= _zz_BA_2_1;
                  A_2 <= _zz_A_2_8[13:0];
                end
                st1Valid <= when_Ddr3ControllerCore_l1660;
                st2Valid <= st1Valid;
                st3Valid <= st2Valid;
                if(when_Ddr3ControllerCore_l1672) begin
                  wrHavePending <= 1'b1;
                  wrExtraCnt <= (wrExtraCnt + 6'h01);
                end else begin
                  wrHavePending <= 1'b0;
                  wrStreamOpen <= 1'b0;
                end
                case(wrMode)
                  2'b00 : begin
                    if(when_Ddr3ControllerCore_l1683) begin
                      dqs_out <= 8'h40;
                      dqs_oen <= 4'b0011;
                      dq_oen <= 4'b0111;
                      dq_out_6 <= 16'h0;
                      dq_out_7 <= st1Req_wdata[15 : 0];
                      dm_out[6] <= 1'b1;
                      dm_out[7] <= (! (|st1Req_wstrb[1 : 0]));
                    end else begin
                      if(st2Valid) begin
                        dqs_out <= 8'h55;
                        dqs_oen <= 4'b0000;
                        dq_oen <= 4'b0000;
                        dq_out_0 <= st2Req_wdata[31 : 16];
                        dm_out[0] <= (! (|st2Req_wstrb[3 : 2]));
                        dq_out_1 <= st2Req_wdata[47 : 32];
                        dm_out[1] <= (! (|st2Req_wstrb[5 : 4]));
                        dq_out_2 <= st2Req_wdata[63 : 48];
                        dm_out[2] <= (! (|st2Req_wstrb[7 : 6]));
                        dq_out_3 <= st2Req_wdata[79 : 64];
                        dm_out[3] <= (! (|st2Req_wstrb[9 : 8]));
                        dq_out_4 <= st2Req_wdata[95 : 80];
                        dm_out[4] <= (! (|st2Req_wstrb[11 : 10]));
                        dq_out_5 <= st2Req_wdata[111 : 96];
                        dm_out[5] <= (! (|st2Req_wstrb[13 : 12]));
                        dq_out_6 <= st2Req_wdata[127 : 112];
                        dm_out[6] <= (! (|st2Req_wstrb[15 : 14]));
                        if(st1Valid) begin
                          dq_out_7 <= st1Req_wdata[15 : 0];
                          dm_out[7] <= (! (|st1Req_wstrb[1 : 0]));
                        end else begin
                          dq_out_7 <= 16'h0;
                          dm_out[7] <= 1'b1;
                        end
                      end else begin
                        if(st3Valid) begin
                          dqs_out <= 8'h0;
                          dqs_oen <= 4'b1110;
                          dq_oen <= 4'b1111;
                        end
                      end
                    end
                  end
                  2'b01 : begin
                    if(when_Ddr3ControllerCore_l1713) begin
                      dqs_out <= 8'h40;
                      dqs_oen <= 4'b0011;
                      dq_oen <= 4'b0011;
                      dq_out_4 <= 16'h0;
                      dm_out[4] <= 1'b1;
                      dq_out_5 <= st1Req_wdata[15 : 0];
                      dm_out[5] <= (! (|st1Req_wstrb[1 : 0]));
                      dq_out_6 <= st1Req_wdata[31 : 16];
                      dm_out[6] <= (! (|st1Req_wstrb[3 : 2]));
                      dq_out_7 <= st1Req_wdata[47 : 32];
                      dm_out[7] <= (! (|st1Req_wstrb[5 : 4]));
                    end else begin
                      if(st2Valid) begin
                        dqs_out <= 8'h55;
                        dqs_oen <= 4'b0000;
                        dq_oen <= 4'b0000;
                        dq_out_0 <= st2Req_wdata[63 : 48];
                        dm_out[0] <= (! (|st2Req_wstrb[7 : 6]));
                        dq_out_1 <= st2Req_wdata[79 : 64];
                        dm_out[1] <= (! (|st2Req_wstrb[9 : 8]));
                        dq_out_2 <= st2Req_wdata[95 : 80];
                        dm_out[2] <= (! (|st2Req_wstrb[11 : 10]));
                        dq_out_3 <= st2Req_wdata[111 : 96];
                        dm_out[3] <= (! (|st2Req_wstrb[13 : 12]));
                        dq_out_4 <= st2Req_wdata[127 : 112];
                        dm_out[4] <= (! (|st2Req_wstrb[15 : 14]));
                        if(st1Valid) begin
                          dq_out_5 <= st1Req_wdata[15 : 0];
                          dm_out[5] <= (! (|st1Req_wstrb[1 : 0]));
                          dq_out_6 <= st1Req_wdata[31 : 16];
                          dm_out[6] <= (! (|st1Req_wstrb[3 : 2]));
                          dq_out_7 <= st1Req_wdata[47 : 32];
                          dm_out[7] <= (! (|st1Req_wstrb[5 : 4]));
                        end else begin
                          dq_out_5 <= 16'h0;
                          dm_out[5] <= 1'b1;
                          dq_out_6 <= 16'h0;
                          dm_out[6] <= 1'b1;
                          dq_out_7 <= 16'h0;
                          dm_out[7] <= 1'b1;
                        end
                      end else begin
                        if(st3Valid) begin
                          dqs_out <= 8'h0;
                          dqs_oen <= 4'b1110;
                          dq_oen <= 4'b1111;
                        end
                      end
                    end
                  end
                  2'b10 : begin
                    if(when_Ddr3ControllerCore_l1749) begin
                      dqs_out <= 8'h0;
                      dqs_oen <= 4'b0111;
                    end else begin
                      if(when_Ddr3ControllerCore_l1752) begin
                        dqs_out <= 8'h55;
                        dqs_oen <= 4'b0000;
                        dq_oen <= 4'b0000;
                        dq_out_0 <= 16'h0;
                        dm_out[0] <= 1'b1;
                        dq_out_1 <= st2Req_wdata[15 : 0];
                        dm_out[1] <= (! (|st2Req_wstrb[1 : 0]));
                        dq_out_2 <= st2Req_wdata[31 : 16];
                        dm_out[2] <= (! (|st2Req_wstrb[3 : 2]));
                        dq_out_3 <= st2Req_wdata[47 : 32];
                        dm_out[3] <= (! (|st2Req_wstrb[5 : 4]));
                        dq_out_4 <= st2Req_wdata[63 : 48];
                        dm_out[4] <= (! (|st2Req_wstrb[7 : 6]));
                        dq_out_5 <= st2Req_wdata[79 : 64];
                        dm_out[5] <= (! (|st2Req_wstrb[9 : 8]));
                        dq_out_6 <= st2Req_wdata[95 : 80];
                        dm_out[6] <= (! (|st2Req_wstrb[11 : 10]));
                        dq_out_7 <= st2Req_wdata[111 : 96];
                        dm_out[7] <= (! (|st2Req_wstrb[13 : 12]));
                      end else begin
                        if(when_Ddr3ControllerCore_l1762) begin
                          dqs_out <= 8'h55;
                          dqs_oen <= 4'b0000;
                          dq_oen <= 4'b0000;
                          dq_out_0 <= st3Req_wdata[127 : 112];
                          dm_out[0] <= (! (|st3Req_wstrb[15 : 14]));
                          dq_out_1 <= st2Req_wdata[15 : 0];
                          dm_out[1] <= (! (|st2Req_wstrb[1 : 0]));
                          dq_out_2 <= st2Req_wdata[31 : 16];
                          dm_out[2] <= (! (|st2Req_wstrb[3 : 2]));
                          dq_out_3 <= st2Req_wdata[47 : 32];
                          dm_out[3] <= (! (|st2Req_wstrb[5 : 4]));
                          dq_out_4 <= st2Req_wdata[63 : 48];
                          dm_out[4] <= (! (|st2Req_wstrb[7 : 6]));
                          dq_out_5 <= st2Req_wdata[79 : 64];
                          dm_out[5] <= (! (|st2Req_wstrb[9 : 8]));
                          dq_out_6 <= st2Req_wdata[95 : 80];
                          dm_out[6] <= (! (|st2Req_wstrb[11 : 10]));
                          dq_out_7 <= st2Req_wdata[111 : 96];
                          dm_out[7] <= (! (|st2Req_wstrb[13 : 12]));
                        end else begin
                          if(st3Valid) begin
                            dqs_out <= 8'h01;
                            dqs_oen <= 4'b1100;
                            dq_oen <= 4'b1110;
                            dq_out_0 <= st3Req_wdata[127 : 112];
                            dq_out_1 <= 16'h0;
                            dm_out[0] <= (! (|st3Req_wstrb[15 : 14]));
                            dm_out[1] <= 1'b1;
                          end
                        end
                      end
                    end
                  end
                  default : begin
                    if(when_Ddr3ControllerCore_l1783) begin
                      dqs_out <= 8'h54;
                      dqs_oen <= 4'b0000;
                      dq_oen <= 4'b0001;
                      dq_out_2 <= 16'h0;
                      dm_out[2] <= 1'b1;
                      dq_out_3 <= st2Req_wdata[15 : 0];
                      dm_out[3] <= (! (|st2Req_wstrb[1 : 0]));
                      dq_out_4 <= st2Req_wdata[31 : 16];
                      dm_out[4] <= (! (|st2Req_wstrb[3 : 2]));
                      dq_out_5 <= st2Req_wdata[47 : 32];
                      dm_out[5] <= (! (|st2Req_wstrb[5 : 4]));
                      dq_out_6 <= st2Req_wdata[63 : 48];
                      dm_out[6] <= (! (|st2Req_wstrb[7 : 6]));
                      dq_out_7 <= st2Req_wdata[79 : 64];
                      dm_out[7] <= (! (|st2Req_wstrb[9 : 8]));
                    end else begin
                      if(when_Ddr3ControllerCore_l1793) begin
                        dqs_out <= 8'h55;
                        dqs_oen <= 4'b0000;
                        dq_oen <= 4'b0000;
                        dq_out_0 <= st3Req_wdata[95 : 80];
                        dm_out[0] <= (! (|st3Req_wstrb[11 : 10]));
                        dq_out_1 <= st3Req_wdata[111 : 96];
                        dm_out[1] <= (! (|st3Req_wstrb[13 : 12]));
                        dq_out_2 <= st3Req_wdata[127 : 112];
                        dm_out[2] <= (! (|st3Req_wstrb[15 : 14]));
                        dq_out_3 <= st2Req_wdata[15 : 0];
                        dm_out[3] <= (! (|st2Req_wstrb[1 : 0]));
                        dq_out_4 <= st2Req_wdata[31 : 16];
                        dm_out[4] <= (! (|st2Req_wstrb[3 : 2]));
                        dq_out_5 <= st2Req_wdata[47 : 32];
                        dm_out[5] <= (! (|st2Req_wstrb[5 : 4]));
                        dq_out_6 <= st2Req_wdata[63 : 48];
                        dm_out[6] <= (! (|st2Req_wstrb[7 : 6]));
                        dq_out_7 <= st2Req_wdata[79 : 64];
                        dm_out[7] <= (! (|st2Req_wstrb[9 : 8]));
                      end else begin
                        if(st3Valid) begin
                          dqs_out <= 8'h05;
                          dqs_oen <= 4'b1000;
                          dq_oen <= 4'b1100;
                          dq_out_0 <= st3Req_wdata[95 : 80];
                          dm_out[0] <= (! (|st3Req_wstrb[11 : 10]));
                          dq_out_1 <= st3Req_wdata[111 : 96];
                          dm_out[1] <= (! (|st3Req_wstrb[13 : 12]));
                          dq_out_2 <= st3Req_wdata[127 : 112];
                          dm_out[2] <= (! (|st3Req_wstrb[15 : 14]));
                          dq_out_3 <= 16'h0;
                          dm_out[3] <= 1'b1;
                        end
                      end
                    end
                  end
                endcase
                if(when_Ddr3ControllerCore_l1660) begin
                  wrCooldown <= ((2'b10 <= wrMode) ? 4'b0101 : 4'b0100);
                end else begin
                  if(when_Ddr3ControllerCore_l1821) begin
                    wrCooldown <= (wrCooldown - 4'b0001);
                  end
                end
                if(when_Ddr3ControllerCore_l1825) begin
                  busy <= 1'b0;
                  state <= Ddr3State_IDLE;
                end
              end
            end
            default : begin
              if(when_Ddr3ControllerCore_l1834) begin
                busy <= 1'b0;
                state <= Ddr3State_IDLE;
              end
            end
          endcase
        end
      end else begin
        busy <= 1'b1;
        data_ready <= 1'b0;
        CKE <= 1'b0;
        nRAS_0 <= 1'b1;
        nCAS_0 <= 1'b1;
        nWE_0 <= 1'b1;
        nRAS_1 <= 1'b1;
        nCAS_1 <= 1'b1;
        nWE_1 <= 1'b1;
        nRAS_2 <= 1'b1;
        nCAS_2 <= 1'b1;
        nWE_2 <= 1'b1;
        nRAS_3 <= 1'b1;
        nCAS_3 <= 1'b1;
        nWE_3 <= 1'b1;
        dq_oen <= 4'b1111;
        dqs_oen <= 4'b1111;
        dqs_out <= 8'h0;
        dm_out <= 8'hff;
        dq_out_0 <= 16'h0;
        dq_out_1 <= 16'h0;
        dq_out_2 <= 16'h0;
        dq_out_3 <= 16'h0;
        dq_out_4 <= 16'h0;
        dq_out_5 <= 16'h0;
        dq_out_6 <= 16'h0;
        dq_out_7 <= 16'h0;
        dqs_read <= 4'b0000;
        dqs_hold <= 1'b0;
        tick_counter <= 17'h0ea60;
        tick <= 1'b0;
        cycle <= 7'h0;
        wlevel_cnt <= 4'b0000;
        wlevel_tries <= 9'h0;
        wlVoteN <= 3'b000;
        wlVoteCnt <= 3'b000;
        wlVoteCnt0 <= 3'b000;
        wlVoteCnt1 <= 3'b000;
        wlLockedR <= 1'b0;
        wlLockedStepR <= 8'h0;
        wlevel_done <= 1'b0;
        wstep <= 8'h0;
        rcalib_cnt <= 4'b0000;
        rcalib_done <= 1'b0;
        rcalib_tries <= 10'h0;
        dllSweepOn <= 1'b0;
        dllSweepDone <= 1'b0;
        bestCntDll <= 4'b0000;
        needFinalSurvey <= 1'b0;
        s0Side <= 1'b0;
        s0Mag <= 7'h0;
        s1Side <= 1'b0;
        s1Mag <= 7'h0;
        s2Side <= 1'b0;
        s2Mag <= 7'h0;
        bestSide <= 1'b0;
        bestMag <= 7'h0;
        anchorLeft <= 2'b00;
        aligning <= 1'b0;
        settleLeft <= 2'b00;
        applyArmed <= 1'b0;
        navigateLeft <= 8'h0;
        bistReturn <= 1'b0;
        rmove <= 1'b0;
        rdir <= 1'b0;
        bestRot <= 3'b000;
        wrMode <= 2'b00;
        shiftCalDone <= 1'b0;
        tryMode <= 2'b00;
        wCalDone <= 1'b0;
        wTry <= 2'b00;
        wBase <= 8'h0;
        bestWstep <= 8'h0;
        best0 <= 4'b0000;
        best0Pos <= 2'b00;
        best0Sel <= 3'b000;
        best0Rot <= 3'b000;
        bestMode <= 2'b00;
        bestWCnt <= 4'b0000;
        bestWPos <= 2'b00;
        bestWSel <= 3'b000;
        bestWRot <= 3'b000;
        bestWMode <= 2'b00;
        rotScorer_rotScoresReg_0 <= 4'b0000;
        rotScorer_rotScoresReg_1 <= 4'b0000;
        rotScorer_rotScoresReg_2 <= 4'b0000;
        rotScorer_rotScoresReg_3 <= 4'b0000;
        rotScorer_rotScoresReg_4 <= 4'b0000;
        rotScorer_rotScoresReg_5 <= 4'b0000;
        rotScorer_rotScoresReg_6 <= 4'b0000;
        rotScorer_rotScoresReg_7 <= 4'b0000;
        rotScorer_sweepScore <= 4'b0000;
        rotScorer_sweepRot <= 3'b000;
        rotScorer_trainLatch <= 128'h0;
        training <= 1'b1;
        trainDone <= 1'b0;
        needPoison <= 1'b0;
        rclkpos <= 2'b00;
        rclksel <= 3'b000;
        init_done_latched <= 1'b0;
        rowOpen <= 1'b0;
        openBank <= 3'b000;
        openRow <= 14'h0;
        prechForReq <= 1'b0;
        wrStreamOpen <= 1'b0;
        wrHavePending <= 1'b0;
        wrExtraCnt <= 6'h0;
        wrCooldown <= 4'b0000;
        st1Valid <= 1'b0;
        st2Valid <= 1'b0;
        st3Valid <= 1'b0;
        rdStreamOpen <= 1'b0;
        rdHavePending <= 1'b0;
        rdExtraCnt <= 6'h0;
        rdRspLeft <= 6'h0;
        rburst_seen <= 2'b00;
        resetn_delay <= 1'b0;
        wserRstCnt <= 3'b000;
        wser_rst <= 1'b0;
        state <= Ddr3State_RST_WAIT;
      end
      dqPrevVec_0 <= io_phy_dq_in_0;
      dqPrevVec_1 <= io_phy_dq_in_1;
      dqPrevVec_2 <= io_phy_dq_in_2;
      dqPrevVec_3 <= io_phy_dq_in_3;
      dqPrevVec_4 <= io_phy_dq_in_4;
      dqPrevVec_5 <= io_phy_dq_in_5;
      dqPrevVec_6 <= io_phy_dq_in_6;
      dqPrevVec_7 <= io_phy_dq_in_7;
      if(when_Ddr3ControllerCore_l1997) begin
        init_done_latched <= 1'b1;
      end
    end
  end

  always @(posedge io_pclk) begin
    if(io_phy_rst_lock_n) begin
      if(when_Ddr3ControllerCore_l454) begin
        case(state)
          Ddr3State_RST_WAIT : begin
          end
          Ddr3State_CKE_WAIT : begin
          end
          Ddr3State_CONFIG_1 : begin
          end
          Ddr3State_ZQCL : begin
          end
          Ddr3State_WRITE_LEVELING : begin
          end
          Ddr3State_READ_CALIB : begin
            case(cycle)
              7'h0e : begin
                if(!when_Ddr3ControllerCore_l737) begin
                  if(dllSweepOn) begin
                    if(!when_Ddr3ControllerCore_l775) begin
                      if(when_Ddr3ControllerCore_l859) begin
                        if(!when_Ddr3ControllerCore_l874) begin
                          if(!when_Ddr3ControllerCore_l899) begin
                            if(when_Ddr3ControllerCore_l987) begin
                              reqReg_write <= 1'b1;
                              reqReg_addr <= 27'h0;
                              reqReg_wdata <= trainPat;
                              reqReg_wstrb <= 16'hffff;
                            end
                          end
                        end
                      end
                    end
                  end else begin
                    if(when_Ddr3ControllerCore_l1023) begin
                      if(when_Ddr3ControllerCore_l1030) begin
                        if(when_Ddr3ControllerCore_l1038) begin
                          if(when_Ddr3ControllerCore_l1040) begin
                            reqReg_write <= 1'b1;
                            reqReg_addr <= 27'h0;
                            reqReg_wdata <= trainPat;
                            reqReg_wstrb <= 16'hffff;
                          end else begin
                            if(when_Ddr3ControllerCore_l1053) begin
                              reqReg_write <= 1'b1;
                              reqReg_addr <= 27'h0;
                              reqReg_wdata <= trainPat;
                              reqReg_wstrb <= 16'hffff;
                            end else begin
                              reqReg_write <= 1'b1;
                              reqReg_addr <= 27'h0;
                              reqReg_wdata <= trainPat;
                              reqReg_wstrb <= 16'hffff;
                            end
                          end
                        end
                        if(!scanOn) begin
                          if(shiftCalDone) begin
                            if(!when_Ddr3ControllerCore_l1135) begin
                              if(when_Ddr3ControllerCore_l1172) begin
                                reqReg_write <= 1'b1;
                                reqReg_addr <= 27'h0;
                                reqReg_wdata <= trainPat;
                                reqReg_wstrb <= 16'hffff;
                              end
                            end
                          end
                        end
                      end else begin
                        if(when_Ddr3ControllerCore_l1217) begin
                          if(when_Ddr3ControllerCore_l1219) begin
                            reqReg_write <= 1'b1;
                            reqReg_addr <= 27'h0;
                            reqReg_wdata <= trainPat;
                            reqReg_wstrb <= 16'hffff;
                          end
                        end
                      end
                    end else begin
                      reqReg_write <= 1'b1;
                      reqReg_addr <= 27'h0;
                      reqReg_wdata <= trainPat;
                      reqReg_wstrb <= 16'hffff;
                    end
                  end
                end
              end
              default : begin
              end
            endcase
          end
          Ddr3State_IDLE : begin
            if(training) begin
              reqReg_write <= 1'b1;
              reqReg_addr <= 27'h0;
              reqReg_wdata <= trainPat;
              reqReg_wstrb <= 16'hffff;
            end else begin
              if(needPoison) begin
                reqReg_write <= 1'b1;
                reqReg_addr <= 27'h0000001;
                reqReg_wdata <= poisonPat;
                reqReg_wstrb <= 16'hffff;
              end else begin
                if(!refresh_due) begin
                  if(!needFinalSurvey) begin
                    if(io_req_valid) begin
                      reqReg_write <= io_req_payload_write;
                      reqReg_addr <= io_req_payload_addr;
                      reqReg_wdata <= io_req_payload_wdata;
                      reqReg_wstrb <= io_req_payload_wstrb;
                    end
                  end
                end
              end
            end
          end
          Ddr3State_PRECHARGE : begin
          end
          Ddr3State_READ : begin
            if(when_Ddr3ControllerCore_l1449) begin
              if(when_Ddr3ControllerCore_l1450) begin
                reqReg_write <= io_req_payload_write;
                reqReg_addr <= io_req_payload_addr;
                reqReg_wdata <= io_req_payload_wdata;
                reqReg_wstrb <= io_req_payload_wstrb;
              end
            end
          end
          Ddr3State_WRITE : begin
            if(!trainDone) begin
              if(when_Ddr3ControllerCore_l1660) begin
                st1Req_write <= reqReg_write;
                st1Req_addr <= reqReg_addr;
                st1Req_wdata <= reqReg_wdata;
                st1Req_wstrb <= reqReg_wstrb;
              end
              st2Req_write <= st1Req_write;
              st2Req_addr <= st1Req_addr;
              st2Req_wdata <= st1Req_wdata;
              st2Req_wstrb <= st1Req_wstrb;
              st3Req_write <= st2Req_write;
              st3Req_addr <= st2Req_addr;
              st3Req_wdata <= st2Req_wdata;
              st3Req_wstrb <= st2Req_wstrb;
              if(when_Ddr3ControllerCore_l1672) begin
                reqReg_write <= io_req_payload_write;
                reqReg_addr <= io_req_payload_addr;
                reqReg_wdata <= io_req_payload_wdata;
                reqReg_wstrb <= io_req_payload_wstrb;
              end
            end
          end
          default : begin
          end
        endcase
      end
    end
  end


endmodule

module DistLowLatencyFifo_1 (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [127:0]  io_push_payload_data,
  input  wire [15:0]   io_push_payload_strb,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [127:0]  io_pop_payload_data,
  output wire [15:0]   io_pop_payload_strb,
  output wire [4:0]    io_occupancy,
  input  wire          io_pclk,
  input  wire          _zz_4
);

  wire       [143:0]  ram_spinal_port0;
  wire       [143:0]  _zz_ram_port;
  wire       [3:0]    _zz_ptrDiff;
  reg                 _zz_1;
  reg        [3:0]    pushPtr;
  reg        [3:0]    popPtr;
  reg                 risingOccupancy;
  wire                ptrMatch;
  wire                empty;
  wire                full;
  wire       [143:0]  _zz_io_pop_payload_data;
  wire                io_push_fire;
  wire                io_pop_fire;
  wire                when_DistLowLatencyFifo_l41;
  wire       [4:0]    ptrDiff;
  (* syn_ramstyle = "distributed" , ram_style = "distributed" *) reg [143:0] ram [0:15];

  assign _zz_ptrDiff = (pushPtr - popPtr);
  assign _zz_ram_port = {io_push_payload_strb,io_push_payload_data};
  assign ram_spinal_port0 = ram[popPtr];
  always @(posedge io_pclk) begin
    if(_zz_1) begin
      ram[pushPtr] <= _zz_ram_port;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(io_push_fire) begin
      _zz_1 = 1'b1;
    end
  end

  assign ptrMatch = (pushPtr == popPtr);
  assign empty = (ptrMatch && (! risingOccupancy));
  assign full = (ptrMatch && risingOccupancy);
  assign io_push_ready = (! full);
  assign io_pop_valid = (! empty);
  assign _zz_io_pop_payload_data = ram_spinal_port0;
  assign io_pop_payload_data = _zz_io_pop_payload_data[127 : 0];
  assign io_pop_payload_strb = _zz_io_pop_payload_data[143 : 128];
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign io_pop_fire = (io_pop_valid && io_pop_ready);
  assign when_DistLowLatencyFifo_l41 = (io_push_fire != io_pop_fire);
  assign ptrDiff = {1'd0, _zz_ptrDiff};
  assign io_occupancy = (empty ? 5'h0 : (full ? 5'h10 : ptrDiff));
  always @(posedge io_pclk or posedge _zz_4) begin
    if(_zz_4) begin
      pushPtr <= 4'b0000;
      popPtr <= 4'b0000;
      risingOccupancy <= 1'b0;
    end else begin
      if(io_push_fire) begin
        pushPtr <= (pushPtr + 4'b0001);
      end
      if(io_pop_fire) begin
        popPtr <= (popPtr + 4'b0001);
      end
      if(when_DistLowLatencyFifo_l41) begin
        risingOccupancy <= io_push_fire;
      end
    end
  end


endmodule

module DistLowLatencyFifo (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [127:0]  io_push_payload,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [127:0]  io_pop_payload,
  output wire [4:0]    io_occupancy,
  input  wire          io_pclk,
  input  wire          _zz_4
);

  wire       [127:0]  ram_spinal_port0;
  wire       [3:0]    _zz_ptrDiff;
  reg                 _zz_1;
  reg        [3:0]    pushPtr;
  reg        [3:0]    popPtr;
  reg                 risingOccupancy;
  wire                ptrMatch;
  wire                empty;
  wire                full;
  wire                io_push_fire;
  wire                io_pop_fire;
  wire                when_DistLowLatencyFifo_l41;
  wire       [4:0]    ptrDiff;
  (* syn_ramstyle = "distributed" , ram_style = "distributed" *) reg [127:0] ram [0:15];

  assign _zz_ptrDiff = (pushPtr - popPtr);
  assign ram_spinal_port0 = ram[popPtr];
  always @(posedge io_pclk) begin
    if(_zz_1) begin
      ram[pushPtr] <= io_push_payload;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(io_push_fire) begin
      _zz_1 = 1'b1;
    end
  end

  assign ptrMatch = (pushPtr == popPtr);
  assign empty = (ptrMatch && (! risingOccupancy));
  assign full = (ptrMatch && risingOccupancy);
  assign io_push_ready = (! full);
  assign io_pop_valid = (! empty);
  assign io_pop_payload = ram_spinal_port0;
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign io_pop_fire = (io_pop_valid && io_pop_ready);
  assign when_DistLowLatencyFifo_l41 = (io_push_fire != io_pop_fire);
  assign ptrDiff = {1'd0, _zz_ptrDiff};
  assign io_occupancy = (empty ? 5'h0 : (full ? 5'h10 : ptrDiff));
  always @(posedge io_pclk or posedge _zz_4) begin
    if(_zz_4) begin
      pushPtr <= 4'b0000;
      popPtr <= 4'b0000;
      risingOccupancy <= 1'b0;
    end else begin
      if(io_push_fire) begin
        pushPtr <= (pushPtr + 4'b0001);
      end
      if(io_pop_fire) begin
        popPtr <= (popPtr + 4'b0001);
      end
      if(when_DistLowLatencyFifo_l41) begin
        risingOccupancy <= io_push_fire;
      end
    end
  end


endmodule
