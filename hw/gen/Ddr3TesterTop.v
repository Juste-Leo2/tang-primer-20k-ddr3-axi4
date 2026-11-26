// Generator : SpinalHDL v1.15.0    git head : 05a01af3d3345aa0afcaad8e0186dde13a359db2
// Component : Ddr3TesterTop
// Git hash  : 938d91df56096189ad7e0892f29e13a736de1626
// Date      : 26/11/2026, 21:40:24

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
  wire       [255:0]  coreArea_ddr3_io_wlMap;
  wire       [7:0]    coreArea_ddr3_io_wlFirst;
  wire       [7:0]    coreArea_ddr3_io_wlLast;
  wire       [7:0]    coreArea_ddr3_io_wlMatchN;
  wire       [1:0]    coreArea_ddr3_io_wr_adv;
  wire       [11:0]   coreArea_ddr3_io_w_scores;
  wire       [127:0]  coreArea_ddr3_io_train_latch;
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
    .io_wlMap                 (coreArea_ddr3_io_wlMap[255:0]                ), //o
    .io_wlFirst               (coreArea_ddr3_io_wlFirst[7:0]                ), //o
    .io_wlLast                (coreArea_ddr3_io_wlLast[7:0]                 ), //o
    .io_wlMatchN              (coreArea_ddr3_io_wlMatchN[7:0]               ), //o
    .io_wr_adv                (coreArea_ddr3_io_wr_adv[1:0]                 ), //o
    .io_w_scores              (coreArea_ddr3_io_w_scores[11:0]              ), //o
    .io_train_latch           (coreArea_ddr3_io_train_latch[127:0]          ), //o
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
    .io_wlMap                 (coreArea_ddr3_io_wlMap[255:0]                ), //i
    .io_wlFirst               (coreArea_ddr3_io_wlFirst[7:0]                ), //i
    .io_wlLast                (coreArea_ddr3_io_wlLast[7:0]                 ), //i
    .io_wlMatchN              (coreArea_ddr3_io_wlMatchN[7:0]               ), //i
    .io_wr_adv                (coreArea_ddr3_io_wr_adv[1:0]                 ), //i
    .io_w_scores              (coreArea_ddr3_io_w_scores[11:0]              ), //i
    .io_train_latch           (coreArea_ddr3_io_train_latch[127:0]          ), //i
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
  input  wire [255:0]  io_wlMap,
  input  wire [7:0]    io_wlFirst,
  input  wire [7:0]    io_wlLast,
  input  wire [7:0]    io_wlMatchN,
  input  wire [1:0]    io_wr_adv,
  input  wire [11:0]   io_w_scores,
  input  wire [127:0]  io_train_latch,
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
  localparam fsm_sPrintWlmap = 5'd5;
  localparam fsm_sPrintLatch = 5'd6;
  localparam fsm_sSingleWriteAW = 5'd7;
  localparam fsm_sSingleWriteW0 = 5'd8;
  localparam fsm_sSingleWriteW1 = 5'd9;
  localparam fsm_sSingleWriteB = 5'd10;
  localparam fsm_sSingleReadAR = 5'd11;
  localparam fsm_sSingleReadR0 = 5'd12;
  localparam fsm_sSingleReadR1 = 5'd13;
  localparam fsm_sBulkWriteAW = 5'd14;
  localparam fsm_sBulkWriteW = 5'd15;
  localparam fsm_sBulkWriteB = 5'd16;
  localparam fsm_sBulkReadAR = 5'd17;
  localparam fsm_sBulkReadR = 5'd18;
  localparam fsm_sReportPass = 5'd19;
  localparam fsm_sReportFail = 5'd20;
  localparam fsm_sLoopDelay = 5'd21;

  wire                uart_io_write_ready;
  wire                uart_io_txd;
  wire                uart_io_busy;
  wire       [14:0]   _zz_currentByteAddr;
  wire       [31:0]   _zz_beatBlockAddr;
  wire       [8:0]    _zz_beatBlockAddr_1;
  wire       [4:0]    _zz_beatBlockAddr_2;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65;
  wire       [7:0]    _zz__zz_printChar;
  wire       [7:0]    _zz__zz_printChar_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_1;
  wire       [7:0]    _zz__zz_printChar_1_1;
  wire       [7:0]    _zz__zz_printChar_1_2;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_2;
  wire       [7:0]    _zz__zz_printChar_2;
  wire       [7:0]    _zz__zz_printChar_2_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_3;
  wire       [7:0]    _zz__zz_printChar_3;
  wire       [7:0]    _zz__zz_printChar_3_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_4;
  wire       [7:0]    _zz__zz_printChar_4;
  wire       [7:0]    _zz__zz_printChar_4_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_5;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_5_1;
  wire       [7:0]    _zz__zz_printChar_5;
  wire       [7:0]    _zz__zz_printChar_5_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_6;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_6_1;
  wire       [7:0]    _zz__zz_printChar_6;
  wire       [7:0]    _zz__zz_printChar_6_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_7;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_7_1;
  wire       [2:0]    _zz__zz_when_Ddr3MemtestEngine_l65_7_2;
  wire       [7:0]    _zz__zz_printChar_7;
  wire       [7:0]    _zz__zz_printChar_7_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_8;
  wire       [7:0]    _zz__zz_printChar_8;
  wire       [7:0]    _zz__zz_printChar_8_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_9;
  wire       [7:0]    _zz__zz_printChar_9;
  wire       [7:0]    _zz__zz_printChar_9_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_10;
  wire       [7:0]    _zz__zz_printChar_10;
  wire       [7:0]    _zz__zz_printChar_10_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_11;
  wire       [7:0]    _zz__zz_printChar_11;
  wire       [7:0]    _zz__zz_printChar_11_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_12;
  wire       [7:0]    _zz__zz_printChar_12;
  wire       [7:0]    _zz__zz_printChar_12_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_13;
  wire       [7:0]    _zz__zz_printChar_13;
  wire       [7:0]    _zz__zz_printChar_13_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_14;
  wire       [7:0]    _zz__zz_printChar_14;
  wire       [7:0]    _zz__zz_printChar_14_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_15;
  reg        [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_15_1;
  wire       [5:0]    _zz__zz_when_Ddr3MemtestEngine_l65_15_2;
  wire       [5:0]    _zz__zz_when_Ddr3MemtestEngine_l65_15_3;
  wire       [6:0]    _zz__zz_when_Ddr3MemtestEngine_l65_15_4;
  wire       [7:0]    _zz__zz_printChar_15;
  wire       [7:0]    _zz__zz_printChar_15_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_16;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_16_1;
  wire       [7:0]    _zz__zz_printChar_16;
  wire       [7:0]    _zz__zz_printChar_16_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_17;
  wire       [7:0]    _zz__zz_printChar_17;
  wire       [7:0]    _zz__zz_printChar_17_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_18;
  wire       [7:0]    _zz__zz_printChar_18;
  wire       [7:0]    _zz__zz_printChar_18_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_19;
  wire       [7:0]    _zz__zz_printChar_19;
  wire       [7:0]    _zz__zz_printChar_19_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_20;
  reg        [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_20_1;
  wire       [4:0]    _zz__zz_when_Ddr3MemtestEngine_l65_20_2;
  wire       [4:0]    _zz__zz_when_Ddr3MemtestEngine_l65_20_3;
  wire       [6:0]    _zz__zz_when_Ddr3MemtestEngine_l65_20_4;
  wire       [7:0]    _zz__zz_printChar_20;
  wire       [7:0]    _zz__zz_printChar_20_1;
  wire       [31:0]   _zz_io_axi_w_payload_data;
  wire       [31:0]   _zz_io_axi_w_payload_data_1;
  wire       [10:0]   _zz_when_Ddr3MemtestEngine_l506;
  wire       [31:0]   _zz__zz_errExpected;
  wire       [31:0]   _zz__zz_errExpected_1;
  wire       [10:0]   _zz_when_Ddr3MemtestEngine_l545;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_21;
  wire       [7:0]    _zz__zz_printChar_21;
  wire       [7:0]    _zz__zz_printChar_21_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_22;
  wire       [7:0]    _zz__zz_printChar_22;
  wire       [7:0]    _zz__zz_printChar_22_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_23;
  wire       [7:0]    _zz__zz_printChar_23;
  wire       [7:0]    _zz__zz_printChar_23_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_24;
  wire       [7:0]    _zz__zz_printChar_24;
  wire       [7:0]    _zz__zz_printChar_24_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_25;
  wire       [7:0]    _zz__zz_printChar_25;
  wire       [7:0]    _zz__zz_printChar_25_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_26;
  wire       [7:0]    _zz__zz_printChar_26;
  wire       [7:0]    _zz__zz_printChar_26_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_27;
  wire       [7:0]    _zz__zz_printChar_27;
  wire       [7:0]    _zz__zz_printChar_27_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_28;
  wire       [7:0]    _zz__zz_printChar_28;
  wire       [7:0]    _zz__zz_printChar_28_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_29;
  wire       [7:0]    _zz__zz_printChar_29;
  wire       [7:0]    _zz__zz_printChar_29_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_30;
  wire       [7:0]    _zz__zz_printChar_30;
  wire       [7:0]    _zz__zz_printChar_30_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_31;
  wire       [7:0]    _zz__zz_printChar_31;
  wire       [7:0]    _zz__zz_printChar_31_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_32;
  wire       [7:0]    _zz__zz_printChar_32;
  wire       [7:0]    _zz__zz_printChar_32_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_33;
  wire       [7:0]    _zz__zz_printChar_33;
  wire       [7:0]    _zz__zz_printChar_33_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_34;
  wire       [7:0]    _zz__zz_printChar_34;
  wire       [7:0]    _zz__zz_printChar_34_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_35;
  wire       [7:0]    _zz__zz_printChar_35;
  wire       [7:0]    _zz__zz_printChar_35_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_36;
  wire       [7:0]    _zz__zz_printChar_36;
  wire       [7:0]    _zz__zz_printChar_36_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_37;
  wire       [7:0]    _zz__zz_printChar_37;
  wire       [7:0]    _zz__zz_printChar_37_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_38;
  wire       [7:0]    _zz__zz_printChar_38;
  wire       [7:0]    _zz__zz_printChar_38_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_39;
  wire       [7:0]    _zz__zz_printChar_39;
  wire       [7:0]    _zz__zz_printChar_39_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_40;
  wire       [7:0]    _zz__zz_printChar_40;
  wire       [7:0]    _zz__zz_printChar_40_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_41;
  wire       [7:0]    _zz__zz_printChar_41;
  wire       [7:0]    _zz__zz_printChar_41_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_42;
  wire       [7:0]    _zz__zz_printChar_42;
  wire       [7:0]    _zz__zz_printChar_42_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_43;
  wire       [7:0]    _zz__zz_printChar_43;
  wire       [7:0]    _zz__zz_printChar_43_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_44;
  wire       [7:0]    _zz__zz_printChar_44;
  wire       [7:0]    _zz__zz_printChar_44_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_45;
  wire       [7:0]    _zz__zz_printChar_45;
  wire       [7:0]    _zz__zz_printChar_45_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_46;
  wire       [7:0]    _zz__zz_printChar_46;
  wire       [7:0]    _zz__zz_printChar_46_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_47;
  wire       [7:0]    _zz__zz_printChar_47;
  wire       [7:0]    _zz__zz_printChar_47_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_48;
  wire       [7:0]    _zz__zz_printChar_48;
  wire       [7:0]    _zz__zz_printChar_48_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_49;
  wire       [7:0]    _zz__zz_printChar_49;
  wire       [7:0]    _zz__zz_printChar_49_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_50;
  wire       [7:0]    _zz__zz_printChar_50;
  wire       [7:0]    _zz__zz_printChar_50_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_51;
  wire       [7:0]    _zz__zz_printChar_51;
  wire       [7:0]    _zz__zz_printChar_51_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_52;
  wire       [7:0]    _zz__zz_printChar_52;
  wire       [7:0]    _zz__zz_printChar_52_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_53;
  wire       [7:0]    _zz__zz_printChar_53;
  wire       [7:0]    _zz__zz_printChar_53_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_54;
  wire       [7:0]    _zz__zz_printChar_54;
  wire       [7:0]    _zz__zz_printChar_54_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_55;
  wire       [7:0]    _zz__zz_printChar_55;
  wire       [7:0]    _zz__zz_printChar_55_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_56;
  wire       [7:0]    _zz__zz_printChar_56;
  wire       [7:0]    _zz__zz_printChar_56_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_57;
  wire       [7:0]    _zz__zz_printChar_57;
  wire       [7:0]    _zz__zz_printChar_57_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_58;
  wire       [7:0]    _zz__zz_printChar_58;
  wire       [7:0]    _zz__zz_printChar_58_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_59;
  wire       [7:0]    _zz__zz_printChar_59;
  wire       [7:0]    _zz__zz_printChar_59_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_60;
  wire       [7:0]    _zz__zz_printChar_60;
  wire       [7:0]    _zz__zz_printChar_60_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_61;
  wire       [7:0]    _zz__zz_printChar_61;
  wire       [7:0]    _zz__zz_printChar_61_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_62;
  wire       [7:0]    _zz__zz_printChar_62;
  wire       [7:0]    _zz__zz_printChar_62_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_63;
  wire       [7:0]    _zz__zz_printChar_63;
  wire       [7:0]    _zz__zz_printChar_63_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_64;
  wire       [7:0]    _zz__zz_printChar_64;
  wire       [7:0]    _zz__zz_printChar_64_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_65;
  wire       [7:0]    _zz__zz_printChar_65;
  wire       [7:0]    _zz__zz_printChar_65_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_66;
  wire       [7:0]    _zz__zz_printChar_66;
  wire       [7:0]    _zz__zz_printChar_66_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_67;
  wire       [7:0]    _zz__zz_printChar_67;
  wire       [7:0]    _zz__zz_printChar_67_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_68;
  wire       [7:0]    _zz__zz_printChar_68;
  wire       [7:0]    _zz__zz_printChar_68_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_69;
  wire       [7:0]    _zz__zz_printChar_69;
  wire       [7:0]    _zz__zz_printChar_69_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_70;
  wire       [7:0]    _zz__zz_printChar_70;
  wire       [7:0]    _zz__zz_printChar_70_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_71;
  wire       [7:0]    _zz__zz_printChar_71;
  wire       [7:0]    _zz__zz_printChar_71_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_72;
  wire       [7:0]    _zz__zz_printChar_72;
  wire       [7:0]    _zz__zz_printChar_72_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_73;
  wire       [7:0]    _zz__zz_printChar_73;
  wire       [7:0]    _zz__zz_printChar_73_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_74;
  wire       [7:0]    _zz__zz_printChar_74;
  wire       [7:0]    _zz__zz_printChar_74_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_75;
  wire       [7:0]    _zz__zz_printChar_75;
  wire       [7:0]    _zz__zz_printChar_75_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_76;
  wire       [7:0]    _zz__zz_printChar_76;
  wire       [7:0]    _zz__zz_printChar_76_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_77;
  wire       [7:0]    _zz__zz_printChar_77;
  wire       [7:0]    _zz__zz_printChar_77_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_78;
  wire       [7:0]    _zz__zz_printChar_78;
  wire       [7:0]    _zz__zz_printChar_78_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_79;
  wire       [7:0]    _zz__zz_printChar_79;
  wire       [7:0]    _zz__zz_printChar_79_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_80;
  wire       [7:0]    _zz__zz_printChar_80;
  wire       [7:0]    _zz__zz_printChar_80_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_81;
  wire       [7:0]    _zz__zz_printChar_81;
  wire       [7:0]    _zz__zz_printChar_81_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_82;
  wire       [7:0]    _zz__zz_printChar_82;
  wire       [7:0]    _zz__zz_printChar_82_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_83;
  wire       [7:0]    _zz__zz_printChar_83;
  wire       [7:0]    _zz__zz_printChar_83_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_84;
  wire       [7:0]    _zz__zz_printChar_84;
  wire       [7:0]    _zz__zz_printChar_84_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_85;
  wire       [7:0]    _zz__zz_printChar_85;
  wire       [7:0]    _zz__zz_printChar_85_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_86;
  wire       [7:0]    _zz__zz_printChar_86;
  wire       [7:0]    _zz__zz_printChar_86_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_87;
  wire       [7:0]    _zz__zz_printChar_87;
  wire       [7:0]    _zz__zz_printChar_87_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_88;
  wire       [7:0]    _zz__zz_printChar_88;
  wire       [7:0]    _zz__zz_printChar_88_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_89;
  wire       [7:0]    _zz__zz_printChar_89;
  wire       [7:0]    _zz__zz_printChar_89_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_90;
  wire       [7:0]    _zz__zz_printChar_90;
  wire       [7:0]    _zz__zz_printChar_90_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_91;
  wire       [7:0]    _zz__zz_printChar_91;
  wire       [7:0]    _zz__zz_printChar_91_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_92;
  wire       [7:0]    _zz__zz_printChar_92;
  wire       [7:0]    _zz__zz_printChar_92_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_93;
  wire       [7:0]    _zz__zz_printChar_93;
  wire       [7:0]    _zz__zz_printChar_93_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_94;
  wire       [7:0]    _zz__zz_printChar_94;
  wire       [7:0]    _zz__zz_printChar_94_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_95;
  wire       [7:0]    _zz__zz_printChar_95;
  wire       [7:0]    _zz__zz_printChar_95_1;
  wire       [3:0]    _zz__zz_when_Ddr3MemtestEngine_l65_96;
  wire       [7:0]    _zz__zz_printChar_96;
  wire       [7:0]    _zz__zz_printChar_96_1;
  wire                txStream_valid;
  wire                txStream_ready;
  wire       [7:0]    txStream_payload;
  reg                 printValid;
  reg        [7:0]    printChar;
  wire                printBusy;
  wire                txStream_fire;
  reg        [15:0]   passCount;
  reg                 errorReg;
  reg                 passReg;
  reg        [31:0]   errAddr;
  reg        [63:0]   errExpected;
  reg        [63:0]   errActual;
  reg        [63:0]   errActual1;
  reg        [24:0]   hbCounter;
  reg                 hbReg;
  wire                when_Ddr3MemtestEngine_l101;
  reg        [10:0]   burstIndex;
  reg        [5:0]    beatIdx;
  reg        [31:0]   wrCycleCnt;
  reg        [31:0]   rdCycleCnt;
  wire       [31:0]   currentByteAddr;
  wire       [31:0]   beatBlockAddr;
  wire       [3:0]    wlMapNib_0;
  wire       [3:0]    wlMapNib_1;
  wire       [3:0]    wlMapNib_2;
  wire       [3:0]    wlMapNib_3;
  wire       [3:0]    wlMapNib_4;
  wire       [3:0]    wlMapNib_5;
  wire       [3:0]    wlMapNib_6;
  wire       [3:0]    wlMapNib_7;
  wire       [3:0]    wlMapNib_8;
  wire       [3:0]    wlMapNib_9;
  wire       [3:0]    wlMapNib_10;
  wire       [3:0]    wlMapNib_11;
  wire       [3:0]    wlMapNib_12;
  wire       [3:0]    wlMapNib_13;
  wire       [3:0]    wlMapNib_14;
  wire       [3:0]    wlMapNib_15;
  wire       [3:0]    wlMapNib_16;
  wire       [3:0]    wlMapNib_17;
  wire       [3:0]    wlMapNib_18;
  wire       [3:0]    wlMapNib_19;
  wire       [3:0]    wlMapNib_20;
  wire       [3:0]    wlMapNib_21;
  wire       [3:0]    wlMapNib_22;
  wire       [3:0]    wlMapNib_23;
  wire       [3:0]    wlMapNib_24;
  wire       [3:0]    wlMapNib_25;
  wire       [3:0]    wlMapNib_26;
  wire       [3:0]    wlMapNib_27;
  wire       [3:0]    wlMapNib_28;
  wire       [3:0]    wlMapNib_29;
  wire       [3:0]    wlMapNib_30;
  wire       [3:0]    wlMapNib_31;
  wire       [3:0]    wlMapNib_32;
  wire       [3:0]    wlMapNib_33;
  wire       [3:0]    wlMapNib_34;
  wire       [3:0]    wlMapNib_35;
  wire       [3:0]    wlMapNib_36;
  wire       [3:0]    wlMapNib_37;
  wire       [3:0]    wlMapNib_38;
  wire       [3:0]    wlMapNib_39;
  wire       [3:0]    wlMapNib_40;
  wire       [3:0]    wlMapNib_41;
  wire       [3:0]    wlMapNib_42;
  wire       [3:0]    wlMapNib_43;
  wire       [3:0]    wlMapNib_44;
  wire       [3:0]    wlMapNib_45;
  wire       [3:0]    wlMapNib_46;
  wire       [3:0]    wlMapNib_47;
  wire       [3:0]    wlMapNib_48;
  wire       [3:0]    wlMapNib_49;
  wire       [3:0]    wlMapNib_50;
  wire       [3:0]    wlMapNib_51;
  wire       [3:0]    wlMapNib_52;
  wire       [3:0]    wlMapNib_53;
  wire       [3:0]    wlMapNib_54;
  wire       [3:0]    wlMapNib_55;
  wire       [3:0]    wlMapNib_56;
  wire       [3:0]    wlMapNib_57;
  wire       [3:0]    wlMapNib_58;
  wire       [3:0]    wlMapNib_59;
  wire       [3:0]    wlMapNib_60;
  wire       [3:0]    wlMapNib_61;
  wire       [3:0]    wlMapNib_62;
  wire       [3:0]    wlMapNib_63;
  wire       [3:0]    latchNib_0;
  wire       [3:0]    latchNib_1;
  wire       [3:0]    latchNib_2;
  wire       [3:0]    latchNib_3;
  wire       [3:0]    latchNib_4;
  wire       [3:0]    latchNib_5;
  wire       [3:0]    latchNib_6;
  wire       [3:0]    latchNib_7;
  wire       [3:0]    latchNib_8;
  wire       [3:0]    latchNib_9;
  wire       [3:0]    latchNib_10;
  wire       [3:0]    latchNib_11;
  wire       [3:0]    latchNib_12;
  wire       [3:0]    latchNib_13;
  wire       [3:0]    latchNib_14;
  wire       [3:0]    latchNib_15;
  wire       [3:0]    latchNib_16;
  wire       [3:0]    latchNib_17;
  wire       [3:0]    latchNib_18;
  wire       [3:0]    latchNib_19;
  wire       [3:0]    latchNib_20;
  wire       [3:0]    latchNib_21;
  wire       [3:0]    latchNib_22;
  wire       [3:0]    latchNib_23;
  wire       [3:0]    latchNib_24;
  wire       [3:0]    latchNib_25;
  wire       [3:0]    latchNib_26;
  wire       [3:0]    latchNib_27;
  wire       [3:0]    latchNib_28;
  wire       [3:0]    latchNib_29;
  wire       [3:0]    latchNib_30;
  wire       [3:0]    latchNib_31;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [6:0]    fsm_msgIndex;
  reg        [27:0]   fsm_delayCounter;
  reg        [4:0]    fsm_stateReg;
  reg        [4:0]    fsm_stateNext;
  wire                when_Ddr3MemtestEngine_l199;
  wire                when_Ddr3MemtestEngine_l231;
  wire                when_Ddr3MemtestEngine_l239;
  wire                when_Ddr3MemtestEngine_l250;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65;
  reg        [7:0]    _zz_printChar;
  wire                when_Ddr3MemtestEngine_l65;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_1;
  reg        [7:0]    _zz_printChar_1;
  wire                when_Ddr3MemtestEngine_l65_1;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_2;
  reg        [7:0]    _zz_printChar_2;
  wire                when_Ddr3MemtestEngine_l65_2;
  wire                when_Ddr3MemtestEngine_l277;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_3;
  reg        [7:0]    _zz_printChar_3;
  wire                when_Ddr3MemtestEngine_l65_3;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_4;
  reg        [7:0]    _zz_printChar_4;
  wire                when_Ddr3MemtestEngine_l65_4;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_5;
  reg        [7:0]    _zz_printChar_5;
  wire                when_Ddr3MemtestEngine_l65_5;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_6;
  reg        [7:0]    _zz_printChar_6;
  wire                when_Ddr3MemtestEngine_l65_6;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_7;
  reg        [7:0]    _zz_printChar_7;
  wire                when_Ddr3MemtestEngine_l65_7;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_8;
  reg        [7:0]    _zz_printChar_8;
  wire                when_Ddr3MemtestEngine_l65_8;
  wire                when_Ddr3MemtestEngine_l325;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_9;
  reg        [7:0]    _zz_printChar_9;
  wire                when_Ddr3MemtestEngine_l65_9;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_10;
  reg        [7:0]    _zz_printChar_10;
  wire                when_Ddr3MemtestEngine_l65_10;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_11;
  reg        [7:0]    _zz_printChar_11;
  wire                when_Ddr3MemtestEngine_l65_11;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_12;
  reg        [7:0]    _zz_printChar_12;
  wire                when_Ddr3MemtestEngine_l65_12;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_13;
  reg        [7:0]    _zz_printChar_13;
  wire                when_Ddr3MemtestEngine_l65_13;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_14;
  reg        [7:0]    _zz_printChar_14;
  wire                when_Ddr3MemtestEngine_l65_14;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_15;
  reg        [7:0]    _zz_printChar_15;
  wire                when_Ddr3MemtestEngine_l65_15;
  wire                when_Ddr3MemtestEngine_l365;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_16;
  reg        [7:0]    _zz_printChar_16;
  wire                when_Ddr3MemtestEngine_l65_16;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_17;
  reg        [7:0]    _zz_printChar_17;
  wire                when_Ddr3MemtestEngine_l65_17;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_18;
  reg        [7:0]    _zz_printChar_18;
  wire                when_Ddr3MemtestEngine_l65_18;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_19;
  reg        [7:0]    _zz_printChar_19;
  wire                when_Ddr3MemtestEngine_l65_19;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_20;
  reg        [7:0]    _zz_printChar_20;
  wire                when_Ddr3MemtestEngine_l65_20;
  wire                when_Ddr3MemtestEngine_l442;
  wire                when_Ddr3MemtestEngine_l458;
  wire                when_Ddr3MemtestEngine_l464;
  wire                when_Ddr3MemtestEngine_l495;
  wire                when_Ddr3MemtestEngine_l506;
  wire       [63:0]   _zz_errExpected;
  wire                _zz_when_Ddr3MemtestEngine_l534;
  wire                when_Ddr3MemtestEngine_l534;
  wire                when_Ddr3MemtestEngine_l540;
  wire                when_Ddr3MemtestEngine_l544;
  wire                when_Ddr3MemtestEngine_l545;
  wire                when_Ddr3MemtestEngine_l562;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_21;
  reg        [7:0]    _zz_printChar_21;
  wire                when_Ddr3MemtestEngine_l65_21;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_22;
  reg        [7:0]    _zz_printChar_22;
  wire                when_Ddr3MemtestEngine_l65_22;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_23;
  reg        [7:0]    _zz_printChar_23;
  wire                when_Ddr3MemtestEngine_l65_23;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_24;
  reg        [7:0]    _zz_printChar_24;
  wire                when_Ddr3MemtestEngine_l65_24;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_25;
  reg        [7:0]    _zz_printChar_25;
  wire                when_Ddr3MemtestEngine_l65_25;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_26;
  reg        [7:0]    _zz_printChar_26;
  wire                when_Ddr3MemtestEngine_l65_26;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_27;
  reg        [7:0]    _zz_printChar_27;
  wire                when_Ddr3MemtestEngine_l65_27;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_28;
  reg        [7:0]    _zz_printChar_28;
  wire                when_Ddr3MemtestEngine_l65_28;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_29;
  reg        [7:0]    _zz_printChar_29;
  wire                when_Ddr3MemtestEngine_l65_29;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_30;
  reg        [7:0]    _zz_printChar_30;
  wire                when_Ddr3MemtestEngine_l65_30;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_31;
  reg        [7:0]    _zz_printChar_31;
  wire                when_Ddr3MemtestEngine_l65_31;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_32;
  reg        [7:0]    _zz_printChar_32;
  wire                when_Ddr3MemtestEngine_l65_32;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_33;
  reg        [7:0]    _zz_printChar_33;
  wire                when_Ddr3MemtestEngine_l65_33;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_34;
  reg        [7:0]    _zz_printChar_34;
  wire                when_Ddr3MemtestEngine_l65_34;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_35;
  reg        [7:0]    _zz_printChar_35;
  wire                when_Ddr3MemtestEngine_l65_35;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_36;
  reg        [7:0]    _zz_printChar_36;
  wire                when_Ddr3MemtestEngine_l65_36;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_37;
  reg        [7:0]    _zz_printChar_37;
  wire                when_Ddr3MemtestEngine_l65_37;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_38;
  reg        [7:0]    _zz_printChar_38;
  wire                when_Ddr3MemtestEngine_l65_38;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_39;
  reg        [7:0]    _zz_printChar_39;
  wire                when_Ddr3MemtestEngine_l65_39;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_40;
  reg        [7:0]    _zz_printChar_40;
  wire                when_Ddr3MemtestEngine_l65_40;
  wire                when_Ddr3MemtestEngine_l610;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_41;
  reg        [7:0]    _zz_printChar_41;
  wire                when_Ddr3MemtestEngine_l65_41;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_42;
  reg        [7:0]    _zz_printChar_42;
  wire                when_Ddr3MemtestEngine_l65_42;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_43;
  reg        [7:0]    _zz_printChar_43;
  wire                when_Ddr3MemtestEngine_l65_43;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_44;
  reg        [7:0]    _zz_printChar_44;
  wire                when_Ddr3MemtestEngine_l65_44;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_45;
  reg        [7:0]    _zz_printChar_45;
  wire                when_Ddr3MemtestEngine_l65_45;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_46;
  reg        [7:0]    _zz_printChar_46;
  wire                when_Ddr3MemtestEngine_l65_46;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_47;
  reg        [7:0]    _zz_printChar_47;
  wire                when_Ddr3MemtestEngine_l65_47;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_48;
  reg        [7:0]    _zz_printChar_48;
  wire                when_Ddr3MemtestEngine_l65_48;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_49;
  reg        [7:0]    _zz_printChar_49;
  wire                when_Ddr3MemtestEngine_l65_49;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_50;
  reg        [7:0]    _zz_printChar_50;
  wire                when_Ddr3MemtestEngine_l65_50;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_51;
  reg        [7:0]    _zz_printChar_51;
  wire                when_Ddr3MemtestEngine_l65_51;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_52;
  reg        [7:0]    _zz_printChar_52;
  wire                when_Ddr3MemtestEngine_l65_52;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_53;
  reg        [7:0]    _zz_printChar_53;
  wire                when_Ddr3MemtestEngine_l65_53;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_54;
  reg        [7:0]    _zz_printChar_54;
  wire                when_Ddr3MemtestEngine_l65_54;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_55;
  reg        [7:0]    _zz_printChar_55;
  wire                when_Ddr3MemtestEngine_l65_55;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_56;
  reg        [7:0]    _zz_printChar_56;
  wire                when_Ddr3MemtestEngine_l65_56;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_57;
  reg        [7:0]    _zz_printChar_57;
  wire                when_Ddr3MemtestEngine_l65_57;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_58;
  reg        [7:0]    _zz_printChar_58;
  wire                when_Ddr3MemtestEngine_l65_58;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_59;
  reg        [7:0]    _zz_printChar_59;
  wire                when_Ddr3MemtestEngine_l65_59;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_60;
  reg        [7:0]    _zz_printChar_60;
  wire                when_Ddr3MemtestEngine_l65_60;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_61;
  reg        [7:0]    _zz_printChar_61;
  wire                when_Ddr3MemtestEngine_l65_61;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_62;
  reg        [7:0]    _zz_printChar_62;
  wire                when_Ddr3MemtestEngine_l65_62;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_63;
  reg        [7:0]    _zz_printChar_63;
  wire                when_Ddr3MemtestEngine_l65_63;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_64;
  reg        [7:0]    _zz_printChar_64;
  wire                when_Ddr3MemtestEngine_l65_64;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_65;
  reg        [7:0]    _zz_printChar_65;
  wire                when_Ddr3MemtestEngine_l65_65;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_66;
  reg        [7:0]    _zz_printChar_66;
  wire                when_Ddr3MemtestEngine_l65_66;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_67;
  reg        [7:0]    _zz_printChar_67;
  wire                when_Ddr3MemtestEngine_l65_67;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_68;
  reg        [7:0]    _zz_printChar_68;
  wire                when_Ddr3MemtestEngine_l65_68;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_69;
  reg        [7:0]    _zz_printChar_69;
  wire                when_Ddr3MemtestEngine_l65_69;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_70;
  reg        [7:0]    _zz_printChar_70;
  wire                when_Ddr3MemtestEngine_l65_70;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_71;
  reg        [7:0]    _zz_printChar_71;
  wire                when_Ddr3MemtestEngine_l65_71;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_72;
  reg        [7:0]    _zz_printChar_72;
  wire                when_Ddr3MemtestEngine_l65_72;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_73;
  reg        [7:0]    _zz_printChar_73;
  wire                when_Ddr3MemtestEngine_l65_73;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_74;
  reg        [7:0]    _zz_printChar_74;
  wire                when_Ddr3MemtestEngine_l65_74;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_75;
  reg        [7:0]    _zz_printChar_75;
  wire                when_Ddr3MemtestEngine_l65_75;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_76;
  reg        [7:0]    _zz_printChar_76;
  wire                when_Ddr3MemtestEngine_l65_76;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_77;
  reg        [7:0]    _zz_printChar_77;
  wire                when_Ddr3MemtestEngine_l65_77;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_78;
  reg        [7:0]    _zz_printChar_78;
  wire                when_Ddr3MemtestEngine_l65_78;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_79;
  reg        [7:0]    _zz_printChar_79;
  wire                when_Ddr3MemtestEngine_l65_79;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_80;
  reg        [7:0]    _zz_printChar_80;
  wire                when_Ddr3MemtestEngine_l65_80;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_81;
  reg        [7:0]    _zz_printChar_81;
  wire                when_Ddr3MemtestEngine_l65_81;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_82;
  reg        [7:0]    _zz_printChar_82;
  wire                when_Ddr3MemtestEngine_l65_82;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_83;
  reg        [7:0]    _zz_printChar_83;
  wire                when_Ddr3MemtestEngine_l65_83;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_84;
  reg        [7:0]    _zz_printChar_84;
  wire                when_Ddr3MemtestEngine_l65_84;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_85;
  reg        [7:0]    _zz_printChar_85;
  wire                when_Ddr3MemtestEngine_l65_85;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_86;
  reg        [7:0]    _zz_printChar_86;
  wire                when_Ddr3MemtestEngine_l65_86;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_87;
  reg        [7:0]    _zz_printChar_87;
  wire                when_Ddr3MemtestEngine_l65_87;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_88;
  reg        [7:0]    _zz_printChar_88;
  wire                when_Ddr3MemtestEngine_l65_88;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_89;
  reg        [7:0]    _zz_printChar_89;
  wire                when_Ddr3MemtestEngine_l65_89;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_90;
  reg        [7:0]    _zz_printChar_90;
  wire                when_Ddr3MemtestEngine_l65_90;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_91;
  reg        [7:0]    _zz_printChar_91;
  wire                when_Ddr3MemtestEngine_l65_91;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_92;
  reg        [7:0]    _zz_printChar_92;
  wire                when_Ddr3MemtestEngine_l65_92;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_93;
  reg        [7:0]    _zz_printChar_93;
  wire                when_Ddr3MemtestEngine_l65_93;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_94;
  reg        [7:0]    _zz_printChar_94;
  wire                when_Ddr3MemtestEngine_l65_94;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_95;
  reg        [7:0]    _zz_printChar_95;
  wire                when_Ddr3MemtestEngine_l65_95;
  wire       [7:0]    _zz_when_Ddr3MemtestEngine_l65_96;
  reg        [7:0]    _zz_printChar_96;
  wire                when_Ddr3MemtestEngine_l65_96;
  wire                when_Ddr3MemtestEngine_l698;
  `ifndef SYNTHESIS
  reg [111:0] fsm_stateReg_string;
  reg [111:0] fsm_stateNext_string;
  `endif


  assign _zz_currentByteAddr = ({4'd0,burstIndex} <<< 3'd4);
  assign _zz_beatBlockAddr_1 = ({4'd0,_zz_beatBlockAddr_2} <<< 3'd4);
  assign _zz_beatBlockAddr = {23'd0, _zz_beatBlockAddr_1};
  assign _zz_beatBlockAddr_2 = (beatIdx >>> 1'd1);
  assign _zz__zz_when_Ddr3MemtestEngine_l65 = io_dbg_state;
  assign _zz__zz_printChar = (_zz_when_Ddr3MemtestEngine_l65 + 8'h30);
  assign _zz__zz_printChar_1 = (_zz_when_Ddr3MemtestEngine_l65 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_1 = io_wstep[7 : 4];
  assign _zz__zz_printChar_1_1 = (_zz_when_Ddr3MemtestEngine_l65_1 + 8'h30);
  assign _zz__zz_printChar_1_2 = (_zz_when_Ddr3MemtestEngine_l65_1 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_2 = io_wstep[3 : 0];
  assign _zz__zz_printChar_2 = (_zz_when_Ddr3MemtestEngine_l65_2 + 8'h30);
  assign _zz__zz_printChar_2_1 = (_zz_when_Ddr3MemtestEngine_l65_2 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_3 = io_wstep[7 : 4];
  assign _zz__zz_printChar_3 = (_zz_when_Ddr3MemtestEngine_l65_3 + 8'h30);
  assign _zz__zz_printChar_3_1 = (_zz_when_Ddr3MemtestEngine_l65_3 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_4 = io_wstep[3 : 0];
  assign _zz__zz_printChar_4 = (_zz_when_Ddr3MemtestEngine_l65_4 + 8'h30);
  assign _zz__zz_printChar_4_1 = (_zz_when_Ddr3MemtestEngine_l65_4 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_5 = _zz__zz_when_Ddr3MemtestEngine_l65_5_1;
  assign _zz__zz_when_Ddr3MemtestEngine_l65_5_1 = {2'd0, io_rclkpos};
  assign _zz__zz_printChar_5 = (_zz_when_Ddr3MemtestEngine_l65_5 + 8'h30);
  assign _zz__zz_printChar_5_1 = (_zz_when_Ddr3MemtestEngine_l65_5 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_6 = _zz__zz_when_Ddr3MemtestEngine_l65_6_1;
  assign _zz__zz_when_Ddr3MemtestEngine_l65_6_1 = {1'd0, io_rclksel};
  assign _zz__zz_printChar_6 = (_zz_when_Ddr3MemtestEngine_l65_6 + 8'h30);
  assign _zz__zz_printChar_6_1 = (_zz_when_Ddr3MemtestEngine_l65_6 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_7 = _zz__zz_when_Ddr3MemtestEngine_l65_7_1;
  assign _zz__zz_when_Ddr3MemtestEngine_l65_7_2 = io_best_rot;
  assign _zz__zz_when_Ddr3MemtestEngine_l65_7_1 = {1'd0, _zz__zz_when_Ddr3MemtestEngine_l65_7_2};
  assign _zz__zz_printChar_7 = (_zz_when_Ddr3MemtestEngine_l65_7 + 8'h30);
  assign _zz__zz_printChar_7_1 = (_zz_when_Ddr3MemtestEngine_l65_7 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_8 = io_best_score;
  assign _zz__zz_printChar_8 = (_zz_when_Ddr3MemtestEngine_l65_8 + 8'h30);
  assign _zz__zz_printChar_8_1 = (_zz_when_Ddr3MemtestEngine_l65_8 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_9 = io_wlFirst[7 : 4];
  assign _zz__zz_printChar_9 = (_zz_when_Ddr3MemtestEngine_l65_9 + 8'h30);
  assign _zz__zz_printChar_9_1 = (_zz_when_Ddr3MemtestEngine_l65_9 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_10 = io_wlFirst[3 : 0];
  assign _zz__zz_printChar_10 = (_zz_when_Ddr3MemtestEngine_l65_10 + 8'h30);
  assign _zz__zz_printChar_10_1 = (_zz_when_Ddr3MemtestEngine_l65_10 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_11 = io_wlLast[7 : 4];
  assign _zz__zz_printChar_11 = (_zz_when_Ddr3MemtestEngine_l65_11 + 8'h30);
  assign _zz__zz_printChar_11_1 = (_zz_when_Ddr3MemtestEngine_l65_11 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_12 = io_wlLast[3 : 0];
  assign _zz__zz_printChar_12 = (_zz_when_Ddr3MemtestEngine_l65_12 + 8'h30);
  assign _zz__zz_printChar_12_1 = (_zz_when_Ddr3MemtestEngine_l65_12 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_13 = io_wlMatchN[7 : 4];
  assign _zz__zz_printChar_13 = (_zz_when_Ddr3MemtestEngine_l65_13 + 8'h30);
  assign _zz__zz_printChar_13_1 = (_zz_when_Ddr3MemtestEngine_l65_13 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_14 = io_wlMatchN[3 : 0];
  assign _zz__zz_printChar_14 = (_zz_when_Ddr3MemtestEngine_l65_14 + 8'h30);
  assign _zz__zz_printChar_14_1 = (_zz_when_Ddr3MemtestEngine_l65_14 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_15 = _zz__zz_when_Ddr3MemtestEngine_l65_15_1;
  assign _zz__zz_when_Ddr3MemtestEngine_l65_15_2 = (6'h3f - _zz__zz_when_Ddr3MemtestEngine_l65_15_3);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_15_4 = (fsm_msgIndex - 7'h1a);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_15_3 = _zz__zz_when_Ddr3MemtestEngine_l65_15_4[5:0];
  assign _zz__zz_printChar_15 = (_zz_when_Ddr3MemtestEngine_l65_15 + 8'h30);
  assign _zz__zz_printChar_15_1 = (_zz_when_Ddr3MemtestEngine_l65_15 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_16 = _zz__zz_when_Ddr3MemtestEngine_l65_16_1;
  assign _zz__zz_when_Ddr3MemtestEngine_l65_16_1 = {2'd0, io_wr_adv};
  assign _zz__zz_printChar_16 = (_zz_when_Ddr3MemtestEngine_l65_16 + 8'h30);
  assign _zz__zz_printChar_16_1 = (_zz_when_Ddr3MemtestEngine_l65_16 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_17 = io_w_scores[3 : 0];
  assign _zz__zz_printChar_17 = (_zz_when_Ddr3MemtestEngine_l65_17 + 8'h30);
  assign _zz__zz_printChar_17_1 = (_zz_when_Ddr3MemtestEngine_l65_17 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_18 = io_w_scores[7 : 4];
  assign _zz__zz_printChar_18 = (_zz_when_Ddr3MemtestEngine_l65_18 + 8'h30);
  assign _zz__zz_printChar_18_1 = (_zz_when_Ddr3MemtestEngine_l65_18 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_19 = io_w_scores[11 : 8];
  assign _zz__zz_printChar_19 = (_zz_when_Ddr3MemtestEngine_l65_19 + 8'h30);
  assign _zz__zz_printChar_19_1 = (_zz_when_Ddr3MemtestEngine_l65_19 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_20 = _zz__zz_when_Ddr3MemtestEngine_l65_20_1;
  assign _zz__zz_when_Ddr3MemtestEngine_l65_20_2 = (5'h1f - _zz__zz_when_Ddr3MemtestEngine_l65_20_3);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_20_4 = (fsm_msgIndex - 7'h14);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_20_3 = _zz__zz_when_Ddr3MemtestEngine_l65_20_4[4:0];
  assign _zz__zz_printChar_20 = (_zz_when_Ddr3MemtestEngine_l65_20 + 8'h30);
  assign _zz__zz_printChar_20_1 = (_zz_when_Ddr3MemtestEngine_l65_20 + 8'h37);
  assign _zz_io_axi_w_payload_data = (beatBlockAddr + 32'h00000002);
  assign _zz_io_axi_w_payload_data_1 = (beatBlockAddr + 32'h00000001);
  assign _zz_when_Ddr3MemtestEngine_l506 = (burstIndex + 11'h010);
  assign _zz__zz_errExpected = (beatBlockAddr + 32'h00000002);
  assign _zz__zz_errExpected_1 = (beatBlockAddr + 32'h00000001);
  assign _zz_when_Ddr3MemtestEngine_l545 = (burstIndex + 11'h010);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_21 = passCount[15 : 12];
  assign _zz__zz_printChar_21 = (_zz_when_Ddr3MemtestEngine_l65_21 + 8'h30);
  assign _zz__zz_printChar_21_1 = (_zz_when_Ddr3MemtestEngine_l65_21 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_22 = passCount[11 : 8];
  assign _zz__zz_printChar_22 = (_zz_when_Ddr3MemtestEngine_l65_22 + 8'h30);
  assign _zz__zz_printChar_22_1 = (_zz_when_Ddr3MemtestEngine_l65_22 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_23 = passCount[7 : 4];
  assign _zz__zz_printChar_23 = (_zz_when_Ddr3MemtestEngine_l65_23 + 8'h30);
  assign _zz__zz_printChar_23_1 = (_zz_when_Ddr3MemtestEngine_l65_23 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_24 = passCount[3 : 0];
  assign _zz__zz_printChar_24 = (_zz_when_Ddr3MemtestEngine_l65_24 + 8'h30);
  assign _zz__zz_printChar_24_1 = (_zz_when_Ddr3MemtestEngine_l65_24 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_25 = wrCycleCnt[31 : 28];
  assign _zz__zz_printChar_25 = (_zz_when_Ddr3MemtestEngine_l65_25 + 8'h30);
  assign _zz__zz_printChar_25_1 = (_zz_when_Ddr3MemtestEngine_l65_25 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_26 = wrCycleCnt[27 : 24];
  assign _zz__zz_printChar_26 = (_zz_when_Ddr3MemtestEngine_l65_26 + 8'h30);
  assign _zz__zz_printChar_26_1 = (_zz_when_Ddr3MemtestEngine_l65_26 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_27 = wrCycleCnt[23 : 20];
  assign _zz__zz_printChar_27 = (_zz_when_Ddr3MemtestEngine_l65_27 + 8'h30);
  assign _zz__zz_printChar_27_1 = (_zz_when_Ddr3MemtestEngine_l65_27 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_28 = wrCycleCnt[19 : 16];
  assign _zz__zz_printChar_28 = (_zz_when_Ddr3MemtestEngine_l65_28 + 8'h30);
  assign _zz__zz_printChar_28_1 = (_zz_when_Ddr3MemtestEngine_l65_28 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_29 = wrCycleCnt[15 : 12];
  assign _zz__zz_printChar_29 = (_zz_when_Ddr3MemtestEngine_l65_29 + 8'h30);
  assign _zz__zz_printChar_29_1 = (_zz_when_Ddr3MemtestEngine_l65_29 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_30 = wrCycleCnt[11 : 8];
  assign _zz__zz_printChar_30 = (_zz_when_Ddr3MemtestEngine_l65_30 + 8'h30);
  assign _zz__zz_printChar_30_1 = (_zz_when_Ddr3MemtestEngine_l65_30 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_31 = wrCycleCnt[7 : 4];
  assign _zz__zz_printChar_31 = (_zz_when_Ddr3MemtestEngine_l65_31 + 8'h30);
  assign _zz__zz_printChar_31_1 = (_zz_when_Ddr3MemtestEngine_l65_31 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_32 = wrCycleCnt[3 : 0];
  assign _zz__zz_printChar_32 = (_zz_when_Ddr3MemtestEngine_l65_32 + 8'h30);
  assign _zz__zz_printChar_32_1 = (_zz_when_Ddr3MemtestEngine_l65_32 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_33 = rdCycleCnt[31 : 28];
  assign _zz__zz_printChar_33 = (_zz_when_Ddr3MemtestEngine_l65_33 + 8'h30);
  assign _zz__zz_printChar_33_1 = (_zz_when_Ddr3MemtestEngine_l65_33 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_34 = rdCycleCnt[27 : 24];
  assign _zz__zz_printChar_34 = (_zz_when_Ddr3MemtestEngine_l65_34 + 8'h30);
  assign _zz__zz_printChar_34_1 = (_zz_when_Ddr3MemtestEngine_l65_34 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_35 = rdCycleCnt[23 : 20];
  assign _zz__zz_printChar_35 = (_zz_when_Ddr3MemtestEngine_l65_35 + 8'h30);
  assign _zz__zz_printChar_35_1 = (_zz_when_Ddr3MemtestEngine_l65_35 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_36 = rdCycleCnt[19 : 16];
  assign _zz__zz_printChar_36 = (_zz_when_Ddr3MemtestEngine_l65_36 + 8'h30);
  assign _zz__zz_printChar_36_1 = (_zz_when_Ddr3MemtestEngine_l65_36 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_37 = rdCycleCnt[15 : 12];
  assign _zz__zz_printChar_37 = (_zz_when_Ddr3MemtestEngine_l65_37 + 8'h30);
  assign _zz__zz_printChar_37_1 = (_zz_when_Ddr3MemtestEngine_l65_37 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_38 = rdCycleCnt[11 : 8];
  assign _zz__zz_printChar_38 = (_zz_when_Ddr3MemtestEngine_l65_38 + 8'h30);
  assign _zz__zz_printChar_38_1 = (_zz_when_Ddr3MemtestEngine_l65_38 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_39 = rdCycleCnt[7 : 4];
  assign _zz__zz_printChar_39 = (_zz_when_Ddr3MemtestEngine_l65_39 + 8'h30);
  assign _zz__zz_printChar_39_1 = (_zz_when_Ddr3MemtestEngine_l65_39 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_40 = rdCycleCnt[3 : 0];
  assign _zz__zz_printChar_40 = (_zz_when_Ddr3MemtestEngine_l65_40 + 8'h30);
  assign _zz__zz_printChar_40_1 = (_zz_when_Ddr3MemtestEngine_l65_40 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_41 = errAddr[31 : 28];
  assign _zz__zz_printChar_41 = (_zz_when_Ddr3MemtestEngine_l65_41 + 8'h30);
  assign _zz__zz_printChar_41_1 = (_zz_when_Ddr3MemtestEngine_l65_41 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_42 = errAddr[27 : 24];
  assign _zz__zz_printChar_42 = (_zz_when_Ddr3MemtestEngine_l65_42 + 8'h30);
  assign _zz__zz_printChar_42_1 = (_zz_when_Ddr3MemtestEngine_l65_42 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_43 = errAddr[23 : 20];
  assign _zz__zz_printChar_43 = (_zz_when_Ddr3MemtestEngine_l65_43 + 8'h30);
  assign _zz__zz_printChar_43_1 = (_zz_when_Ddr3MemtestEngine_l65_43 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_44 = errAddr[19 : 16];
  assign _zz__zz_printChar_44 = (_zz_when_Ddr3MemtestEngine_l65_44 + 8'h30);
  assign _zz__zz_printChar_44_1 = (_zz_when_Ddr3MemtestEngine_l65_44 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_45 = errAddr[15 : 12];
  assign _zz__zz_printChar_45 = (_zz_when_Ddr3MemtestEngine_l65_45 + 8'h30);
  assign _zz__zz_printChar_45_1 = (_zz_when_Ddr3MemtestEngine_l65_45 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_46 = errAddr[11 : 8];
  assign _zz__zz_printChar_46 = (_zz_when_Ddr3MemtestEngine_l65_46 + 8'h30);
  assign _zz__zz_printChar_46_1 = (_zz_when_Ddr3MemtestEngine_l65_46 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_47 = errAddr[7 : 4];
  assign _zz__zz_printChar_47 = (_zz_when_Ddr3MemtestEngine_l65_47 + 8'h30);
  assign _zz__zz_printChar_47_1 = (_zz_when_Ddr3MemtestEngine_l65_47 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_48 = errAddr[3 : 0];
  assign _zz__zz_printChar_48 = (_zz_when_Ddr3MemtestEngine_l65_48 + 8'h30);
  assign _zz__zz_printChar_48_1 = (_zz_when_Ddr3MemtestEngine_l65_48 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_49 = errExpected[63 : 60];
  assign _zz__zz_printChar_49 = (_zz_when_Ddr3MemtestEngine_l65_49 + 8'h30);
  assign _zz__zz_printChar_49_1 = (_zz_when_Ddr3MemtestEngine_l65_49 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_50 = errExpected[59 : 56];
  assign _zz__zz_printChar_50 = (_zz_when_Ddr3MemtestEngine_l65_50 + 8'h30);
  assign _zz__zz_printChar_50_1 = (_zz_when_Ddr3MemtestEngine_l65_50 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_51 = errExpected[55 : 52];
  assign _zz__zz_printChar_51 = (_zz_when_Ddr3MemtestEngine_l65_51 + 8'h30);
  assign _zz__zz_printChar_51_1 = (_zz_when_Ddr3MemtestEngine_l65_51 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_52 = errExpected[51 : 48];
  assign _zz__zz_printChar_52 = (_zz_when_Ddr3MemtestEngine_l65_52 + 8'h30);
  assign _zz__zz_printChar_52_1 = (_zz_when_Ddr3MemtestEngine_l65_52 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_53 = errExpected[47 : 44];
  assign _zz__zz_printChar_53 = (_zz_when_Ddr3MemtestEngine_l65_53 + 8'h30);
  assign _zz__zz_printChar_53_1 = (_zz_when_Ddr3MemtestEngine_l65_53 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_54 = errExpected[43 : 40];
  assign _zz__zz_printChar_54 = (_zz_when_Ddr3MemtestEngine_l65_54 + 8'h30);
  assign _zz__zz_printChar_54_1 = (_zz_when_Ddr3MemtestEngine_l65_54 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_55 = errExpected[39 : 36];
  assign _zz__zz_printChar_55 = (_zz_when_Ddr3MemtestEngine_l65_55 + 8'h30);
  assign _zz__zz_printChar_55_1 = (_zz_when_Ddr3MemtestEngine_l65_55 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_56 = errExpected[35 : 32];
  assign _zz__zz_printChar_56 = (_zz_when_Ddr3MemtestEngine_l65_56 + 8'h30);
  assign _zz__zz_printChar_56_1 = (_zz_when_Ddr3MemtestEngine_l65_56 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_57 = errExpected[31 : 28];
  assign _zz__zz_printChar_57 = (_zz_when_Ddr3MemtestEngine_l65_57 + 8'h30);
  assign _zz__zz_printChar_57_1 = (_zz_when_Ddr3MemtestEngine_l65_57 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_58 = errExpected[27 : 24];
  assign _zz__zz_printChar_58 = (_zz_when_Ddr3MemtestEngine_l65_58 + 8'h30);
  assign _zz__zz_printChar_58_1 = (_zz_when_Ddr3MemtestEngine_l65_58 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_59 = errExpected[23 : 20];
  assign _zz__zz_printChar_59 = (_zz_when_Ddr3MemtestEngine_l65_59 + 8'h30);
  assign _zz__zz_printChar_59_1 = (_zz_when_Ddr3MemtestEngine_l65_59 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_60 = errExpected[19 : 16];
  assign _zz__zz_printChar_60 = (_zz_when_Ddr3MemtestEngine_l65_60 + 8'h30);
  assign _zz__zz_printChar_60_1 = (_zz_when_Ddr3MemtestEngine_l65_60 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_61 = errExpected[15 : 12];
  assign _zz__zz_printChar_61 = (_zz_when_Ddr3MemtestEngine_l65_61 + 8'h30);
  assign _zz__zz_printChar_61_1 = (_zz_when_Ddr3MemtestEngine_l65_61 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_62 = errExpected[11 : 8];
  assign _zz__zz_printChar_62 = (_zz_when_Ddr3MemtestEngine_l65_62 + 8'h30);
  assign _zz__zz_printChar_62_1 = (_zz_when_Ddr3MemtestEngine_l65_62 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_63 = errExpected[7 : 4];
  assign _zz__zz_printChar_63 = (_zz_when_Ddr3MemtestEngine_l65_63 + 8'h30);
  assign _zz__zz_printChar_63_1 = (_zz_when_Ddr3MemtestEngine_l65_63 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_64 = errExpected[3 : 0];
  assign _zz__zz_printChar_64 = (_zz_when_Ddr3MemtestEngine_l65_64 + 8'h30);
  assign _zz__zz_printChar_64_1 = (_zz_when_Ddr3MemtestEngine_l65_64 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_65 = errActual[63 : 60];
  assign _zz__zz_printChar_65 = (_zz_when_Ddr3MemtestEngine_l65_65 + 8'h30);
  assign _zz__zz_printChar_65_1 = (_zz_when_Ddr3MemtestEngine_l65_65 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_66 = errActual[59 : 56];
  assign _zz__zz_printChar_66 = (_zz_when_Ddr3MemtestEngine_l65_66 + 8'h30);
  assign _zz__zz_printChar_66_1 = (_zz_when_Ddr3MemtestEngine_l65_66 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_67 = errActual[55 : 52];
  assign _zz__zz_printChar_67 = (_zz_when_Ddr3MemtestEngine_l65_67 + 8'h30);
  assign _zz__zz_printChar_67_1 = (_zz_when_Ddr3MemtestEngine_l65_67 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_68 = errActual[51 : 48];
  assign _zz__zz_printChar_68 = (_zz_when_Ddr3MemtestEngine_l65_68 + 8'h30);
  assign _zz__zz_printChar_68_1 = (_zz_when_Ddr3MemtestEngine_l65_68 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_69 = errActual[47 : 44];
  assign _zz__zz_printChar_69 = (_zz_when_Ddr3MemtestEngine_l65_69 + 8'h30);
  assign _zz__zz_printChar_69_1 = (_zz_when_Ddr3MemtestEngine_l65_69 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_70 = errActual[43 : 40];
  assign _zz__zz_printChar_70 = (_zz_when_Ddr3MemtestEngine_l65_70 + 8'h30);
  assign _zz__zz_printChar_70_1 = (_zz_when_Ddr3MemtestEngine_l65_70 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_71 = errActual[39 : 36];
  assign _zz__zz_printChar_71 = (_zz_when_Ddr3MemtestEngine_l65_71 + 8'h30);
  assign _zz__zz_printChar_71_1 = (_zz_when_Ddr3MemtestEngine_l65_71 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_72 = errActual[35 : 32];
  assign _zz__zz_printChar_72 = (_zz_when_Ddr3MemtestEngine_l65_72 + 8'h30);
  assign _zz__zz_printChar_72_1 = (_zz_when_Ddr3MemtestEngine_l65_72 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_73 = errActual[31 : 28];
  assign _zz__zz_printChar_73 = (_zz_when_Ddr3MemtestEngine_l65_73 + 8'h30);
  assign _zz__zz_printChar_73_1 = (_zz_when_Ddr3MemtestEngine_l65_73 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_74 = errActual[27 : 24];
  assign _zz__zz_printChar_74 = (_zz_when_Ddr3MemtestEngine_l65_74 + 8'h30);
  assign _zz__zz_printChar_74_1 = (_zz_when_Ddr3MemtestEngine_l65_74 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_75 = errActual[23 : 20];
  assign _zz__zz_printChar_75 = (_zz_when_Ddr3MemtestEngine_l65_75 + 8'h30);
  assign _zz__zz_printChar_75_1 = (_zz_when_Ddr3MemtestEngine_l65_75 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_76 = errActual[19 : 16];
  assign _zz__zz_printChar_76 = (_zz_when_Ddr3MemtestEngine_l65_76 + 8'h30);
  assign _zz__zz_printChar_76_1 = (_zz_when_Ddr3MemtestEngine_l65_76 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_77 = errActual[15 : 12];
  assign _zz__zz_printChar_77 = (_zz_when_Ddr3MemtestEngine_l65_77 + 8'h30);
  assign _zz__zz_printChar_77_1 = (_zz_when_Ddr3MemtestEngine_l65_77 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_78 = errActual[11 : 8];
  assign _zz__zz_printChar_78 = (_zz_when_Ddr3MemtestEngine_l65_78 + 8'h30);
  assign _zz__zz_printChar_78_1 = (_zz_when_Ddr3MemtestEngine_l65_78 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_79 = errActual[7 : 4];
  assign _zz__zz_printChar_79 = (_zz_when_Ddr3MemtestEngine_l65_79 + 8'h30);
  assign _zz__zz_printChar_79_1 = (_zz_when_Ddr3MemtestEngine_l65_79 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_80 = errActual[3 : 0];
  assign _zz__zz_printChar_80 = (_zz_when_Ddr3MemtestEngine_l65_80 + 8'h30);
  assign _zz__zz_printChar_80_1 = (_zz_when_Ddr3MemtestEngine_l65_80 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_81 = errActual1[63 : 60];
  assign _zz__zz_printChar_81 = (_zz_when_Ddr3MemtestEngine_l65_81 + 8'h30);
  assign _zz__zz_printChar_81_1 = (_zz_when_Ddr3MemtestEngine_l65_81 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_82 = errActual1[59 : 56];
  assign _zz__zz_printChar_82 = (_zz_when_Ddr3MemtestEngine_l65_82 + 8'h30);
  assign _zz__zz_printChar_82_1 = (_zz_when_Ddr3MemtestEngine_l65_82 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_83 = errActual1[55 : 52];
  assign _zz__zz_printChar_83 = (_zz_when_Ddr3MemtestEngine_l65_83 + 8'h30);
  assign _zz__zz_printChar_83_1 = (_zz_when_Ddr3MemtestEngine_l65_83 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_84 = errActual1[51 : 48];
  assign _zz__zz_printChar_84 = (_zz_when_Ddr3MemtestEngine_l65_84 + 8'h30);
  assign _zz__zz_printChar_84_1 = (_zz_when_Ddr3MemtestEngine_l65_84 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_85 = errActual1[47 : 44];
  assign _zz__zz_printChar_85 = (_zz_when_Ddr3MemtestEngine_l65_85 + 8'h30);
  assign _zz__zz_printChar_85_1 = (_zz_when_Ddr3MemtestEngine_l65_85 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_86 = errActual1[43 : 40];
  assign _zz__zz_printChar_86 = (_zz_when_Ddr3MemtestEngine_l65_86 + 8'h30);
  assign _zz__zz_printChar_86_1 = (_zz_when_Ddr3MemtestEngine_l65_86 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_87 = errActual1[39 : 36];
  assign _zz__zz_printChar_87 = (_zz_when_Ddr3MemtestEngine_l65_87 + 8'h30);
  assign _zz__zz_printChar_87_1 = (_zz_when_Ddr3MemtestEngine_l65_87 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_88 = errActual1[35 : 32];
  assign _zz__zz_printChar_88 = (_zz_when_Ddr3MemtestEngine_l65_88 + 8'h30);
  assign _zz__zz_printChar_88_1 = (_zz_when_Ddr3MemtestEngine_l65_88 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_89 = errActual1[31 : 28];
  assign _zz__zz_printChar_89 = (_zz_when_Ddr3MemtestEngine_l65_89 + 8'h30);
  assign _zz__zz_printChar_89_1 = (_zz_when_Ddr3MemtestEngine_l65_89 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_90 = errActual1[27 : 24];
  assign _zz__zz_printChar_90 = (_zz_when_Ddr3MemtestEngine_l65_90 + 8'h30);
  assign _zz__zz_printChar_90_1 = (_zz_when_Ddr3MemtestEngine_l65_90 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_91 = errActual1[23 : 20];
  assign _zz__zz_printChar_91 = (_zz_when_Ddr3MemtestEngine_l65_91 + 8'h30);
  assign _zz__zz_printChar_91_1 = (_zz_when_Ddr3MemtestEngine_l65_91 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_92 = errActual1[19 : 16];
  assign _zz__zz_printChar_92 = (_zz_when_Ddr3MemtestEngine_l65_92 + 8'h30);
  assign _zz__zz_printChar_92_1 = (_zz_when_Ddr3MemtestEngine_l65_92 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_93 = errActual1[15 : 12];
  assign _zz__zz_printChar_93 = (_zz_when_Ddr3MemtestEngine_l65_93 + 8'h30);
  assign _zz__zz_printChar_93_1 = (_zz_when_Ddr3MemtestEngine_l65_93 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_94 = errActual1[11 : 8];
  assign _zz__zz_printChar_94 = (_zz_when_Ddr3MemtestEngine_l65_94 + 8'h30);
  assign _zz__zz_printChar_94_1 = (_zz_when_Ddr3MemtestEngine_l65_94 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_95 = errActual1[7 : 4];
  assign _zz__zz_printChar_95 = (_zz_when_Ddr3MemtestEngine_l65_95 + 8'h30);
  assign _zz__zz_printChar_95_1 = (_zz_when_Ddr3MemtestEngine_l65_95 + 8'h37);
  assign _zz__zz_when_Ddr3MemtestEngine_l65_96 = errActual1[3 : 0];
  assign _zz__zz_printChar_96 = (_zz_when_Ddr3MemtestEngine_l65_96 + 8'h30);
  assign _zz__zz_printChar_96_1 = (_zz_when_Ddr3MemtestEngine_l65_96 + 8'h37);
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
    case(_zz__zz_when_Ddr3MemtestEngine_l65_15_2)
      6'b000000 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_0;
      6'b000001 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_1;
      6'b000010 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_2;
      6'b000011 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_3;
      6'b000100 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_4;
      6'b000101 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_5;
      6'b000110 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_6;
      6'b000111 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_7;
      6'b001000 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_8;
      6'b001001 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_9;
      6'b001010 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_10;
      6'b001011 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_11;
      6'b001100 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_12;
      6'b001101 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_13;
      6'b001110 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_14;
      6'b001111 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_15;
      6'b010000 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_16;
      6'b010001 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_17;
      6'b010010 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_18;
      6'b010011 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_19;
      6'b010100 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_20;
      6'b010101 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_21;
      6'b010110 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_22;
      6'b010111 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_23;
      6'b011000 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_24;
      6'b011001 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_25;
      6'b011010 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_26;
      6'b011011 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_27;
      6'b011100 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_28;
      6'b011101 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_29;
      6'b011110 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_30;
      6'b011111 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_31;
      6'b100000 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_32;
      6'b100001 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_33;
      6'b100010 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_34;
      6'b100011 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_35;
      6'b100100 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_36;
      6'b100101 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_37;
      6'b100110 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_38;
      6'b100111 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_39;
      6'b101000 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_40;
      6'b101001 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_41;
      6'b101010 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_42;
      6'b101011 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_43;
      6'b101100 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_44;
      6'b101101 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_45;
      6'b101110 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_46;
      6'b101111 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_47;
      6'b110000 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_48;
      6'b110001 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_49;
      6'b110010 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_50;
      6'b110011 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_51;
      6'b110100 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_52;
      6'b110101 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_53;
      6'b110110 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_54;
      6'b110111 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_55;
      6'b111000 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_56;
      6'b111001 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_57;
      6'b111010 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_58;
      6'b111011 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_59;
      6'b111100 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_60;
      6'b111101 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_61;
      6'b111110 : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_62;
      default : _zz__zz_when_Ddr3MemtestEngine_l65_15_1 = wlMapNib_63;
    endcase
  end

  always @(*) begin
    case(_zz__zz_when_Ddr3MemtestEngine_l65_20_2)
      5'b00000 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_0;
      5'b00001 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_1;
      5'b00010 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_2;
      5'b00011 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_3;
      5'b00100 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_4;
      5'b00101 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_5;
      5'b00110 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_6;
      5'b00111 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_7;
      5'b01000 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_8;
      5'b01001 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_9;
      5'b01010 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_10;
      5'b01011 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_11;
      5'b01100 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_12;
      5'b01101 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_13;
      5'b01110 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_14;
      5'b01111 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_15;
      5'b10000 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_16;
      5'b10001 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_17;
      5'b10010 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_18;
      5'b10011 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_19;
      5'b10100 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_20;
      5'b10101 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_21;
      5'b10110 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_22;
      5'b10111 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_23;
      5'b11000 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_24;
      5'b11001 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_25;
      5'b11010 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_26;
      5'b11011 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_27;
      5'b11100 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_28;
      5'b11101 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_29;
      5'b11110 : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_30;
      default : _zz__zz_when_Ddr3MemtestEngine_l65_20_1 = latchNib_31;
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
      fsm_sPrintWlmap : fsm_stateReg_string = "sPrintWlmap   ";
      fsm_sPrintLatch : fsm_stateReg_string = "sPrintLatch   ";
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
      fsm_sPrintWlmap : fsm_stateNext_string = "sPrintWlmap   ";
      fsm_sPrintLatch : fsm_stateNext_string = "sPrintLatch   ";
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
  assign printBusy = 1'b0;
  assign txStream_valid = printValid;
  assign txStream_payload = printChar;
  assign txStream_fire = (txStream_valid && txStream_ready);
  assign io_test_error = errorReg;
  assign io_test_pass = passReg;
  assign when_Ddr3MemtestEngine_l101 = (hbCounter == 25'h0);
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
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
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
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
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
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
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
        io_axi_aw_payload_len = 8'h1f;
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
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
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
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
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
    io_axi_w_payload_strb = 8'hff;
    case(fsm_stateReg)
      fsm_sBootBanner : begin
      end
      fsm_sWaitCalib : begin
      end
      fsm_sPrintCalib : begin
      end
      fsm_sPrintBanner : begin
      end
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
      end
      fsm_sSingleWriteAW : begin
      end
      fsm_sSingleWriteW0 : begin
        io_axi_w_payload_strb = 8'hff;
      end
      fsm_sSingleWriteW1 : begin
        io_axi_w_payload_strb = 8'hff;
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
        io_axi_w_payload_strb = 8'hff;
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
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
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
        io_axi_w_payload_last = (beatIdx == 6'h1f);
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
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
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
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
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
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
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
        io_axi_ar_payload_len = 8'h1f;
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
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
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
  assign wlMapNib_0 = io_wlMap[3 : 0];
  assign wlMapNib_1 = io_wlMap[7 : 4];
  assign wlMapNib_2 = io_wlMap[11 : 8];
  assign wlMapNib_3 = io_wlMap[15 : 12];
  assign wlMapNib_4 = io_wlMap[19 : 16];
  assign wlMapNib_5 = io_wlMap[23 : 20];
  assign wlMapNib_6 = io_wlMap[27 : 24];
  assign wlMapNib_7 = io_wlMap[31 : 28];
  assign wlMapNib_8 = io_wlMap[35 : 32];
  assign wlMapNib_9 = io_wlMap[39 : 36];
  assign wlMapNib_10 = io_wlMap[43 : 40];
  assign wlMapNib_11 = io_wlMap[47 : 44];
  assign wlMapNib_12 = io_wlMap[51 : 48];
  assign wlMapNib_13 = io_wlMap[55 : 52];
  assign wlMapNib_14 = io_wlMap[59 : 56];
  assign wlMapNib_15 = io_wlMap[63 : 60];
  assign wlMapNib_16 = io_wlMap[67 : 64];
  assign wlMapNib_17 = io_wlMap[71 : 68];
  assign wlMapNib_18 = io_wlMap[75 : 72];
  assign wlMapNib_19 = io_wlMap[79 : 76];
  assign wlMapNib_20 = io_wlMap[83 : 80];
  assign wlMapNib_21 = io_wlMap[87 : 84];
  assign wlMapNib_22 = io_wlMap[91 : 88];
  assign wlMapNib_23 = io_wlMap[95 : 92];
  assign wlMapNib_24 = io_wlMap[99 : 96];
  assign wlMapNib_25 = io_wlMap[103 : 100];
  assign wlMapNib_26 = io_wlMap[107 : 104];
  assign wlMapNib_27 = io_wlMap[111 : 108];
  assign wlMapNib_28 = io_wlMap[115 : 112];
  assign wlMapNib_29 = io_wlMap[119 : 116];
  assign wlMapNib_30 = io_wlMap[123 : 120];
  assign wlMapNib_31 = io_wlMap[127 : 124];
  assign wlMapNib_32 = io_wlMap[131 : 128];
  assign wlMapNib_33 = io_wlMap[135 : 132];
  assign wlMapNib_34 = io_wlMap[139 : 136];
  assign wlMapNib_35 = io_wlMap[143 : 140];
  assign wlMapNib_36 = io_wlMap[147 : 144];
  assign wlMapNib_37 = io_wlMap[151 : 148];
  assign wlMapNib_38 = io_wlMap[155 : 152];
  assign wlMapNib_39 = io_wlMap[159 : 156];
  assign wlMapNib_40 = io_wlMap[163 : 160];
  assign wlMapNib_41 = io_wlMap[167 : 164];
  assign wlMapNib_42 = io_wlMap[171 : 168];
  assign wlMapNib_43 = io_wlMap[175 : 172];
  assign wlMapNib_44 = io_wlMap[179 : 176];
  assign wlMapNib_45 = io_wlMap[183 : 180];
  assign wlMapNib_46 = io_wlMap[187 : 184];
  assign wlMapNib_47 = io_wlMap[191 : 188];
  assign wlMapNib_48 = io_wlMap[195 : 192];
  assign wlMapNib_49 = io_wlMap[199 : 196];
  assign wlMapNib_50 = io_wlMap[203 : 200];
  assign wlMapNib_51 = io_wlMap[207 : 204];
  assign wlMapNib_52 = io_wlMap[211 : 208];
  assign wlMapNib_53 = io_wlMap[215 : 212];
  assign wlMapNib_54 = io_wlMap[219 : 216];
  assign wlMapNib_55 = io_wlMap[223 : 220];
  assign wlMapNib_56 = io_wlMap[227 : 224];
  assign wlMapNib_57 = io_wlMap[231 : 228];
  assign wlMapNib_58 = io_wlMap[235 : 232];
  assign wlMapNib_59 = io_wlMap[239 : 236];
  assign wlMapNib_60 = io_wlMap[243 : 240];
  assign wlMapNib_61 = io_wlMap[247 : 244];
  assign wlMapNib_62 = io_wlMap[251 : 248];
  assign wlMapNib_63 = io_wlMap[255 : 252];
  assign latchNib_0 = io_train_latch[3 : 0];
  assign latchNib_1 = io_train_latch[7 : 4];
  assign latchNib_2 = io_train_latch[11 : 8];
  assign latchNib_3 = io_train_latch[15 : 12];
  assign latchNib_4 = io_train_latch[19 : 16];
  assign latchNib_5 = io_train_latch[23 : 20];
  assign latchNib_6 = io_train_latch[27 : 24];
  assign latchNib_7 = io_train_latch[31 : 28];
  assign latchNib_8 = io_train_latch[35 : 32];
  assign latchNib_9 = io_train_latch[39 : 36];
  assign latchNib_10 = io_train_latch[43 : 40];
  assign latchNib_11 = io_train_latch[47 : 44];
  assign latchNib_12 = io_train_latch[51 : 48];
  assign latchNib_13 = io_train_latch[55 : 52];
  assign latchNib_14 = io_train_latch[59 : 56];
  assign latchNib_15 = io_train_latch[63 : 60];
  assign latchNib_16 = io_train_latch[67 : 64];
  assign latchNib_17 = io_train_latch[71 : 68];
  assign latchNib_18 = io_train_latch[75 : 72];
  assign latchNib_19 = io_train_latch[79 : 76];
  assign latchNib_20 = io_train_latch[83 : 80];
  assign latchNib_21 = io_train_latch[87 : 84];
  assign latchNib_22 = io_train_latch[91 : 88];
  assign latchNib_23 = io_train_latch[95 : 92];
  assign latchNib_24 = io_train_latch[99 : 96];
  assign latchNib_25 = io_train_latch[103 : 100];
  assign latchNib_26 = io_train_latch[107 : 104];
  assign latchNib_27 = io_train_latch[111 : 108];
  assign latchNib_28 = io_train_latch[115 : 112];
  assign latchNib_29 = io_train_latch[119 : 116];
  assign latchNib_30 = io_train_latch[123 : 120];
  assign latchNib_31 = io_train_latch[127 : 124];
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
      fsm_sPrintWlmap : begin
      end
      fsm_sPrintLatch : begin
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
        if(when_Ddr3MemtestEngine_l199) begin
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
        if(when_Ddr3MemtestEngine_l231) begin
          fsm_stateNext = fsm_sPrintBanner;
        end else begin
          if(when_Ddr3MemtestEngine_l239) begin
            fsm_stateNext = fsm_sPrintCalib;
          end
        end
      end
      fsm_sPrintCalib : begin
        if(when_Ddr3MemtestEngine_l250) begin
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
        if(when_Ddr3MemtestEngine_l277) begin
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
              fsm_stateNext = fsm_sPrintWlmap;
            end
          endcase
        end
      end
      fsm_sPrintWlmap : begin
        if(when_Ddr3MemtestEngine_l325) begin
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
            7'h5a : begin
            end
            7'h5b : begin
              fsm_stateNext = fsm_sPrintLatch;
            end
            default : begin
            end
          endcase
        end
      end
      fsm_sPrintLatch : begin
        if(when_Ddr3MemtestEngine_l365) begin
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
            7'h34 : begin
            end
            7'h35 : begin
              fsm_stateNext = fsm_sSingleWriteAW;
            end
            default : begin
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
          if(when_Ddr3MemtestEngine_l464) begin
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
          if(when_Ddr3MemtestEngine_l495) begin
            fsm_stateNext = fsm_sBulkWriteB;
          end
        end
      end
      fsm_sBulkWriteB : begin
        if(io_axi_b_valid) begin
          if(when_Ddr3MemtestEngine_l506) begin
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
          if(when_Ddr3MemtestEngine_l540) begin
            fsm_stateNext = fsm_sReportFail;
          end else begin
            if(when_Ddr3MemtestEngine_l544) begin
              if(when_Ddr3MemtestEngine_l545) begin
                fsm_stateNext = fsm_sReportPass;
              end else begin
                fsm_stateNext = fsm_sBulkReadAR;
              end
            end
          end
        end
      end
      fsm_sReportPass : begin
        if(when_Ddr3MemtestEngine_l562) begin
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
            7'h22 : begin
            end
            default : begin
              fsm_stateNext = fsm_sLoopDelay;
            end
          endcase
        end
      end
      fsm_sReportFail : begin
      end
      fsm_sLoopDelay : begin
        if(when_Ddr3MemtestEngine_l698) begin
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

  assign when_Ddr3MemtestEngine_l199 = (! printValid);
  assign when_Ddr3MemtestEngine_l231 = (((io_pll_lock && io_init_done) && io_write_level_done) && io_read_calib_done);
  assign when_Ddr3MemtestEngine_l239 = (fsm_delayCounter == 28'h2435b6e);
  assign when_Ddr3MemtestEngine_l250 = (! printValid);
  assign _zz_when_Ddr3MemtestEngine_l65 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65};
  assign when_Ddr3MemtestEngine_l65 = (_zz_when_Ddr3MemtestEngine_l65 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65) begin
      _zz_printChar = _zz__zz_printChar;
    end else begin
      _zz_printChar = _zz__zz_printChar_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_1 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_1};
  assign when_Ddr3MemtestEngine_l65_1 = (_zz_when_Ddr3MemtestEngine_l65_1 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_1) begin
      _zz_printChar_1 = _zz__zz_printChar_1_1;
    end else begin
      _zz_printChar_1 = _zz__zz_printChar_1_2;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_2 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_2};
  assign when_Ddr3MemtestEngine_l65_2 = (_zz_when_Ddr3MemtestEngine_l65_2 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_2) begin
      _zz_printChar_2 = _zz__zz_printChar_2;
    end else begin
      _zz_printChar_2 = _zz__zz_printChar_2_1;
    end
  end

  assign when_Ddr3MemtestEngine_l277 = (! printValid);
  assign _zz_when_Ddr3MemtestEngine_l65_3 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_3};
  assign when_Ddr3MemtestEngine_l65_3 = (_zz_when_Ddr3MemtestEngine_l65_3 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_3) begin
      _zz_printChar_3 = _zz__zz_printChar_3;
    end else begin
      _zz_printChar_3 = _zz__zz_printChar_3_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_4 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_4};
  assign when_Ddr3MemtestEngine_l65_4 = (_zz_when_Ddr3MemtestEngine_l65_4 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_4) begin
      _zz_printChar_4 = _zz__zz_printChar_4;
    end else begin
      _zz_printChar_4 = _zz__zz_printChar_4_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_5 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_5};
  assign when_Ddr3MemtestEngine_l65_5 = (_zz_when_Ddr3MemtestEngine_l65_5 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_5) begin
      _zz_printChar_5 = _zz__zz_printChar_5;
    end else begin
      _zz_printChar_5 = _zz__zz_printChar_5_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_6 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_6};
  assign when_Ddr3MemtestEngine_l65_6 = (_zz_when_Ddr3MemtestEngine_l65_6 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_6) begin
      _zz_printChar_6 = _zz__zz_printChar_6;
    end else begin
      _zz_printChar_6 = _zz__zz_printChar_6_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_7 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_7};
  assign when_Ddr3MemtestEngine_l65_7 = (_zz_when_Ddr3MemtestEngine_l65_7 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_7) begin
      _zz_printChar_7 = _zz__zz_printChar_7;
    end else begin
      _zz_printChar_7 = _zz__zz_printChar_7_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_8 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_8};
  assign when_Ddr3MemtestEngine_l65_8 = (_zz_when_Ddr3MemtestEngine_l65_8 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_8) begin
      _zz_printChar_8 = _zz__zz_printChar_8;
    end else begin
      _zz_printChar_8 = _zz__zz_printChar_8_1;
    end
  end

  assign when_Ddr3MemtestEngine_l325 = (! printValid);
  assign _zz_when_Ddr3MemtestEngine_l65_9 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_9};
  assign when_Ddr3MemtestEngine_l65_9 = (_zz_when_Ddr3MemtestEngine_l65_9 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_9) begin
      _zz_printChar_9 = _zz__zz_printChar_9;
    end else begin
      _zz_printChar_9 = _zz__zz_printChar_9_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_10 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_10};
  assign when_Ddr3MemtestEngine_l65_10 = (_zz_when_Ddr3MemtestEngine_l65_10 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_10) begin
      _zz_printChar_10 = _zz__zz_printChar_10;
    end else begin
      _zz_printChar_10 = _zz__zz_printChar_10_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_11 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_11};
  assign when_Ddr3MemtestEngine_l65_11 = (_zz_when_Ddr3MemtestEngine_l65_11 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_11) begin
      _zz_printChar_11 = _zz__zz_printChar_11;
    end else begin
      _zz_printChar_11 = _zz__zz_printChar_11_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_12 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_12};
  assign when_Ddr3MemtestEngine_l65_12 = (_zz_when_Ddr3MemtestEngine_l65_12 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_12) begin
      _zz_printChar_12 = _zz__zz_printChar_12;
    end else begin
      _zz_printChar_12 = _zz__zz_printChar_12_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_13 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_13};
  assign when_Ddr3MemtestEngine_l65_13 = (_zz_when_Ddr3MemtestEngine_l65_13 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_13) begin
      _zz_printChar_13 = _zz__zz_printChar_13;
    end else begin
      _zz_printChar_13 = _zz__zz_printChar_13_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_14 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_14};
  assign when_Ddr3MemtestEngine_l65_14 = (_zz_when_Ddr3MemtestEngine_l65_14 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_14) begin
      _zz_printChar_14 = _zz__zz_printChar_14;
    end else begin
      _zz_printChar_14 = _zz__zz_printChar_14_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_15 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_15};
  assign when_Ddr3MemtestEngine_l65_15 = (_zz_when_Ddr3MemtestEngine_l65_15 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_15) begin
      _zz_printChar_15 = _zz__zz_printChar_15;
    end else begin
      _zz_printChar_15 = _zz__zz_printChar_15_1;
    end
  end

  assign when_Ddr3MemtestEngine_l365 = (! printValid);
  assign _zz_when_Ddr3MemtestEngine_l65_16 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_16};
  assign when_Ddr3MemtestEngine_l65_16 = (_zz_when_Ddr3MemtestEngine_l65_16 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_16) begin
      _zz_printChar_16 = _zz__zz_printChar_16;
    end else begin
      _zz_printChar_16 = _zz__zz_printChar_16_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_17 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_17};
  assign when_Ddr3MemtestEngine_l65_17 = (_zz_when_Ddr3MemtestEngine_l65_17 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_17) begin
      _zz_printChar_17 = _zz__zz_printChar_17;
    end else begin
      _zz_printChar_17 = _zz__zz_printChar_17_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_18 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_18};
  assign when_Ddr3MemtestEngine_l65_18 = (_zz_when_Ddr3MemtestEngine_l65_18 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_18) begin
      _zz_printChar_18 = _zz__zz_printChar_18;
    end else begin
      _zz_printChar_18 = _zz__zz_printChar_18_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_19 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_19};
  assign when_Ddr3MemtestEngine_l65_19 = (_zz_when_Ddr3MemtestEngine_l65_19 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_19) begin
      _zz_printChar_19 = _zz__zz_printChar_19;
    end else begin
      _zz_printChar_19 = _zz__zz_printChar_19_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_20 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_20};
  assign when_Ddr3MemtestEngine_l65_20 = (_zz_when_Ddr3MemtestEngine_l65_20 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_20) begin
      _zz_printChar_20 = _zz__zz_printChar_20;
    end else begin
      _zz_printChar_20 = _zz__zz_printChar_20_1;
    end
  end

  assign when_Ddr3MemtestEngine_l442 = ((! errorReg) && (io_axi_r_payload_data != 64'h0123456789abcdef));
  assign when_Ddr3MemtestEngine_l458 = ((! errorReg) && (io_axi_r_payload_data != 64'hfedcba9876543210));
  assign when_Ddr3MemtestEngine_l464 = (errorReg || (io_axi_r_payload_data != 64'hfedcba9876543210));
  assign when_Ddr3MemtestEngine_l495 = (beatIdx == 6'h1f);
  assign when_Ddr3MemtestEngine_l506 = (11'h400 <= _zz_when_Ddr3MemtestEngine_l506);
  assign _zz_errExpected = (beatIdx[0] ? {(beatBlockAddr ^ 32'h12345678),_zz__zz_errExpected} : {(beatBlockAddr ^ 32'h5aa55aa5),_zz__zz_errExpected_1});
  assign _zz_when_Ddr3MemtestEngine_l534 = (io_axi_r_payload_data != _zz_errExpected);
  assign when_Ddr3MemtestEngine_l534 = ((! errorReg) && _zz_when_Ddr3MemtestEngine_l534);
  assign when_Ddr3MemtestEngine_l540 = (errorReg || _zz_when_Ddr3MemtestEngine_l534);
  assign when_Ddr3MemtestEngine_l544 = (beatIdx == 6'h1f);
  assign when_Ddr3MemtestEngine_l545 = (11'h400 <= _zz_when_Ddr3MemtestEngine_l545);
  assign when_Ddr3MemtestEngine_l562 = (! printValid);
  assign _zz_when_Ddr3MemtestEngine_l65_21 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_21};
  assign when_Ddr3MemtestEngine_l65_21 = (_zz_when_Ddr3MemtestEngine_l65_21 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_21) begin
      _zz_printChar_21 = _zz__zz_printChar_21;
    end else begin
      _zz_printChar_21 = _zz__zz_printChar_21_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_22 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_22};
  assign when_Ddr3MemtestEngine_l65_22 = (_zz_when_Ddr3MemtestEngine_l65_22 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_22) begin
      _zz_printChar_22 = _zz__zz_printChar_22;
    end else begin
      _zz_printChar_22 = _zz__zz_printChar_22_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_23 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_23};
  assign when_Ddr3MemtestEngine_l65_23 = (_zz_when_Ddr3MemtestEngine_l65_23 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_23) begin
      _zz_printChar_23 = _zz__zz_printChar_23;
    end else begin
      _zz_printChar_23 = _zz__zz_printChar_23_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_24 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_24};
  assign when_Ddr3MemtestEngine_l65_24 = (_zz_when_Ddr3MemtestEngine_l65_24 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_24) begin
      _zz_printChar_24 = _zz__zz_printChar_24;
    end else begin
      _zz_printChar_24 = _zz__zz_printChar_24_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_25 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_25};
  assign when_Ddr3MemtestEngine_l65_25 = (_zz_when_Ddr3MemtestEngine_l65_25 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_25) begin
      _zz_printChar_25 = _zz__zz_printChar_25;
    end else begin
      _zz_printChar_25 = _zz__zz_printChar_25_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_26 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_26};
  assign when_Ddr3MemtestEngine_l65_26 = (_zz_when_Ddr3MemtestEngine_l65_26 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_26) begin
      _zz_printChar_26 = _zz__zz_printChar_26;
    end else begin
      _zz_printChar_26 = _zz__zz_printChar_26_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_27 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_27};
  assign when_Ddr3MemtestEngine_l65_27 = (_zz_when_Ddr3MemtestEngine_l65_27 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_27) begin
      _zz_printChar_27 = _zz__zz_printChar_27;
    end else begin
      _zz_printChar_27 = _zz__zz_printChar_27_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_28 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_28};
  assign when_Ddr3MemtestEngine_l65_28 = (_zz_when_Ddr3MemtestEngine_l65_28 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_28) begin
      _zz_printChar_28 = _zz__zz_printChar_28;
    end else begin
      _zz_printChar_28 = _zz__zz_printChar_28_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_29 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_29};
  assign when_Ddr3MemtestEngine_l65_29 = (_zz_when_Ddr3MemtestEngine_l65_29 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_29) begin
      _zz_printChar_29 = _zz__zz_printChar_29;
    end else begin
      _zz_printChar_29 = _zz__zz_printChar_29_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_30 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_30};
  assign when_Ddr3MemtestEngine_l65_30 = (_zz_when_Ddr3MemtestEngine_l65_30 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_30) begin
      _zz_printChar_30 = _zz__zz_printChar_30;
    end else begin
      _zz_printChar_30 = _zz__zz_printChar_30_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_31 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_31};
  assign when_Ddr3MemtestEngine_l65_31 = (_zz_when_Ddr3MemtestEngine_l65_31 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_31) begin
      _zz_printChar_31 = _zz__zz_printChar_31;
    end else begin
      _zz_printChar_31 = _zz__zz_printChar_31_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_32 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_32};
  assign when_Ddr3MemtestEngine_l65_32 = (_zz_when_Ddr3MemtestEngine_l65_32 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_32) begin
      _zz_printChar_32 = _zz__zz_printChar_32;
    end else begin
      _zz_printChar_32 = _zz__zz_printChar_32_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_33 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_33};
  assign when_Ddr3MemtestEngine_l65_33 = (_zz_when_Ddr3MemtestEngine_l65_33 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_33) begin
      _zz_printChar_33 = _zz__zz_printChar_33;
    end else begin
      _zz_printChar_33 = _zz__zz_printChar_33_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_34 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_34};
  assign when_Ddr3MemtestEngine_l65_34 = (_zz_when_Ddr3MemtestEngine_l65_34 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_34) begin
      _zz_printChar_34 = _zz__zz_printChar_34;
    end else begin
      _zz_printChar_34 = _zz__zz_printChar_34_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_35 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_35};
  assign when_Ddr3MemtestEngine_l65_35 = (_zz_when_Ddr3MemtestEngine_l65_35 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_35) begin
      _zz_printChar_35 = _zz__zz_printChar_35;
    end else begin
      _zz_printChar_35 = _zz__zz_printChar_35_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_36 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_36};
  assign when_Ddr3MemtestEngine_l65_36 = (_zz_when_Ddr3MemtestEngine_l65_36 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_36) begin
      _zz_printChar_36 = _zz__zz_printChar_36;
    end else begin
      _zz_printChar_36 = _zz__zz_printChar_36_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_37 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_37};
  assign when_Ddr3MemtestEngine_l65_37 = (_zz_when_Ddr3MemtestEngine_l65_37 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_37) begin
      _zz_printChar_37 = _zz__zz_printChar_37;
    end else begin
      _zz_printChar_37 = _zz__zz_printChar_37_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_38 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_38};
  assign when_Ddr3MemtestEngine_l65_38 = (_zz_when_Ddr3MemtestEngine_l65_38 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_38) begin
      _zz_printChar_38 = _zz__zz_printChar_38;
    end else begin
      _zz_printChar_38 = _zz__zz_printChar_38_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_39 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_39};
  assign when_Ddr3MemtestEngine_l65_39 = (_zz_when_Ddr3MemtestEngine_l65_39 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_39) begin
      _zz_printChar_39 = _zz__zz_printChar_39;
    end else begin
      _zz_printChar_39 = _zz__zz_printChar_39_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_40 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_40};
  assign when_Ddr3MemtestEngine_l65_40 = (_zz_when_Ddr3MemtestEngine_l65_40 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_40) begin
      _zz_printChar_40 = _zz__zz_printChar_40;
    end else begin
      _zz_printChar_40 = _zz__zz_printChar_40_1;
    end
  end

  assign when_Ddr3MemtestEngine_l610 = (! printValid);
  assign _zz_when_Ddr3MemtestEngine_l65_41 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_41};
  assign when_Ddr3MemtestEngine_l65_41 = (_zz_when_Ddr3MemtestEngine_l65_41 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_41) begin
      _zz_printChar_41 = _zz__zz_printChar_41;
    end else begin
      _zz_printChar_41 = _zz__zz_printChar_41_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_42 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_42};
  assign when_Ddr3MemtestEngine_l65_42 = (_zz_when_Ddr3MemtestEngine_l65_42 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_42) begin
      _zz_printChar_42 = _zz__zz_printChar_42;
    end else begin
      _zz_printChar_42 = _zz__zz_printChar_42_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_43 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_43};
  assign when_Ddr3MemtestEngine_l65_43 = (_zz_when_Ddr3MemtestEngine_l65_43 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_43) begin
      _zz_printChar_43 = _zz__zz_printChar_43;
    end else begin
      _zz_printChar_43 = _zz__zz_printChar_43_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_44 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_44};
  assign when_Ddr3MemtestEngine_l65_44 = (_zz_when_Ddr3MemtestEngine_l65_44 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_44) begin
      _zz_printChar_44 = _zz__zz_printChar_44;
    end else begin
      _zz_printChar_44 = _zz__zz_printChar_44_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_45 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_45};
  assign when_Ddr3MemtestEngine_l65_45 = (_zz_when_Ddr3MemtestEngine_l65_45 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_45) begin
      _zz_printChar_45 = _zz__zz_printChar_45;
    end else begin
      _zz_printChar_45 = _zz__zz_printChar_45_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_46 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_46};
  assign when_Ddr3MemtestEngine_l65_46 = (_zz_when_Ddr3MemtestEngine_l65_46 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_46) begin
      _zz_printChar_46 = _zz__zz_printChar_46;
    end else begin
      _zz_printChar_46 = _zz__zz_printChar_46_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_47 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_47};
  assign when_Ddr3MemtestEngine_l65_47 = (_zz_when_Ddr3MemtestEngine_l65_47 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_47) begin
      _zz_printChar_47 = _zz__zz_printChar_47;
    end else begin
      _zz_printChar_47 = _zz__zz_printChar_47_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_48 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_48};
  assign when_Ddr3MemtestEngine_l65_48 = (_zz_when_Ddr3MemtestEngine_l65_48 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_48) begin
      _zz_printChar_48 = _zz__zz_printChar_48;
    end else begin
      _zz_printChar_48 = _zz__zz_printChar_48_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_49 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_49};
  assign when_Ddr3MemtestEngine_l65_49 = (_zz_when_Ddr3MemtestEngine_l65_49 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_49) begin
      _zz_printChar_49 = _zz__zz_printChar_49;
    end else begin
      _zz_printChar_49 = _zz__zz_printChar_49_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_50 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_50};
  assign when_Ddr3MemtestEngine_l65_50 = (_zz_when_Ddr3MemtestEngine_l65_50 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_50) begin
      _zz_printChar_50 = _zz__zz_printChar_50;
    end else begin
      _zz_printChar_50 = _zz__zz_printChar_50_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_51 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_51};
  assign when_Ddr3MemtestEngine_l65_51 = (_zz_when_Ddr3MemtestEngine_l65_51 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_51) begin
      _zz_printChar_51 = _zz__zz_printChar_51;
    end else begin
      _zz_printChar_51 = _zz__zz_printChar_51_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_52 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_52};
  assign when_Ddr3MemtestEngine_l65_52 = (_zz_when_Ddr3MemtestEngine_l65_52 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_52) begin
      _zz_printChar_52 = _zz__zz_printChar_52;
    end else begin
      _zz_printChar_52 = _zz__zz_printChar_52_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_53 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_53};
  assign when_Ddr3MemtestEngine_l65_53 = (_zz_when_Ddr3MemtestEngine_l65_53 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_53) begin
      _zz_printChar_53 = _zz__zz_printChar_53;
    end else begin
      _zz_printChar_53 = _zz__zz_printChar_53_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_54 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_54};
  assign when_Ddr3MemtestEngine_l65_54 = (_zz_when_Ddr3MemtestEngine_l65_54 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_54) begin
      _zz_printChar_54 = _zz__zz_printChar_54;
    end else begin
      _zz_printChar_54 = _zz__zz_printChar_54_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_55 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_55};
  assign when_Ddr3MemtestEngine_l65_55 = (_zz_when_Ddr3MemtestEngine_l65_55 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_55) begin
      _zz_printChar_55 = _zz__zz_printChar_55;
    end else begin
      _zz_printChar_55 = _zz__zz_printChar_55_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_56 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_56};
  assign when_Ddr3MemtestEngine_l65_56 = (_zz_when_Ddr3MemtestEngine_l65_56 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_56) begin
      _zz_printChar_56 = _zz__zz_printChar_56;
    end else begin
      _zz_printChar_56 = _zz__zz_printChar_56_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_57 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_57};
  assign when_Ddr3MemtestEngine_l65_57 = (_zz_when_Ddr3MemtestEngine_l65_57 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_57) begin
      _zz_printChar_57 = _zz__zz_printChar_57;
    end else begin
      _zz_printChar_57 = _zz__zz_printChar_57_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_58 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_58};
  assign when_Ddr3MemtestEngine_l65_58 = (_zz_when_Ddr3MemtestEngine_l65_58 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_58) begin
      _zz_printChar_58 = _zz__zz_printChar_58;
    end else begin
      _zz_printChar_58 = _zz__zz_printChar_58_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_59 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_59};
  assign when_Ddr3MemtestEngine_l65_59 = (_zz_when_Ddr3MemtestEngine_l65_59 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_59) begin
      _zz_printChar_59 = _zz__zz_printChar_59;
    end else begin
      _zz_printChar_59 = _zz__zz_printChar_59_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_60 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_60};
  assign when_Ddr3MemtestEngine_l65_60 = (_zz_when_Ddr3MemtestEngine_l65_60 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_60) begin
      _zz_printChar_60 = _zz__zz_printChar_60;
    end else begin
      _zz_printChar_60 = _zz__zz_printChar_60_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_61 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_61};
  assign when_Ddr3MemtestEngine_l65_61 = (_zz_when_Ddr3MemtestEngine_l65_61 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_61) begin
      _zz_printChar_61 = _zz__zz_printChar_61;
    end else begin
      _zz_printChar_61 = _zz__zz_printChar_61_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_62 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_62};
  assign when_Ddr3MemtestEngine_l65_62 = (_zz_when_Ddr3MemtestEngine_l65_62 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_62) begin
      _zz_printChar_62 = _zz__zz_printChar_62;
    end else begin
      _zz_printChar_62 = _zz__zz_printChar_62_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_63 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_63};
  assign when_Ddr3MemtestEngine_l65_63 = (_zz_when_Ddr3MemtestEngine_l65_63 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_63) begin
      _zz_printChar_63 = _zz__zz_printChar_63;
    end else begin
      _zz_printChar_63 = _zz__zz_printChar_63_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_64 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_64};
  assign when_Ddr3MemtestEngine_l65_64 = (_zz_when_Ddr3MemtestEngine_l65_64 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_64) begin
      _zz_printChar_64 = _zz__zz_printChar_64;
    end else begin
      _zz_printChar_64 = _zz__zz_printChar_64_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_65 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_65};
  assign when_Ddr3MemtestEngine_l65_65 = (_zz_when_Ddr3MemtestEngine_l65_65 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_65) begin
      _zz_printChar_65 = _zz__zz_printChar_65;
    end else begin
      _zz_printChar_65 = _zz__zz_printChar_65_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_66 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_66};
  assign when_Ddr3MemtestEngine_l65_66 = (_zz_when_Ddr3MemtestEngine_l65_66 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_66) begin
      _zz_printChar_66 = _zz__zz_printChar_66;
    end else begin
      _zz_printChar_66 = _zz__zz_printChar_66_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_67 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_67};
  assign when_Ddr3MemtestEngine_l65_67 = (_zz_when_Ddr3MemtestEngine_l65_67 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_67) begin
      _zz_printChar_67 = _zz__zz_printChar_67;
    end else begin
      _zz_printChar_67 = _zz__zz_printChar_67_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_68 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_68};
  assign when_Ddr3MemtestEngine_l65_68 = (_zz_when_Ddr3MemtestEngine_l65_68 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_68) begin
      _zz_printChar_68 = _zz__zz_printChar_68;
    end else begin
      _zz_printChar_68 = _zz__zz_printChar_68_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_69 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_69};
  assign when_Ddr3MemtestEngine_l65_69 = (_zz_when_Ddr3MemtestEngine_l65_69 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_69) begin
      _zz_printChar_69 = _zz__zz_printChar_69;
    end else begin
      _zz_printChar_69 = _zz__zz_printChar_69_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_70 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_70};
  assign when_Ddr3MemtestEngine_l65_70 = (_zz_when_Ddr3MemtestEngine_l65_70 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_70) begin
      _zz_printChar_70 = _zz__zz_printChar_70;
    end else begin
      _zz_printChar_70 = _zz__zz_printChar_70_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_71 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_71};
  assign when_Ddr3MemtestEngine_l65_71 = (_zz_when_Ddr3MemtestEngine_l65_71 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_71) begin
      _zz_printChar_71 = _zz__zz_printChar_71;
    end else begin
      _zz_printChar_71 = _zz__zz_printChar_71_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_72 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_72};
  assign when_Ddr3MemtestEngine_l65_72 = (_zz_when_Ddr3MemtestEngine_l65_72 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_72) begin
      _zz_printChar_72 = _zz__zz_printChar_72;
    end else begin
      _zz_printChar_72 = _zz__zz_printChar_72_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_73 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_73};
  assign when_Ddr3MemtestEngine_l65_73 = (_zz_when_Ddr3MemtestEngine_l65_73 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_73) begin
      _zz_printChar_73 = _zz__zz_printChar_73;
    end else begin
      _zz_printChar_73 = _zz__zz_printChar_73_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_74 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_74};
  assign when_Ddr3MemtestEngine_l65_74 = (_zz_when_Ddr3MemtestEngine_l65_74 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_74) begin
      _zz_printChar_74 = _zz__zz_printChar_74;
    end else begin
      _zz_printChar_74 = _zz__zz_printChar_74_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_75 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_75};
  assign when_Ddr3MemtestEngine_l65_75 = (_zz_when_Ddr3MemtestEngine_l65_75 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_75) begin
      _zz_printChar_75 = _zz__zz_printChar_75;
    end else begin
      _zz_printChar_75 = _zz__zz_printChar_75_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_76 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_76};
  assign when_Ddr3MemtestEngine_l65_76 = (_zz_when_Ddr3MemtestEngine_l65_76 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_76) begin
      _zz_printChar_76 = _zz__zz_printChar_76;
    end else begin
      _zz_printChar_76 = _zz__zz_printChar_76_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_77 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_77};
  assign when_Ddr3MemtestEngine_l65_77 = (_zz_when_Ddr3MemtestEngine_l65_77 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_77) begin
      _zz_printChar_77 = _zz__zz_printChar_77;
    end else begin
      _zz_printChar_77 = _zz__zz_printChar_77_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_78 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_78};
  assign when_Ddr3MemtestEngine_l65_78 = (_zz_when_Ddr3MemtestEngine_l65_78 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_78) begin
      _zz_printChar_78 = _zz__zz_printChar_78;
    end else begin
      _zz_printChar_78 = _zz__zz_printChar_78_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_79 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_79};
  assign when_Ddr3MemtestEngine_l65_79 = (_zz_when_Ddr3MemtestEngine_l65_79 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_79) begin
      _zz_printChar_79 = _zz__zz_printChar_79;
    end else begin
      _zz_printChar_79 = _zz__zz_printChar_79_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_80 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_80};
  assign when_Ddr3MemtestEngine_l65_80 = (_zz_when_Ddr3MemtestEngine_l65_80 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_80) begin
      _zz_printChar_80 = _zz__zz_printChar_80;
    end else begin
      _zz_printChar_80 = _zz__zz_printChar_80_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_81 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_81};
  assign when_Ddr3MemtestEngine_l65_81 = (_zz_when_Ddr3MemtestEngine_l65_81 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_81) begin
      _zz_printChar_81 = _zz__zz_printChar_81;
    end else begin
      _zz_printChar_81 = _zz__zz_printChar_81_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_82 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_82};
  assign when_Ddr3MemtestEngine_l65_82 = (_zz_when_Ddr3MemtestEngine_l65_82 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_82) begin
      _zz_printChar_82 = _zz__zz_printChar_82;
    end else begin
      _zz_printChar_82 = _zz__zz_printChar_82_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_83 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_83};
  assign when_Ddr3MemtestEngine_l65_83 = (_zz_when_Ddr3MemtestEngine_l65_83 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_83) begin
      _zz_printChar_83 = _zz__zz_printChar_83;
    end else begin
      _zz_printChar_83 = _zz__zz_printChar_83_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_84 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_84};
  assign when_Ddr3MemtestEngine_l65_84 = (_zz_when_Ddr3MemtestEngine_l65_84 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_84) begin
      _zz_printChar_84 = _zz__zz_printChar_84;
    end else begin
      _zz_printChar_84 = _zz__zz_printChar_84_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_85 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_85};
  assign when_Ddr3MemtestEngine_l65_85 = (_zz_when_Ddr3MemtestEngine_l65_85 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_85) begin
      _zz_printChar_85 = _zz__zz_printChar_85;
    end else begin
      _zz_printChar_85 = _zz__zz_printChar_85_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_86 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_86};
  assign when_Ddr3MemtestEngine_l65_86 = (_zz_when_Ddr3MemtestEngine_l65_86 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_86) begin
      _zz_printChar_86 = _zz__zz_printChar_86;
    end else begin
      _zz_printChar_86 = _zz__zz_printChar_86_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_87 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_87};
  assign when_Ddr3MemtestEngine_l65_87 = (_zz_when_Ddr3MemtestEngine_l65_87 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_87) begin
      _zz_printChar_87 = _zz__zz_printChar_87;
    end else begin
      _zz_printChar_87 = _zz__zz_printChar_87_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_88 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_88};
  assign when_Ddr3MemtestEngine_l65_88 = (_zz_when_Ddr3MemtestEngine_l65_88 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_88) begin
      _zz_printChar_88 = _zz__zz_printChar_88;
    end else begin
      _zz_printChar_88 = _zz__zz_printChar_88_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_89 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_89};
  assign when_Ddr3MemtestEngine_l65_89 = (_zz_when_Ddr3MemtestEngine_l65_89 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_89) begin
      _zz_printChar_89 = _zz__zz_printChar_89;
    end else begin
      _zz_printChar_89 = _zz__zz_printChar_89_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_90 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_90};
  assign when_Ddr3MemtestEngine_l65_90 = (_zz_when_Ddr3MemtestEngine_l65_90 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_90) begin
      _zz_printChar_90 = _zz__zz_printChar_90;
    end else begin
      _zz_printChar_90 = _zz__zz_printChar_90_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_91 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_91};
  assign when_Ddr3MemtestEngine_l65_91 = (_zz_when_Ddr3MemtestEngine_l65_91 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_91) begin
      _zz_printChar_91 = _zz__zz_printChar_91;
    end else begin
      _zz_printChar_91 = _zz__zz_printChar_91_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_92 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_92};
  assign when_Ddr3MemtestEngine_l65_92 = (_zz_when_Ddr3MemtestEngine_l65_92 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_92) begin
      _zz_printChar_92 = _zz__zz_printChar_92;
    end else begin
      _zz_printChar_92 = _zz__zz_printChar_92_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_93 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_93};
  assign when_Ddr3MemtestEngine_l65_93 = (_zz_when_Ddr3MemtestEngine_l65_93 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_93) begin
      _zz_printChar_93 = _zz__zz_printChar_93;
    end else begin
      _zz_printChar_93 = _zz__zz_printChar_93_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_94 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_94};
  assign when_Ddr3MemtestEngine_l65_94 = (_zz_when_Ddr3MemtestEngine_l65_94 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_94) begin
      _zz_printChar_94 = _zz__zz_printChar_94;
    end else begin
      _zz_printChar_94 = _zz__zz_printChar_94_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_95 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_95};
  assign when_Ddr3MemtestEngine_l65_95 = (_zz_when_Ddr3MemtestEngine_l65_95 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_95) begin
      _zz_printChar_95 = _zz__zz_printChar_95;
    end else begin
      _zz_printChar_95 = _zz__zz_printChar_95_1;
    end
  end

  assign _zz_when_Ddr3MemtestEngine_l65_96 = {4'd0, _zz__zz_when_Ddr3MemtestEngine_l65_96};
  assign when_Ddr3MemtestEngine_l65_96 = (_zz_when_Ddr3MemtestEngine_l65_96 < 8'h0a);
  always @(*) begin
    if(when_Ddr3MemtestEngine_l65_96) begin
      _zz_printChar_96 = _zz__zz_printChar_96;
    end else begin
      _zz_printChar_96 = _zz__zz_printChar_96_1;
    end
  end

  assign when_Ddr3MemtestEngine_l698 = (fsm_delayCounter == 28'h00b964f);
  always @(posedge clkoutd or posedge _zz_1) begin
    if(_zz_1) begin
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
      beatIdx <= 6'h0;
      wrCycleCnt <= 32'h0;
      rdCycleCnt <= 32'h0;
      fsm_msgIndex <= 7'h0;
      fsm_delayCounter <= 28'h0;
      fsm_stateReg <= fsm_BOOT;
    end else begin
      if(txStream_fire) begin
        printValid <= 1'b0;
      end
      hbCounter <= (hbCounter + 25'h0000001);
      if(when_Ddr3MemtestEngine_l101) begin
        hbReg <= (! hbReg);
      end
      fsm_stateReg <= fsm_stateNext;
      case(fsm_stateReg)
        fsm_sBootBanner : begin
          if(when_Ddr3MemtestEngine_l199) begin
            case(fsm_msgIndex)
              7'h0 : begin
                printChar <= 8'h0d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h01 : begin
                printChar <= 8'h0a;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h02 : begin
                printChar <= 8'h5b;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h03 : begin
                printChar <= 8'h42;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h04 : begin
                printChar <= 8'h4f;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h05 : begin
                printChar <= 8'h4f;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h06 : begin
                printChar <= 8'h54;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h07 : begin
                printChar <= 8'h5d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h08 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h09 : begin
                printChar <= 8'h44;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0a : begin
                printChar <= 8'h44;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0b : begin
                printChar <= 8'h52;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0c : begin
                printChar <= 8'h33;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0d : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0e : begin
                printChar <= 8'h43;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0f : begin
                printChar <= 8'h6f;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h10 : begin
                printChar <= 8'h72;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h11 : begin
                printChar <= 8'h65;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h12 : begin
                printChar <= 8'h0d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h13 : begin
                printChar <= 8'h0a;
                printValid <= 1'b1;
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
          if(when_Ddr3MemtestEngine_l231) begin
            fsm_msgIndex <= 7'h0;
          end else begin
            fsm_delayCounter <= (fsm_delayCounter + 28'h0000001);
            if(when_Ddr3MemtestEngine_l239) begin
              fsm_delayCounter <= 28'h0;
              fsm_msgIndex <= 7'h0;
            end
          end
        end
        fsm_sPrintCalib : begin
          if(when_Ddr3MemtestEngine_l250) begin
            case(fsm_msgIndex)
              7'h0 : begin
                printChar <= 8'h5b;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h01 : begin
                printChar <= 8'h43;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h02 : begin
                printChar <= 8'h41;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h03 : begin
                printChar <= 8'h4c;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h04 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h05 : begin
                printChar <= 8'h73;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h06 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h07 : begin
                printChar <= _zz_printChar;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h08 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h09 : begin
                printChar <= 8'h57;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0a : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0b : begin
                printChar <= _zz_printChar_1;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0c : begin
                printChar <= _zz_printChar_2;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0d : begin
                printChar <= 8'h0d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0e : begin
                printChar <= 8'h0a;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              default : begin
                fsm_msgIndex <= 7'h0;
              end
            endcase
          end
        end
        fsm_sPrintBanner : begin
          if(when_Ddr3MemtestEngine_l277) begin
            case(fsm_msgIndex)
              7'h0 : begin
                printChar <= 8'h0d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h01 : begin
                printChar <= 8'h0a;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h02 : begin
                printChar <= 8'h5b;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h03 : begin
                printChar <= 8'h44;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h04 : begin
                printChar <= 8'h44;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h05 : begin
                printChar <= 8'h52;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h06 : begin
                printChar <= 8'h33;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h07 : begin
                printChar <= 8'h2d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h08 : begin
                printChar <= 8'h4f;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h09 : begin
                printChar <= 8'h4b;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0a : begin
                printChar <= 8'h5d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0b : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0c : begin
                printChar <= 8'h57;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0d : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0e : begin
                printChar <= _zz_printChar_3;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0f : begin
                printChar <= _zz_printChar_4;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h10 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h11 : begin
                printChar <= 8'h50;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h12 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h13 : begin
                printChar <= _zz_printChar_5;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h14 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h15 : begin
                printChar <= 8'h53;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h16 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h17 : begin
                printChar <= _zz_printChar_6;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h18 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h19 : begin
                printChar <= 8'h52;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1a : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1b : begin
                printChar <= _zz_printChar_7;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1c : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1d : begin
                printChar <= 8'h43;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1e : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1f : begin
                printChar <= _zz_printChar_8;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h20 : begin
                printChar <= 8'h0d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h21 : begin
                printChar <= 8'h0a;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              default : begin
                fsm_msgIndex <= 7'h0;
              end
            endcase
          end
        end
        fsm_sPrintWlmap : begin
          if(when_Ddr3MemtestEngine_l325) begin
            case(fsm_msgIndex)
              7'h0 : begin
                printChar <= 8'h0d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h01 : begin
                printChar <= 8'h0a;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h02 : begin
                printChar <= 8'h5b;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h03 : begin
                printChar <= 8'h57;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h04 : begin
                printChar <= 8'h4c;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h05 : begin
                printChar <= 8'h4d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h06 : begin
                printChar <= 8'h41;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h07 : begin
                printChar <= 8'h50;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h08 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h09 : begin
                printChar <= 8'h66;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0a : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0b : begin
                printChar <= _zz_printChar_9;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0c : begin
                printChar <= _zz_printChar_10;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0d : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0e : begin
                printChar <= 8'h6c;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0f : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h10 : begin
                printChar <= _zz_printChar_11;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h11 : begin
                printChar <= _zz_printChar_12;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h12 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h13 : begin
                printChar <= 8'h6e;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h14 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h15 : begin
                printChar <= _zz_printChar_13;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h16 : begin
                printChar <= _zz_printChar_14;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h17 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h18 : begin
                printChar <= 8'h6d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h19 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h5a : begin
                printChar <= 8'h0d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h5b : begin
                printChar <= 8'h0a;
                printValid <= 1'b1;
                fsm_msgIndex <= 7'h0;
              end
              default : begin
                printChar <= _zz_printChar_15;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
            endcase
          end
        end
        fsm_sPrintLatch : begin
          if(when_Ddr3MemtestEngine_l365) begin
            case(fsm_msgIndex)
              7'h0 : begin
                printChar <= 8'h5b;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h01 : begin
                printChar <= 8'h4c;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h02 : begin
                printChar <= 8'h41;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h03 : begin
                printChar <= 8'h54;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h04 : begin
                printChar <= 8'h43;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h05 : begin
                printChar <= 8'h48;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h06 : begin
                printChar <= 8'h5d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h07 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h08 : begin
                printChar <= 8'h41;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h09 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0a : begin
                printChar <= _zz_printChar_16;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0b : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0c : begin
                printChar <= 8'h53;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0d : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0e : begin
                printChar <= _zz_printChar_17;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0f : begin
                printChar <= _zz_printChar_18;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h10 : begin
                printChar <= _zz_printChar_19;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h11 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h12 : begin
                printChar <= 8'h4c;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h13 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h34 : begin
                printChar <= 8'h0d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h35 : begin
                printChar <= 8'h0a;
                printValid <= 1'b1;
                fsm_msgIndex <= 7'h0;
              end
              default : begin
                printChar <= _zz_printChar_20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
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
            if(when_Ddr3MemtestEngine_l442) begin
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
            if(when_Ddr3MemtestEngine_l458) begin
              errorReg <= 1'b1;
              errAddr <= 32'h00000008;
              errExpected <= 64'hfedcba9876543210;
              errActual <= io_axi_r_payload_data;
            end
            if(when_Ddr3MemtestEngine_l464) begin
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
            beatIdx <= 6'h0;
          end
        end
        fsm_sBulkWriteW : begin
          wrCycleCnt <= (wrCycleCnt + 32'h00000001);
          if(io_axi_w_ready) begin
            if(!when_Ddr3MemtestEngine_l495) begin
              beatIdx <= (beatIdx + 6'h01);
            end
          end
        end
        fsm_sBulkWriteB : begin
          wrCycleCnt <= (wrCycleCnt + 32'h00000001);
          if(io_axi_b_valid) begin
            if(when_Ddr3MemtestEngine_l506) begin
              burstIndex <= 11'h0;
              rdCycleCnt <= 32'h0;
            end else begin
              burstIndex <= (burstIndex + 11'h010);
            end
          end
        end
        fsm_sBulkReadAR : begin
          rdCycleCnt <= (rdCycleCnt + 32'h00000001);
          if(io_axi_ar_ready) begin
            beatIdx <= 6'h0;
          end
        end
        fsm_sBulkReadR : begin
          rdCycleCnt <= (rdCycleCnt + 32'h00000001);
          if(io_axi_r_valid) begin
            if(when_Ddr3MemtestEngine_l534) begin
              errorReg <= 1'b1;
              errAddr <= (beatBlockAddr + (beatIdx[0] ? 32'h00000008 : 32'h0));
              errExpected <= _zz_errExpected;
              errActual <= io_axi_r_payload_data;
            end
            if(when_Ddr3MemtestEngine_l540) begin
              fsm_msgIndex <= 7'h0;
            end else begin
              if(when_Ddr3MemtestEngine_l544) begin
                if(when_Ddr3MemtestEngine_l545) begin
                  fsm_msgIndex <= 7'h0;
                end else begin
                  burstIndex <= (burstIndex + 11'h010);
                end
              end else begin
                beatIdx <= (beatIdx + 6'h01);
              end
            end
          end
        end
        fsm_sReportPass : begin
          passReg <= 1'b1;
          if(when_Ddr3MemtestEngine_l562) begin
            case(fsm_msgIndex)
              7'h0 : begin
                printChar <= 8'h5b;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h01 : begin
                printChar <= 8'h50;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h02 : begin
                printChar <= 8'h41;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h03 : begin
                printChar <= 8'h53;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h04 : begin
                printChar <= 8'h53;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h05 : begin
                printChar <= 8'h5d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h06 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h07 : begin
                printChar <= _zz_printChar_21;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h08 : begin
                printChar <= _zz_printChar_22;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h09 : begin
                printChar <= _zz_printChar_23;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0a : begin
                printChar <= _zz_printChar_24;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0b : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0c : begin
                printChar <= 8'h57;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0d : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0e : begin
                printChar <= _zz_printChar_25;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0f : begin
                printChar <= _zz_printChar_26;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h10 : begin
                printChar <= _zz_printChar_27;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h11 : begin
                printChar <= _zz_printChar_28;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h12 : begin
                printChar <= _zz_printChar_29;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h13 : begin
                printChar <= _zz_printChar_30;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h14 : begin
                printChar <= _zz_printChar_31;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h15 : begin
                printChar <= _zz_printChar_32;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h16 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h17 : begin
                printChar <= 8'h52;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h18 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h19 : begin
                printChar <= _zz_printChar_33;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1a : begin
                printChar <= _zz_printChar_34;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1b : begin
                printChar <= _zz_printChar_35;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1c : begin
                printChar <= _zz_printChar_36;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1d : begin
                printChar <= _zz_printChar_37;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1e : begin
                printChar <= _zz_printChar_38;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1f : begin
                printChar <= _zz_printChar_39;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h20 : begin
                printChar <= _zz_printChar_40;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h21 : begin
                printChar <= 8'h0d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h22 : begin
                printChar <= 8'h0a;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              default : begin
                passCount <= (passCount + 16'h0001);
                fsm_delayCounter <= 28'h0;
              end
            endcase
          end
        end
        fsm_sReportFail : begin
          if(when_Ddr3MemtestEngine_l610) begin
            case(fsm_msgIndex)
              7'h0 : begin
                printChar <= 8'h5b;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h01 : begin
                printChar <= 8'h46;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h02 : begin
                printChar <= 8'h41;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h03 : begin
                printChar <= 8'h49;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h04 : begin
                printChar <= 8'h4c;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h05 : begin
                printChar <= 8'h5d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h06 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h07 : begin
                printChar <= 8'h41;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h08 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h09 : begin
                printChar <= _zz_printChar_41;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0a : begin
                printChar <= _zz_printChar_42;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0b : begin
                printChar <= _zz_printChar_43;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0c : begin
                printChar <= _zz_printChar_44;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0d : begin
                printChar <= _zz_printChar_45;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0e : begin
                printChar <= _zz_printChar_46;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h0f : begin
                printChar <= _zz_printChar_47;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h10 : begin
                printChar <= _zz_printChar_48;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h11 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h12 : begin
                printChar <= 8'h45;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h13 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h14 : begin
                printChar <= _zz_printChar_49;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h15 : begin
                printChar <= _zz_printChar_50;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h16 : begin
                printChar <= _zz_printChar_51;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h17 : begin
                printChar <= _zz_printChar_52;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h18 : begin
                printChar <= _zz_printChar_53;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h19 : begin
                printChar <= _zz_printChar_54;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1a : begin
                printChar <= _zz_printChar_55;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1b : begin
                printChar <= _zz_printChar_56;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1c : begin
                printChar <= _zz_printChar_57;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1d : begin
                printChar <= _zz_printChar_58;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1e : begin
                printChar <= _zz_printChar_59;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h1f : begin
                printChar <= _zz_printChar_60;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h20 : begin
                printChar <= _zz_printChar_61;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h21 : begin
                printChar <= _zz_printChar_62;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h22 : begin
                printChar <= _zz_printChar_63;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h23 : begin
                printChar <= _zz_printChar_64;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h24 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h25 : begin
                printChar <= 8'h47;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h26 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h27 : begin
                printChar <= _zz_printChar_65;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h28 : begin
                printChar <= _zz_printChar_66;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h29 : begin
                printChar <= _zz_printChar_67;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h2a : begin
                printChar <= _zz_printChar_68;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h2b : begin
                printChar <= _zz_printChar_69;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h2c : begin
                printChar <= _zz_printChar_70;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h2d : begin
                printChar <= _zz_printChar_71;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h2e : begin
                printChar <= _zz_printChar_72;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h2f : begin
                printChar <= _zz_printChar_73;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h30 : begin
                printChar <= _zz_printChar_74;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h31 : begin
                printChar <= _zz_printChar_75;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h32 : begin
                printChar <= _zz_printChar_76;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h33 : begin
                printChar <= _zz_printChar_77;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h34 : begin
                printChar <= _zz_printChar_78;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h35 : begin
                printChar <= _zz_printChar_79;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h36 : begin
                printChar <= _zz_printChar_80;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h37 : begin
                printChar <= 8'h20;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h38 : begin
                printChar <= 8'h48;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h39 : begin
                printChar <= 8'h3d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h3a : begin
                printChar <= _zz_printChar_81;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h3b : begin
                printChar <= _zz_printChar_82;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h3c : begin
                printChar <= _zz_printChar_83;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h3d : begin
                printChar <= _zz_printChar_84;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h3e : begin
                printChar <= _zz_printChar_85;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h3f : begin
                printChar <= _zz_printChar_86;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h40 : begin
                printChar <= _zz_printChar_87;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h41 : begin
                printChar <= _zz_printChar_88;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h42 : begin
                printChar <= _zz_printChar_89;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h43 : begin
                printChar <= _zz_printChar_90;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h44 : begin
                printChar <= _zz_printChar_91;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h45 : begin
                printChar <= _zz_printChar_92;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h46 : begin
                printChar <= _zz_printChar_93;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h47 : begin
                printChar <= _zz_printChar_94;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h48 : begin
                printChar <= _zz_printChar_95;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h49 : begin
                printChar <= _zz_printChar_96;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h4a : begin
                printChar <= 8'h0d;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              7'h4b : begin
                printChar <= 8'h0a;
                printValid <= 1'b1;
                fsm_msgIndex <= (fsm_msgIndex + 7'h01);
              end
              default : begin
              end
            endcase
          end
        end
        fsm_sLoopDelay : begin
          fsm_delayCounter <= (fsm_delayCounter + 28'h0000001);
          if(when_Ddr3MemtestEngine_l698) begin
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
  output wire [255:0]  io_wlMap,
  output wire [7:0]    io_wlFirst,
  output wire [7:0]    io_wlLast,
  output wire [7:0]    io_wlMatchN,
  output wire [1:0]    io_wr_adv,
  output wire [11:0]   io_w_scores,
  output wire [127:0]  io_train_latch,
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
  wire       [255:0]  area_ctrl_io_wlMap;
  wire       [7:0]    area_ctrl_io_wlFirst;
  wire       [7:0]    area_ctrl_io_wlLast;
  wire       [7:0]    area_ctrl_io_wlMatchN;
  wire       [1:0]    area_ctrl_io_wr_adv;
  wire       [11:0]   area_ctrl_io_w_scores;
  wire       [127:0]  area_ctrl_io_train_latch;
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
    .io_wlMap             (area_ctrl_io_wlMap[255:0]              ), //o
    .io_wlFirst           (area_ctrl_io_wlFirst[7:0]              ), //o
    .io_wlLast            (area_ctrl_io_wlLast[7:0]               ), //o
    .io_wlMatchN          (area_ctrl_io_wlMatchN[7:0]             ), //o
    .io_wr_adv            (area_ctrl_io_wr_adv[1:0]               ), //o
    .io_w_scores          (area_ctrl_io_w_scores[11:0]            ), //o
    .io_train_latch       (area_ctrl_io_train_latch[127:0]        ), //o
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
  assign io_wlMap = area_ctrl_io_wlMap;
  assign io_wlFirst = area_ctrl_io_wlFirst;
  assign io_wlLast = area_ctrl_io_wlLast;
  assign io_wlMatchN = area_ctrl_io_wlMatchN;
  assign io_wr_adv = area_ctrl_io_wr_adv;
  assign io_w_scores = area_ctrl_io_w_scores;
  assign io_train_latch = area_ctrl_io_train_latch;

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
  output wire [255:0]  io_wlMap,
  output wire [7:0]    io_wlFirst,
  output wire [7:0]    io_wlLast,
  output wire [7:0]    io_wlMatchN,
  output wire [1:0]    io_wr_adv,
  output wire [11:0]   io_w_scores,
  output wire [127:0]  io_train_latch,
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
  wire       [255:0]  coreArea_core_io_wlMap;
  wire       [7:0]    coreArea_core_io_wlFirst;
  wire       [7:0]    coreArea_core_io_wlLast;
  wire       [7:0]    coreArea_core_io_wlMatchN;
  wire       [1:0]    coreArea_core_io_wr_adv;
  wire       [11:0]   coreArea_core_io_w_scores;
  wire       [127:0]  coreArea_core_io_train_latch;
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
  wire                _zz_when_Ddr3ControllerCore_l2226;

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
    .io_wlMap                          (coreArea_core_io_wlMap[255:0]            ), //o
    .io_wlFirst                        (coreArea_core_io_wlFirst[7:0]            ), //o
    .io_wlLast                         (coreArea_core_io_wlLast[7:0]             ), //o
    .io_wlMatchN                       (coreArea_core_io_wlMatchN[7:0]           ), //o
    .io_wr_adv                         (coreArea_core_io_wr_adv[1:0]             ), //o
    .io_w_scores                       (coreArea_core_io_w_scores[11:0]          ), //o
    .io_train_latch                    (coreArea_core_io_train_latch[127:0]      ), //o
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
    ._zz_when_Ddr3ControllerCore_l2226 (_zz_when_Ddr3ControllerCore_l2226        ), //i
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
  assign _zz_when_Ddr3ControllerCore_l2226 = (! io_resetn);
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
  assign io_wlMap = coreArea_core_io_wlMap;
  assign io_wlFirst = coreArea_core_io_wlFirst;
  assign io_wlLast = coreArea_core_io_wlLast;
  assign io_wlMatchN = coreArea_core_io_wlMatchN;
  assign io_wr_adv = coreArea_core_io_wr_adv;
  assign io_w_scores = coreArea_core_io_w_scores;
  assign io_train_latch = coreArea_core_io_train_latch;

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
  wire       [4:0]    rFifo_io_availability;
  wire                wFifo_io_push_ready;
  wire                wFifo_io_pop_valid;
  wire       [127:0]  wFifo_io_pop_payload_data;
  wire       [15:0]   wFifo_io_pop_payload_strb;
  wire       [4:0]    wFifo_io_occupancy;
  wire       [4:0]    wFifo_io_availability;
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
  reg                 outReq_ready;
  wire                outReq_payload_write;
  wire       [26:0]   outReq_payload_addr;
  wire       [127:0]  outReq_payload_wdata;
  wire       [15:0]   outReq_payload_wstrb;
  wire                outReq_stage_valid;
  wire                outReq_stage_ready;
  wire                outReq_stage_payload_write;
  wire       [26:0]   outReq_stage_payload_addr;
  wire       [127:0]  outReq_stage_payload_wdata;
  wire       [15:0]   outReq_stage_payload_wstrb;
  reg                 outReq_rValid;
  reg                 outReq_rData_write;
  reg        [26:0]   outReq_rData_addr;
  reg        [127:0]  outReq_rData_wdata;
  reg        [15:0]   outReq_rData_wstrb;
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
  StreamFifoLowLatency rFifo (
    .io_push_valid   (rFifo_io_push_valid        ), //i
    .io_push_ready   (rFifo_io_push_ready        ), //o
    .io_push_payload (io_rsp_payload_rdata[127:0]), //i
    .io_pop_valid    (rFifo_io_pop_valid         ), //o
    .io_pop_ready    (rFifo_io_pop_ready         ), //i
    .io_pop_payload  (rFifo_io_pop_payload[127:0]), //o
    .io_flush        (1'b0                       ), //i
    .io_occupancy    (rFifo_io_occupancy[4:0]    ), //o
    .io_availability (rFifo_io_availability[4:0] ), //o
    .io_pclk         (io_pclk                    ), //i
    ._zz_1           (_zz_1                      )  //i
  );
  StreamFifoLowLatency_1 wFifo (
    .io_push_valid        (wFifo_io_push_valid              ), //i
    .io_push_ready        (wFifo_io_push_ready              ), //o
    .io_push_payload_data (wFifo_io_push_payload_data[127:0]), //i
    .io_push_payload_strb (wFifo_io_push_payload_strb[15:0] ), //i
    .io_pop_valid         (wFifo_io_pop_valid               ), //o
    .io_pop_ready         (wFifo_io_pop_ready               ), //i
    .io_pop_payload_data  (wFifo_io_pop_payload_data[127:0] ), //o
    .io_pop_payload_strb  (wFifo_io_pop_payload_strb[15:0]  ), //o
    .io_flush             (1'b0                             ), //i
    .io_occupancy         (wFifo_io_occupancy[4:0]          ), //o
    .io_availability      (wFifo_io_availability[4:0]       ), //o
    .io_pclk              (io_pclk                          ), //i
    ._zz_1                (_zz_1                            )  //i
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

  always @(*) begin
    outReq_ready = outReq_stage_ready;
    if(when_Stream_l477) begin
      outReq_ready = 1'b1;
    end
  end

  assign when_Stream_l477 = (! outReq_stage_valid);
  assign outReq_stage_valid = outReq_rValid;
  assign outReq_stage_payload_write = outReq_rData_write;
  assign outReq_stage_payload_addr = outReq_rData_addr;
  assign outReq_stage_payload_wdata = outReq_rData_wdata;
  assign outReq_stage_payload_wstrb = outReq_rData_wstrb;
  assign io_req_valid = outReq_stage_valid;
  assign outReq_stage_ready = io_req_ready;
  assign io_req_payload_write = outReq_stage_payload_write;
  assign io_req_payload_addr = outReq_stage_payload_addr;
  assign io_req_payload_wdata = outReq_stage_payload_wdata;
  assign io_req_payload_wstrb = outReq_stage_payload_wstrb;
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
      outReq_rValid <= 1'b0;
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
      if(outReq_ready) begin
        outReq_rValid <= outReq_valid;
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
  output wire [255:0]  io_wlMap,
  output wire [7:0]    io_wlFirst,
  output wire [7:0]    io_wlLast,
  output wire [7:0]    io_wlMatchN,
  output wire [1:0]    io_wr_adv,
  output wire [11:0]   io_w_scores,
  output wire [127:0]  io_train_latch,
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
  input  wire          _zz_when_Ddr3ControllerCore_l2226,
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

  wire       [3:0]    _zz_rotScores_0;
  wire       [3:0]    _zz_rotScores_0_1;
  wire       [3:0]    _zz_rotScores_0_2;
  wire       [3:0]    _zz_rotScores_0_3;
  wire       [3:0]    _zz_rotScores_0_4;
  wire       [3:0]    _zz_rotScores_0_5;
  wire       [3:0]    _zz_rotScores_0_6;
  wire       [3:0]    _zz_rotScores_0_7;
  wire       [0:0]    _zz_rotScores_0_8;
  wire       [3:0]    _zz_rotScores_0_9;
  wire       [0:0]    _zz_rotScores_0_10;
  wire       [3:0]    _zz_rotScores_0_11;
  wire       [0:0]    _zz_rotScores_0_12;
  wire       [3:0]    _zz_rotScores_0_13;
  wire       [0:0]    _zz_rotScores_0_14;
  wire       [3:0]    _zz_rotScores_0_15;
  wire       [0:0]    _zz_rotScores_0_16;
  wire       [3:0]    _zz_rotScores_0_17;
  wire       [0:0]    _zz_rotScores_0_18;
  wire       [3:0]    _zz_rotScores_0_19;
  wire       [0:0]    _zz_rotScores_0_20;
  wire       [3:0]    _zz_rotScores_0_21;
  wire       [0:0]    _zz_rotScores_0_22;
  wire       [3:0]    _zz_rotScores_1;
  wire       [3:0]    _zz_rotScores_1_1;
  wire       [3:0]    _zz_rotScores_1_2;
  wire       [3:0]    _zz_rotScores_1_3;
  wire       [3:0]    _zz_rotScores_1_4;
  wire       [3:0]    _zz_rotScores_1_5;
  wire       [3:0]    _zz_rotScores_1_6;
  wire       [3:0]    _zz_rotScores_1_7;
  wire       [0:0]    _zz_rotScores_1_8;
  wire       [3:0]    _zz_rotScores_1_9;
  wire       [0:0]    _zz_rotScores_1_10;
  wire       [3:0]    _zz_rotScores_1_11;
  wire       [0:0]    _zz_rotScores_1_12;
  wire       [3:0]    _zz_rotScores_1_13;
  wire       [0:0]    _zz_rotScores_1_14;
  wire       [3:0]    _zz_rotScores_1_15;
  wire       [0:0]    _zz_rotScores_1_16;
  wire       [3:0]    _zz_rotScores_1_17;
  wire       [0:0]    _zz_rotScores_1_18;
  wire       [3:0]    _zz_rotScores_1_19;
  wire       [0:0]    _zz_rotScores_1_20;
  wire       [3:0]    _zz_rotScores_1_21;
  wire       [0:0]    _zz_rotScores_1_22;
  wire       [3:0]    _zz_rotScores_2;
  wire       [3:0]    _zz_rotScores_2_1;
  wire       [3:0]    _zz_rotScores_2_2;
  wire       [3:0]    _zz_rotScores_2_3;
  wire       [3:0]    _zz_rotScores_2_4;
  wire       [3:0]    _zz_rotScores_2_5;
  wire       [3:0]    _zz_rotScores_2_6;
  wire       [3:0]    _zz_rotScores_2_7;
  wire       [0:0]    _zz_rotScores_2_8;
  wire       [3:0]    _zz_rotScores_2_9;
  wire       [0:0]    _zz_rotScores_2_10;
  wire       [3:0]    _zz_rotScores_2_11;
  wire       [0:0]    _zz_rotScores_2_12;
  wire       [3:0]    _zz_rotScores_2_13;
  wire       [0:0]    _zz_rotScores_2_14;
  wire       [3:0]    _zz_rotScores_2_15;
  wire       [0:0]    _zz_rotScores_2_16;
  wire       [3:0]    _zz_rotScores_2_17;
  wire       [0:0]    _zz_rotScores_2_18;
  wire       [3:0]    _zz_rotScores_2_19;
  wire       [0:0]    _zz_rotScores_2_20;
  wire       [3:0]    _zz_rotScores_2_21;
  wire       [0:0]    _zz_rotScores_2_22;
  wire       [3:0]    _zz_rotScores_3;
  wire       [3:0]    _zz_rotScores_3_1;
  wire       [3:0]    _zz_rotScores_3_2;
  wire       [3:0]    _zz_rotScores_3_3;
  wire       [3:0]    _zz_rotScores_3_4;
  wire       [3:0]    _zz_rotScores_3_5;
  wire       [3:0]    _zz_rotScores_3_6;
  wire       [3:0]    _zz_rotScores_3_7;
  wire       [0:0]    _zz_rotScores_3_8;
  wire       [3:0]    _zz_rotScores_3_9;
  wire       [0:0]    _zz_rotScores_3_10;
  wire       [3:0]    _zz_rotScores_3_11;
  wire       [0:0]    _zz_rotScores_3_12;
  wire       [3:0]    _zz_rotScores_3_13;
  wire       [0:0]    _zz_rotScores_3_14;
  wire       [3:0]    _zz_rotScores_3_15;
  wire       [0:0]    _zz_rotScores_3_16;
  wire       [3:0]    _zz_rotScores_3_17;
  wire       [0:0]    _zz_rotScores_3_18;
  wire       [3:0]    _zz_rotScores_3_19;
  wire       [0:0]    _zz_rotScores_3_20;
  wire       [3:0]    _zz_rotScores_3_21;
  wire       [0:0]    _zz_rotScores_3_22;
  wire       [3:0]    _zz_rotScores_4;
  wire       [3:0]    _zz_rotScores_4_1;
  wire       [3:0]    _zz_rotScores_4_2;
  wire       [3:0]    _zz_rotScores_4_3;
  wire       [3:0]    _zz_rotScores_4_4;
  wire       [3:0]    _zz_rotScores_4_5;
  wire       [3:0]    _zz_rotScores_4_6;
  wire       [3:0]    _zz_rotScores_4_7;
  wire       [0:0]    _zz_rotScores_4_8;
  wire       [3:0]    _zz_rotScores_4_9;
  wire       [0:0]    _zz_rotScores_4_10;
  wire       [3:0]    _zz_rotScores_4_11;
  wire       [0:0]    _zz_rotScores_4_12;
  wire       [3:0]    _zz_rotScores_4_13;
  wire       [0:0]    _zz_rotScores_4_14;
  wire       [3:0]    _zz_rotScores_4_15;
  wire       [0:0]    _zz_rotScores_4_16;
  wire       [3:0]    _zz_rotScores_4_17;
  wire       [0:0]    _zz_rotScores_4_18;
  wire       [3:0]    _zz_rotScores_4_19;
  wire       [0:0]    _zz_rotScores_4_20;
  wire       [3:0]    _zz_rotScores_4_21;
  wire       [0:0]    _zz_rotScores_4_22;
  wire       [3:0]    _zz_rotScores_5;
  wire       [3:0]    _zz_rotScores_5_1;
  wire       [3:0]    _zz_rotScores_5_2;
  wire       [3:0]    _zz_rotScores_5_3;
  wire       [3:0]    _zz_rotScores_5_4;
  wire       [3:0]    _zz_rotScores_5_5;
  wire       [3:0]    _zz_rotScores_5_6;
  wire       [3:0]    _zz_rotScores_5_7;
  wire       [0:0]    _zz_rotScores_5_8;
  wire       [3:0]    _zz_rotScores_5_9;
  wire       [0:0]    _zz_rotScores_5_10;
  wire       [3:0]    _zz_rotScores_5_11;
  wire       [0:0]    _zz_rotScores_5_12;
  wire       [3:0]    _zz_rotScores_5_13;
  wire       [0:0]    _zz_rotScores_5_14;
  wire       [3:0]    _zz_rotScores_5_15;
  wire       [0:0]    _zz_rotScores_5_16;
  wire       [3:0]    _zz_rotScores_5_17;
  wire       [0:0]    _zz_rotScores_5_18;
  wire       [3:0]    _zz_rotScores_5_19;
  wire       [0:0]    _zz_rotScores_5_20;
  wire       [3:0]    _zz_rotScores_5_21;
  wire       [0:0]    _zz_rotScores_5_22;
  wire       [3:0]    _zz_rotScores_6;
  wire       [3:0]    _zz_rotScores_6_1;
  wire       [3:0]    _zz_rotScores_6_2;
  wire       [3:0]    _zz_rotScores_6_3;
  wire       [3:0]    _zz_rotScores_6_4;
  wire       [3:0]    _zz_rotScores_6_5;
  wire       [3:0]    _zz_rotScores_6_6;
  wire       [3:0]    _zz_rotScores_6_7;
  wire       [0:0]    _zz_rotScores_6_8;
  wire       [3:0]    _zz_rotScores_6_9;
  wire       [0:0]    _zz_rotScores_6_10;
  wire       [3:0]    _zz_rotScores_6_11;
  wire       [0:0]    _zz_rotScores_6_12;
  wire       [3:0]    _zz_rotScores_6_13;
  wire       [0:0]    _zz_rotScores_6_14;
  wire       [3:0]    _zz_rotScores_6_15;
  wire       [0:0]    _zz_rotScores_6_16;
  wire       [3:0]    _zz_rotScores_6_17;
  wire       [0:0]    _zz_rotScores_6_18;
  wire       [3:0]    _zz_rotScores_6_19;
  wire       [0:0]    _zz_rotScores_6_20;
  wire       [3:0]    _zz_rotScores_6_21;
  wire       [0:0]    _zz_rotScores_6_22;
  wire       [3:0]    _zz_rotScores_7;
  wire       [3:0]    _zz_rotScores_7_1;
  wire       [3:0]    _zz_rotScores_7_2;
  wire       [3:0]    _zz_rotScores_7_3;
  wire       [3:0]    _zz_rotScores_7_4;
  wire       [3:0]    _zz_rotScores_7_5;
  wire       [3:0]    _zz_rotScores_7_6;
  wire       [3:0]    _zz_rotScores_7_7;
  wire       [0:0]    _zz_rotScores_7_8;
  wire       [3:0]    _zz_rotScores_7_9;
  wire       [0:0]    _zz_rotScores_7_10;
  wire       [3:0]    _zz_rotScores_7_11;
  wire       [0:0]    _zz_rotScores_7_12;
  wire       [3:0]    _zz_rotScores_7_13;
  wire       [0:0]    _zz_rotScores_7_14;
  wire       [3:0]    _zz_rotScores_7_15;
  wire       [0:0]    _zz_rotScores_7_16;
  wire       [3:0]    _zz_rotScores_7_17;
  wire       [0:0]    _zz_rotScores_7_18;
  wire       [3:0]    _zz_rotScores_7_19;
  wire       [0:0]    _zz_rotScores_7_20;
  wire       [3:0]    _zz_rotScores_7_21;
  wire       [0:0]    _zz_rotScores_7_22;
  wire       [6:0]    _zz_rdCyc;
  wire       [1:0]    _zz_rdCyc_1;
  wire       [0:0]    _zz_rotSplit;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l597;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l601;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l601_1;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l601_2;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l601_3;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l601_4;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l601_5;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l601_6;
  wire       [6:0]    _zz_cycle_1;
  wire       [16:0]   _zz_tick_counter;
  wire       [12:0]   _zz_A_0_1;
  wire       [12:0]   _zz_A_0_2;
  wire       [12:0]   _zz_A_0_3;
  wire       [12:0]   _zz_A_0_4;
  wire       [13:0]   _zz_A_0_5;
  wire       [0:0]    _zz_A_0_6;
  wire       [12:0]   _zz_A_0_7;
  wire       [2:0]    _zz_when_Ddr3ControllerCore_l744;
  wire       [2:0]    _zz_when_Ddr3ControllerCore_l744_1;
  wire       [0:0]    _zz_when_Ddr3ControllerCore_l744_2;
  wire       [12:0]   _zz_A_0_8;
  wire       [7:0]    _zz_wstep;
  wire       [7:0]    _zz_wstep_1;
  wire       [8:0]    _zz_wstep_2;
  wire       [8:0]    _zz_wstep_3;
  wire       [8:0]    _zz_wstep_4;
  wire       [7:0]    _zz_wstep_5;
  wire       [12:0]   _zz_A_0_9;
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
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l1309;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l1321;
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
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l1685_1;
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
  reg        [255:0]  wlMapR;
  reg        [7:0]    wlFirstR;
  reg        [7:0]    wlLastR;
  reg                 wlSeenR;
  reg        [7:0]    wlMatchNR;
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
  reg        [127:0]  trainLatch;
  wire       [15:0]   latchBeats_0;
  wire       [15:0]   latchBeats_1;
  wire       [15:0]   latchBeats_2;
  wire       [15:0]   latchBeats_3;
  wire       [15:0]   latchBeats_4;
  wire       [15:0]   latchBeats_5;
  wire       [15:0]   latchBeats_6;
  wire       [15:0]   latchBeats_7;
  wire       [15:0]   patBeats_0;
  wire       [15:0]   patBeats_1;
  wire       [15:0]   patBeats_2;
  wire       [15:0]   patBeats_3;
  wire       [15:0]   patBeats_4;
  wire       [15:0]   patBeats_5;
  wire       [15:0]   patBeats_6;
  wire       [15:0]   patBeats_7;
  wire       [3:0]    rotScores_0;
  wire       [3:0]    rotScores_1;
  wire       [3:0]    rotScores_2;
  wire       [3:0]    rotScores_3;
  wire       [3:0]    rotScores_4;
  wire       [3:0]    rotScores_5;
  wire       [3:0]    rotScores_6;
  wire       [3:0]    rotScores_7;
  reg        [3:0]    rotScoresReg_0;
  reg        [3:0]    rotScoresReg_1;
  reg        [3:0]    rotScoresReg_2;
  reg        [3:0]    rotScoresReg_3;
  reg        [3:0]    rotScoresReg_4;
  reg        [3:0]    rotScoresReg_5;
  reg        [3:0]    rotScoresReg_6;
  reg        [3:0]    rotScoresReg_7;
  wire       [3:0]    rotScoreW_0;
  wire       [3:0]    rotScoreW_1;
  wire       [3:0]    rotScoreW_2;
  wire       [3:0]    rotScoreW_3;
  wire       [3:0]    rotScoreW_4;
  wire       [3:0]    rotScoreW_5;
  wire       [3:0]    rotScoreW_6;
  wire       [3:0]    rotScoreW_7;
  wire       [2:0]    rotIdxW_0;
  wire       [2:0]    rotIdxW_1;
  wire       [2:0]    rotIdxW_2;
  wire       [2:0]    rotIdxW_3;
  wire       [2:0]    rotIdxW_4;
  wire       [2:0]    rotIdxW_5;
  wire       [2:0]    rotIdxW_6;
  wire       [2:0]    rotIdxW_7;
  wire       [3:0]    treeS1_0;
  wire       [3:0]    treeS1_1;
  wire       [3:0]    treeS1_2;
  wire       [3:0]    treeS1_3;
  wire       [2:0]    treeI1_0;
  wire       [2:0]    treeI1_1;
  wire       [2:0]    treeI1_2;
  wire       [2:0]    treeI1_3;
  wire                _zz_treeS1_0;
  wire                _zz_treeS1_1;
  wire                _zz_treeS1_2;
  wire                _zz_treeS1_3;
  wire       [3:0]    treeS2_0;
  wire       [3:0]    treeS2_1;
  wire       [2:0]    treeI2_0;
  wire       [2:0]    treeI2_1;
  wire                _zz_treeS2_0;
  wire                _zz_treeS2_1;
  wire                _zz_rotScoreW_7;
  reg        [3:0]    sweepScoreReg;
  reg        [2:0]    sweepRotReg;
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
  reg        [127:0]  bestLatch;
  reg        [3:0]    bestWCnt;
  reg        [1:0]    bestWPos;
  reg        [2:0]    bestWSel;
  reg        [2:0]    bestWRot;
  reg        [1:0]    bestWMode;
  reg        [3:0]    wScores_0;
  reg        [3:0]    wScores_1;
  reg        [3:0]    wScores_2;
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
  wire                when_Ddr3ControllerCore_l471;
  wire                when_Ddr3ControllerCore_l472;
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
  wire                when_Ddr3ControllerCore_l555;
  wire                when_Ddr3ControllerCore_l556;
  wire       [6:0]    rdCyc;
  wire       [6:0]    rotSplit;
  reg        [3:0]    dqs_read;
  wire                when_Ddr3ControllerCore_l597;
  wire                when_Ddr3ControllerCore_l601;
  wire       [13:0]   inRow;
  wire       [2:0]    inBank;
  wire                inSameRow;
  wire                canAcceptWrStream;
  wire                canAcceptRdStream;
  wire                acceptReq;
  wire                when_Ddr3ControllerCore_l640;
  wire                when_Ddr3ControllerCore_l645;
  wire                when_Ddr3ControllerCore_l660;
  wire       [15:0]   _zz_A_0;
  wire                when_Ddr3ControllerCore_l785;
  wire                when_Ddr3ControllerCore_l744;
  wire                when_Ddr3ControllerCore_l737;
  wire                when_Ddr3ControllerCore_l745;
  wire                when_Ddr3ControllerCore_l750;
  wire                when_Ddr3ControllerCore_l759;
  wire                when_Ddr3ControllerCore_l774;
  wire                when_Ddr3ControllerCore_l763;
  wire                when_Ddr3ControllerCore_l924;
  wire                when_Ddr3ControllerCore_l929;
  wire                when_Ddr3ControllerCore_l949;
  wire                when_Ddr3ControllerCore_l951;
  wire                when_Ddr3ControllerCore_l963;
  wire                when_Ddr3ControllerCore_l987;
  wire                when_Ddr3ControllerCore_l988;
  wire                when_Ddr3ControllerCore_l1003;
  wire                when_Ddr3ControllerCore_l1028;
  wire                when_Ddr3ControllerCore_l1046;
  wire                when_Ddr3ControllerCore_l1071;
  wire                when_Ddr3ControllerCore_l1076;
  wire                when_Ddr3ControllerCore_l1087;
  wire                when_Ddr3ControllerCore_l1112;
  wire                when_Ddr3ControllerCore_l1148;
  wire                when_Ddr3ControllerCore_l1154;
  wire                when_Ddr3ControllerCore_l1176;
  wire                when_Ddr3ControllerCore_l1195;
  wire                when_Ddr3ControllerCore_l1200;
  wire                when_Ddr3ControllerCore_l1225;
  wire                when_Ddr3ControllerCore_l1233;
  wire                when_Ddr3ControllerCore_l1237;
  wire                when_Ddr3ControllerCore_l1244;
  wire                when_Ddr3ControllerCore_l1252;
  wire                when_Ddr3ControllerCore_l1254;
  wire                when_Ddr3ControllerCore_l1260;
  wire                when_Ddr3ControllerCore_l1267;
  wire       [1:0]    _zz_wrMode;
  wire                when_Ddr3ControllerCore_l1276;
  wire                when_Ddr3ControllerCore_l1293;
  wire                when_Ddr3ControllerCore_l1300;
  wire                when_Ddr3ControllerCore_l1309;
  wire       [6:0]    _zz_s0Mag;
  wire                when_Ddr3ControllerCore_l1321;
  wire       [6:0]    _zz_s0Mag_1;
  wire                when_Ddr3ControllerCore_l1314;
  wire                when_Ddr3ControllerCore_l1350;
  wire                when_Ddr3ControllerCore_l1387;
  wire                when_Ddr3ControllerCore_l1432;
  wire       [3:0]    _zz_1;
  wire                when_Ddr3ControllerCore_l1435;
  wire                when_Ddr3ControllerCore_l1436;
  wire                when_Ddr3ControllerCore_l1444;
  wire                when_Ddr3ControllerCore_l1466;
  wire       [13:0]   _zz_openRow;
  wire       [2:0]    _zz_openBank;
  wire                _zz_cycle;
  wire                when_Ddr3ControllerCore_l1570;
  wire                when_Ddr3ControllerCore_l1579;
  wire                when_Ddr3ControllerCore_l1611;
  wire       [13:0]   _zz_openRow_1;
  wire       [2:0]    _zz_openBank_1;
  wire       [2:0]    _zz_BA_2;
  wire       [15:0]   _zz_A_2;
  wire                when_Ddr3ControllerCore_l1657;
  wire                when_Ddr3ControllerCore_l1661;
  wire                when_Ddr3ControllerCore_l1667;
  wire                when_Ddr3ControllerCore_l1666;
  wire       [6:0]    _zz_when_Ddr3ControllerCore_l1685;
  wire                _zz_data_ready;
  wire                when_Ddr3ControllerCore_l1685;
  wire       [9:0]    _zz_A_2_1;
  wire       [2:0]    _zz_BA_2_1;
  wire                when_Ddr3ControllerCore_l1700;
  wire                when_Ddr3ControllerCore_l1706;
  wire                when_Ddr3ControllerCore_l1741;
  wire                when_Ddr3ControllerCore_l1827;
  wire                when_Ddr3ControllerCore_l1859;
  wire                when_Ddr3ControllerCore_l1877;
  wire                when_Ddr3ControllerCore_l1889;
  wire                when_Ddr3ControllerCore_l1900;
  wire                when_Ddr3ControllerCore_l1930;
  wire                when_Ddr3ControllerCore_l1966;
  wire                when_Ddr3ControllerCore_l1969;
  wire                when_Ddr3ControllerCore_l1979;
  wire                when_Ddr3ControllerCore_l2000;
  wire                when_Ddr3ControllerCore_l2010;
  wire                when_Ddr3ControllerCore_l2038;
  wire                when_Ddr3ControllerCore_l2042;
  wire                when_Ddr3ControllerCore_l2051;
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
  wire                when_Ddr3ControllerCore_l2226;
  `ifndef SYNTHESIS
  reg [111:0] state_string;
  `endif


  assign _zz_rotScores_0 = (_zz_rotScores_0_1 + _zz_rotScores_0_19);
  assign _zz_rotScores_0_1 = (_zz_rotScores_0_2 + _zz_rotScores_0_17);
  assign _zz_rotScores_0_2 = (_zz_rotScores_0_3 + _zz_rotScores_0_15);
  assign _zz_rotScores_0_3 = (_zz_rotScores_0_4 + _zz_rotScores_0_13);
  assign _zz_rotScores_0_4 = (_zz_rotScores_0_5 + _zz_rotScores_0_11);
  assign _zz_rotScores_0_5 = (_zz_rotScores_0_6 + _zz_rotScores_0_9);
  assign _zz_rotScores_0_6 = (4'b0000 + _zz_rotScores_0_7);
  assign _zz_rotScores_0_8 = (latchBeats_0 == patBeats_0);
  assign _zz_rotScores_0_7 = {3'd0, _zz_rotScores_0_8};
  assign _zz_rotScores_0_10 = (latchBeats_1 == patBeats_1);
  assign _zz_rotScores_0_9 = {3'd0, _zz_rotScores_0_10};
  assign _zz_rotScores_0_12 = (latchBeats_2 == patBeats_2);
  assign _zz_rotScores_0_11 = {3'd0, _zz_rotScores_0_12};
  assign _zz_rotScores_0_14 = (latchBeats_3 == patBeats_3);
  assign _zz_rotScores_0_13 = {3'd0, _zz_rotScores_0_14};
  assign _zz_rotScores_0_16 = (latchBeats_4 == patBeats_4);
  assign _zz_rotScores_0_15 = {3'd0, _zz_rotScores_0_16};
  assign _zz_rotScores_0_18 = (latchBeats_5 == patBeats_5);
  assign _zz_rotScores_0_17 = {3'd0, _zz_rotScores_0_18};
  assign _zz_rotScores_0_20 = (latchBeats_6 == patBeats_6);
  assign _zz_rotScores_0_19 = {3'd0, _zz_rotScores_0_20};
  assign _zz_rotScores_0_22 = (latchBeats_7 == patBeats_7);
  assign _zz_rotScores_0_21 = {3'd0, _zz_rotScores_0_22};
  assign _zz_rotScores_1 = (_zz_rotScores_1_1 + _zz_rotScores_1_19);
  assign _zz_rotScores_1_1 = (_zz_rotScores_1_2 + _zz_rotScores_1_17);
  assign _zz_rotScores_1_2 = (_zz_rotScores_1_3 + _zz_rotScores_1_15);
  assign _zz_rotScores_1_3 = (_zz_rotScores_1_4 + _zz_rotScores_1_13);
  assign _zz_rotScores_1_4 = (_zz_rotScores_1_5 + _zz_rotScores_1_11);
  assign _zz_rotScores_1_5 = (_zz_rotScores_1_6 + _zz_rotScores_1_9);
  assign _zz_rotScores_1_6 = (4'b0000 + _zz_rotScores_1_7);
  assign _zz_rotScores_1_8 = (latchBeats_0 == patBeats_1);
  assign _zz_rotScores_1_7 = {3'd0, _zz_rotScores_1_8};
  assign _zz_rotScores_1_10 = (latchBeats_1 == patBeats_2);
  assign _zz_rotScores_1_9 = {3'd0, _zz_rotScores_1_10};
  assign _zz_rotScores_1_12 = (latchBeats_2 == patBeats_3);
  assign _zz_rotScores_1_11 = {3'd0, _zz_rotScores_1_12};
  assign _zz_rotScores_1_14 = (latchBeats_3 == patBeats_4);
  assign _zz_rotScores_1_13 = {3'd0, _zz_rotScores_1_14};
  assign _zz_rotScores_1_16 = (latchBeats_4 == patBeats_5);
  assign _zz_rotScores_1_15 = {3'd0, _zz_rotScores_1_16};
  assign _zz_rotScores_1_18 = (latchBeats_5 == patBeats_6);
  assign _zz_rotScores_1_17 = {3'd0, _zz_rotScores_1_18};
  assign _zz_rotScores_1_20 = (latchBeats_6 == patBeats_7);
  assign _zz_rotScores_1_19 = {3'd0, _zz_rotScores_1_20};
  assign _zz_rotScores_1_22 = (latchBeats_7 == patBeats_0);
  assign _zz_rotScores_1_21 = {3'd0, _zz_rotScores_1_22};
  assign _zz_rotScores_2 = (_zz_rotScores_2_1 + _zz_rotScores_2_19);
  assign _zz_rotScores_2_1 = (_zz_rotScores_2_2 + _zz_rotScores_2_17);
  assign _zz_rotScores_2_2 = (_zz_rotScores_2_3 + _zz_rotScores_2_15);
  assign _zz_rotScores_2_3 = (_zz_rotScores_2_4 + _zz_rotScores_2_13);
  assign _zz_rotScores_2_4 = (_zz_rotScores_2_5 + _zz_rotScores_2_11);
  assign _zz_rotScores_2_5 = (_zz_rotScores_2_6 + _zz_rotScores_2_9);
  assign _zz_rotScores_2_6 = (4'b0000 + _zz_rotScores_2_7);
  assign _zz_rotScores_2_8 = (latchBeats_0 == patBeats_2);
  assign _zz_rotScores_2_7 = {3'd0, _zz_rotScores_2_8};
  assign _zz_rotScores_2_10 = (latchBeats_1 == patBeats_3);
  assign _zz_rotScores_2_9 = {3'd0, _zz_rotScores_2_10};
  assign _zz_rotScores_2_12 = (latchBeats_2 == patBeats_4);
  assign _zz_rotScores_2_11 = {3'd0, _zz_rotScores_2_12};
  assign _zz_rotScores_2_14 = (latchBeats_3 == patBeats_5);
  assign _zz_rotScores_2_13 = {3'd0, _zz_rotScores_2_14};
  assign _zz_rotScores_2_16 = (latchBeats_4 == patBeats_6);
  assign _zz_rotScores_2_15 = {3'd0, _zz_rotScores_2_16};
  assign _zz_rotScores_2_18 = (latchBeats_5 == patBeats_7);
  assign _zz_rotScores_2_17 = {3'd0, _zz_rotScores_2_18};
  assign _zz_rotScores_2_20 = (latchBeats_6 == patBeats_0);
  assign _zz_rotScores_2_19 = {3'd0, _zz_rotScores_2_20};
  assign _zz_rotScores_2_22 = (latchBeats_7 == patBeats_1);
  assign _zz_rotScores_2_21 = {3'd0, _zz_rotScores_2_22};
  assign _zz_rotScores_3 = (_zz_rotScores_3_1 + _zz_rotScores_3_19);
  assign _zz_rotScores_3_1 = (_zz_rotScores_3_2 + _zz_rotScores_3_17);
  assign _zz_rotScores_3_2 = (_zz_rotScores_3_3 + _zz_rotScores_3_15);
  assign _zz_rotScores_3_3 = (_zz_rotScores_3_4 + _zz_rotScores_3_13);
  assign _zz_rotScores_3_4 = (_zz_rotScores_3_5 + _zz_rotScores_3_11);
  assign _zz_rotScores_3_5 = (_zz_rotScores_3_6 + _zz_rotScores_3_9);
  assign _zz_rotScores_3_6 = (4'b0000 + _zz_rotScores_3_7);
  assign _zz_rotScores_3_8 = (latchBeats_0 == patBeats_3);
  assign _zz_rotScores_3_7 = {3'd0, _zz_rotScores_3_8};
  assign _zz_rotScores_3_10 = (latchBeats_1 == patBeats_4);
  assign _zz_rotScores_3_9 = {3'd0, _zz_rotScores_3_10};
  assign _zz_rotScores_3_12 = (latchBeats_2 == patBeats_5);
  assign _zz_rotScores_3_11 = {3'd0, _zz_rotScores_3_12};
  assign _zz_rotScores_3_14 = (latchBeats_3 == patBeats_6);
  assign _zz_rotScores_3_13 = {3'd0, _zz_rotScores_3_14};
  assign _zz_rotScores_3_16 = (latchBeats_4 == patBeats_7);
  assign _zz_rotScores_3_15 = {3'd0, _zz_rotScores_3_16};
  assign _zz_rotScores_3_18 = (latchBeats_5 == patBeats_0);
  assign _zz_rotScores_3_17 = {3'd0, _zz_rotScores_3_18};
  assign _zz_rotScores_3_20 = (latchBeats_6 == patBeats_1);
  assign _zz_rotScores_3_19 = {3'd0, _zz_rotScores_3_20};
  assign _zz_rotScores_3_22 = (latchBeats_7 == patBeats_2);
  assign _zz_rotScores_3_21 = {3'd0, _zz_rotScores_3_22};
  assign _zz_rotScores_4 = (_zz_rotScores_4_1 + _zz_rotScores_4_19);
  assign _zz_rotScores_4_1 = (_zz_rotScores_4_2 + _zz_rotScores_4_17);
  assign _zz_rotScores_4_2 = (_zz_rotScores_4_3 + _zz_rotScores_4_15);
  assign _zz_rotScores_4_3 = (_zz_rotScores_4_4 + _zz_rotScores_4_13);
  assign _zz_rotScores_4_4 = (_zz_rotScores_4_5 + _zz_rotScores_4_11);
  assign _zz_rotScores_4_5 = (_zz_rotScores_4_6 + _zz_rotScores_4_9);
  assign _zz_rotScores_4_6 = (4'b0000 + _zz_rotScores_4_7);
  assign _zz_rotScores_4_8 = (latchBeats_0 == patBeats_4);
  assign _zz_rotScores_4_7 = {3'd0, _zz_rotScores_4_8};
  assign _zz_rotScores_4_10 = (latchBeats_1 == patBeats_5);
  assign _zz_rotScores_4_9 = {3'd0, _zz_rotScores_4_10};
  assign _zz_rotScores_4_12 = (latchBeats_2 == patBeats_6);
  assign _zz_rotScores_4_11 = {3'd0, _zz_rotScores_4_12};
  assign _zz_rotScores_4_14 = (latchBeats_3 == patBeats_7);
  assign _zz_rotScores_4_13 = {3'd0, _zz_rotScores_4_14};
  assign _zz_rotScores_4_16 = (latchBeats_4 == patBeats_0);
  assign _zz_rotScores_4_15 = {3'd0, _zz_rotScores_4_16};
  assign _zz_rotScores_4_18 = (latchBeats_5 == patBeats_1);
  assign _zz_rotScores_4_17 = {3'd0, _zz_rotScores_4_18};
  assign _zz_rotScores_4_20 = (latchBeats_6 == patBeats_2);
  assign _zz_rotScores_4_19 = {3'd0, _zz_rotScores_4_20};
  assign _zz_rotScores_4_22 = (latchBeats_7 == patBeats_3);
  assign _zz_rotScores_4_21 = {3'd0, _zz_rotScores_4_22};
  assign _zz_rotScores_5 = (_zz_rotScores_5_1 + _zz_rotScores_5_19);
  assign _zz_rotScores_5_1 = (_zz_rotScores_5_2 + _zz_rotScores_5_17);
  assign _zz_rotScores_5_2 = (_zz_rotScores_5_3 + _zz_rotScores_5_15);
  assign _zz_rotScores_5_3 = (_zz_rotScores_5_4 + _zz_rotScores_5_13);
  assign _zz_rotScores_5_4 = (_zz_rotScores_5_5 + _zz_rotScores_5_11);
  assign _zz_rotScores_5_5 = (_zz_rotScores_5_6 + _zz_rotScores_5_9);
  assign _zz_rotScores_5_6 = (4'b0000 + _zz_rotScores_5_7);
  assign _zz_rotScores_5_8 = (latchBeats_0 == patBeats_5);
  assign _zz_rotScores_5_7 = {3'd0, _zz_rotScores_5_8};
  assign _zz_rotScores_5_10 = (latchBeats_1 == patBeats_6);
  assign _zz_rotScores_5_9 = {3'd0, _zz_rotScores_5_10};
  assign _zz_rotScores_5_12 = (latchBeats_2 == patBeats_7);
  assign _zz_rotScores_5_11 = {3'd0, _zz_rotScores_5_12};
  assign _zz_rotScores_5_14 = (latchBeats_3 == patBeats_0);
  assign _zz_rotScores_5_13 = {3'd0, _zz_rotScores_5_14};
  assign _zz_rotScores_5_16 = (latchBeats_4 == patBeats_1);
  assign _zz_rotScores_5_15 = {3'd0, _zz_rotScores_5_16};
  assign _zz_rotScores_5_18 = (latchBeats_5 == patBeats_2);
  assign _zz_rotScores_5_17 = {3'd0, _zz_rotScores_5_18};
  assign _zz_rotScores_5_20 = (latchBeats_6 == patBeats_3);
  assign _zz_rotScores_5_19 = {3'd0, _zz_rotScores_5_20};
  assign _zz_rotScores_5_22 = (latchBeats_7 == patBeats_4);
  assign _zz_rotScores_5_21 = {3'd0, _zz_rotScores_5_22};
  assign _zz_rotScores_6 = (_zz_rotScores_6_1 + _zz_rotScores_6_19);
  assign _zz_rotScores_6_1 = (_zz_rotScores_6_2 + _zz_rotScores_6_17);
  assign _zz_rotScores_6_2 = (_zz_rotScores_6_3 + _zz_rotScores_6_15);
  assign _zz_rotScores_6_3 = (_zz_rotScores_6_4 + _zz_rotScores_6_13);
  assign _zz_rotScores_6_4 = (_zz_rotScores_6_5 + _zz_rotScores_6_11);
  assign _zz_rotScores_6_5 = (_zz_rotScores_6_6 + _zz_rotScores_6_9);
  assign _zz_rotScores_6_6 = (4'b0000 + _zz_rotScores_6_7);
  assign _zz_rotScores_6_8 = (latchBeats_0 == patBeats_6);
  assign _zz_rotScores_6_7 = {3'd0, _zz_rotScores_6_8};
  assign _zz_rotScores_6_10 = (latchBeats_1 == patBeats_7);
  assign _zz_rotScores_6_9 = {3'd0, _zz_rotScores_6_10};
  assign _zz_rotScores_6_12 = (latchBeats_2 == patBeats_0);
  assign _zz_rotScores_6_11 = {3'd0, _zz_rotScores_6_12};
  assign _zz_rotScores_6_14 = (latchBeats_3 == patBeats_1);
  assign _zz_rotScores_6_13 = {3'd0, _zz_rotScores_6_14};
  assign _zz_rotScores_6_16 = (latchBeats_4 == patBeats_2);
  assign _zz_rotScores_6_15 = {3'd0, _zz_rotScores_6_16};
  assign _zz_rotScores_6_18 = (latchBeats_5 == patBeats_3);
  assign _zz_rotScores_6_17 = {3'd0, _zz_rotScores_6_18};
  assign _zz_rotScores_6_20 = (latchBeats_6 == patBeats_4);
  assign _zz_rotScores_6_19 = {3'd0, _zz_rotScores_6_20};
  assign _zz_rotScores_6_22 = (latchBeats_7 == patBeats_5);
  assign _zz_rotScores_6_21 = {3'd0, _zz_rotScores_6_22};
  assign _zz_rotScores_7 = (_zz_rotScores_7_1 + _zz_rotScores_7_19);
  assign _zz_rotScores_7_1 = (_zz_rotScores_7_2 + _zz_rotScores_7_17);
  assign _zz_rotScores_7_2 = (_zz_rotScores_7_3 + _zz_rotScores_7_15);
  assign _zz_rotScores_7_3 = (_zz_rotScores_7_4 + _zz_rotScores_7_13);
  assign _zz_rotScores_7_4 = (_zz_rotScores_7_5 + _zz_rotScores_7_11);
  assign _zz_rotScores_7_5 = (_zz_rotScores_7_6 + _zz_rotScores_7_9);
  assign _zz_rotScores_7_6 = (4'b0000 + _zz_rotScores_7_7);
  assign _zz_rotScores_7_8 = (latchBeats_0 == patBeats_7);
  assign _zz_rotScores_7_7 = {3'd0, _zz_rotScores_7_8};
  assign _zz_rotScores_7_10 = (latchBeats_1 == patBeats_0);
  assign _zz_rotScores_7_9 = {3'd0, _zz_rotScores_7_10};
  assign _zz_rotScores_7_12 = (latchBeats_2 == patBeats_1);
  assign _zz_rotScores_7_11 = {3'd0, _zz_rotScores_7_12};
  assign _zz_rotScores_7_14 = (latchBeats_3 == patBeats_2);
  assign _zz_rotScores_7_13 = {3'd0, _zz_rotScores_7_14};
  assign _zz_rotScores_7_16 = (latchBeats_4 == patBeats_3);
  assign _zz_rotScores_7_15 = {3'd0, _zz_rotScores_7_16};
  assign _zz_rotScores_7_18 = (latchBeats_5 == patBeats_4);
  assign _zz_rotScores_7_17 = {3'd0, _zz_rotScores_7_18};
  assign _zz_rotScores_7_20 = (latchBeats_6 == patBeats_5);
  assign _zz_rotScores_7_19 = {3'd0, _zz_rotScores_7_20};
  assign _zz_rotScores_7_22 = (latchBeats_7 == patBeats_6);
  assign _zz_rotScores_7_21 = {3'd0, _zz_rotScores_7_22};
  assign _zz_rdCyc_1 = rclkpos;
  assign _zz_rdCyc = {5'd0, _zz_rdCyc_1};
  assign _zz_rotSplit = (bestRot != 3'b000);
  assign _zz_when_Ddr3ControllerCore_l597 = (rdCyc + 7'h07);
  assign _zz_when_Ddr3ControllerCore_l601 = (_zz_when_Ddr3ControllerCore_l601_1 + _zz_when_Ddr3ControllerCore_l601_3);
  assign _zz_when_Ddr3ControllerCore_l601_1 = (_zz_when_Ddr3ControllerCore_l601_2 + rotSplit);
  assign _zz_when_Ddr3ControllerCore_l601_2 = (rdCyc + 7'h07);
  assign _zz_when_Ddr3ControllerCore_l601_3 = {1'd0, rdExtraCnt};
  assign _zz_when_Ddr3ControllerCore_l601_4 = (_zz_when_Ddr3ControllerCore_l601_5 + _zz_when_Ddr3ControllerCore_l601_6);
  assign _zz_when_Ddr3ControllerCore_l601_5 = (7'h0a + rotSplit);
  assign _zz_when_Ddr3ControllerCore_l601_6 = {1'd0, rdExtraCnt};
  assign _zz_cycle_1 = (cycle + 7'h01);
  assign _zz_tick_counter = (tick_counter - 17'h00001);
  assign _zz_A_0_1 = MR2[12 : 0];
  assign _zz_A_0_2 = MR3[12 : 0];
  assign _zz_A_0_3 = MR1[12 : 0];
  assign _zz_A_0_4 = MR0[12 : 0];
  assign _zz_A_0_6 = 1'b1;
  assign _zz_A_0_5 = {13'd0, _zz_A_0_6};
  assign _zz_A_0_7 = _zz_A_0[12 : 0];
  assign _zz_when_Ddr3ControllerCore_l744 = (wlVoteCnt + _zz_when_Ddr3ControllerCore_l744_1);
  assign _zz_when_Ddr3ControllerCore_l744_2 = when_Ddr3ControllerCore_l785;
  assign _zz_when_Ddr3ControllerCore_l744_1 = {2'd0, _zz_when_Ddr3ControllerCore_l744_2};
  assign _zz_A_0_8 = MR1[12 : 0];
  assign _zz_wstep = (wstep + 8'h01);
  assign _zz_wstep_2 = ($signed(_zz_wstep_3) + $signed(9'h0));
  assign _zz_wstep_1 = _zz_wstep_2[7 : 0];
  assign _zz_wstep_3 = _zz_wstep_4;
  assign _zz_wstep_5 = wstep;
  assign _zz_wstep_4 = {1'd0, _zz_wstep_5};
  assign _zz_A_0_9 = MR1[12 : 0];
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
  assign _zz_when_Ddr3ControllerCore_l1309 = (scMag + 7'h02);
  assign _zz_when_Ddr3ControllerCore_l1321 = (scMag + 7'h02);
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
  assign _zz_rdRspLeft_2 = when_Ddr3ControllerCore_l1667;
  assign _zz_rdRspLeft_1 = {5'd0, _zz_rdRspLeft_2};
  assign _zz_rdRspLeft_4 = _zz_data_ready;
  assign _zz_rdRspLeft_3 = {5'd0, _zz_rdRspLeft_4};
  assign _zz_when_Ddr3ControllerCore_l1685_1 = (_zz_when_Ddr3ControllerCore_l1685 + 7'h02);
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
  assign latchBeats_0 = trainLatch[15 : 0];
  assign patBeats_0 = trainPat[15 : 0];
  assign latchBeats_1 = trainLatch[31 : 16];
  assign patBeats_1 = trainPat[31 : 16];
  assign latchBeats_2 = trainLatch[47 : 32];
  assign patBeats_2 = trainPat[47 : 32];
  assign latchBeats_3 = trainLatch[63 : 48];
  assign patBeats_3 = trainPat[63 : 48];
  assign latchBeats_4 = trainLatch[79 : 64];
  assign patBeats_4 = trainPat[79 : 64];
  assign latchBeats_5 = trainLatch[95 : 80];
  assign patBeats_5 = trainPat[95 : 80];
  assign latchBeats_6 = trainLatch[111 : 96];
  assign patBeats_6 = trainPat[111 : 96];
  assign latchBeats_7 = trainLatch[127 : 112];
  assign patBeats_7 = trainPat[127 : 112];
  assign rotScores_0 = (_zz_rotScores_0 + _zz_rotScores_0_21);
  assign rotScores_1 = (_zz_rotScores_1 + _zz_rotScores_1_21);
  assign rotScores_2 = (_zz_rotScores_2 + _zz_rotScores_2_21);
  assign rotScores_3 = (_zz_rotScores_3 + _zz_rotScores_3_21);
  assign rotScores_4 = (_zz_rotScores_4 + _zz_rotScores_4_21);
  assign rotScores_5 = (_zz_rotScores_5 + _zz_rotScores_5_21);
  assign rotScores_6 = (_zz_rotScores_6 + _zz_rotScores_6_21);
  assign rotScores_7 = (_zz_rotScores_7 + _zz_rotScores_7_21);
  assign _zz_treeS1_0 = (rotScoresReg_0 < rotScoresReg_1);
  assign treeS1_0 = (_zz_treeS1_0 ? rotScoresReg_1 : rotScoresReg_0);
  assign treeI1_0 = (_zz_treeS1_0 ? 3'b001 : 3'b000);
  assign _zz_treeS1_1 = (rotScoresReg_2 < rotScoresReg_3);
  assign treeS1_1 = (_zz_treeS1_1 ? rotScoresReg_3 : rotScoresReg_2);
  assign treeI1_1 = (_zz_treeS1_1 ? 3'b011 : 3'b010);
  assign _zz_treeS1_2 = (rotScoresReg_4 < rotScoresReg_5);
  assign treeS1_2 = (_zz_treeS1_2 ? rotScoresReg_5 : rotScoresReg_4);
  assign treeI1_2 = (_zz_treeS1_2 ? 3'b101 : 3'b100);
  assign _zz_treeS1_3 = (rotScoresReg_6 < rotScoresReg_7);
  assign treeS1_3 = (_zz_treeS1_3 ? rotScoresReg_7 : rotScoresReg_6);
  assign treeI1_3 = (_zz_treeS1_3 ? 3'b111 : 3'b110);
  assign _zz_treeS2_0 = (treeS1_0 < treeS1_1);
  assign treeS2_0 = (_zz_treeS2_0 ? treeS1_1 : treeS1_0);
  assign treeI2_0 = (_zz_treeS2_0 ? treeI1_1 : treeI1_0);
  assign _zz_treeS2_1 = (treeS1_2 < treeS1_3);
  assign treeS2_1 = (_zz_treeS2_1 ? treeS1_3 : treeS1_2);
  assign treeI2_1 = (_zz_treeS2_1 ? treeI1_3 : treeI1_2);
  assign rotScoreW_0 = 4'b0000;
  assign rotIdxW_0 = 3'b000;
  assign rotScoreW_1 = 4'b0000;
  assign rotIdxW_1 = 3'b000;
  assign rotScoreW_2 = 4'b0000;
  assign rotIdxW_2 = 3'b000;
  assign rotScoreW_3 = 4'b0000;
  assign rotIdxW_3 = 3'b000;
  assign rotScoreW_4 = 4'b0000;
  assign rotIdxW_4 = 3'b000;
  assign rotScoreW_5 = 4'b0000;
  assign rotIdxW_5 = 3'b000;
  assign rotScoreW_6 = 4'b0000;
  assign rotIdxW_6 = 3'b000;
  assign _zz_rotScoreW_7 = (treeS2_0 < treeS2_1);
  assign rotScoreW_7 = (_zz_rotScoreW_7 ? treeS2_1 : treeS2_0);
  assign rotIdxW_7 = (_zz_rotScoreW_7 ? treeI2_1 : treeI2_0);
  assign winEndRaw = (sweepMag0 + sweepMagN);
  assign winEnd = (((sweepMagN == 7'h0) || (7'h40 < winEndRaw)) ? 7'h40 : winEndRaw[6 : 0]);
  assign winDoneNow = (((sweepMagN != 7'h0) && (! s2Side)) && (s2Mag == winEnd));
  assign when_Ddr3ControllerCore_l471 = ((((state == Ddr3State_IDLE) || (state == Ddr3State_READ)) || (state == Ddr3State_WRITE)) || (state == Ddr3State_PRECHARGE));
  assign when_Ddr3ControllerCore_l472 = (refresh_timer == 11'h250);
  assign when_Ddr3ControllerCore_l555 = io_phy_rburst[0];
  assign when_Ddr3ControllerCore_l556 = io_phy_rburst[1];
  assign rdCyc = (_zz_rdCyc + 7'h01);
  assign rotSplit = {6'd0, _zz_rotSplit};
  assign when_Ddr3ControllerCore_l597 = ((state == Ddr3State_READ_CALIB) && (((rdCyc <= cycle) && (cycle <= _zz_when_Ddr3ControllerCore_l597)) && (cycle <= 7'h0a)));
  assign when_Ddr3ControllerCore_l601 = ((state == Ddr3State_READ) && (((rdCyc <= cycle) && (cycle <= _zz_when_Ddr3ControllerCore_l601)) && (cycle <= _zz_when_Ddr3ControllerCore_l601_4)));
  assign inRow = io_req_payload_addr[20 : 7];
  assign inBank = io_req_payload_addr[23 : 21];
  assign inSameRow = ((inBank == openBank) && (inRow == openRow));
  assign canAcceptWrStream = ((((((((state == Ddr3State_WRITE) && (! trainDone)) && wrStreamOpen) && (! refresh_due)) && (wrExtraCnt < 6'h1f)) && (7'h01 <= cycle)) && io_req_payload_write) && inSameRow);
  assign canAcceptRdStream = (((((((state == Ddr3State_READ) && rdStreamOpen) && (! refresh_due)) && (rdExtraCnt < 6'h1f)) && (7'h02 <= cycle)) && (! io_req_payload_write)) && inSameRow);
  assign acceptReq = (((((state == Ddr3State_IDLE) && (! busy)) && (! refresh_due)) || canAcceptWrStream) || canAcceptRdStream);
  assign io_req_ready = acceptReq;
  assign when_Ddr3ControllerCore_l640 = (wserRstCnt != 3'b000);
  assign when_Ddr3ControllerCore_l645 = (! (wserRstCnt != 3'b000));
  assign when_Ddr3ControllerCore_l660 = (tick_counter == 17'h0000f);
  assign _zz_A_0 = (MR1 | 16'h0084);
  assign when_Ddr3ControllerCore_l785 = (io_phy_dq_raw[0] && io_phy_dq_raw[8]);
  assign when_Ddr3ControllerCore_l744 = (3'b010 <= _zz_when_Ddr3ControllerCore_l744);
  assign when_Ddr3ControllerCore_l737 = (wlVoteN == 3'b011);
  assign when_Ddr3ControllerCore_l745 = (! wlSeenR);
  assign when_Ddr3ControllerCore_l750 = (wlMatchNR != 8'hff);
  assign when_Ddr3ControllerCore_l759 = (wlevel_tries == 9'h1ff);
  assign when_Ddr3ControllerCore_l774 = ((wlevel_cnt == 4'b0001) && (8'h08 <= wstep));
  assign when_Ddr3ControllerCore_l763 = (! when_Ddr3ControllerCore_l744);
  assign when_Ddr3ControllerCore_l924 = ((((! aligning) && (anchorLeft == 2'b00)) && (settleLeft == 2'b00)) && (pinLeft == 2'b00));
  assign when_Ddr3ControllerCore_l929 = ((((! aligning) && (anchorLeft == 2'b00)) && (settleLeft == 2'b00)) && (pinLeft == 2'b00));
  assign when_Ddr3ControllerCore_l949 = (scanOn && ((aligning || (anchorLeft != 2'b00)) || (settleLeft != 2'b00)));
  assign when_Ddr3ControllerCore_l951 = (anchorLeft != 2'b00);
  assign when_Ddr3ControllerCore_l963 = (navigateLeft != 8'h0);
  assign when_Ddr3ControllerCore_l987 = (((aligning || (anchorLeft != 2'b00)) || (settleLeft != 2'b00)) || (pinLeft != 2'b00));
  assign when_Ddr3ControllerCore_l988 = (anchorLeft != 2'b00);
  assign when_Ddr3ControllerCore_l1003 = (navigateLeft != 8'h0);
  assign when_Ddr3ControllerCore_l1028 = (pinLeft != 2'b00);
  assign when_Ddr3ControllerCore_l1046 = ((settleLeft == 2'b01) && applyArmed);
  assign when_Ddr3ControllerCore_l1071 = (settleLeft == 2'b00);
  assign when_Ddr3ControllerCore_l1076 = (bestCntDll < sweepScoreReg);
  assign when_Ddr3ControllerCore_l1087 = (bestCntDll == 4'b1000);
  assign when_Ddr3ControllerCore_l1112 = ((s2Side && (s2Mag == 7'h40)) && (rclkpos == 2'b11));
  assign when_Ddr3ControllerCore_l1148 = (rclkpos == 2'b11);
  assign when_Ddr3ControllerCore_l1154 = (((! s2Side) && (s2Mag == 7'h40)) && (! winDoneNow));
  assign when_Ddr3ControllerCore_l1176 = ((s0Mag != 7'h40) && (! winDoneNow));
  assign when_Ddr3ControllerCore_l1195 = (! training);
  assign when_Ddr3ControllerCore_l1200 = (! winDoneNow);
  assign when_Ddr3ControllerCore_l1225 = (bestCnt < sweepScoreReg);
  assign when_Ddr3ControllerCore_l1233 = (rclksel == 3'b111);
  assign when_Ddr3ControllerCore_l1237 = (rcalib_tries == 10'h028);
  assign when_Ddr3ControllerCore_l1244 = ((! training) && (! dllSweepDone));
  assign when_Ddr3ControllerCore_l1252 = ((! scanOn) && (! shiftCalDone));
  assign when_Ddr3ControllerCore_l1254 = ((bestCnt == 4'b1000) && ((tryMode == 2'b00) || (! 1'b0)));
  assign when_Ddr3ControllerCore_l1260 = ((tryMode == 2'b00) || (best0 < bestCnt));
  assign when_Ddr3ControllerCore_l1267 = (tryMode < 2'b11);
  assign _zz_wrMode = (tryMode + 2'b01);
  assign when_Ddr3ControllerCore_l1276 = (bestCnt <= best0);
  assign when_Ddr3ControllerCore_l1293 = (bestSurveyCnt < bestCnt);
  assign when_Ddr3ControllerCore_l1300 = (bestCnt == 4'b1000);
  assign when_Ddr3ControllerCore_l1309 = ((! scSide) && (_zz_when_Ddr3ControllerCore_l1309 <= 7'h40));
  assign _zz_s0Mag = (scMag + 7'h02);
  assign when_Ddr3ControllerCore_l1321 = (_zz_when_Ddr3ControllerCore_l1321 <= 7'h40);
  assign _zz_s0Mag_1 = (scMag + 7'h02);
  assign when_Ddr3ControllerCore_l1314 = (! scSide);
  assign when_Ddr3ControllerCore_l1350 = (sweepMagN != 7'h0);
  assign when_Ddr3ControllerCore_l1387 = (bestCnt == 4'b1000);
  assign when_Ddr3ControllerCore_l1432 = (! training);
  assign _zz_1 = ({3'd0,1'b1} <<< wTry);
  assign when_Ddr3ControllerCore_l1435 = ((bestCnt < 4'b1000) && (wTry < 2'b10));
  assign when_Ddr3ControllerCore_l1436 = ((wTry == 2'b00) || (bestWCnt < bestCnt));
  assign when_Ddr3ControllerCore_l1444 = (wTry == 2'b00);
  assign when_Ddr3ControllerCore_l1466 = ((wTry == 2'b10) && (bestCnt < bestWCnt));
  assign _zz_openRow = io_req_payload_addr[20 : 7];
  assign _zz_openBank = io_req_payload_addr[23 : 21];
  assign _zz_cycle = ((rowOpen && (_zz_openBank == openBank)) && (_zz_openRow == openRow));
  assign when_Ddr3ControllerCore_l1570 = (rowOpen && (! _zz_cycle));
  assign when_Ddr3ControllerCore_l1579 = (! rowOpen);
  assign when_Ddr3ControllerCore_l1611 = (cycle == 7'h02);
  assign _zz_openRow_1 = reqReg_addr[20 : 7];
  assign _zz_openBank_1 = reqReg_addr[23 : 21];
  assign _zz_BA_2 = reqReg_addr[23 : 21];
  assign _zz_A_2 = (_zz__zz_A_2 | 16'h1000);
  assign when_Ddr3ControllerCore_l1657 = (cycle == 7'h01);
  assign when_Ddr3ControllerCore_l1661 = ((cycle == 7'h02) || rdHavePending);
  assign when_Ddr3ControllerCore_l1667 = (canAcceptRdStream && io_req_valid);
  assign when_Ddr3ControllerCore_l1666 = (7'h02 <= cycle);
  assign _zz_when_Ddr3ControllerCore_l1685 = (7'h09 + rotSplit);
  assign _zz_data_ready = ((_zz_when_Ddr3ControllerCore_l1685 <= cycle) && (rdRspLeft != 6'h0));
  assign when_Ddr3ControllerCore_l1685 = (((((! rdStreamOpen) && (! rdHavePending)) && (rdRspLeft == 6'h0)) && (! data_ready)) && (_zz_when_Ddr3ControllerCore_l1685_1 <= cycle));
  assign _zz_A_2_1 = {reqReg_addr[6 : 0],3'b000};
  assign _zz_BA_2_1 = reqReg_addr[23 : 21];
  assign when_Ddr3ControllerCore_l1700 = (cycle == 7'h01);
  assign when_Ddr3ControllerCore_l1706 = (cycle == 7'h02);
  assign when_Ddr3ControllerCore_l1741 = (cycle == 7'h03);
  assign when_Ddr3ControllerCore_l1827 = (cycle == 7'h04);
  assign when_Ddr3ControllerCore_l1859 = (cycle == ((2'b10 <= wrMode) ? 7'h08 : 7'h07));
  assign when_Ddr3ControllerCore_l1877 = ((cycle == 7'h01) || wrHavePending);
  assign when_Ddr3ControllerCore_l1889 = (canAcceptWrStream && io_req_valid);
  assign when_Ddr3ControllerCore_l1900 = (st1Valid && (! st2Valid));
  assign when_Ddr3ControllerCore_l1930 = (st1Valid && (! st2Valid));
  assign when_Ddr3ControllerCore_l1966 = (st1Valid && (! st2Valid));
  assign when_Ddr3ControllerCore_l1969 = (st2Valid && (! st3Valid));
  assign when_Ddr3ControllerCore_l1979 = (st3Valid && st2Valid);
  assign when_Ddr3ControllerCore_l2000 = (st2Valid && (! st3Valid));
  assign when_Ddr3ControllerCore_l2010 = (st3Valid && st2Valid);
  assign when_Ddr3ControllerCore_l2038 = (wrCooldown != 4'b0000);
  assign when_Ddr3ControllerCore_l2042 = (((((! when_Ddr3ControllerCore_l1877) && (! st1Valid)) && (! st2Valid)) && (! st3Valid)) && (wrCooldown == 4'b0000));
  assign when_Ddr3ControllerCore_l2051 = (cycle == 7'h10);
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
  assign when_Ddr3ControllerCore_l2226 = (((((io_phy_rst_lock_n && (! _zz_when_Ddr3ControllerCore_l2226)) && (! busy)) && (state == Ddr3State_IDLE)) && wlevel_done) && rcalib_done);
  assign io_init_done = init_done_latched;
  assign io_write_level_done = wlevel_done;
  assign io_read_calib_done = rcalib_done;
  assign io_wstep = wstep;
  assign io_rclkpos = rclkpos;
  assign io_rclksel = rclksel;
  assign io_best_rot = bestRot;
  assign io_best_score = bestCnt;
  assign io_dbg_state = state;
  assign io_wlMap = wlMapR;
  assign io_wlFirst = wlFirstR;
  assign io_wlLast = wlLastR;
  assign io_wlMatchN = wlMatchNR;
  assign io_wr_adv = wrMode;
  assign io_w_scores = {{wScores_2,wScores_1},wScores_0};
  assign io_train_latch = bestLatch;
  always @(posedge io_pclk or posedge _zz_when_Ddr3ControllerCore_l2226) begin
    if(_zz_when_Ddr3ControllerCore_l2226) begin
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
      wlMapR <= 256'h0;
      wlFirstR <= 8'h0;
      wlLastR <= 8'h0;
      wlSeenR <= 1'b0;
      wlMatchNR <= 8'h0;
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
      trainLatch <= 128'h0;
      rotScoresReg_0 <= 4'b0000;
      rotScoresReg_1 <= 4'b0000;
      rotScoresReg_2 <= 4'b0000;
      rotScoresReg_3 <= 4'b0000;
      rotScoresReg_4 <= 4'b0000;
      rotScoresReg_5 <= 4'b0000;
      rotScoresReg_6 <= 4'b0000;
      rotScoresReg_7 <= 4'b0000;
      sweepScoreReg <= 4'b0000;
      sweepRotReg <= 3'b000;
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
      bestLatch <= 128'h0;
      bestWCnt <= 4'b0000;
      bestWPos <= 2'b00;
      bestWSel <= 3'b000;
      bestWRot <= 3'b000;
      bestWMode <= 2'b00;
      wScores_0 <= 4'b0000;
      wScores_1 <= 4'b0000;
      wScores_2 <= 4'b0000;
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
      if(when_Ddr3ControllerCore_l471) begin
        if(when_Ddr3ControllerCore_l472) begin
          refresh_due <= 1'b1;
          refresh_timer <= 11'h0;
        end else begin
          refresh_timer <= (refresh_timer + 11'h001);
        end
      end
      if(when_Ddr3ControllerCore_l555) begin
        rburst_seen[0] <= 1'b1;
      end
      if(when_Ddr3ControllerCore_l556) begin
        rburst_seen[1] <= 1'b1;
      end
      dqs_read <= 4'b0000;
      if(when_Ddr3ControllerCore_l597) begin
        dqs_read <= 4'b1111;
      end
      if(when_Ddr3ControllerCore_l601) begin
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
        if(when_Ddr3ControllerCore_l640) begin
          wserRstCnt <= (wserRstCnt - 3'b001);
          wser_rst <= (3'b010 < wserRstCnt);
        end
        if(when_Ddr3ControllerCore_l645) begin
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
              if(when_Ddr3ControllerCore_l660) begin
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
                  wlMapR <= 256'h0;
                  wlFirstR <= 8'h0;
                  wlLastR <= 8'h0;
                  wlSeenR <= 1'b0;
                  wlMatchNR <= 8'h0;
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
                  if(when_Ddr3ControllerCore_l737) begin
                    wlVoteN <= 3'b000;
                    wlVoteCnt <= 3'b000;
                    wlevel_tries <= (wlevel_tries + 9'h001);
                    wlMapR[wstep] <= when_Ddr3ControllerCore_l744;
                    if(when_Ddr3ControllerCore_l744) begin
                      if(when_Ddr3ControllerCore_l745) begin
                        wlSeenR <= 1'b1;
                        wlFirstR <= wstep;
                      end
                      wlLastR <= wstep;
                      if(when_Ddr3ControllerCore_l750) begin
                        wlMatchNR <= (wlMatchNR + 8'h01);
                      end
                    end
                    if(when_Ddr3ControllerCore_l759) begin
                      wlevel_done <= 1'b1;
                      wstep <= 8'hff;
                      nRAS_0 <= CMD_SetModeReg[2];
                      nCAS_0 <= CMD_SetModeReg[1];
                      nWE_0 <= CMD_SetModeReg[0];
                      BA_0 <= MR1[15 : 13];
                      A_0 <= {1'd0, _zz_A_0_8};
                    end else begin
                      if(when_Ddr3ControllerCore_l763) begin
                        wstep <= _zz_wstep;
                        wlevel_cnt <= 4'b0000;
                        cycle <= 7'h0a;
                      end else begin
                        wlevel_cnt <= (wlevel_cnt + 4'b0001);
                        if(when_Ddr3ControllerCore_l774) begin
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
                    if(when_Ddr3ControllerCore_l785) begin
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
                      wScores_0 <= 4'b0000;
                      wScores_1 <= 4'b0000;
                      wScores_2 <= 4'b0000;
                    end
                    rcalib_cnt <= 4'b0000;
                    rcalib_tries <= 10'h0;
                    bestCnt <= 4'b0000;
                    bestLatch <= 128'h0;
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
                  trainLatch <= {{{{{{{io_phy_dq_in_7,io_phy_dq_in_6},io_phy_dq_in_5},io_phy_dq_in_4},io_phy_dq_in_3},io_phy_dq_in_2},io_phy_dq_in_1},io_phy_dq_in_0};
                end
                7'h0c : begin
                  rotScoresReg_0 <= rotScores_0;
                  rotScoresReg_1 <= rotScores_1;
                  rotScoresReg_2 <= rotScores_2;
                  rotScoresReg_3 <= rotScores_3;
                  rotScoresReg_4 <= rotScores_4;
                  rotScoresReg_5 <= rotScores_5;
                  rotScoresReg_6 <= rotScores_6;
                  rotScoresReg_7 <= rotScores_7;
                end
                7'h0d : begin
                  sweepScoreReg <= rotScoreW_7;
                  sweepRotReg <= rotIdxW_7;
                end
                7'h0e : begin
                  if(when_Ddr3ControllerCore_l924) begin
                    `ifndef SYNTHESIS
                      `ifdef FORMAL
                        assert(1'b0); // Ddr3ControllerCore.scala:L925
                      `else
                        if(!1'b0) begin
                          $display("NOTE RCALIB chk pos=%x sel=%x seen=%x score=%x rot=%x latch=%x best=%x tries=%x", rclkpos, rclksel, rburst_seen, sweepScoreReg, sweepRotReg, trainLatch, bestCnt, rcalib_tries); // Ddr3ControllerCore.scala:L925
                        end
                      `endif
                    `endif
                  end
                  rcalib_cnt <= 4'b0000;
                  if(when_Ddr3ControllerCore_l929) begin
                    rcalib_tries <= (rcalib_tries + 10'h001);
                  end
                  if(when_Ddr3ControllerCore_l949) begin
                    rmove <= 1'b0;
                    if(when_Ddr3ControllerCore_l951) begin
                      anchorLeft <= (anchorLeft - 2'b01);
                      cycle <= 7'h01;
                    end else begin
                      if(aligning) begin
                        if(when_Ddr3ControllerCore_l963) begin
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
                      if(when_Ddr3ControllerCore_l987) begin
                        if(when_Ddr3ControllerCore_l988) begin
                          anchorLeft <= (anchorLeft - 2'b01);
                          cycle <= 7'h01;
                        end else begin
                          if(aligning) begin
                            if(when_Ddr3ControllerCore_l1003) begin
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
                            if(when_Ddr3ControllerCore_l1028) begin
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
                              if(when_Ddr3ControllerCore_l1046) begin
                                rclkpos <= bestPos;
                                needFinalSurvey <= 1'b1;
                                dllSweepDone <= 1'b1;
                                dllSweepOn <= 1'b0;
                                applyArmed <= 1'b0;
                                `ifndef SYNTHESIS
                                  `ifdef FORMAL
                                    assert(1'b0); // Ddr3ControllerCore.scala:L1056
                                  `else
                                    if(!1'b0) begin
                                      $display("NOTE RCALIB dll side=%x mag=%x pos=%x score=%x", bestSide, bestMag, bestPos, bestCntDll); // Ddr3ControllerCore.scala:L1056
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
                        if(when_Ddr3ControllerCore_l1071) begin
                          if(when_Ddr3ControllerCore_l1076) begin
                            bestCntDll <= sweepScoreReg;
                            bestLatch <= trainLatch;
                            bestMag <= s2Mag;
                            bestSide <= s2Side;
                            bestPos <= rclkpos;
                            bestSel <= rclksel;
                            bestRot <= sweepRotReg;
                          end
                          if(when_Ddr3ControllerCore_l1087) begin
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
                                assert(1'b0); // Ddr3ControllerCore.scala:L1102
                              `else
                                if(!1'b0) begin
                                  $display("NOTE RCALIB dll side=%x mag=%x pos=%x score=%x", bestSide, bestMag, bestPos, bestCntDll); // Ddr3ControllerCore.scala:L1102
                                end
                              `endif
                            `endif
                            cycle <= 7'h01;
                          end else begin
                            if(when_Ddr3ControllerCore_l1112) begin
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
                                  assert(1'b0); // Ddr3ControllerCore.scala:L1125
                                `else
                                  if(!1'b0) begin
                                    $display("NOTE RCALIB dll side=%x mag=%x pos=%x score=%x", bestSide, bestMag, bestPos, bestCntDll); // Ddr3ControllerCore.scala:L1125
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
                              if(when_Ddr3ControllerCore_l1148) begin
                                if(when_Ddr3ControllerCore_l1154) begin
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
                                      assert(1'b0); // Ddr3ControllerCore.scala:L1166
                                    `else
                                      if(!1'b0) begin
                                        $display("NOTE RCALIB dll side switch to minus"); // Ddr3ControllerCore.scala:L1166
                                      end
                                    `endif
                                  `endif
                                end else begin
                                  if(when_Ddr3ControllerCore_l1176) begin
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
                                    assert(1'b0); // Ddr3ControllerCore.scala:L1193
                                  `else
                                    if(!1'b0) begin
                                      $display("NOTE RCALIB window side=%x mag=%x pos=%x rot=%x score=%x", bestSide, bestMag, bestPos, bestRot, bestCntDll); // Ddr3ControllerCore.scala:L1193
                                    end
                                  `endif
                                `endif
                                if(when_Ddr3ControllerCore_l1195) begin
                                  rcalib_done <= 1'b1;
                                end
                                nRAS_0 <= CMD_PreCharge[2];
                                nCAS_0 <= CMD_PreCharge[1];
                                nWE_0 <= CMD_PreCharge[0];
                                BA_0 <= 3'b000;
                                A_0 <= {13'd0, _zz_A_0_13};
                              end
                              if(when_Ddr3ControllerCore_l1200) begin
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
                      if(when_Ddr3ControllerCore_l1225) begin
                        bestCnt <= sweepScoreReg;
                        bestLatch <= trainLatch;
                        bestPos <= rclkpos;
                        bestSel <= rclksel;
                        bestRot <= sweepRotReg;
                      end
                      rclksel <= _zz_rclksel;
                      if(when_Ddr3ControllerCore_l1233) begin
                        rclkpos <= _zz_rclkpos_1;
                      end
                      if(when_Ddr3ControllerCore_l1237) begin
                        rclkpos <= bestPos;
                        rclksel <= bestSel;
                        if(when_Ddr3ControllerCore_l1244) begin
                          if(when_Ddr3ControllerCore_l1252) begin
                            if(when_Ddr3ControllerCore_l1254) begin
                              shiftCalDone <= 1'b1;
                              dllSweepDone <= 1'b1;
                              rcalib_tries <= 10'h028;
                              trainDone <= 1'b1;
                              needPoison <= 1'b0;
                              bistReturn <= 1'b1;
                              state <= Ddr3State_WRITE;
                              cycle <= 7'h0;
                            end else begin
                              if(when_Ddr3ControllerCore_l1260) begin
                                best0 <= bestCnt;
                                bestMode <= wrMode;
                                best0Pos <= bestPos;
                                best0Sel <= bestSel;
                                best0Rot <= bestRot;
                              end
                              if(when_Ddr3ControllerCore_l1267) begin
                                tryMode <= _zz_wrMode;
                                wrMode <= _zz_wrMode;
                                rcalib_tries <= 10'h0;
                                bestCnt <= 4'b0000;
                                bestLatch <= 128'h0;
                                trainDone <= 1'b1;
                                needPoison <= 1'b0;
                                bistReturn <= 1'b1;
                                state <= Ddr3State_WRITE;
                                cycle <= 7'h0;
                              end else begin
                                if(when_Ddr3ControllerCore_l1276) begin
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
                            if(when_Ddr3ControllerCore_l1293) begin
                              bestSurveyCnt <= bestCnt;
                              bestSurveySide <= scSide;
                              bestSurveyMag <= scMag;
                            end
                            if(when_Ddr3ControllerCore_l1300) begin
                              `ifndef SYNTHESIS
                                `ifdef FORMAL
                                  assert(1'b0); // Ddr3ControllerCore.scala:L1302
                                `else
                                  if(!1'b0) begin
                                    $display("NOTE RCALIB scan sweep at side=%x mag=%x score=%x", scSide, scMag, bestCnt); // Ddr3ControllerCore.scala:L1302
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
                              if(when_Ddr3ControllerCore_l1309) begin
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
                                if(when_Ddr3ControllerCore_l1314) begin
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
                                  if(when_Ddr3ControllerCore_l1321) begin
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
                                        assert(1'b0); // Ddr3ControllerCore.scala:L1329
                                      `else
                                        if(!1'b0) begin
                                          $display("NOTE RCALIB scan done best side=%x mag=%x score=%x", bestSurveySide, bestSurveyMag, bestSurveyCnt); // Ddr3ControllerCore.scala:L1329
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
                              if(when_Ddr3ControllerCore_l1350) begin
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
                                    assert(1'b0); // Ddr3ControllerCore.scala:L1379
                                  `else
                                    if(!1'b0) begin
                                      $display("NOTE RCALIB window start mag0=%x n=%x", sweepMag0, sweepMagN); // Ddr3ControllerCore.scala:L1379
                                    end
                                  `endif
                                `endif
                                cycle <= 7'h01;
                              end else begin
                                if(when_Ddr3ControllerCore_l1387) begin
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
                                      assert(1'b0); // Ddr3ControllerCore.scala:L1416
                                    `else
                                      if(!1'b0) begin
                                        $display("NOTE RCALIB scan start"); // Ddr3ControllerCore.scala:L1416
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
                              assert(1'b0); // Ddr3ControllerCore.scala:L1425
                            `else
                              if(!1'b0) begin
                                $display("NOTE RCALIB lock best pos=%x sel=%x rot=%x score=%x", bestPos, bestSel, bestRot, bestCnt); // Ddr3ControllerCore.scala:L1425
                              end
                            `endif
                          `endif
                          if(when_Ddr3ControllerCore_l1432) begin
                            if(_zz_1[0]) begin
                              wScores_0 <= bestCnt;
                            end
                            if(_zz_1[1]) begin
                              wScores_1 <= bestCnt;
                            end
                            if(_zz_1[2]) begin
                              wScores_2 <= bestCnt;
                            end
                            if(when_Ddr3ControllerCore_l1435) begin
                              if(when_Ddr3ControllerCore_l1436) begin
                                bestWCnt <= bestCnt;
                                bestWstep <= wstep;
                                bestWPos <= bestPos;
                                bestWSel <= bestSel;
                                bestWRot <= bestRot;
                                bestWMode <= wrMode;
                              end
                              if(when_Ddr3ControllerCore_l1444) begin
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
                              bestLatch <= 128'h0;
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
                              if(when_Ddr3ControllerCore_l1466) begin
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
                        if(when_Ddr3ControllerCore_l1570) begin
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
                          if(when_Ddr3ControllerCore_l1579) begin
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
              if(when_Ddr3ControllerCore_l1611) begin
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
              if(when_Ddr3ControllerCore_l1657) begin
                nRAS_2 <= CMD_Read[2];
                nCAS_2 <= CMD_Read[1];
                nWE_2 <= CMD_Read[0];
                BA_2 <= _zz_BA_2;
                A_2 <= _zz_A_2[13:0];
              end
              if(when_Ddr3ControllerCore_l1661) begin
                nRAS_2 <= CMD_Read[2];
                nCAS_2 <= CMD_Read[1];
                nWE_2 <= CMD_Read[0];
                BA_2 <= _zz_BA_2;
                A_2 <= _zz_A_2[13:0];
              end
              if(when_Ddr3ControllerCore_l1666) begin
                if(when_Ddr3ControllerCore_l1667) begin
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
              if(when_Ddr3ControllerCore_l1685) begin
                busy <= 1'b0;
                state <= Ddr3State_IDLE;
              end
            end
            Ddr3State_WRITE : begin
              if(trainDone) begin
                if(when_Ddr3ControllerCore_l1700) begin
                  nRAS_2 <= CMD_Write[2];
                  nCAS_2 <= CMD_Write[1];
                  nWE_2 <= CMD_Write[0];
                  BA_2 <= _zz_BA_2_1;
                  A_2 <= _zz_A_2_6[13:0];
                end
                if(when_Ddr3ControllerCore_l1706) begin
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
                if(when_Ddr3ControllerCore_l1741) begin
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
                if(when_Ddr3ControllerCore_l1827) begin
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
                if(when_Ddr3ControllerCore_l1859) begin
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
                if(when_Ddr3ControllerCore_l1877) begin
                  nRAS_2 <= CMD_Write[2];
                  nCAS_2 <= CMD_Write[1];
                  nWE_2 <= CMD_Write[0];
                  BA_2 <= _zz_BA_2_1;
                  A_2 <= _zz_A_2_8[13:0];
                end
                st1Valid <= when_Ddr3ControllerCore_l1877;
                st2Valid <= st1Valid;
                st3Valid <= st2Valid;
                if(when_Ddr3ControllerCore_l1889) begin
                  wrHavePending <= 1'b1;
                  wrExtraCnt <= (wrExtraCnt + 6'h01);
                end else begin
                  wrHavePending <= 1'b0;
                  wrStreamOpen <= 1'b0;
                end
                case(wrMode)
                  2'b00 : begin
                    if(when_Ddr3ControllerCore_l1900) begin
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
                    if(when_Ddr3ControllerCore_l1930) begin
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
                    if(when_Ddr3ControllerCore_l1966) begin
                      dqs_out <= 8'h0;
                      dqs_oen <= 4'b0111;
                    end else begin
                      if(when_Ddr3ControllerCore_l1969) begin
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
                        if(when_Ddr3ControllerCore_l1979) begin
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
                    if(when_Ddr3ControllerCore_l2000) begin
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
                      if(when_Ddr3ControllerCore_l2010) begin
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
                if(when_Ddr3ControllerCore_l1877) begin
                  wrCooldown <= ((2'b10 <= wrMode) ? 4'b0101 : 4'b0100);
                end else begin
                  if(when_Ddr3ControllerCore_l2038) begin
                    wrCooldown <= (wrCooldown - 4'b0001);
                  end
                end
                if(when_Ddr3ControllerCore_l2042) begin
                  busy <= 1'b0;
                  state <= Ddr3State_IDLE;
                end
              end
            end
            default : begin
              if(when_Ddr3ControllerCore_l2051) begin
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
        wlMapR <= 256'h0;
        wlFirstR <= 8'h0;
        wlLastR <= 8'h0;
        wlSeenR <= 1'b0;
        wlMatchNR <= 8'h0;
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
        bestLatch <= 128'h0;
        bestWCnt <= 4'b0000;
        bestWPos <= 2'b00;
        bestWSel <= 3'b000;
        bestWRot <= 3'b000;
        bestWMode <= 2'b00;
        rotScoresReg_0 <= 4'b0000;
        rotScoresReg_1 <= 4'b0000;
        rotScoresReg_2 <= 4'b0000;
        rotScoresReg_3 <= 4'b0000;
        rotScoresReg_4 <= 4'b0000;
        rotScoresReg_5 <= 4'b0000;
        rotScoresReg_6 <= 4'b0000;
        rotScoresReg_7 <= 4'b0000;
        sweepScoreReg <= 4'b0000;
        sweepRotReg <= 3'b000;
        wScores_0 <= 4'b0000;
        wScores_1 <= 4'b0000;
        wScores_2 <= 4'b0000;
        training <= 1'b1;
        trainDone <= 1'b0;
        needPoison <= 1'b0;
        trainLatch <= 128'h0;
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
      if(when_Ddr3ControllerCore_l2226) begin
        init_done_latched <= 1'b1;
      end
    end
  end

  always @(posedge io_pclk) begin
    if(io_phy_rst_lock_n) begin
      if(when_Ddr3ControllerCore_l645) begin
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
                if(!when_Ddr3ControllerCore_l949) begin
                  if(dllSweepOn) begin
                    if(!when_Ddr3ControllerCore_l987) begin
                      if(when_Ddr3ControllerCore_l1071) begin
                        if(!when_Ddr3ControllerCore_l1087) begin
                          if(!when_Ddr3ControllerCore_l1112) begin
                            if(when_Ddr3ControllerCore_l1200) begin
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
                    if(when_Ddr3ControllerCore_l1237) begin
                      if(when_Ddr3ControllerCore_l1244) begin
                        if(when_Ddr3ControllerCore_l1252) begin
                          if(when_Ddr3ControllerCore_l1254) begin
                            reqReg_write <= 1'b1;
                            reqReg_addr <= 27'h0;
                            reqReg_wdata <= trainPat;
                            reqReg_wstrb <= 16'hffff;
                          end else begin
                            if(when_Ddr3ControllerCore_l1267) begin
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
                            if(!when_Ddr3ControllerCore_l1350) begin
                              if(when_Ddr3ControllerCore_l1387) begin
                                reqReg_write <= 1'b1;
                                reqReg_addr <= 27'h0;
                                reqReg_wdata <= trainPat;
                                reqReg_wstrb <= 16'hffff;
                              end
                            end
                          end
                        end
                      end else begin
                        if(when_Ddr3ControllerCore_l1432) begin
                          if(when_Ddr3ControllerCore_l1435) begin
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
            if(when_Ddr3ControllerCore_l1666) begin
              if(when_Ddr3ControllerCore_l1667) begin
                reqReg_write <= io_req_payload_write;
                reqReg_addr <= io_req_payload_addr;
                reqReg_wdata <= io_req_payload_wdata;
                reqReg_wstrb <= io_req_payload_wstrb;
              end
            end
          end
          Ddr3State_WRITE : begin
            if(!trainDone) begin
              if(when_Ddr3ControllerCore_l1877) begin
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
              if(when_Ddr3ControllerCore_l1889) begin
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

module StreamFifoLowLatency_1 (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [127:0]  io_push_payload_data,
  input  wire [15:0]   io_push_payload_strb,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [127:0]  io_pop_payload_data,
  output wire [15:0]   io_pop_payload_strb,
  input  wire          io_flush,
  output wire [4:0]    io_occupancy,
  output wire [4:0]    io_availability,
  input  wire          io_pclk,
  input  wire          _zz_1
);

  wire                fifo_io_push_ready;
  wire                fifo_io_pop_valid;
  wire       [127:0]  fifo_io_pop_payload_data;
  wire       [15:0]   fifo_io_pop_payload_strb;
  wire       [4:0]    fifo_io_occupancy;
  wire       [4:0]    fifo_io_availability;

  StreamFifo_1 fifo (
    .io_push_valid        (io_push_valid                  ), //i
    .io_push_ready        (fifo_io_push_ready             ), //o
    .io_push_payload_data (io_push_payload_data[127:0]    ), //i
    .io_push_payload_strb (io_push_payload_strb[15:0]     ), //i
    .io_pop_valid         (fifo_io_pop_valid              ), //o
    .io_pop_ready         (io_pop_ready                   ), //i
    .io_pop_payload_data  (fifo_io_pop_payload_data[127:0]), //o
    .io_pop_payload_strb  (fifo_io_pop_payload_strb[15:0] ), //o
    .io_flush             (io_flush                       ), //i
    .io_occupancy         (fifo_io_occupancy[4:0]         ), //o
    .io_availability      (fifo_io_availability[4:0]      ), //o
    .io_pclk              (io_pclk                        ), //i
    ._zz_4                (_zz_1                          )  //i
  );
  assign io_push_ready = fifo_io_push_ready;
  assign io_pop_valid = fifo_io_pop_valid;
  assign io_pop_payload_data = fifo_io_pop_payload_data;
  assign io_pop_payload_strb = fifo_io_pop_payload_strb;
  assign io_occupancy = fifo_io_occupancy;
  assign io_availability = fifo_io_availability;

endmodule

module StreamFifoLowLatency (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [127:0]  io_push_payload,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [127:0]  io_pop_payload,
  input  wire          io_flush,
  output wire [4:0]    io_occupancy,
  output wire [4:0]    io_availability,
  input  wire          io_pclk,
  input  wire          _zz_1
);

  wire                fifo_io_push_ready;
  wire                fifo_io_pop_valid;
  wire       [127:0]  fifo_io_pop_payload;
  wire       [4:0]    fifo_io_occupancy;
  wire       [4:0]    fifo_io_availability;

  StreamFifo fifo (
    .io_push_valid   (io_push_valid             ), //i
    .io_push_ready   (fifo_io_push_ready        ), //o
    .io_push_payload (io_push_payload[127:0]    ), //i
    .io_pop_valid    (fifo_io_pop_valid         ), //o
    .io_pop_ready    (io_pop_ready              ), //i
    .io_pop_payload  (fifo_io_pop_payload[127:0]), //o
    .io_flush        (io_flush                  ), //i
    .io_occupancy    (fifo_io_occupancy[4:0]    ), //o
    .io_availability (fifo_io_availability[4:0] ), //o
    .io_pclk         (io_pclk                   ), //i
    ._zz_4           (_zz_1                     )  //i
  );
  assign io_push_ready = fifo_io_push_ready;
  assign io_pop_valid = fifo_io_pop_valid;
  assign io_pop_payload = fifo_io_pop_payload;
  assign io_occupancy = fifo_io_occupancy;
  assign io_availability = fifo_io_availability;

endmodule

module StreamFifo_1 (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [127:0]  io_push_payload_data,
  input  wire [15:0]   io_push_payload_strb,
  output reg           io_pop_valid,
  input  wire          io_pop_ready,
  output reg  [127:0]  io_pop_payload_data,
  output reg  [15:0]   io_pop_payload_strb,
  input  wire          io_flush,
  output wire [4:0]    io_occupancy,
  output wire [4:0]    io_availability,
  input  wire          io_pclk,
  input  wire          _zz_4
);

  wire       [143:0]  logic_ram_spinal_port1;
  wire       [143:0]  _zz_logic_ram_port;
  reg                 _zz_1;
  reg                 logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [4:0]    logic_ptr_push;
  reg        [4:0]    logic_ptr_pop;
  wire       [4:0]    logic_ptr_occupancy;
  wire       [4:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1557;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [3:0]    logic_push_onRam_write_payload_address;
  wire       [127:0]  logic_push_onRam_write_payload_data_data;
  wire       [15:0]   logic_push_onRam_write_payload_data_strb;
  wire                logic_pop_addressGen_valid;
  wire                logic_pop_addressGen_ready;
  wire       [3:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire       [127:0]  logic_pop_async_readed_data;
  wire       [15:0]   logic_pop_async_readed_strb;
  wire       [143:0]  _zz_logic_pop_async_readed_data;
  wire                logic_pop_addressGen_translated_valid;
  wire                logic_pop_addressGen_translated_ready;
  wire       [127:0]  logic_pop_addressGen_translated_payload_data;
  wire       [15:0]   logic_pop_addressGen_translated_payload_strb;
  (* ram_style = "distributed" *) reg [143:0] logic_ram [0:15];

  assign _zz_logic_ram_port = {logic_push_onRam_write_payload_data_strb,logic_push_onRam_write_payload_data_data};
  always @(posedge io_pclk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= _zz_logic_ram_port;
    end
  end

  assign logic_ram_spinal_port1 = logic_ram[logic_pop_addressGen_payload];
  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1557 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 5'h10) == 5'h0);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  always @(*) begin
    logic_ptr_doPush = io_push_fire;
    if(logic_ptr_empty) begin
      if(io_pop_ready) begin
        logic_ptr_doPush = 1'b0;
      end
    end
  end

  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[3:0];
  assign logic_push_onRam_write_payload_data_data = io_push_payload_data;
  assign logic_push_onRam_write_payload_data_strb = io_push_payload_strb;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[3:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  assign _zz_logic_pop_async_readed_data = logic_ram_spinal_port1;
  assign logic_pop_async_readed_data = _zz_logic_pop_async_readed_data[127 : 0];
  assign logic_pop_async_readed_strb = _zz_logic_pop_async_readed_data[143 : 128];
  assign logic_pop_addressGen_translated_valid = logic_pop_addressGen_valid;
  assign logic_pop_addressGen_ready = logic_pop_addressGen_translated_ready;
  assign logic_pop_addressGen_translated_payload_data = logic_pop_async_readed_data;
  assign logic_pop_addressGen_translated_payload_strb = logic_pop_async_readed_strb;
  always @(*) begin
    io_pop_valid = logic_pop_addressGen_translated_valid;
    if(logic_ptr_empty) begin
      io_pop_valid = io_push_valid;
    end
  end

  assign logic_pop_addressGen_translated_ready = io_pop_ready;
  always @(*) begin
    io_pop_payload_data = logic_pop_addressGen_translated_payload_data;
    if(logic_ptr_empty) begin
      io_pop_payload_data = io_push_payload_data;
    end
  end

  always @(*) begin
    io_pop_payload_strb = logic_pop_addressGen_translated_payload_strb;
    if(logic_ptr_empty) begin
      io_pop_payload_strb = io_push_payload_strb;
    end
  end

  assign logic_ptr_popOnIo = logic_ptr_pop;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (5'h10 - logic_ptr_occupancy);
  always @(posedge io_pclk or posedge _zz_4) begin
    if(_zz_4) begin
      logic_ptr_push <= 5'h0;
      logic_ptr_pop <= 5'h0;
      logic_ptr_wentUp <= 1'b0;
    end else begin
      if(when_Stream_l1557) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 5'h01);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 5'h01);
      end
      if(io_flush) begin
        logic_ptr_push <= 5'h0;
        logic_ptr_pop <= 5'h0;
      end
    end
  end


endmodule

module StreamFifo (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [127:0]  io_push_payload,
  output reg           io_pop_valid,
  input  wire          io_pop_ready,
  output reg  [127:0]  io_pop_payload,
  input  wire          io_flush,
  output wire [4:0]    io_occupancy,
  output wire [4:0]    io_availability,
  input  wire          io_pclk,
  input  wire          _zz_4
);

  wire       [127:0]  logic_ram_spinal_port1;
  reg                 _zz_1;
  reg                 logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [4:0]    logic_ptr_push;
  reg        [4:0]    logic_ptr_pop;
  wire       [4:0]    logic_ptr_occupancy;
  wire       [4:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1557;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [3:0]    logic_push_onRam_write_payload_address;
  wire       [127:0]  logic_push_onRam_write_payload_data;
  wire                logic_pop_addressGen_valid;
  wire                logic_pop_addressGen_ready;
  wire       [3:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire       [127:0]  logic_pop_async_readed;
  wire                logic_pop_addressGen_translated_valid;
  wire                logic_pop_addressGen_translated_ready;
  wire       [127:0]  logic_pop_addressGen_translated_payload;
  (* ram_style = "distributed" *) reg [127:0] logic_ram [0:15];

  always @(posedge io_pclk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= logic_push_onRam_write_payload_data;
    end
  end

  assign logic_ram_spinal_port1 = logic_ram[logic_pop_addressGen_payload];
  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1557 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 5'h10) == 5'h0);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  always @(*) begin
    logic_ptr_doPush = io_push_fire;
    if(logic_ptr_empty) begin
      if(io_pop_ready) begin
        logic_ptr_doPush = 1'b0;
      end
    end
  end

  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[3:0];
  assign logic_push_onRam_write_payload_data = io_push_payload;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[3:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  assign logic_pop_async_readed = logic_ram_spinal_port1;
  assign logic_pop_addressGen_translated_valid = logic_pop_addressGen_valid;
  assign logic_pop_addressGen_ready = logic_pop_addressGen_translated_ready;
  assign logic_pop_addressGen_translated_payload = logic_pop_async_readed;
  always @(*) begin
    io_pop_valid = logic_pop_addressGen_translated_valid;
    if(logic_ptr_empty) begin
      io_pop_valid = io_push_valid;
    end
  end

  assign logic_pop_addressGen_translated_ready = io_pop_ready;
  always @(*) begin
    io_pop_payload = logic_pop_addressGen_translated_payload;
    if(logic_ptr_empty) begin
      io_pop_payload = io_push_payload;
    end
  end

  assign logic_ptr_popOnIo = logic_ptr_pop;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (5'h10 - logic_ptr_occupancy);
  always @(posedge io_pclk or posedge _zz_4) begin
    if(_zz_4) begin
      logic_ptr_push <= 5'h0;
      logic_ptr_pop <= 5'h0;
      logic_ptr_wentUp <= 1'b0;
    end else begin
      if(when_Stream_l1557) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 5'h01);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 5'h01);
      end
      if(io_flush) begin
        logic_ptr_push <= 5'h0;
        logic_ptr_pop <= 5'h0;
      end
    end
  end


endmodule
