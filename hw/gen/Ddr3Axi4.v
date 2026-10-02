// Generator : SpinalHDL v1.15.0    git head : 05a01af3d3345aa0afcaad8e0186dde13a359db2
// Component : Ddr3Axi4
// Git hash  : ab505cc0aab9e98108d28d8bb1646c4a89363517
// Date      : 02/10/2026, 22:45:38

`timescale 1ns/1ps

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
  input  wire [127:0]  io_axi_w_payload_data,
  input  wire [15:0]   io_axi_w_payload_strb,
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
  output wire [127:0]  io_axi_r_payload_data,
  output wire [3:0]    io_axi_r_payload_id,
  output wire [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  output wire          io_init_done,
  output wire          io_write_level_done,
  output wire          io_read_calib_done,
  output wire [7:0]    io_wstep,
  output wire [1:0]    io_rclkpos,
  output wire [2:0]    io_rclksel,
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
  wire       [127:0]  area_bridge_io_axi_r_payload_data;
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
    .io_axi_aw_valid          (io_axi_aw_valid                         ), //i
    .io_axi_aw_ready          (area_bridge_io_axi_aw_ready             ), //o
    .io_axi_aw_payload_addr   (io_axi_aw_payload_addr[31:0]            ), //i
    .io_axi_aw_payload_id     (io_axi_aw_payload_id[3:0]               ), //i
    .io_axi_aw_payload_region (io_axi_aw_payload_region[3:0]           ), //i
    .io_axi_aw_payload_len    (io_axi_aw_payload_len[7:0]              ), //i
    .io_axi_aw_payload_size   (io_axi_aw_payload_size[2:0]             ), //i
    .io_axi_aw_payload_burst  (io_axi_aw_payload_burst[1:0]            ), //i
    .io_axi_aw_payload_lock   (io_axi_aw_payload_lock                  ), //i
    .io_axi_aw_payload_cache  (io_axi_aw_payload_cache[3:0]            ), //i
    .io_axi_aw_payload_qos    (io_axi_aw_payload_qos[3:0]              ), //i
    .io_axi_aw_payload_prot   (io_axi_aw_payload_prot[2:0]             ), //i
    .io_axi_w_valid           (io_axi_w_valid                          ), //i
    .io_axi_w_ready           (area_bridge_io_axi_w_ready              ), //o
    .io_axi_w_payload_data    (io_axi_w_payload_data[127:0]            ), //i
    .io_axi_w_payload_strb    (io_axi_w_payload_strb[15:0]             ), //i
    .io_axi_w_payload_last    (io_axi_w_payload_last                   ), //i
    .io_axi_b_valid           (area_bridge_io_axi_b_valid              ), //o
    .io_axi_b_ready           (io_axi_b_ready                          ), //i
    .io_axi_b_payload_id      (area_bridge_io_axi_b_payload_id[3:0]    ), //o
    .io_axi_b_payload_resp    (area_bridge_io_axi_b_payload_resp[1:0]  ), //o
    .io_axi_ar_valid          (io_axi_ar_valid                         ), //i
    .io_axi_ar_ready          (area_bridge_io_axi_ar_ready             ), //o
    .io_axi_ar_payload_addr   (io_axi_ar_payload_addr[31:0]            ), //i
    .io_axi_ar_payload_id     (io_axi_ar_payload_id[3:0]               ), //i
    .io_axi_ar_payload_region (io_axi_ar_payload_region[3:0]           ), //i
    .io_axi_ar_payload_len    (io_axi_ar_payload_len[7:0]              ), //i
    .io_axi_ar_payload_size   (io_axi_ar_payload_size[2:0]             ), //i
    .io_axi_ar_payload_burst  (io_axi_ar_payload_burst[1:0]            ), //i
    .io_axi_ar_payload_lock   (io_axi_ar_payload_lock                  ), //i
    .io_axi_ar_payload_cache  (io_axi_ar_payload_cache[3:0]            ), //i
    .io_axi_ar_payload_qos    (io_axi_ar_payload_qos[3:0]              ), //i
    .io_axi_ar_payload_prot   (io_axi_ar_payload_prot[2:0]             ), //i
    .io_axi_r_valid           (area_bridge_io_axi_r_valid              ), //o
    .io_axi_r_ready           (io_axi_r_ready                          ), //i
    .io_axi_r_payload_data    (area_bridge_io_axi_r_payload_data[127:0]), //o
    .io_axi_r_payload_id      (area_bridge_io_axi_r_payload_id[3:0]    ), //o
    .io_axi_r_payload_resp    (area_bridge_io_axi_r_payload_resp[1:0]  ), //o
    .io_axi_r_payload_last    (area_bridge_io_axi_r_payload_last       ), //o
    .io_init_done             (area_ctrl_io_init_done                  ), //i
    .io_req_valid             (area_bridge_io_req_valid                ), //o
    .io_req_ready             (area_ctrl_io_req_ready                  ), //i
    .io_req_payload_write     (area_bridge_io_req_payload_write        ), //o
    .io_req_payload_addr      (area_bridge_io_req_payload_addr[26:0]   ), //o
    .io_req_payload_wdata     (area_bridge_io_req_payload_wdata[127:0] ), //o
    .io_req_payload_wstrb     (area_bridge_io_req_payload_wstrb[15:0]  ), //o
    .io_rsp_valid             (area_ctrl_io_rsp_valid                  ), //i
    .io_rsp_payload_rdata     (area_ctrl_io_rsp_payload_rdata[127:0]   ), //i
    .io_pclk                  (io_pclk                                 ), //i
    ._zz_1                    (_zz_1                                   )  //i
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
  wire                coreArea_core_io_phy_dqs_hold;
  wire       [7:0]    coreArea_core_io_phy_wstep;
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
  wire                phy_io_dlllock;
  wire                phy_io_rst_lock_n;
  wire       [1:0]    phy_io_rburst;
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
  wire                _zz_when_Ddr3ControllerCore_l714;

  Ddr3ControllerCore coreArea_core (
    .io_req_valid                     (io_req_valid                             ), //i
    .io_req_ready                     (coreArea_core_io_req_ready               ), //o
    .io_req_payload_write             (io_req_payload_write                     ), //i
    .io_req_payload_addr              (io_req_payload_addr[26:0]                ), //i
    .io_req_payload_wdata             (io_req_payload_wdata[127:0]              ), //i
    .io_req_payload_wstrb             (io_req_payload_wstrb[15:0]               ), //i
    .io_rsp_valid                     (coreArea_core_io_rsp_valid               ), //o
    .io_rsp_payload_rdata             (coreArea_core_io_rsp_payload_rdata[127:0]), //o
    .io_init_done                     (coreArea_core_io_init_done               ), //o
    .io_write_level_done              (coreArea_core_io_write_level_done        ), //o
    .io_read_calib_done               (coreArea_core_io_read_calib_done         ), //o
    .io_wstep                         (coreArea_core_io_wstep[7:0]              ), //o
    .io_rclkpos                       (coreArea_core_io_rclkpos[1:0]            ), //o
    .io_rclksel                       (coreArea_core_io_rclksel[2:0]            ), //o
    .io_phy_dlllock                   (phy_io_dlllock                           ), //i
    .io_phy_rst_lock_n                (phy_io_rst_lock_n                        ), //i
    .io_phy_rburst                    (phy_io_rburst[1:0]                       ), //i
    .io_phy_dq_in_0                   (phy_io_dq_in_0[15:0]                     ), //i
    .io_phy_dq_in_1                   (phy_io_dq_in_1[15:0]                     ), //i
    .io_phy_dq_in_2                   (phy_io_dq_in_2[15:0]                     ), //i
    .io_phy_dq_in_3                   (phy_io_dq_in_3[15:0]                     ), //i
    .io_phy_dq_in_4                   (phy_io_dq_in_4[15:0]                     ), //i
    .io_phy_dq_in_5                   (phy_io_dq_in_5[15:0]                     ), //i
    .io_phy_dq_in_6                   (phy_io_dq_in_6[15:0]                     ), //i
    .io_phy_dq_in_7                   (phy_io_dq_in_7[15:0]                     ), //i
    .io_phy_dq_raw                    (phy_io_dq_raw[15:0]                      ), //i
    .io_phy_dqs_hold                  (coreArea_core_io_phy_dqs_hold            ), //o
    .io_phy_wstep                     (coreArea_core_io_phy_wstep[7:0]          ), //o
    .io_phy_rclkpos                   (coreArea_core_io_phy_rclkpos[1:0]        ), //o
    .io_phy_rclksel                   (coreArea_core_io_phy_rclksel[2:0]        ), //o
    .io_phy_dqs_read                  (coreArea_core_io_phy_dqs_read[3:0]       ), //o
    .io_phy_dq_out_0                  (coreArea_core_io_phy_dq_out_0[15:0]      ), //o
    .io_phy_dq_out_1                  (coreArea_core_io_phy_dq_out_1[15:0]      ), //o
    .io_phy_dq_out_2                  (coreArea_core_io_phy_dq_out_2[15:0]      ), //o
    .io_phy_dq_out_3                  (coreArea_core_io_phy_dq_out_3[15:0]      ), //o
    .io_phy_dq_out_4                  (coreArea_core_io_phy_dq_out_4[15:0]      ), //o
    .io_phy_dq_out_5                  (coreArea_core_io_phy_dq_out_5[15:0]      ), //o
    .io_phy_dq_out_6                  (coreArea_core_io_phy_dq_out_6[15:0]      ), //o
    .io_phy_dq_out_7                  (coreArea_core_io_phy_dq_out_7[15:0]      ), //o
    .io_phy_dq_oen                    (coreArea_core_io_phy_dq_oen[3:0]         ), //o
    .io_phy_dqs_out                   (coreArea_core_io_phy_dqs_out[7:0]        ), //o
    .io_phy_dqs_oen                   (coreArea_core_io_phy_dqs_oen[3:0]        ), //o
    .io_phy_dm_out                    (coreArea_core_io_phy_dm_out[7:0]         ), //o
    .io_phy_nRAS_0                    (coreArea_core_io_phy_nRAS_0              ), //o
    .io_phy_nRAS_1                    (coreArea_core_io_phy_nRAS_1              ), //o
    .io_phy_nRAS_2                    (coreArea_core_io_phy_nRAS_2              ), //o
    .io_phy_nRAS_3                    (coreArea_core_io_phy_nRAS_3              ), //o
    .io_phy_nCAS_0                    (coreArea_core_io_phy_nCAS_0              ), //o
    .io_phy_nCAS_1                    (coreArea_core_io_phy_nCAS_1              ), //o
    .io_phy_nCAS_2                    (coreArea_core_io_phy_nCAS_2              ), //o
    .io_phy_nCAS_3                    (coreArea_core_io_phy_nCAS_3              ), //o
    .io_phy_nWE_0                     (coreArea_core_io_phy_nWE_0               ), //o
    .io_phy_nWE_1                     (coreArea_core_io_phy_nWE_1               ), //o
    .io_phy_nWE_2                     (coreArea_core_io_phy_nWE_2               ), //o
    .io_phy_nWE_3                     (coreArea_core_io_phy_nWE_3               ), //o
    .io_phy_A_0                       (coreArea_core_io_phy_A_0[13:0]           ), //o
    .io_phy_A_1                       (coreArea_core_io_phy_A_1[13:0]           ), //o
    .io_phy_A_2                       (coreArea_core_io_phy_A_2[13:0]           ), //o
    .io_phy_A_3                       (coreArea_core_io_phy_A_3[13:0]           ), //o
    .io_phy_BA_0                      (coreArea_core_io_phy_BA_0[2:0]           ), //o
    .io_phy_BA_1                      (coreArea_core_io_phy_BA_1[2:0]           ), //o
    .io_phy_BA_2                      (coreArea_core_io_phy_BA_2[2:0]           ), //o
    .io_phy_BA_3                      (coreArea_core_io_phy_BA_3[2:0]           ), //o
    .io_phy_CKE                       (coreArea_core_io_phy_CKE                 ), //o
    .io_phy_resetn_delay              (coreArea_core_io_phy_resetn_delay        ), //o
    ._zz_when_Ddr3ControllerCore_l714 (_zz_when_Ddr3ControllerCore_l714         ), //i
    .io_pclk                          (io_pclk                                  )  //i
  );
  GowinDdr3Phy phy (
    .io_pclk            (io_pclk                            ), //i
    .io_fclk            (io_fclk                            ), //i
    .io_ck              (io_ck                              ), //i
    .io_resetn          (io_resetn                          ), //i
    .io_dqs_hold        (coreArea_core_io_phy_dqs_hold      ), //i
    .io_wstep           (coreArea_core_io_phy_wstep[7:0]    ), //i
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
    .io_dlllock         (phy_io_dlllock                     ), //o
    .io_rst_lock_n      (phy_io_rst_lock_n                  ), //o
    .io_rburst          (phy_io_rburst[1:0]                 ), //o
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
  assign _zz_when_Ddr3ControllerCore_l714 = (! io_resetn);
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
  output reg           io_axi_w_ready,
  input  wire [127:0]  io_axi_w_payload_data,
  input  wire [15:0]   io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output reg           io_axi_b_valid,
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
  output reg           io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output reg  [127:0]  io_axi_r_payload_data,
  output wire [3:0]    io_axi_r_payload_id,
  output wire [1:0]    io_axi_r_payload_resp,
  output reg           io_axi_r_payload_last,
  input  wire          io_init_done,
  output reg           io_req_valid,
  input  wire          io_req_ready,
  output reg           io_req_payload_write,
  output reg  [26:0]   io_req_payload_addr,
  output reg  [127:0]  io_req_payload_wdata,
  output reg  [15:0]   io_req_payload_wstrb,
  input  wire          io_rsp_valid,
  input  wire [127:0]  io_rsp_payload_rdata,
  input  wire          io_pclk,
  input  wire          _zz_1
);
  localparam ReadState_IDLE = 3'd0;
  localparam ReadState_ISSUE_REQ = 3'd1;
  localparam ReadState_WAIT_DATA = 3'd2;
  localparam ReadState_SEND_BEAT1 = 3'd3;
  localparam ReadState_SEND_BEAT2 = 3'd4;
  localparam WriteState_IDLE = 2'd0;
  localparam WriteState_RECV_W = 2'd1;
  localparam WriteState_ISSUE_REQ = 2'd2;
  localparam WriteState_SEND_RESP = 2'd3;

  wire       [7:0]    _zz_rRemaining_2;
  wire       [27:0]   _zz_io_req_payload_addr;
  wire       [63:0]   _zz_io_axi_r_payload_data;
  wire       [27:0]   _zz_io_req_payload_addr_1;
  reg        [2:0]    rState;
  reg        [31:0]   rAddr;
  reg        [7:0]    rLen;
  reg        [3:0]    rId;
  reg        [127:0]  rBuf128;
  reg        [8:0]    rRemaining;
  reg        [1:0]    wState;
  reg        [31:0]   wAddr;
  reg        [7:0]    wLen;
  reg        [3:0]    wId;
  reg        [127:0]  wBuf128;
  reg        [15:0]   wStrb128;
  reg                 wPhase64;
  wire                when_Ddr3Axi4Bridge_l72;
  wire       [8:0]    _zz_rRemaining;
  wire                when_Ddr3Axi4Bridge_l107;
  wire       [8:0]    _zz_rRemaining_1;
  wire                when_Ddr3Axi4Bridge_l137;
  wire                when_Ddr3Axi4Bridge_l149;
  `ifndef SYNTHESIS
  reg [79:0] rState_string;
  reg [71:0] wState_string;
  `endif


  assign _zz_rRemaining_2 = (io_axi_ar_payload_len + 8'h01);
  assign _zz_io_req_payload_addr = (rAddr >>> 3'd4);
  assign _zz_io_axi_r_payload_data = rBuf128[127 : 64];
  assign _zz_io_req_payload_addr_1 = (wAddr >>> 3'd4);
  `ifndef SYNTHESIS
  always @(*) begin
    case(rState)
      ReadState_IDLE : rState_string = "IDLE      ";
      ReadState_ISSUE_REQ : rState_string = "ISSUE_REQ ";
      ReadState_WAIT_DATA : rState_string = "WAIT_DATA ";
      ReadState_SEND_BEAT1 : rState_string = "SEND_BEAT1";
      ReadState_SEND_BEAT2 : rState_string = "SEND_BEAT2";
      default : rState_string = "??????????";
    endcase
  end
  always @(*) begin
    case(wState)
      WriteState_IDLE : wState_string = "IDLE     ";
      WriteState_RECV_W : wState_string = "RECV_W   ";
      WriteState_ISSUE_REQ : wState_string = "ISSUE_REQ";
      WriteState_SEND_RESP : wState_string = "SEND_RESP";
      default : wState_string = "?????????";
    endcase
  end
  `endif

  always @(*) begin
    io_req_valid = 1'b0;
    case(rState)
      ReadState_IDLE : begin
      end
      ReadState_ISSUE_REQ : begin
        io_req_valid = 1'b1;
      end
      ReadState_WAIT_DATA : begin
      end
      ReadState_SEND_BEAT1 : begin
      end
      default : begin
      end
    endcase
    case(wState)
      WriteState_IDLE : begin
      end
      WriteState_RECV_W : begin
      end
      WriteState_ISSUE_REQ : begin
        io_req_valid = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_req_payload_write = 1'b0;
    case(rState)
      ReadState_IDLE : begin
      end
      ReadState_ISSUE_REQ : begin
        io_req_payload_write = 1'b0;
      end
      ReadState_WAIT_DATA : begin
      end
      ReadState_SEND_BEAT1 : begin
      end
      default : begin
      end
    endcase
    case(wState)
      WriteState_IDLE : begin
      end
      WriteState_RECV_W : begin
      end
      WriteState_ISSUE_REQ : begin
        io_req_payload_write = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_req_payload_addr = 27'h0;
    case(rState)
      ReadState_IDLE : begin
      end
      ReadState_ISSUE_REQ : begin
        io_req_payload_addr = _zz_io_req_payload_addr[26:0];
      end
      ReadState_WAIT_DATA : begin
      end
      ReadState_SEND_BEAT1 : begin
      end
      default : begin
      end
    endcase
    case(wState)
      WriteState_IDLE : begin
      end
      WriteState_RECV_W : begin
      end
      WriteState_ISSUE_REQ : begin
        io_req_payload_addr = _zz_io_req_payload_addr_1[26:0];
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_req_payload_wdata = 128'h0;
    case(wState)
      WriteState_IDLE : begin
      end
      WriteState_RECV_W : begin
      end
      WriteState_ISSUE_REQ : begin
        io_req_payload_wdata = wBuf128;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_req_payload_wstrb = 16'hffff;
    case(wState)
      WriteState_IDLE : begin
      end
      WriteState_RECV_W : begin
      end
      WriteState_ISSUE_REQ : begin
        io_req_payload_wstrb = wStrb128;
      end
      default : begin
      end
    endcase
  end

  assign io_axi_ar_ready = (((rState == ReadState_IDLE) && io_init_done) && (wState == WriteState_IDLE));
  assign io_axi_aw_ready = (((wState == WriteState_IDLE) && io_init_done) && (rState == ReadState_IDLE));
  always @(*) begin
    io_axi_w_ready = 1'b0;
    case(wState)
      WriteState_IDLE : begin
      end
      WriteState_RECV_W : begin
        io_axi_w_ready = 1'b1;
      end
      WriteState_ISSUE_REQ : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_r_valid = 1'b0;
    case(rState)
      ReadState_IDLE : begin
      end
      ReadState_ISSUE_REQ : begin
      end
      ReadState_WAIT_DATA : begin
      end
      ReadState_SEND_BEAT1 : begin
        io_axi_r_valid = 1'b1;
      end
      default : begin
        io_axi_r_valid = 1'b1;
      end
    endcase
  end

  always @(*) begin
    io_axi_r_payload_data = 128'h0;
    case(rState)
      ReadState_IDLE : begin
      end
      ReadState_ISSUE_REQ : begin
      end
      ReadState_WAIT_DATA : begin
      end
      ReadState_SEND_BEAT1 : begin
        io_axi_r_payload_data = rBuf128;
      end
      default : begin
        io_axi_r_payload_data = {64'd0, _zz_io_axi_r_payload_data};
      end
    endcase
  end

  assign io_axi_r_payload_id = rId;
  assign io_axi_r_payload_resp = 2'b00;
  always @(*) begin
    io_axi_r_payload_last = 1'b0;
    case(rState)
      ReadState_IDLE : begin
      end
      ReadState_ISSUE_REQ : begin
      end
      ReadState_WAIT_DATA : begin
      end
      ReadState_SEND_BEAT1 : begin
        io_axi_r_payload_last = (rRemaining == 9'h001);
      end
      default : begin
        io_axi_r_payload_last = (rRemaining == 9'h001);
      end
    endcase
  end

  always @(*) begin
    io_axi_b_valid = 1'b0;
    case(wState)
      WriteState_IDLE : begin
      end
      WriteState_RECV_W : begin
      end
      WriteState_ISSUE_REQ : begin
      end
      default : begin
        io_axi_b_valid = 1'b1;
      end
    endcase
  end

  assign io_axi_b_payload_id = wId;
  assign io_axi_b_payload_resp = 2'b00;
  assign when_Ddr3Axi4Bridge_l72 = (io_axi_ar_valid && io_axi_ar_ready);
  assign _zz_rRemaining = (rRemaining - 9'h001);
  assign when_Ddr3Axi4Bridge_l107 = (_zz_rRemaining == 9'h0);
  assign _zz_rRemaining_1 = (rRemaining - 9'h001);
  assign when_Ddr3Axi4Bridge_l137 = (_zz_rRemaining_1 == 9'h0);
  assign when_Ddr3Axi4Bridge_l149 = (io_axi_aw_valid && io_axi_aw_ready);
  always @(posedge io_pclk or posedge _zz_1) begin
    if(_zz_1) begin
      rState <= ReadState_IDLE;
      rAddr <= 32'h0;
      rLen <= 8'h0;
      rId <= 4'b0000;
      rBuf128 <= 128'h0;
      rRemaining <= 9'h0;
      wState <= WriteState_IDLE;
      wAddr <= 32'h0;
      wLen <= 8'h0;
      wId <= 4'b0000;
      wBuf128 <= 128'h0;
      wStrb128 <= 16'h0;
      wPhase64 <= 1'b0;
    end else begin
      case(rState)
        ReadState_IDLE : begin
          if(when_Ddr3Axi4Bridge_l72) begin
            rAddr <= io_axi_ar_payload_addr;
            rLen <= io_axi_ar_payload_len;
            rId <= io_axi_ar_payload_id;
            rRemaining <= {1'd0, _zz_rRemaining_2};
            rState <= ReadState_ISSUE_REQ;
          end
        end
        ReadState_ISSUE_REQ : begin
          if(io_req_ready) begin
            rState <= ReadState_WAIT_DATA;
          end
        end
        ReadState_WAIT_DATA : begin
          if(io_rsp_valid) begin
            rBuf128 <= io_rsp_payload_rdata;
            rState <= ReadState_SEND_BEAT1;
          end
        end
        ReadState_SEND_BEAT1 : begin
          if(io_axi_r_ready) begin
            rRemaining <= _zz_rRemaining;
            rAddr <= (rAddr + 32'h00000010);
            if(when_Ddr3Axi4Bridge_l107) begin
              rState <= ReadState_IDLE;
            end else begin
              rState <= ReadState_ISSUE_REQ;
            end
          end
        end
        default : begin
          if(io_axi_r_ready) begin
            rRemaining <= _zz_rRemaining_1;
            rAddr <= (rAddr + 32'h00000008);
            if(when_Ddr3Axi4Bridge_l137) begin
              rState <= ReadState_IDLE;
            end else begin
              rState <= ReadState_ISSUE_REQ;
            end
          end
        end
      endcase
      case(wState)
        WriteState_IDLE : begin
          if(when_Ddr3Axi4Bridge_l149) begin
            wAddr <= io_axi_aw_payload_addr;
            wLen <= io_axi_aw_payload_len;
            wId <= io_axi_aw_payload_id;
            wPhase64 <= 1'b0;
            wState <= WriteState_RECV_W;
          end
        end
        WriteState_RECV_W : begin
          if(io_axi_w_valid) begin
            wBuf128 <= io_axi_w_payload_data;
            wStrb128 <= io_axi_w_payload_strb;
            wState <= WriteState_ISSUE_REQ;
          end
        end
        WriteState_ISSUE_REQ : begin
          if(io_req_ready) begin
            wState <= WriteState_SEND_RESP;
          end
        end
        default : begin
          if(io_axi_b_ready) begin
            wState <= WriteState_IDLE;
          end
        end
      endcase
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
  output wire          io_dlllock,
  output wire          io_rst_lock_n,
  output wire [1:0]    io_rburst,
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
  wire                dQS_1_RESET;
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
  wire                oSER8_MEM_1_RESET;
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
  wire                oSER8_MEM_2_RESET;
  wire                dQS_2_DQSIN;
  wire                dQS_2_RESET;
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
  wire                oSER8_MEM_3_RESET;
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
  wire                oSER8_MEM_4_RESET;
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
  wire                oSER8_MEM_5_RESET;
  wire                iOBUF_3_I;
  wire                iOBUF_3_OEN;
  wire                iDES8_MEM_1_D;
  wire                iDES8_MEM_1_RESET;
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
  wire                oSER8_MEM_6_RESET;
  wire                iOBUF_4_I;
  wire                iOBUF_4_OEN;
  wire                iDES8_MEM_2_D;
  wire                iDES8_MEM_2_RESET;
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
  wire                oSER8_MEM_7_RESET;
  wire                iOBUF_5_I;
  wire                iOBUF_5_OEN;
  wire                iDES8_MEM_3_D;
  wire                iDES8_MEM_3_RESET;
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
  wire                oSER8_MEM_8_RESET;
  wire                iOBUF_6_I;
  wire                iOBUF_6_OEN;
  wire                iDES8_MEM_4_D;
  wire                iDES8_MEM_4_RESET;
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
  wire                oSER8_MEM_9_RESET;
  wire                iOBUF_7_I;
  wire                iOBUF_7_OEN;
  wire                iDES8_MEM_5_D;
  wire                iDES8_MEM_5_RESET;
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
  wire                oSER8_MEM_10_RESET;
  wire                iOBUF_8_I;
  wire                iOBUF_8_OEN;
  wire                iDES8_MEM_6_D;
  wire                iDES8_MEM_6_RESET;
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
  wire                oSER8_MEM_11_RESET;
  wire                iOBUF_9_I;
  wire                iOBUF_9_OEN;
  wire                iDES8_MEM_7_D;
  wire                iDES8_MEM_7_RESET;
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
  wire                oSER8_MEM_12_RESET;
  wire                iOBUF_10_I;
  wire                iOBUF_10_OEN;
  wire                iDES8_MEM_8_D;
  wire                iDES8_MEM_8_RESET;
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
  wire                oSER8_MEM_13_RESET;
  wire                iOBUF_11_I;
  wire                iOBUF_11_OEN;
  wire                iDES8_MEM_9_D;
  wire                iDES8_MEM_9_RESET;
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
  wire                oSER8_MEM_14_RESET;
  wire                iOBUF_12_I;
  wire                iOBUF_12_OEN;
  wire                iDES8_MEM_10_D;
  wire                iDES8_MEM_10_RESET;
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
  wire                oSER8_MEM_15_RESET;
  wire                iOBUF_13_I;
  wire                iOBUF_13_OEN;
  wire                iDES8_MEM_11_D;
  wire                iDES8_MEM_11_RESET;
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
  wire                oSER8_MEM_16_RESET;
  wire                iOBUF_14_I;
  wire                iOBUF_14_OEN;
  wire                iDES8_MEM_12_D;
  wire                iDES8_MEM_12_RESET;
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
  wire                oSER8_MEM_17_RESET;
  wire                iOBUF_15_I;
  wire                iOBUF_15_OEN;
  wire                iDES8_MEM_13_D;
  wire                iDES8_MEM_13_RESET;
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
  wire                oSER8_MEM_18_RESET;
  wire                iOBUF_16_I;
  wire                iOBUF_16_OEN;
  wire                iDES8_MEM_14_D;
  wire                iDES8_MEM_14_RESET;
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
  wire                oSER8_MEM_19_RESET;
  wire                iOBUF_17_I;
  wire                iOBUF_17_OEN;
  wire                iDES8_MEM_15_D;
  wire                iDES8_MEM_15_RESET;
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
  wire                oSER8_MEM_20_RESET;
  wire                iOBUF_18_I;
  wire                iOBUF_18_OEN;
  wire                iDES8_MEM_16_D;
  wire                iDES8_MEM_16_RESET;
  wire                oSER8_1_RESET;
  wire                oSER8_2_RESET;
  wire                oSER8_3_RESET;
  wire                oSER8_4_D0;
  wire                oSER8_4_D1;
  wire                oSER8_4_D2;
  wire                oSER8_4_D3;
  wire                oSER8_4_D4;
  wire                oSER8_4_D5;
  wire                oSER8_4_D6;
  wire                oSER8_4_D7;
  wire                oSER8_4_RESET;
  wire                oSER8_5_D0;
  wire                oSER8_5_D1;
  wire                oSER8_5_D2;
  wire                oSER8_5_D3;
  wire                oSER8_5_D4;
  wire                oSER8_5_D5;
  wire                oSER8_5_D6;
  wire                oSER8_5_D7;
  wire                oSER8_5_RESET;
  wire                oSER8_6_D0;
  wire                oSER8_6_D1;
  wire                oSER8_6_D2;
  wire                oSER8_6_D3;
  wire                oSER8_6_D4;
  wire                oSER8_6_D5;
  wire                oSER8_6_D6;
  wire                oSER8_6_D7;
  wire                oSER8_6_RESET;
  wire                oSER8_7_D0;
  wire                oSER8_7_D1;
  wire                oSER8_7_D2;
  wire                oSER8_7_D3;
  wire                oSER8_7_D4;
  wire                oSER8_7_D5;
  wire                oSER8_7_D6;
  wire                oSER8_7_D7;
  wire                oSER8_7_RESET;
  wire                oSER8_8_D0;
  wire                oSER8_8_D1;
  wire                oSER8_8_D2;
  wire                oSER8_8_D3;
  wire                oSER8_8_D4;
  wire                oSER8_8_D5;
  wire                oSER8_8_D6;
  wire                oSER8_8_D7;
  wire                oSER8_8_RESET;
  wire                oSER8_9_D0;
  wire                oSER8_9_D1;
  wire                oSER8_9_D2;
  wire                oSER8_9_D3;
  wire                oSER8_9_D4;
  wire                oSER8_9_D5;
  wire                oSER8_9_D6;
  wire                oSER8_9_D7;
  wire                oSER8_9_RESET;
  wire                oSER8_10_D0;
  wire                oSER8_10_D1;
  wire                oSER8_10_D2;
  wire                oSER8_10_D3;
  wire                oSER8_10_D4;
  wire                oSER8_10_D5;
  wire                oSER8_10_D6;
  wire                oSER8_10_D7;
  wire                oSER8_10_RESET;
  wire                oSER8_11_D0;
  wire                oSER8_11_D1;
  wire                oSER8_11_D2;
  wire                oSER8_11_D3;
  wire                oSER8_11_D4;
  wire                oSER8_11_D5;
  wire                oSER8_11_D6;
  wire                oSER8_11_D7;
  wire                oSER8_11_RESET;
  wire                oSER8_12_D0;
  wire                oSER8_12_D1;
  wire                oSER8_12_D2;
  wire                oSER8_12_D3;
  wire                oSER8_12_D4;
  wire                oSER8_12_D5;
  wire                oSER8_12_D6;
  wire                oSER8_12_D7;
  wire                oSER8_12_RESET;
  wire                oSER8_13_D0;
  wire                oSER8_13_D1;
  wire                oSER8_13_D2;
  wire                oSER8_13_D3;
  wire                oSER8_13_D4;
  wire                oSER8_13_D5;
  wire                oSER8_13_D6;
  wire                oSER8_13_D7;
  wire                oSER8_13_RESET;
  wire                oSER8_14_D0;
  wire                oSER8_14_D1;
  wire                oSER8_14_D2;
  wire                oSER8_14_D3;
  wire                oSER8_14_D4;
  wire                oSER8_14_D5;
  wire                oSER8_14_D6;
  wire                oSER8_14_D7;
  wire                oSER8_14_RESET;
  wire                oSER8_15_D0;
  wire                oSER8_15_D1;
  wire                oSER8_15_D2;
  wire                oSER8_15_D3;
  wire                oSER8_15_D4;
  wire                oSER8_15_D5;
  wire                oSER8_15_D6;
  wire                oSER8_15_D7;
  wire                oSER8_15_RESET;
  wire                oSER8_16_D0;
  wire                oSER8_16_D1;
  wire                oSER8_16_D2;
  wire                oSER8_16_D3;
  wire                oSER8_16_D4;
  wire                oSER8_16_D5;
  wire                oSER8_16_D6;
  wire                oSER8_16_D7;
  wire                oSER8_16_RESET;
  wire                oSER8_17_D0;
  wire                oSER8_17_D1;
  wire                oSER8_17_D2;
  wire                oSER8_17_D3;
  wire                oSER8_17_D4;
  wire                oSER8_17_D5;
  wire                oSER8_17_D6;
  wire                oSER8_17_D7;
  wire                oSER8_17_RESET;
  wire                oSER8_18_D0;
  wire                oSER8_18_D1;
  wire                oSER8_18_D2;
  wire                oSER8_18_D3;
  wire                oSER8_18_D4;
  wire                oSER8_18_D5;
  wire                oSER8_18_D6;
  wire                oSER8_18_D7;
  wire                oSER8_18_RESET;
  wire                oSER8_19_D0;
  wire                oSER8_19_D1;
  wire                oSER8_19_D2;
  wire                oSER8_19_D3;
  wire                oSER8_19_D4;
  wire                oSER8_19_D5;
  wire                oSER8_19_D6;
  wire                oSER8_19_D7;
  wire                oSER8_19_RESET;
  wire                oSER8_20_D0;
  wire                oSER8_20_D1;
  wire                oSER8_20_D2;
  wire                oSER8_20_D3;
  wire                oSER8_20_D4;
  wire                oSER8_20_D5;
  wire                oSER8_20_D6;
  wire                oSER8_20_D7;
  wire                oSER8_20_RESET;
  wire       [7:0]    dll_1_STEP;
  wire                dll_1_LOCK;
  wire                dQS_1_DQSR90;
  wire       [2:0]    dQS_1_WPOINT;
  wire       [2:0]    dQS_1_RPOINT;
  wire                dQS_1_DQSW0;
  wire                dQS_1_DQSW270;
  wire                dQS_1_RBURST;
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
  wire                rst_lock_n;
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
    .FCLK    (io_fclk          ), //i
    .PCLK    (io_pclk          ), //i
    .DQSIN   (dQS_1_DQSIN      ), //i
    .RESET   (dQS_1_RESET      ), //i
    .HOLD    (io_dqs_hold      ), //i
    .RLOADN  (1'b0             ), //i
    .WLOADN  (1'b0             ), //i
    .RMOVE   (1'b0             ), //i
    .WMOVE   (1'b0             ), //i
    .DLLSTEP (dll_1_STEP[7:0]  ), //i
    .WSTEP   (io_wstep[7:0]    ), //i
    .RCLKSEL (io_rclksel[2:0]  ), //i
    .READ    (io_dqs_read[3:0] ), //i
    .DQSR90  (dQS_1_DQSR90     ), //o
    .WPOINT  (dQS_1_WPOINT[2:0]), //o
    .RPOINT  (dQS_1_RPOINT[2:0]), //o
    .DQSW0   (dQS_1_DQSW0      ), //o
    .DQSW270 (dQS_1_DQSW270    ), //o
    .RBURST  (dQS_1_RBURST     )  //o
  );
  OSER8_MEM oSER8_MEM_1 (
    .D0    (oSER8_MEM_1_D0   ), //i
    .D1    (oSER8_MEM_1_D1   ), //i
    .D2    (oSER8_MEM_1_D2   ), //i
    .D3    (oSER8_MEM_1_D3   ), //i
    .D4    (oSER8_MEM_1_D4   ), //i
    .D5    (oSER8_MEM_1_D5   ), //i
    .D6    (oSER8_MEM_1_D6   ), //i
    .D7    (oSER8_MEM_1_D7   ), //i
    .TX0   (oSER8_MEM_1_TX0  ), //i
    .TX1   (oSER8_MEM_1_TX1  ), //i
    .TX2   (oSER8_MEM_1_TX2  ), //i
    .TX3   (oSER8_MEM_1_TX3  ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .TCLK  (clk_dqsw_0       ), //i
    .RESET (oSER8_MEM_1_RESET), //i
    .Q0    (oSER8_MEM_1_Q0   ), //o
    .Q1    (oSER8_MEM_1_Q1   )  //o
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
    .D0    (oSER8_MEM_2_D0   ), //i
    .D1    (oSER8_MEM_2_D1   ), //i
    .D2    (oSER8_MEM_2_D2   ), //i
    .D3    (oSER8_MEM_2_D3   ), //i
    .D4    (oSER8_MEM_2_D4   ), //i
    .D5    (oSER8_MEM_2_D5   ), //i
    .D6    (oSER8_MEM_2_D6   ), //i
    .D7    (oSER8_MEM_2_D7   ), //i
    .TX0   (1'b0             ), //i
    .TX1   (1'b0             ), //i
    .TX2   (1'b0             ), //i
    .TX3   (1'b0             ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .TCLK  (clk_dqsw270_0    ), //i
    .RESET (oSER8_MEM_2_RESET), //i
    .Q0    (oSER8_MEM_2_Q0   ), //o
    .Q1    (oSER8_MEM_2_Q1   )  //o
  );
  DQS #(
    .DQS_MODE ("X4"   ),
    .HWL      ("false")
  ) dQS_2 (
    .FCLK    (io_fclk          ), //i
    .PCLK    (io_pclk          ), //i
    .DQSIN   (dQS_2_DQSIN      ), //i
    .RESET   (dQS_2_RESET      ), //i
    .HOLD    (io_dqs_hold      ), //i
    .RLOADN  (1'b0             ), //i
    .WLOADN  (1'b0             ), //i
    .RMOVE   (1'b0             ), //i
    .WMOVE   (1'b0             ), //i
    .DLLSTEP (dll_1_STEP[7:0]  ), //i
    .WSTEP   (io_wstep[7:0]    ), //i
    .RCLKSEL (io_rclksel[2:0]  ), //i
    .READ    (io_dqs_read[3:0] ), //i
    .DQSR90  (dQS_2_DQSR90     ), //o
    .WPOINT  (dQS_2_WPOINT[2:0]), //o
    .RPOINT  (dQS_2_RPOINT[2:0]), //o
    .DQSW0   (dQS_2_DQSW0      ), //o
    .DQSW270 (dQS_2_DQSW270    ), //o
    .RBURST  (dQS_2_RBURST     )  //o
  );
  OSER8_MEM oSER8_MEM_3 (
    .D0    (oSER8_MEM_3_D0   ), //i
    .D1    (oSER8_MEM_3_D1   ), //i
    .D2    (oSER8_MEM_3_D2   ), //i
    .D3    (oSER8_MEM_3_D3   ), //i
    .D4    (oSER8_MEM_3_D4   ), //i
    .D5    (oSER8_MEM_3_D5   ), //i
    .D6    (oSER8_MEM_3_D6   ), //i
    .D7    (oSER8_MEM_3_D7   ), //i
    .TX0   (oSER8_MEM_3_TX0  ), //i
    .TX1   (oSER8_MEM_3_TX1  ), //i
    .TX2   (oSER8_MEM_3_TX2  ), //i
    .TX3   (oSER8_MEM_3_TX3  ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .TCLK  (clk_dqsw_1       ), //i
    .RESET (oSER8_MEM_3_RESET), //i
    .Q0    (oSER8_MEM_3_Q0   ), //o
    .Q1    (oSER8_MEM_3_Q1   )  //o
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
    .D0    (oSER8_MEM_4_D0   ), //i
    .D1    (oSER8_MEM_4_D1   ), //i
    .D2    (oSER8_MEM_4_D2   ), //i
    .D3    (oSER8_MEM_4_D3   ), //i
    .D4    (oSER8_MEM_4_D4   ), //i
    .D5    (oSER8_MEM_4_D5   ), //i
    .D6    (oSER8_MEM_4_D6   ), //i
    .D7    (oSER8_MEM_4_D7   ), //i
    .TX0   (1'b0             ), //i
    .TX1   (1'b0             ), //i
    .TX2   (1'b0             ), //i
    .TX3   (1'b0             ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .TCLK  (clk_dqsw270_1    ), //i
    .RESET (oSER8_MEM_4_RESET), //i
    .Q0    (oSER8_MEM_4_Q0   ), //o
    .Q1    (oSER8_MEM_4_Q1   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_5 (
    .D0    (oSER8_MEM_5_D0   ), //i
    .D1    (oSER8_MEM_5_D1   ), //i
    .D2    (oSER8_MEM_5_D2   ), //i
    .D3    (oSER8_MEM_5_D3   ), //i
    .D4    (oSER8_MEM_5_D4   ), //i
    .D5    (oSER8_MEM_5_D5   ), //i
    .D6    (oSER8_MEM_5_D6   ), //i
    .D7    (oSER8_MEM_5_D7   ), //i
    .TX0   (oSER8_MEM_5_TX0  ), //i
    .TX1   (oSER8_MEM_5_TX1  ), //i
    .TX2   (oSER8_MEM_5_TX2  ), //i
    .TX3   (oSER8_MEM_5_TX3  ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .TCLK  (clk_dqsw270_0    ), //i
    .RESET (oSER8_MEM_5_RESET), //i
    .Q0    (oSER8_MEM_5_Q0   ), //o
    .Q1    (oSER8_MEM_5_Q1   )  //o
  );
  IOBUF iOBUF_3 (
    .I   (iOBUF_3_I        ), //i
    .OEN (iOBUF_3_OEN      ), //i
    .O   (iOBUF_3_O        ), //o
    .IO  (io_pad_DDR3_DQ[0])  //~
  );
  IDES8_MEM iDES8_MEM_1 (
    .D     (iDES8_MEM_1_D    ), //i
    .ICLK  (clk_dqsr_0       ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .CALIB (1'b0             ), //i
    .RESET (iDES8_MEM_1_RESET), //i
    .WADDR (dqs_waddr_0[2:0] ), //i
    .RADDR (dqs_raddr_0[2:0] ), //i
    .Q0    (iDES8_MEM_1_Q0   ), //o
    .Q1    (iDES8_MEM_1_Q1   ), //o
    .Q2    (iDES8_MEM_1_Q2   ), //o
    .Q3    (iDES8_MEM_1_Q3   ), //o
    .Q4    (iDES8_MEM_1_Q4   ), //o
    .Q5    (iDES8_MEM_1_Q5   ), //o
    .Q6    (iDES8_MEM_1_Q6   ), //o
    .Q7    (iDES8_MEM_1_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_6 (
    .D0    (oSER8_MEM_6_D0   ), //i
    .D1    (oSER8_MEM_6_D1   ), //i
    .D2    (oSER8_MEM_6_D2   ), //i
    .D3    (oSER8_MEM_6_D3   ), //i
    .D4    (oSER8_MEM_6_D4   ), //i
    .D5    (oSER8_MEM_6_D5   ), //i
    .D6    (oSER8_MEM_6_D6   ), //i
    .D7    (oSER8_MEM_6_D7   ), //i
    .TX0   (oSER8_MEM_6_TX0  ), //i
    .TX1   (oSER8_MEM_6_TX1  ), //i
    .TX2   (oSER8_MEM_6_TX2  ), //i
    .TX3   (oSER8_MEM_6_TX3  ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .TCLK  (clk_dqsw270_0    ), //i
    .RESET (oSER8_MEM_6_RESET), //i
    .Q0    (oSER8_MEM_6_Q0   ), //o
    .Q1    (oSER8_MEM_6_Q1   )  //o
  );
  IOBUF iOBUF_4 (
    .I   (iOBUF_4_I        ), //i
    .OEN (iOBUF_4_OEN      ), //i
    .O   (iOBUF_4_O        ), //o
    .IO  (io_pad_DDR3_DQ[1])  //~
  );
  IDES8_MEM iDES8_MEM_2 (
    .D     (iDES8_MEM_2_D    ), //i
    .ICLK  (clk_dqsr_0       ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .CALIB (1'b0             ), //i
    .RESET (iDES8_MEM_2_RESET), //i
    .WADDR (dqs_waddr_0[2:0] ), //i
    .RADDR (dqs_raddr_0[2:0] ), //i
    .Q0    (iDES8_MEM_2_Q0   ), //o
    .Q1    (iDES8_MEM_2_Q1   ), //o
    .Q2    (iDES8_MEM_2_Q2   ), //o
    .Q3    (iDES8_MEM_2_Q3   ), //o
    .Q4    (iDES8_MEM_2_Q4   ), //o
    .Q5    (iDES8_MEM_2_Q5   ), //o
    .Q6    (iDES8_MEM_2_Q6   ), //o
    .Q7    (iDES8_MEM_2_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_7 (
    .D0    (oSER8_MEM_7_D0   ), //i
    .D1    (oSER8_MEM_7_D1   ), //i
    .D2    (oSER8_MEM_7_D2   ), //i
    .D3    (oSER8_MEM_7_D3   ), //i
    .D4    (oSER8_MEM_7_D4   ), //i
    .D5    (oSER8_MEM_7_D5   ), //i
    .D6    (oSER8_MEM_7_D6   ), //i
    .D7    (oSER8_MEM_7_D7   ), //i
    .TX0   (oSER8_MEM_7_TX0  ), //i
    .TX1   (oSER8_MEM_7_TX1  ), //i
    .TX2   (oSER8_MEM_7_TX2  ), //i
    .TX3   (oSER8_MEM_7_TX3  ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .TCLK  (clk_dqsw270_0    ), //i
    .RESET (oSER8_MEM_7_RESET), //i
    .Q0    (oSER8_MEM_7_Q0   ), //o
    .Q1    (oSER8_MEM_7_Q1   )  //o
  );
  IOBUF iOBUF_5 (
    .I   (iOBUF_5_I        ), //i
    .OEN (iOBUF_5_OEN      ), //i
    .O   (iOBUF_5_O        ), //o
    .IO  (io_pad_DDR3_DQ[2])  //~
  );
  IDES8_MEM iDES8_MEM_3 (
    .D     (iDES8_MEM_3_D    ), //i
    .ICLK  (clk_dqsr_0       ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .CALIB (1'b0             ), //i
    .RESET (iDES8_MEM_3_RESET), //i
    .WADDR (dqs_waddr_0[2:0] ), //i
    .RADDR (dqs_raddr_0[2:0] ), //i
    .Q0    (iDES8_MEM_3_Q0   ), //o
    .Q1    (iDES8_MEM_3_Q1   ), //o
    .Q2    (iDES8_MEM_3_Q2   ), //o
    .Q3    (iDES8_MEM_3_Q3   ), //o
    .Q4    (iDES8_MEM_3_Q4   ), //o
    .Q5    (iDES8_MEM_3_Q5   ), //o
    .Q6    (iDES8_MEM_3_Q6   ), //o
    .Q7    (iDES8_MEM_3_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_8 (
    .D0    (oSER8_MEM_8_D0   ), //i
    .D1    (oSER8_MEM_8_D1   ), //i
    .D2    (oSER8_MEM_8_D2   ), //i
    .D3    (oSER8_MEM_8_D3   ), //i
    .D4    (oSER8_MEM_8_D4   ), //i
    .D5    (oSER8_MEM_8_D5   ), //i
    .D6    (oSER8_MEM_8_D6   ), //i
    .D7    (oSER8_MEM_8_D7   ), //i
    .TX0   (oSER8_MEM_8_TX0  ), //i
    .TX1   (oSER8_MEM_8_TX1  ), //i
    .TX2   (oSER8_MEM_8_TX2  ), //i
    .TX3   (oSER8_MEM_8_TX3  ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .TCLK  (clk_dqsw270_0    ), //i
    .RESET (oSER8_MEM_8_RESET), //i
    .Q0    (oSER8_MEM_8_Q0   ), //o
    .Q1    (oSER8_MEM_8_Q1   )  //o
  );
  IOBUF iOBUF_6 (
    .I   (iOBUF_6_I        ), //i
    .OEN (iOBUF_6_OEN      ), //i
    .O   (iOBUF_6_O        ), //o
    .IO  (io_pad_DDR3_DQ[3])  //~
  );
  IDES8_MEM iDES8_MEM_4 (
    .D     (iDES8_MEM_4_D    ), //i
    .ICLK  (clk_dqsr_0       ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .CALIB (1'b0             ), //i
    .RESET (iDES8_MEM_4_RESET), //i
    .WADDR (dqs_waddr_0[2:0] ), //i
    .RADDR (dqs_raddr_0[2:0] ), //i
    .Q0    (iDES8_MEM_4_Q0   ), //o
    .Q1    (iDES8_MEM_4_Q1   ), //o
    .Q2    (iDES8_MEM_4_Q2   ), //o
    .Q3    (iDES8_MEM_4_Q3   ), //o
    .Q4    (iDES8_MEM_4_Q4   ), //o
    .Q5    (iDES8_MEM_4_Q5   ), //o
    .Q6    (iDES8_MEM_4_Q6   ), //o
    .Q7    (iDES8_MEM_4_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_9 (
    .D0    (oSER8_MEM_9_D0   ), //i
    .D1    (oSER8_MEM_9_D1   ), //i
    .D2    (oSER8_MEM_9_D2   ), //i
    .D3    (oSER8_MEM_9_D3   ), //i
    .D4    (oSER8_MEM_9_D4   ), //i
    .D5    (oSER8_MEM_9_D5   ), //i
    .D6    (oSER8_MEM_9_D6   ), //i
    .D7    (oSER8_MEM_9_D7   ), //i
    .TX0   (oSER8_MEM_9_TX0  ), //i
    .TX1   (oSER8_MEM_9_TX1  ), //i
    .TX2   (oSER8_MEM_9_TX2  ), //i
    .TX3   (oSER8_MEM_9_TX3  ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .TCLK  (clk_dqsw270_0    ), //i
    .RESET (oSER8_MEM_9_RESET), //i
    .Q0    (oSER8_MEM_9_Q0   ), //o
    .Q1    (oSER8_MEM_9_Q1   )  //o
  );
  IOBUF iOBUF_7 (
    .I   (iOBUF_7_I        ), //i
    .OEN (iOBUF_7_OEN      ), //i
    .O   (iOBUF_7_O        ), //o
    .IO  (io_pad_DDR3_DQ[4])  //~
  );
  IDES8_MEM iDES8_MEM_5 (
    .D     (iDES8_MEM_5_D    ), //i
    .ICLK  (clk_dqsr_0       ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .CALIB (1'b0             ), //i
    .RESET (iDES8_MEM_5_RESET), //i
    .WADDR (dqs_waddr_0[2:0] ), //i
    .RADDR (dqs_raddr_0[2:0] ), //i
    .Q0    (iDES8_MEM_5_Q0   ), //o
    .Q1    (iDES8_MEM_5_Q1   ), //o
    .Q2    (iDES8_MEM_5_Q2   ), //o
    .Q3    (iDES8_MEM_5_Q3   ), //o
    .Q4    (iDES8_MEM_5_Q4   ), //o
    .Q5    (iDES8_MEM_5_Q5   ), //o
    .Q6    (iDES8_MEM_5_Q6   ), //o
    .Q7    (iDES8_MEM_5_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_10 (
    .D0    (oSER8_MEM_10_D0   ), //i
    .D1    (oSER8_MEM_10_D1   ), //i
    .D2    (oSER8_MEM_10_D2   ), //i
    .D3    (oSER8_MEM_10_D3   ), //i
    .D4    (oSER8_MEM_10_D4   ), //i
    .D5    (oSER8_MEM_10_D5   ), //i
    .D6    (oSER8_MEM_10_D6   ), //i
    .D7    (oSER8_MEM_10_D7   ), //i
    .TX0   (oSER8_MEM_10_TX0  ), //i
    .TX1   (oSER8_MEM_10_TX1  ), //i
    .TX2   (oSER8_MEM_10_TX2  ), //i
    .TX3   (oSER8_MEM_10_TX3  ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .TCLK  (clk_dqsw270_0     ), //i
    .RESET (oSER8_MEM_10_RESET), //i
    .Q0    (oSER8_MEM_10_Q0   ), //o
    .Q1    (oSER8_MEM_10_Q1   )  //o
  );
  IOBUF iOBUF_8 (
    .I   (iOBUF_8_I        ), //i
    .OEN (iOBUF_8_OEN      ), //i
    .O   (iOBUF_8_O        ), //o
    .IO  (io_pad_DDR3_DQ[5])  //~
  );
  IDES8_MEM iDES8_MEM_6 (
    .D     (iDES8_MEM_6_D    ), //i
    .ICLK  (clk_dqsr_0       ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .CALIB (1'b0             ), //i
    .RESET (iDES8_MEM_6_RESET), //i
    .WADDR (dqs_waddr_0[2:0] ), //i
    .RADDR (dqs_raddr_0[2:0] ), //i
    .Q0    (iDES8_MEM_6_Q0   ), //o
    .Q1    (iDES8_MEM_6_Q1   ), //o
    .Q2    (iDES8_MEM_6_Q2   ), //o
    .Q3    (iDES8_MEM_6_Q3   ), //o
    .Q4    (iDES8_MEM_6_Q4   ), //o
    .Q5    (iDES8_MEM_6_Q5   ), //o
    .Q6    (iDES8_MEM_6_Q6   ), //o
    .Q7    (iDES8_MEM_6_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_11 (
    .D0    (oSER8_MEM_11_D0   ), //i
    .D1    (oSER8_MEM_11_D1   ), //i
    .D2    (oSER8_MEM_11_D2   ), //i
    .D3    (oSER8_MEM_11_D3   ), //i
    .D4    (oSER8_MEM_11_D4   ), //i
    .D5    (oSER8_MEM_11_D5   ), //i
    .D6    (oSER8_MEM_11_D6   ), //i
    .D7    (oSER8_MEM_11_D7   ), //i
    .TX0   (oSER8_MEM_11_TX0  ), //i
    .TX1   (oSER8_MEM_11_TX1  ), //i
    .TX2   (oSER8_MEM_11_TX2  ), //i
    .TX3   (oSER8_MEM_11_TX3  ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .TCLK  (clk_dqsw270_0     ), //i
    .RESET (oSER8_MEM_11_RESET), //i
    .Q0    (oSER8_MEM_11_Q0   ), //o
    .Q1    (oSER8_MEM_11_Q1   )  //o
  );
  IOBUF iOBUF_9 (
    .I   (iOBUF_9_I        ), //i
    .OEN (iOBUF_9_OEN      ), //i
    .O   (iOBUF_9_O        ), //o
    .IO  (io_pad_DDR3_DQ[6])  //~
  );
  IDES8_MEM iDES8_MEM_7 (
    .D     (iDES8_MEM_7_D    ), //i
    .ICLK  (clk_dqsr_0       ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .CALIB (1'b0             ), //i
    .RESET (iDES8_MEM_7_RESET), //i
    .WADDR (dqs_waddr_0[2:0] ), //i
    .RADDR (dqs_raddr_0[2:0] ), //i
    .Q0    (iDES8_MEM_7_Q0   ), //o
    .Q1    (iDES8_MEM_7_Q1   ), //o
    .Q2    (iDES8_MEM_7_Q2   ), //o
    .Q3    (iDES8_MEM_7_Q3   ), //o
    .Q4    (iDES8_MEM_7_Q4   ), //o
    .Q5    (iDES8_MEM_7_Q5   ), //o
    .Q6    (iDES8_MEM_7_Q6   ), //o
    .Q7    (iDES8_MEM_7_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_12 (
    .D0    (oSER8_MEM_12_D0   ), //i
    .D1    (oSER8_MEM_12_D1   ), //i
    .D2    (oSER8_MEM_12_D2   ), //i
    .D3    (oSER8_MEM_12_D3   ), //i
    .D4    (oSER8_MEM_12_D4   ), //i
    .D5    (oSER8_MEM_12_D5   ), //i
    .D6    (oSER8_MEM_12_D6   ), //i
    .D7    (oSER8_MEM_12_D7   ), //i
    .TX0   (oSER8_MEM_12_TX0  ), //i
    .TX1   (oSER8_MEM_12_TX1  ), //i
    .TX2   (oSER8_MEM_12_TX2  ), //i
    .TX3   (oSER8_MEM_12_TX3  ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .TCLK  (clk_dqsw270_0     ), //i
    .RESET (oSER8_MEM_12_RESET), //i
    .Q0    (oSER8_MEM_12_Q0   ), //o
    .Q1    (oSER8_MEM_12_Q1   )  //o
  );
  IOBUF iOBUF_10 (
    .I   (iOBUF_10_I       ), //i
    .OEN (iOBUF_10_OEN     ), //i
    .O   (iOBUF_10_O       ), //o
    .IO  (io_pad_DDR3_DQ[7])  //~
  );
  IDES8_MEM iDES8_MEM_8 (
    .D     (iDES8_MEM_8_D    ), //i
    .ICLK  (clk_dqsr_0       ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .CALIB (1'b0             ), //i
    .RESET (iDES8_MEM_8_RESET), //i
    .WADDR (dqs_waddr_0[2:0] ), //i
    .RADDR (dqs_raddr_0[2:0] ), //i
    .Q0    (iDES8_MEM_8_Q0   ), //o
    .Q1    (iDES8_MEM_8_Q1   ), //o
    .Q2    (iDES8_MEM_8_Q2   ), //o
    .Q3    (iDES8_MEM_8_Q3   ), //o
    .Q4    (iDES8_MEM_8_Q4   ), //o
    .Q5    (iDES8_MEM_8_Q5   ), //o
    .Q6    (iDES8_MEM_8_Q6   ), //o
    .Q7    (iDES8_MEM_8_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_13 (
    .D0    (oSER8_MEM_13_D0   ), //i
    .D1    (oSER8_MEM_13_D1   ), //i
    .D2    (oSER8_MEM_13_D2   ), //i
    .D3    (oSER8_MEM_13_D3   ), //i
    .D4    (oSER8_MEM_13_D4   ), //i
    .D5    (oSER8_MEM_13_D5   ), //i
    .D6    (oSER8_MEM_13_D6   ), //i
    .D7    (oSER8_MEM_13_D7   ), //i
    .TX0   (oSER8_MEM_13_TX0  ), //i
    .TX1   (oSER8_MEM_13_TX1  ), //i
    .TX2   (oSER8_MEM_13_TX2  ), //i
    .TX3   (oSER8_MEM_13_TX3  ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .TCLK  (clk_dqsw270_1     ), //i
    .RESET (oSER8_MEM_13_RESET), //i
    .Q0    (oSER8_MEM_13_Q0   ), //o
    .Q1    (oSER8_MEM_13_Q1   )  //o
  );
  IOBUF iOBUF_11 (
    .I   (iOBUF_11_I       ), //i
    .OEN (iOBUF_11_OEN     ), //i
    .O   (iOBUF_11_O       ), //o
    .IO  (io_pad_DDR3_DQ[8])  //~
  );
  IDES8_MEM iDES8_MEM_9 (
    .D     (iDES8_MEM_9_D    ), //i
    .ICLK  (clk_dqsr_1       ), //i
    .FCLK  (io_fclk          ), //i
    .PCLK  (io_pclk          ), //i
    .CALIB (1'b0             ), //i
    .RESET (iDES8_MEM_9_RESET), //i
    .WADDR (dqs_waddr_1[2:0] ), //i
    .RADDR (dqs_raddr_1[2:0] ), //i
    .Q0    (iDES8_MEM_9_Q0   ), //o
    .Q1    (iDES8_MEM_9_Q1   ), //o
    .Q2    (iDES8_MEM_9_Q2   ), //o
    .Q3    (iDES8_MEM_9_Q3   ), //o
    .Q4    (iDES8_MEM_9_Q4   ), //o
    .Q5    (iDES8_MEM_9_Q5   ), //o
    .Q6    (iDES8_MEM_9_Q6   ), //o
    .Q7    (iDES8_MEM_9_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_14 (
    .D0    (oSER8_MEM_14_D0   ), //i
    .D1    (oSER8_MEM_14_D1   ), //i
    .D2    (oSER8_MEM_14_D2   ), //i
    .D3    (oSER8_MEM_14_D3   ), //i
    .D4    (oSER8_MEM_14_D4   ), //i
    .D5    (oSER8_MEM_14_D5   ), //i
    .D6    (oSER8_MEM_14_D6   ), //i
    .D7    (oSER8_MEM_14_D7   ), //i
    .TX0   (oSER8_MEM_14_TX0  ), //i
    .TX1   (oSER8_MEM_14_TX1  ), //i
    .TX2   (oSER8_MEM_14_TX2  ), //i
    .TX3   (oSER8_MEM_14_TX3  ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .TCLK  (clk_dqsw270_1     ), //i
    .RESET (oSER8_MEM_14_RESET), //i
    .Q0    (oSER8_MEM_14_Q0   ), //o
    .Q1    (oSER8_MEM_14_Q1   )  //o
  );
  IOBUF iOBUF_12 (
    .I   (iOBUF_12_I       ), //i
    .OEN (iOBUF_12_OEN     ), //i
    .O   (iOBUF_12_O       ), //o
    .IO  (io_pad_DDR3_DQ[9])  //~
  );
  IDES8_MEM iDES8_MEM_10 (
    .D     (iDES8_MEM_10_D    ), //i
    .ICLK  (clk_dqsr_1        ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .CALIB (1'b0              ), //i
    .RESET (iDES8_MEM_10_RESET), //i
    .WADDR (dqs_waddr_1[2:0]  ), //i
    .RADDR (dqs_raddr_1[2:0]  ), //i
    .Q0    (iDES8_MEM_10_Q0   ), //o
    .Q1    (iDES8_MEM_10_Q1   ), //o
    .Q2    (iDES8_MEM_10_Q2   ), //o
    .Q3    (iDES8_MEM_10_Q3   ), //o
    .Q4    (iDES8_MEM_10_Q4   ), //o
    .Q5    (iDES8_MEM_10_Q5   ), //o
    .Q6    (iDES8_MEM_10_Q6   ), //o
    .Q7    (iDES8_MEM_10_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_15 (
    .D0    (oSER8_MEM_15_D0   ), //i
    .D1    (oSER8_MEM_15_D1   ), //i
    .D2    (oSER8_MEM_15_D2   ), //i
    .D3    (oSER8_MEM_15_D3   ), //i
    .D4    (oSER8_MEM_15_D4   ), //i
    .D5    (oSER8_MEM_15_D5   ), //i
    .D6    (oSER8_MEM_15_D6   ), //i
    .D7    (oSER8_MEM_15_D7   ), //i
    .TX0   (oSER8_MEM_15_TX0  ), //i
    .TX1   (oSER8_MEM_15_TX1  ), //i
    .TX2   (oSER8_MEM_15_TX2  ), //i
    .TX3   (oSER8_MEM_15_TX3  ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .TCLK  (clk_dqsw270_1     ), //i
    .RESET (oSER8_MEM_15_RESET), //i
    .Q0    (oSER8_MEM_15_Q0   ), //o
    .Q1    (oSER8_MEM_15_Q1   )  //o
  );
  IOBUF iOBUF_13 (
    .I   (iOBUF_13_I        ), //i
    .OEN (iOBUF_13_OEN      ), //i
    .O   (iOBUF_13_O        ), //o
    .IO  (io_pad_DDR3_DQ[10])  //~
  );
  IDES8_MEM iDES8_MEM_11 (
    .D     (iDES8_MEM_11_D    ), //i
    .ICLK  (clk_dqsr_1        ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .CALIB (1'b0              ), //i
    .RESET (iDES8_MEM_11_RESET), //i
    .WADDR (dqs_waddr_1[2:0]  ), //i
    .RADDR (dqs_raddr_1[2:0]  ), //i
    .Q0    (iDES8_MEM_11_Q0   ), //o
    .Q1    (iDES8_MEM_11_Q1   ), //o
    .Q2    (iDES8_MEM_11_Q2   ), //o
    .Q3    (iDES8_MEM_11_Q3   ), //o
    .Q4    (iDES8_MEM_11_Q4   ), //o
    .Q5    (iDES8_MEM_11_Q5   ), //o
    .Q6    (iDES8_MEM_11_Q6   ), //o
    .Q7    (iDES8_MEM_11_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_16 (
    .D0    (oSER8_MEM_16_D0   ), //i
    .D1    (oSER8_MEM_16_D1   ), //i
    .D2    (oSER8_MEM_16_D2   ), //i
    .D3    (oSER8_MEM_16_D3   ), //i
    .D4    (oSER8_MEM_16_D4   ), //i
    .D5    (oSER8_MEM_16_D5   ), //i
    .D6    (oSER8_MEM_16_D6   ), //i
    .D7    (oSER8_MEM_16_D7   ), //i
    .TX0   (oSER8_MEM_16_TX0  ), //i
    .TX1   (oSER8_MEM_16_TX1  ), //i
    .TX2   (oSER8_MEM_16_TX2  ), //i
    .TX3   (oSER8_MEM_16_TX3  ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .TCLK  (clk_dqsw270_1     ), //i
    .RESET (oSER8_MEM_16_RESET), //i
    .Q0    (oSER8_MEM_16_Q0   ), //o
    .Q1    (oSER8_MEM_16_Q1   )  //o
  );
  IOBUF iOBUF_14 (
    .I   (iOBUF_14_I        ), //i
    .OEN (iOBUF_14_OEN      ), //i
    .O   (iOBUF_14_O        ), //o
    .IO  (io_pad_DDR3_DQ[11])  //~
  );
  IDES8_MEM iDES8_MEM_12 (
    .D     (iDES8_MEM_12_D    ), //i
    .ICLK  (clk_dqsr_1        ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .CALIB (1'b0              ), //i
    .RESET (iDES8_MEM_12_RESET), //i
    .WADDR (dqs_waddr_1[2:0]  ), //i
    .RADDR (dqs_raddr_1[2:0]  ), //i
    .Q0    (iDES8_MEM_12_Q0   ), //o
    .Q1    (iDES8_MEM_12_Q1   ), //o
    .Q2    (iDES8_MEM_12_Q2   ), //o
    .Q3    (iDES8_MEM_12_Q3   ), //o
    .Q4    (iDES8_MEM_12_Q4   ), //o
    .Q5    (iDES8_MEM_12_Q5   ), //o
    .Q6    (iDES8_MEM_12_Q6   ), //o
    .Q7    (iDES8_MEM_12_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_17 (
    .D0    (oSER8_MEM_17_D0   ), //i
    .D1    (oSER8_MEM_17_D1   ), //i
    .D2    (oSER8_MEM_17_D2   ), //i
    .D3    (oSER8_MEM_17_D3   ), //i
    .D4    (oSER8_MEM_17_D4   ), //i
    .D5    (oSER8_MEM_17_D5   ), //i
    .D6    (oSER8_MEM_17_D6   ), //i
    .D7    (oSER8_MEM_17_D7   ), //i
    .TX0   (oSER8_MEM_17_TX0  ), //i
    .TX1   (oSER8_MEM_17_TX1  ), //i
    .TX2   (oSER8_MEM_17_TX2  ), //i
    .TX3   (oSER8_MEM_17_TX3  ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .TCLK  (clk_dqsw270_1     ), //i
    .RESET (oSER8_MEM_17_RESET), //i
    .Q0    (oSER8_MEM_17_Q0   ), //o
    .Q1    (oSER8_MEM_17_Q1   )  //o
  );
  IOBUF iOBUF_15 (
    .I   (iOBUF_15_I        ), //i
    .OEN (iOBUF_15_OEN      ), //i
    .O   (iOBUF_15_O        ), //o
    .IO  (io_pad_DDR3_DQ[12])  //~
  );
  IDES8_MEM iDES8_MEM_13 (
    .D     (iDES8_MEM_13_D    ), //i
    .ICLK  (clk_dqsr_1        ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .CALIB (1'b0              ), //i
    .RESET (iDES8_MEM_13_RESET), //i
    .WADDR (dqs_waddr_1[2:0]  ), //i
    .RADDR (dqs_raddr_1[2:0]  ), //i
    .Q0    (iDES8_MEM_13_Q0   ), //o
    .Q1    (iDES8_MEM_13_Q1   ), //o
    .Q2    (iDES8_MEM_13_Q2   ), //o
    .Q3    (iDES8_MEM_13_Q3   ), //o
    .Q4    (iDES8_MEM_13_Q4   ), //o
    .Q5    (iDES8_MEM_13_Q5   ), //o
    .Q6    (iDES8_MEM_13_Q6   ), //o
    .Q7    (iDES8_MEM_13_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_18 (
    .D0    (oSER8_MEM_18_D0   ), //i
    .D1    (oSER8_MEM_18_D1   ), //i
    .D2    (oSER8_MEM_18_D2   ), //i
    .D3    (oSER8_MEM_18_D3   ), //i
    .D4    (oSER8_MEM_18_D4   ), //i
    .D5    (oSER8_MEM_18_D5   ), //i
    .D6    (oSER8_MEM_18_D6   ), //i
    .D7    (oSER8_MEM_18_D7   ), //i
    .TX0   (oSER8_MEM_18_TX0  ), //i
    .TX1   (oSER8_MEM_18_TX1  ), //i
    .TX2   (oSER8_MEM_18_TX2  ), //i
    .TX3   (oSER8_MEM_18_TX3  ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .TCLK  (clk_dqsw270_1     ), //i
    .RESET (oSER8_MEM_18_RESET), //i
    .Q0    (oSER8_MEM_18_Q0   ), //o
    .Q1    (oSER8_MEM_18_Q1   )  //o
  );
  IOBUF iOBUF_16 (
    .I   (iOBUF_16_I        ), //i
    .OEN (iOBUF_16_OEN      ), //i
    .O   (iOBUF_16_O        ), //o
    .IO  (io_pad_DDR3_DQ[13])  //~
  );
  IDES8_MEM iDES8_MEM_14 (
    .D     (iDES8_MEM_14_D    ), //i
    .ICLK  (clk_dqsr_1        ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .CALIB (1'b0              ), //i
    .RESET (iDES8_MEM_14_RESET), //i
    .WADDR (dqs_waddr_1[2:0]  ), //i
    .RADDR (dqs_raddr_1[2:0]  ), //i
    .Q0    (iDES8_MEM_14_Q0   ), //o
    .Q1    (iDES8_MEM_14_Q1   ), //o
    .Q2    (iDES8_MEM_14_Q2   ), //o
    .Q3    (iDES8_MEM_14_Q3   ), //o
    .Q4    (iDES8_MEM_14_Q4   ), //o
    .Q5    (iDES8_MEM_14_Q5   ), //o
    .Q6    (iDES8_MEM_14_Q6   ), //o
    .Q7    (iDES8_MEM_14_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_19 (
    .D0    (oSER8_MEM_19_D0   ), //i
    .D1    (oSER8_MEM_19_D1   ), //i
    .D2    (oSER8_MEM_19_D2   ), //i
    .D3    (oSER8_MEM_19_D3   ), //i
    .D4    (oSER8_MEM_19_D4   ), //i
    .D5    (oSER8_MEM_19_D5   ), //i
    .D6    (oSER8_MEM_19_D6   ), //i
    .D7    (oSER8_MEM_19_D7   ), //i
    .TX0   (oSER8_MEM_19_TX0  ), //i
    .TX1   (oSER8_MEM_19_TX1  ), //i
    .TX2   (oSER8_MEM_19_TX2  ), //i
    .TX3   (oSER8_MEM_19_TX3  ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .TCLK  (clk_dqsw270_1     ), //i
    .RESET (oSER8_MEM_19_RESET), //i
    .Q0    (oSER8_MEM_19_Q0   ), //o
    .Q1    (oSER8_MEM_19_Q1   )  //o
  );
  IOBUF iOBUF_17 (
    .I   (iOBUF_17_I        ), //i
    .OEN (iOBUF_17_OEN      ), //i
    .O   (iOBUF_17_O        ), //o
    .IO  (io_pad_DDR3_DQ[14])  //~
  );
  IDES8_MEM iDES8_MEM_15 (
    .D     (iDES8_MEM_15_D    ), //i
    .ICLK  (clk_dqsr_1        ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .CALIB (1'b0              ), //i
    .RESET (iDES8_MEM_15_RESET), //i
    .WADDR (dqs_waddr_1[2:0]  ), //i
    .RADDR (dqs_raddr_1[2:0]  ), //i
    .Q0    (iDES8_MEM_15_Q0   ), //o
    .Q1    (iDES8_MEM_15_Q1   ), //o
    .Q2    (iDES8_MEM_15_Q2   ), //o
    .Q3    (iDES8_MEM_15_Q3   ), //o
    .Q4    (iDES8_MEM_15_Q4   ), //o
    .Q5    (iDES8_MEM_15_Q5   ), //o
    .Q6    (iDES8_MEM_15_Q6   ), //o
    .Q7    (iDES8_MEM_15_Q7   )  //o
  );
  OSER8_MEM #(
    .TCLK_SOURCE ("DQSW270")
  ) oSER8_MEM_20 (
    .D0    (oSER8_MEM_20_D0   ), //i
    .D1    (oSER8_MEM_20_D1   ), //i
    .D2    (oSER8_MEM_20_D2   ), //i
    .D3    (oSER8_MEM_20_D3   ), //i
    .D4    (oSER8_MEM_20_D4   ), //i
    .D5    (oSER8_MEM_20_D5   ), //i
    .D6    (oSER8_MEM_20_D6   ), //i
    .D7    (oSER8_MEM_20_D7   ), //i
    .TX0   (oSER8_MEM_20_TX0  ), //i
    .TX1   (oSER8_MEM_20_TX1  ), //i
    .TX2   (oSER8_MEM_20_TX2  ), //i
    .TX3   (oSER8_MEM_20_TX3  ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .TCLK  (clk_dqsw270_1     ), //i
    .RESET (oSER8_MEM_20_RESET), //i
    .Q0    (oSER8_MEM_20_Q0   ), //o
    .Q1    (oSER8_MEM_20_Q1   )  //o
  );
  IOBUF iOBUF_18 (
    .I   (iOBUF_18_I        ), //i
    .OEN (iOBUF_18_OEN      ), //i
    .O   (iOBUF_18_O        ), //o
    .IO  (io_pad_DDR3_DQ[15])  //~
  );
  IDES8_MEM iDES8_MEM_16 (
    .D     (iDES8_MEM_16_D    ), //i
    .ICLK  (clk_dqsr_1        ), //i
    .FCLK  (io_fclk           ), //i
    .PCLK  (io_pclk           ), //i
    .CALIB (1'b0              ), //i
    .RESET (iDES8_MEM_16_RESET), //i
    .WADDR (dqs_waddr_1[2:0]  ), //i
    .RADDR (dqs_raddr_1[2:0]  ), //i
    .Q0    (iDES8_MEM_16_Q0   ), //o
    .Q1    (iDES8_MEM_16_Q1   ), //o
    .Q2    (iDES8_MEM_16_Q2   ), //o
    .Q3    (iDES8_MEM_16_Q3   ), //o
    .Q4    (iDES8_MEM_16_Q4   ), //o
    .Q5    (iDES8_MEM_16_Q5   ), //o
    .Q6    (iDES8_MEM_16_Q6   ), //o
    .Q7    (iDES8_MEM_16_Q7   )  //o
  );
  OSER8 oSER8_1 (
    .D0    (io_nRAS_0    ), //i
    .D1    (io_nRAS_0    ), //i
    .D2    (io_nRAS_1    ), //i
    .D3    (io_nRAS_1    ), //i
    .D4    (io_nRAS_2    ), //i
    .D5    (io_nRAS_2    ), //i
    .D6    (io_nRAS_3    ), //i
    .D7    (io_nRAS_3    ), //i
    .TX0   (1'b0         ), //i
    .TX1   (1'b0         ), //i
    .TX2   (1'b0         ), //i
    .TX3   (1'b0         ), //i
    .FCLK  (io_fclk      ), //i
    .PCLK  (io_pclk      ), //i
    .RESET (oSER8_1_RESET), //i
    .Q0    (oSER8_1_Q0   ), //o
    .Q1    (oSER8_1_Q1   )  //o
  );
  OSER8 oSER8_2 (
    .D0    (io_nCAS_0    ), //i
    .D1    (io_nCAS_0    ), //i
    .D2    (io_nCAS_1    ), //i
    .D3    (io_nCAS_1    ), //i
    .D4    (io_nCAS_2    ), //i
    .D5    (io_nCAS_2    ), //i
    .D6    (io_nCAS_3    ), //i
    .D7    (io_nCAS_3    ), //i
    .TX0   (1'b0         ), //i
    .TX1   (1'b0         ), //i
    .TX2   (1'b0         ), //i
    .TX3   (1'b0         ), //i
    .FCLK  (io_fclk      ), //i
    .PCLK  (io_pclk      ), //i
    .RESET (oSER8_2_RESET), //i
    .Q0    (oSER8_2_Q0   ), //o
    .Q1    (oSER8_2_Q1   )  //o
  );
  OSER8 oSER8_3 (
    .D0    (io_nWE_0     ), //i
    .D1    (io_nWE_0     ), //i
    .D2    (io_nWE_1     ), //i
    .D3    (io_nWE_1     ), //i
    .D4    (io_nWE_2     ), //i
    .D5    (io_nWE_2     ), //i
    .D6    (io_nWE_3     ), //i
    .D7    (io_nWE_3     ), //i
    .TX0   (1'b0         ), //i
    .TX1   (1'b0         ), //i
    .TX2   (1'b0         ), //i
    .TX3   (1'b0         ), //i
    .FCLK  (io_fclk      ), //i
    .PCLK  (io_pclk      ), //i
    .RESET (oSER8_3_RESET), //i
    .Q0    (oSER8_3_Q0   ), //o
    .Q1    (oSER8_3_Q1   )  //o
  );
  OSER8 oSER8_4 (
    .D0    (oSER8_4_D0   ), //i
    .D1    (oSER8_4_D1   ), //i
    .D2    (oSER8_4_D2   ), //i
    .D3    (oSER8_4_D3   ), //i
    .D4    (oSER8_4_D4   ), //i
    .D5    (oSER8_4_D5   ), //i
    .D6    (oSER8_4_D6   ), //i
    .D7    (oSER8_4_D7   ), //i
    .TX0   (1'b0         ), //i
    .TX1   (1'b0         ), //i
    .TX2   (1'b0         ), //i
    .TX3   (1'b0         ), //i
    .FCLK  (io_fclk      ), //i
    .PCLK  (io_pclk      ), //i
    .RESET (oSER8_4_RESET), //i
    .Q0    (oSER8_4_Q0   ), //o
    .Q1    (oSER8_4_Q1   )  //o
  );
  OSER8 oSER8_5 (
    .D0    (oSER8_5_D0   ), //i
    .D1    (oSER8_5_D1   ), //i
    .D2    (oSER8_5_D2   ), //i
    .D3    (oSER8_5_D3   ), //i
    .D4    (oSER8_5_D4   ), //i
    .D5    (oSER8_5_D5   ), //i
    .D6    (oSER8_5_D6   ), //i
    .D7    (oSER8_5_D7   ), //i
    .TX0   (1'b0         ), //i
    .TX1   (1'b0         ), //i
    .TX2   (1'b0         ), //i
    .TX3   (1'b0         ), //i
    .FCLK  (io_fclk      ), //i
    .PCLK  (io_pclk      ), //i
    .RESET (oSER8_5_RESET), //i
    .Q0    (oSER8_5_Q0   ), //o
    .Q1    (oSER8_5_Q1   )  //o
  );
  OSER8 oSER8_6 (
    .D0    (oSER8_6_D0   ), //i
    .D1    (oSER8_6_D1   ), //i
    .D2    (oSER8_6_D2   ), //i
    .D3    (oSER8_6_D3   ), //i
    .D4    (oSER8_6_D4   ), //i
    .D5    (oSER8_6_D5   ), //i
    .D6    (oSER8_6_D6   ), //i
    .D7    (oSER8_6_D7   ), //i
    .TX0   (1'b0         ), //i
    .TX1   (1'b0         ), //i
    .TX2   (1'b0         ), //i
    .TX3   (1'b0         ), //i
    .FCLK  (io_fclk      ), //i
    .PCLK  (io_pclk      ), //i
    .RESET (oSER8_6_RESET), //i
    .Q0    (oSER8_6_Q0   ), //o
    .Q1    (oSER8_6_Q1   )  //o
  );
  OSER8 oSER8_7 (
    .D0    (oSER8_7_D0   ), //i
    .D1    (oSER8_7_D1   ), //i
    .D2    (oSER8_7_D2   ), //i
    .D3    (oSER8_7_D3   ), //i
    .D4    (oSER8_7_D4   ), //i
    .D5    (oSER8_7_D5   ), //i
    .D6    (oSER8_7_D6   ), //i
    .D7    (oSER8_7_D7   ), //i
    .TX0   (1'b0         ), //i
    .TX1   (1'b0         ), //i
    .TX2   (1'b0         ), //i
    .TX3   (1'b0         ), //i
    .FCLK  (io_fclk      ), //i
    .PCLK  (io_pclk      ), //i
    .RESET (oSER8_7_RESET), //i
    .Q0    (oSER8_7_Q0   ), //o
    .Q1    (oSER8_7_Q1   )  //o
  );
  OSER8 oSER8_8 (
    .D0    (oSER8_8_D0   ), //i
    .D1    (oSER8_8_D1   ), //i
    .D2    (oSER8_8_D2   ), //i
    .D3    (oSER8_8_D3   ), //i
    .D4    (oSER8_8_D4   ), //i
    .D5    (oSER8_8_D5   ), //i
    .D6    (oSER8_8_D6   ), //i
    .D7    (oSER8_8_D7   ), //i
    .TX0   (1'b0         ), //i
    .TX1   (1'b0         ), //i
    .TX2   (1'b0         ), //i
    .TX3   (1'b0         ), //i
    .FCLK  (io_fclk      ), //i
    .PCLK  (io_pclk      ), //i
    .RESET (oSER8_8_RESET), //i
    .Q0    (oSER8_8_Q0   ), //o
    .Q1    (oSER8_8_Q1   )  //o
  );
  OSER8 oSER8_9 (
    .D0    (oSER8_9_D0   ), //i
    .D1    (oSER8_9_D1   ), //i
    .D2    (oSER8_9_D2   ), //i
    .D3    (oSER8_9_D3   ), //i
    .D4    (oSER8_9_D4   ), //i
    .D5    (oSER8_9_D5   ), //i
    .D6    (oSER8_9_D6   ), //i
    .D7    (oSER8_9_D7   ), //i
    .TX0   (1'b0         ), //i
    .TX1   (1'b0         ), //i
    .TX2   (1'b0         ), //i
    .TX3   (1'b0         ), //i
    .FCLK  (io_fclk      ), //i
    .PCLK  (io_pclk      ), //i
    .RESET (oSER8_9_RESET), //i
    .Q0    (oSER8_9_Q0   ), //o
    .Q1    (oSER8_9_Q1   )  //o
  );
  OSER8 oSER8_10 (
    .D0    (oSER8_10_D0   ), //i
    .D1    (oSER8_10_D1   ), //i
    .D2    (oSER8_10_D2   ), //i
    .D3    (oSER8_10_D3   ), //i
    .D4    (oSER8_10_D4   ), //i
    .D5    (oSER8_10_D5   ), //i
    .D6    (oSER8_10_D6   ), //i
    .D7    (oSER8_10_D7   ), //i
    .TX0   (1'b0          ), //i
    .TX1   (1'b0          ), //i
    .TX2   (1'b0          ), //i
    .TX3   (1'b0          ), //i
    .FCLK  (io_fclk       ), //i
    .PCLK  (io_pclk       ), //i
    .RESET (oSER8_10_RESET), //i
    .Q0    (oSER8_10_Q0   ), //o
    .Q1    (oSER8_10_Q1   )  //o
  );
  OSER8 oSER8_11 (
    .D0    (oSER8_11_D0   ), //i
    .D1    (oSER8_11_D1   ), //i
    .D2    (oSER8_11_D2   ), //i
    .D3    (oSER8_11_D3   ), //i
    .D4    (oSER8_11_D4   ), //i
    .D5    (oSER8_11_D5   ), //i
    .D6    (oSER8_11_D6   ), //i
    .D7    (oSER8_11_D7   ), //i
    .TX0   (1'b0          ), //i
    .TX1   (1'b0          ), //i
    .TX2   (1'b0          ), //i
    .TX3   (1'b0          ), //i
    .FCLK  (io_fclk       ), //i
    .PCLK  (io_pclk       ), //i
    .RESET (oSER8_11_RESET), //i
    .Q0    (oSER8_11_Q0   ), //o
    .Q1    (oSER8_11_Q1   )  //o
  );
  OSER8 oSER8_12 (
    .D0    (oSER8_12_D0   ), //i
    .D1    (oSER8_12_D1   ), //i
    .D2    (oSER8_12_D2   ), //i
    .D3    (oSER8_12_D3   ), //i
    .D4    (oSER8_12_D4   ), //i
    .D5    (oSER8_12_D5   ), //i
    .D6    (oSER8_12_D6   ), //i
    .D7    (oSER8_12_D7   ), //i
    .TX0   (1'b0          ), //i
    .TX1   (1'b0          ), //i
    .TX2   (1'b0          ), //i
    .TX3   (1'b0          ), //i
    .FCLK  (io_fclk       ), //i
    .PCLK  (io_pclk       ), //i
    .RESET (oSER8_12_RESET), //i
    .Q0    (oSER8_12_Q0   ), //o
    .Q1    (oSER8_12_Q1   )  //o
  );
  OSER8 oSER8_13 (
    .D0    (oSER8_13_D0   ), //i
    .D1    (oSER8_13_D1   ), //i
    .D2    (oSER8_13_D2   ), //i
    .D3    (oSER8_13_D3   ), //i
    .D4    (oSER8_13_D4   ), //i
    .D5    (oSER8_13_D5   ), //i
    .D6    (oSER8_13_D6   ), //i
    .D7    (oSER8_13_D7   ), //i
    .TX0   (1'b0          ), //i
    .TX1   (1'b0          ), //i
    .TX2   (1'b0          ), //i
    .TX3   (1'b0          ), //i
    .FCLK  (io_fclk       ), //i
    .PCLK  (io_pclk       ), //i
    .RESET (oSER8_13_RESET), //i
    .Q0    (oSER8_13_Q0   ), //o
    .Q1    (oSER8_13_Q1   )  //o
  );
  OSER8 oSER8_14 (
    .D0    (oSER8_14_D0   ), //i
    .D1    (oSER8_14_D1   ), //i
    .D2    (oSER8_14_D2   ), //i
    .D3    (oSER8_14_D3   ), //i
    .D4    (oSER8_14_D4   ), //i
    .D5    (oSER8_14_D5   ), //i
    .D6    (oSER8_14_D6   ), //i
    .D7    (oSER8_14_D7   ), //i
    .TX0   (1'b0          ), //i
    .TX1   (1'b0          ), //i
    .TX2   (1'b0          ), //i
    .TX3   (1'b0          ), //i
    .FCLK  (io_fclk       ), //i
    .PCLK  (io_pclk       ), //i
    .RESET (oSER8_14_RESET), //i
    .Q0    (oSER8_14_Q0   ), //o
    .Q1    (oSER8_14_Q1   )  //o
  );
  OSER8 oSER8_15 (
    .D0    (oSER8_15_D0   ), //i
    .D1    (oSER8_15_D1   ), //i
    .D2    (oSER8_15_D2   ), //i
    .D3    (oSER8_15_D3   ), //i
    .D4    (oSER8_15_D4   ), //i
    .D5    (oSER8_15_D5   ), //i
    .D6    (oSER8_15_D6   ), //i
    .D7    (oSER8_15_D7   ), //i
    .TX0   (1'b0          ), //i
    .TX1   (1'b0          ), //i
    .TX2   (1'b0          ), //i
    .TX3   (1'b0          ), //i
    .FCLK  (io_fclk       ), //i
    .PCLK  (io_pclk       ), //i
    .RESET (oSER8_15_RESET), //i
    .Q0    (oSER8_15_Q0   ), //o
    .Q1    (oSER8_15_Q1   )  //o
  );
  OSER8 oSER8_16 (
    .D0    (oSER8_16_D0   ), //i
    .D1    (oSER8_16_D1   ), //i
    .D2    (oSER8_16_D2   ), //i
    .D3    (oSER8_16_D3   ), //i
    .D4    (oSER8_16_D4   ), //i
    .D5    (oSER8_16_D5   ), //i
    .D6    (oSER8_16_D6   ), //i
    .D7    (oSER8_16_D7   ), //i
    .TX0   (1'b0          ), //i
    .TX1   (1'b0          ), //i
    .TX2   (1'b0          ), //i
    .TX3   (1'b0          ), //i
    .FCLK  (io_fclk       ), //i
    .PCLK  (io_pclk       ), //i
    .RESET (oSER8_16_RESET), //i
    .Q0    (oSER8_16_Q0   ), //o
    .Q1    (oSER8_16_Q1   )  //o
  );
  OSER8 oSER8_17 (
    .D0    (oSER8_17_D0   ), //i
    .D1    (oSER8_17_D1   ), //i
    .D2    (oSER8_17_D2   ), //i
    .D3    (oSER8_17_D3   ), //i
    .D4    (oSER8_17_D4   ), //i
    .D5    (oSER8_17_D5   ), //i
    .D6    (oSER8_17_D6   ), //i
    .D7    (oSER8_17_D7   ), //i
    .TX0   (1'b0          ), //i
    .TX1   (1'b0          ), //i
    .TX2   (1'b0          ), //i
    .TX3   (1'b0          ), //i
    .FCLK  (io_fclk       ), //i
    .PCLK  (io_pclk       ), //i
    .RESET (oSER8_17_RESET), //i
    .Q0    (oSER8_17_Q0   ), //o
    .Q1    (oSER8_17_Q1   )  //o
  );
  OSER8 oSER8_18 (
    .D0    (oSER8_18_D0   ), //i
    .D1    (oSER8_18_D1   ), //i
    .D2    (oSER8_18_D2   ), //i
    .D3    (oSER8_18_D3   ), //i
    .D4    (oSER8_18_D4   ), //i
    .D5    (oSER8_18_D5   ), //i
    .D6    (oSER8_18_D6   ), //i
    .D7    (oSER8_18_D7   ), //i
    .TX0   (1'b0          ), //i
    .TX1   (1'b0          ), //i
    .TX2   (1'b0          ), //i
    .TX3   (1'b0          ), //i
    .FCLK  (io_fclk       ), //i
    .PCLK  (io_pclk       ), //i
    .RESET (oSER8_18_RESET), //i
    .Q0    (oSER8_18_Q0   ), //o
    .Q1    (oSER8_18_Q1   )  //o
  );
  OSER8 oSER8_19 (
    .D0    (oSER8_19_D0   ), //i
    .D1    (oSER8_19_D1   ), //i
    .D2    (oSER8_19_D2   ), //i
    .D3    (oSER8_19_D3   ), //i
    .D4    (oSER8_19_D4   ), //i
    .D5    (oSER8_19_D5   ), //i
    .D6    (oSER8_19_D6   ), //i
    .D7    (oSER8_19_D7   ), //i
    .TX0   (1'b0          ), //i
    .TX1   (1'b0          ), //i
    .TX2   (1'b0          ), //i
    .TX3   (1'b0          ), //i
    .FCLK  (io_fclk       ), //i
    .PCLK  (io_pclk       ), //i
    .RESET (oSER8_19_RESET), //i
    .Q0    (oSER8_19_Q0   ), //o
    .Q1    (oSER8_19_Q1   )  //o
  );
  OSER8 oSER8_20 (
    .D0    (oSER8_20_D0   ), //i
    .D1    (oSER8_20_D1   ), //i
    .D2    (oSER8_20_D2   ), //i
    .D3    (oSER8_20_D3   ), //i
    .D4    (oSER8_20_D4   ), //i
    .D5    (oSER8_20_D5   ), //i
    .D6    (oSER8_20_D6   ), //i
    .D7    (oSER8_20_D7   ), //i
    .TX0   (1'b0          ), //i
    .TX1   (1'b0          ), //i
    .TX2   (1'b0          ), //i
    .TX3   (1'b0          ), //i
    .FCLK  (io_fclk       ), //i
    .PCLK  (io_pclk       ), //i
    .RESET (oSER8_20_RESET), //i
    .Q0    (oSER8_20_Q0   ), //o
    .Q1    (oSER8_20_Q1   )  //o
  );
  assign dll_1_RESET = (! io_resetn);
  assign io_dlllock = dll_1_LOCK;
  assign rst_lock_n = (io_resetn && dll_1_LOCK);
  assign io_rst_lock_n = rst_lock_n;
  assign io_pad_DDR3_nRESET = (rst_lock_n && io_resetn_delay);
  assign io_pad_DDR3_ODT = 1'b1;
  assign io_pad_DDR3_CK = io_ck;
  assign io_pad_DDR3_nCS = 1'b0;
  assign io_pad_DDR3_CKE = io_CKE;
  assign dQS_1_DQSIN = dqs_pad_in[0];
  assign dQS_1_RESET = (! rst_lock_n);
  assign clk_dqsr_0 = dQS_1_DQSR90;
  assign dqs_waddr_0 = dQS_1_WPOINT;
  assign dqs_raddr_0 = dQS_1_RPOINT;
  assign clk_dqsw_0 = dQS_1_DQSW0;
  assign clk_dqsw270_0 = dQS_1_DQSW270;
  always @(*) begin
    rburst[0] = dQS_1_RBURST;
    rburst[1] = dQS_2_RBURST;
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
  assign oSER8_MEM_1_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_2_RESET = (! rst_lock_n);
  always @(*) begin
    io_pad_DDR3_DM[0] = oSER8_MEM_2_Q0;
    io_pad_DDR3_DM[1] = oSER8_MEM_4_Q0;
  end

  assign dQS_2_DQSIN = dqs_pad_in[1];
  assign dQS_2_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_3_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_4_RESET = (! rst_lock_n);
  assign io_rburst = rburst;
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
  assign oSER8_MEM_5_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
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
  assign iDES8_MEM_1_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_6_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_4_I = dq_buf[1];
  assign iOBUF_4_OEN = dq_buf_oen[1];
  assign iDES8_MEM_2_D = dq_pad_in[1];
  assign iDES8_MEM_2_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_7_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_5_I = dq_buf[2];
  assign iOBUF_5_OEN = dq_buf_oen[2];
  assign iDES8_MEM_3_D = dq_pad_in[2];
  assign iDES8_MEM_3_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_8_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_6_I = dq_buf[3];
  assign iOBUF_6_OEN = dq_buf_oen[3];
  assign iDES8_MEM_4_D = dq_pad_in[3];
  assign iDES8_MEM_4_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_9_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_7_I = dq_buf[4];
  assign iOBUF_7_OEN = dq_buf_oen[4];
  assign iDES8_MEM_5_D = dq_pad_in[4];
  assign iDES8_MEM_5_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_10_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_8_I = dq_buf[5];
  assign iOBUF_8_OEN = dq_buf_oen[5];
  assign iDES8_MEM_6_D = dq_pad_in[5];
  assign iDES8_MEM_6_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_11_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_9_I = dq_buf[6];
  assign iOBUF_9_OEN = dq_buf_oen[6];
  assign iDES8_MEM_7_D = dq_pad_in[6];
  assign iDES8_MEM_7_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_12_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_10_I = dq_buf[7];
  assign iOBUF_10_OEN = dq_buf_oen[7];
  assign iDES8_MEM_8_D = dq_pad_in[7];
  assign iDES8_MEM_8_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_13_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_11_I = dq_buf[8];
  assign iOBUF_11_OEN = dq_buf_oen[8];
  assign iDES8_MEM_9_D = dq_pad_in[8];
  assign iDES8_MEM_9_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_14_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_12_I = dq_buf[9];
  assign iOBUF_12_OEN = dq_buf_oen[9];
  assign iDES8_MEM_10_D = dq_pad_in[9];
  assign iDES8_MEM_10_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_15_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_13_I = dq_buf[10];
  assign iOBUF_13_OEN = dq_buf_oen[10];
  assign iDES8_MEM_11_D = dq_pad_in[10];
  assign iDES8_MEM_11_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_16_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_14_I = dq_buf[11];
  assign iOBUF_14_OEN = dq_buf_oen[11];
  assign iDES8_MEM_12_D = dq_pad_in[11];
  assign iDES8_MEM_12_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_17_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_15_I = dq_buf[12];
  assign iOBUF_15_OEN = dq_buf_oen[12];
  assign iDES8_MEM_13_D = dq_pad_in[12];
  assign iDES8_MEM_13_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_18_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_16_I = dq_buf[13];
  assign iOBUF_16_OEN = dq_buf_oen[13];
  assign iDES8_MEM_14_D = dq_pad_in[13];
  assign iDES8_MEM_14_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_19_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_17_I = dq_buf[14];
  assign iOBUF_17_OEN = dq_buf_oen[14];
  assign iDES8_MEM_15_D = dq_pad_in[14];
  assign iDES8_MEM_15_RESET = (! rst_lock_n);
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
  assign oSER8_MEM_20_RESET = ((! rst_lock_n) || (! dll_1_LOCK));
  assign iOBUF_18_I = dq_buf[15];
  assign iOBUF_18_OEN = dq_buf_oen[15];
  assign iDES8_MEM_16_D = dq_pad_in[15];
  assign iDES8_MEM_16_RESET = (! rst_lock_n);
  assign io_dq_raw = dq_pad_in;
  assign oSER8_1_RESET = (! rst_lock_n);
  assign io_pad_DDR3_nRAS = oSER8_1_Q0;
  assign oSER8_2_RESET = (! rst_lock_n);
  assign io_pad_DDR3_nCAS = oSER8_2_Q0;
  assign oSER8_3_RESET = (! rst_lock_n);
  assign io_pad_DDR3_nWE = oSER8_3_Q0;
  assign oSER8_4_D0 = io_A_0[0];
  assign oSER8_4_D1 = io_A_0[0];
  assign oSER8_4_D2 = io_A_1[0];
  assign oSER8_4_D3 = io_A_1[0];
  assign oSER8_4_D4 = io_A_2[0];
  assign oSER8_4_D5 = io_A_2[0];
  assign oSER8_4_D6 = io_A_3[0];
  assign oSER8_4_D7 = io_A_3[0];
  assign oSER8_4_RESET = (! rst_lock_n);
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
  assign oSER8_5_RESET = (! rst_lock_n);
  assign oSER8_6_D0 = io_A_0[2];
  assign oSER8_6_D1 = io_A_0[2];
  assign oSER8_6_D2 = io_A_1[2];
  assign oSER8_6_D3 = io_A_1[2];
  assign oSER8_6_D4 = io_A_2[2];
  assign oSER8_6_D5 = io_A_2[2];
  assign oSER8_6_D6 = io_A_3[2];
  assign oSER8_6_D7 = io_A_3[2];
  assign oSER8_6_RESET = (! rst_lock_n);
  assign oSER8_7_D0 = io_A_0[3];
  assign oSER8_7_D1 = io_A_0[3];
  assign oSER8_7_D2 = io_A_1[3];
  assign oSER8_7_D3 = io_A_1[3];
  assign oSER8_7_D4 = io_A_2[3];
  assign oSER8_7_D5 = io_A_2[3];
  assign oSER8_7_D6 = io_A_3[3];
  assign oSER8_7_D7 = io_A_3[3];
  assign oSER8_7_RESET = (! rst_lock_n);
  assign oSER8_8_D0 = io_A_0[4];
  assign oSER8_8_D1 = io_A_0[4];
  assign oSER8_8_D2 = io_A_1[4];
  assign oSER8_8_D3 = io_A_1[4];
  assign oSER8_8_D4 = io_A_2[4];
  assign oSER8_8_D5 = io_A_2[4];
  assign oSER8_8_D6 = io_A_3[4];
  assign oSER8_8_D7 = io_A_3[4];
  assign oSER8_8_RESET = (! rst_lock_n);
  assign oSER8_9_D0 = io_A_0[5];
  assign oSER8_9_D1 = io_A_0[5];
  assign oSER8_9_D2 = io_A_1[5];
  assign oSER8_9_D3 = io_A_1[5];
  assign oSER8_9_D4 = io_A_2[5];
  assign oSER8_9_D5 = io_A_2[5];
  assign oSER8_9_D6 = io_A_3[5];
  assign oSER8_9_D7 = io_A_3[5];
  assign oSER8_9_RESET = (! rst_lock_n);
  assign oSER8_10_D0 = io_A_0[6];
  assign oSER8_10_D1 = io_A_0[6];
  assign oSER8_10_D2 = io_A_1[6];
  assign oSER8_10_D3 = io_A_1[6];
  assign oSER8_10_D4 = io_A_2[6];
  assign oSER8_10_D5 = io_A_2[6];
  assign oSER8_10_D6 = io_A_3[6];
  assign oSER8_10_D7 = io_A_3[6];
  assign oSER8_10_RESET = (! rst_lock_n);
  assign oSER8_11_D0 = io_A_0[7];
  assign oSER8_11_D1 = io_A_0[7];
  assign oSER8_11_D2 = io_A_1[7];
  assign oSER8_11_D3 = io_A_1[7];
  assign oSER8_11_D4 = io_A_2[7];
  assign oSER8_11_D5 = io_A_2[7];
  assign oSER8_11_D6 = io_A_3[7];
  assign oSER8_11_D7 = io_A_3[7];
  assign oSER8_11_RESET = (! rst_lock_n);
  assign oSER8_12_D0 = io_A_0[8];
  assign oSER8_12_D1 = io_A_0[8];
  assign oSER8_12_D2 = io_A_1[8];
  assign oSER8_12_D3 = io_A_1[8];
  assign oSER8_12_D4 = io_A_2[8];
  assign oSER8_12_D5 = io_A_2[8];
  assign oSER8_12_D6 = io_A_3[8];
  assign oSER8_12_D7 = io_A_3[8];
  assign oSER8_12_RESET = (! rst_lock_n);
  assign oSER8_13_D0 = io_A_0[9];
  assign oSER8_13_D1 = io_A_0[9];
  assign oSER8_13_D2 = io_A_1[9];
  assign oSER8_13_D3 = io_A_1[9];
  assign oSER8_13_D4 = io_A_2[9];
  assign oSER8_13_D5 = io_A_2[9];
  assign oSER8_13_D6 = io_A_3[9];
  assign oSER8_13_D7 = io_A_3[9];
  assign oSER8_13_RESET = (! rst_lock_n);
  assign oSER8_14_D0 = io_A_0[10];
  assign oSER8_14_D1 = io_A_0[10];
  assign oSER8_14_D2 = io_A_1[10];
  assign oSER8_14_D3 = io_A_1[10];
  assign oSER8_14_D4 = io_A_2[10];
  assign oSER8_14_D5 = io_A_2[10];
  assign oSER8_14_D6 = io_A_3[10];
  assign oSER8_14_D7 = io_A_3[10];
  assign oSER8_14_RESET = (! rst_lock_n);
  assign oSER8_15_D0 = io_A_0[11];
  assign oSER8_15_D1 = io_A_0[11];
  assign oSER8_15_D2 = io_A_1[11];
  assign oSER8_15_D3 = io_A_1[11];
  assign oSER8_15_D4 = io_A_2[11];
  assign oSER8_15_D5 = io_A_2[11];
  assign oSER8_15_D6 = io_A_3[11];
  assign oSER8_15_D7 = io_A_3[11];
  assign oSER8_15_RESET = (! rst_lock_n);
  assign oSER8_16_D0 = io_A_0[12];
  assign oSER8_16_D1 = io_A_0[12];
  assign oSER8_16_D2 = io_A_1[12];
  assign oSER8_16_D3 = io_A_1[12];
  assign oSER8_16_D4 = io_A_2[12];
  assign oSER8_16_D5 = io_A_2[12];
  assign oSER8_16_D6 = io_A_3[12];
  assign oSER8_16_D7 = io_A_3[12];
  assign oSER8_16_RESET = (! rst_lock_n);
  assign oSER8_17_D0 = io_A_0[13];
  assign oSER8_17_D1 = io_A_0[13];
  assign oSER8_17_D2 = io_A_1[13];
  assign oSER8_17_D3 = io_A_1[13];
  assign oSER8_17_D4 = io_A_2[13];
  assign oSER8_17_D5 = io_A_2[13];
  assign oSER8_17_D6 = io_A_3[13];
  assign oSER8_17_D7 = io_A_3[13];
  assign oSER8_17_RESET = (! rst_lock_n);
  assign oSER8_18_D0 = io_BA_0[0];
  assign oSER8_18_D1 = io_BA_0[0];
  assign oSER8_18_D2 = io_BA_1[0];
  assign oSER8_18_D3 = io_BA_1[0];
  assign oSER8_18_D4 = io_BA_2[0];
  assign oSER8_18_D5 = io_BA_2[0];
  assign oSER8_18_D6 = io_BA_3[0];
  assign oSER8_18_D7 = io_BA_3[0];
  assign oSER8_18_RESET = (! rst_lock_n);
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
  assign oSER8_19_RESET = (! rst_lock_n);
  assign oSER8_20_D0 = io_BA_0[2];
  assign oSER8_20_D1 = io_BA_0[2];
  assign oSER8_20_D2 = io_BA_1[2];
  assign oSER8_20_D3 = io_BA_1[2];
  assign oSER8_20_D4 = io_BA_2[2];
  assign oSER8_20_D5 = io_BA_2[2];
  assign oSER8_20_D6 = io_BA_3[2];
  assign oSER8_20_D7 = io_BA_3[2];
  assign oSER8_20_RESET = (! rst_lock_n);

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
  input  wire          io_phy_dlllock,
  input  wire          io_phy_rst_lock_n,
  input  wire [1:0]    io_phy_rburst,
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
  input  wire          _zz_when_Ddr3ControllerCore_l714,
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
  localparam Ddr3State_REFRESH = 4'd9;

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
  wire       [4:0]    _zz_rdCyc;
  wire       [4:0]    _zz_rdCyc_1;
  wire       [1:0]    _zz_rdCyc_2;
  wire       [4:0]    _zz_when_Ddr3ControllerCore_l281;
  wire       [4:0]    _zz_when_Ddr3ControllerCore_l281_1;
  wire       [4:0]    _zz_when_Ddr3ControllerCore_l281_2;
  wire       [4:0]    _zz_cycle;
  wire       [16:0]   _zz_tick_counter;
  wire       [12:0]   _zz_A_0_1;
  wire       [12:0]   _zz_A_0_2;
  wire       [12:0]   _zz_A_0_3;
  wire       [12:0]   _zz_A_0_4;
  wire       [13:0]   _zz_A_0_5;
  wire       [0:0]    _zz_A_0_6;
  wire       [12:0]   _zz_A_0_7;
  wire       [7:0]    _zz_wstep;
  wire       [12:0]   _zz_A_0_8;
  wire       [12:0]   _zz_A_0_9;
  wire       [0:0]    _zz_A_0_10;
  wire       [13:0]   _zz_A_2_1;
  wire       [0:0]    _zz_A_2_2;
  wire       [13:0]   _zz_A_2_3;
  wire       [0:0]    _zz_A_2_4;
  wire       [2:0]    _zz_rclksel;
  wire       [1:0]    _zz_rclkpos;
  wire       [0:0]    _zz_A_0_11;
  wire       [0:0]    _zz_A_0_12;
  wire       [0:0]    _zz_A_0_13;
  wire       [15:0]   _zz_A_2_5;
  wire       [15:0]   _zz_A_2_6;
  wire       [15:0]   _zz_A_2_7;
  wire       [15:0]   _zz_A_2_8;
  wire       [0:0]    _zz_A_0_14;
  wire       [15:0]   _zz_A_2_9;
  wire       [15:0]   _zz_A_2_10;
  wire       [9:0]    _zz_A_2_11;
  reg        [15:0]   _zz_rdataVec_0;
  wire       [2:0]    _zz_rdataVec_0_1;
  wire       [3:0]    _zz_rdataVec_0_2;
  wire       [3:0]    _zz_rdataVec_0_3;
  reg        [15:0]   _zz_rdataVec_1;
  wire       [2:0]    _zz_rdataVec_1_1;
  wire       [3:0]    _zz_rdataVec_1_2;
  wire       [3:0]    _zz_rdataVec_1_3;
  reg        [15:0]   _zz_rdataVec_2;
  wire       [2:0]    _zz_rdataVec_2_1;
  wire       [3:0]    _zz_rdataVec_2_2;
  wire       [3:0]    _zz_rdataVec_2_3;
  reg        [15:0]   _zz_rdataVec_3;
  wire       [2:0]    _zz_rdataVec_3_1;
  wire       [3:0]    _zz_rdataVec_3_2;
  wire       [3:0]    _zz_rdataVec_3_3;
  reg        [15:0]   _zz_rdataVec_4;
  wire       [2:0]    _zz_rdataVec_4_1;
  wire       [3:0]    _zz_rdataVec_4_2;
  wire       [3:0]    _zz_rdataVec_4_3;
  reg        [15:0]   _zz_rdataVec_5;
  wire       [2:0]    _zz_rdataVec_5_1;
  wire       [3:0]    _zz_rdataVec_5_2;
  wire       [3:0]    _zz_rdataVec_5_3;
  reg        [15:0]   _zz_rdataVec_6;
  wire       [2:0]    _zz_rdataVec_6_1;
  wire       [3:0]    _zz_rdataVec_6_2;
  wire       [3:0]    _zz_rdataVec_6_3;
  reg        [15:0]   _zz_rdataVec_7;
  wire       [2:0]    _zz_rdataVec_7_1;
  wire       [3:0]    _zz_rdataVec_7_2;
  wire       [3:0]    _zz_rdataVec_7_3;
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
  reg        [4:0]    cycle;
  reg        [16:0]   tick_counter;
  reg                 tick;
  reg                 resetn_delay;
  reg                 CKE;
  reg                 busy;
  reg                 data_ready;
  reg                 init_done_latched;
  reg                 wlevel_done;
  reg        [3:0]    wlevel_cnt;
  reg        [7:0]    wstep;
  reg                 rcalib_done;
  reg        [3:0]    rcalib_cnt;
  reg        [5:0]    rcalib_tries;
  reg        [1:0]    rclkpos;
  reg        [2:0]    rclksel;
  reg        [1:0]    rburst_seen;
  reg                 dqs_hold;
  wire       [127:0]  trainPat;
  reg                 training;
  reg                 trainDone;
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
  wire                _zz_rotScoreW_1;
  wire                _zz_rotScoreW_2;
  wire                _zz_rotScoreW_3;
  wire                _zz_rotScoreW_4;
  wire                _zz_rotScoreW_5;
  wire                _zz_rotScoreW_6;
  wire                _zz_rotScoreW_7;
  reg        [3:0]    bestCnt;
  reg        [1:0]    bestPos;
  reg        [2:0]    bestSel;
  reg        [2:0]    bestRot;
  reg        [10:0]   refresh_timer;
  reg                 refresh_due;
  wire                when_Ddr3ControllerCore_l218;
  wire                when_Ddr3ControllerCore_l219;
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
  wire                when_Ddr3ControllerCore_l253;
  wire                when_Ddr3ControllerCore_l254;
  wire       [4:0]    rdCyc;
  reg        [3:0]    dqs_read;
  wire                when_Ddr3ControllerCore_l281;
  wire                when_Ddr3ControllerCore_l284;
  wire                acceptReq;
  wire                when_Ddr3ControllerCore_l322;
  wire       [15:0]   _zz_A_0;
  wire                when_Ddr3ControllerCore_l383;
  wire                when_Ddr3ControllerCore_l389;
  wire                when_Ddr3ControllerCore_l455;
  wire                when_Ddr3ControllerCore_l462;
  wire                when_Ddr3ControllerCore_l469;
  wire       [3:0]    _zz_state;
  wire                when_Ddr3ControllerCore_l520;
  wire       [9:0]    _zz_A_2;
  wire       [2:0]    _zz_BA_2;
  wire                when_Ddr3ControllerCore_l535;
  wire                when_Ddr3ControllerCore_l541;
  wire                when_Ddr3ControllerCore_l546;
  wire                when_Ddr3ControllerCore_l550;
  wire                when_Ddr3ControllerCore_l555;
  wire                when_Ddr3ControllerCore_l566;
  wire                when_Ddr3ControllerCore_l572;
  wire                when_Ddr3ControllerCore_l585;
  wire                when_Ddr3ControllerCore_l610;
  wire                when_Ddr3ControllerCore_l616;
  wire                when_Ddr3ControllerCore_l631;
  wire       [15:0]   rdataVec_0;
  wire       [15:0]   rdataVec_1;
  wire       [15:0]   rdataVec_2;
  wire       [15:0]   rdataVec_3;
  wire       [15:0]   rdataVec_4;
  wire       [15:0]   rdataVec_5;
  wire       [15:0]   rdataVec_6;
  wire       [15:0]   rdataVec_7;
  wire                when_Ddr3ControllerCore_l714;
  `ifndef SYNTHESIS
  reg [111:0] state_string;
  reg [111:0] _zz_state_string;
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
  assign _zz_rdCyc = (_zz_rdCyc_1 + 5'h01);
  assign _zz_rdCyc_2 = rclkpos;
  assign _zz_rdCyc_1 = {3'd0, _zz_rdCyc_2};
  assign _zz_when_Ddr3ControllerCore_l281 = (rdCyc + 5'h01);
  assign _zz_when_Ddr3ControllerCore_l281_1 = (rdCyc + 5'h02);
  assign _zz_when_Ddr3ControllerCore_l281_2 = (rdCyc + 5'h03);
  assign _zz_cycle = (cycle + 5'h01);
  assign _zz_tick_counter = (tick_counter - 17'h00001);
  assign _zz_A_0_1 = MR2[12 : 0];
  assign _zz_A_0_2 = MR3[12 : 0];
  assign _zz_A_0_3 = MR1[12 : 0];
  assign _zz_A_0_4 = MR0[12 : 0];
  assign _zz_A_0_6 = 1'b1;
  assign _zz_A_0_5 = {13'd0, _zz_A_0_6};
  assign _zz_A_0_7 = _zz_A_0[12 : 0];
  assign _zz_wstep = (wstep + 8'h01);
  assign _zz_A_0_8 = MR1[12 : 0];
  assign _zz_A_0_9 = MR2_RTT_WR[12 : 0];
  assign _zz_A_0_10 = 1'b0;
  assign _zz_A_2_2 = 1'b1;
  assign _zz_A_2_1 = {13'd0, _zz_A_2_2};
  assign _zz_A_2_4 = 1'b1;
  assign _zz_A_2_3 = {13'd0, _zz_A_2_4};
  assign _zz_rclksel = (rclksel + 3'b001);
  assign _zz_rclkpos = (rclkpos + 2'b01);
  assign _zz_A_0_11 = 1'b0;
  assign _zz_A_0_12 = 1'b0;
  assign _zz_A_0_13 = 1'b0;
  assign _zz_A_2_5 = (_zz_A_2_6 | 16'h1000);
  assign _zz_A_2_6 = {6'd0, _zz_A_2};
  assign _zz_A_2_7 = (_zz_A_2_8 | 16'h1000);
  assign _zz_A_2_8 = {6'd0, _zz_A_2};
  assign _zz_A_0_14 = 1'b0;
  assign _zz_A_2_9 = (_zz_A_2_10 | 16'h1400);
  assign _zz_A_2_11 = {reqReg_addr[6 : 0],3'b000};
  assign _zz_A_2_10 = {6'd0, _zz_A_2_11};
  assign _zz_rdataVec_0_2 = (4'b0000 - _zz_rdataVec_0_3);
  assign _zz_rdataVec_0_3 = {1'd0, bestRot};
  assign _zz_rdataVec_1_2 = (4'b0001 - _zz_rdataVec_1_3);
  assign _zz_rdataVec_1_3 = {1'd0, bestRot};
  assign _zz_rdataVec_2_2 = (4'b0010 - _zz_rdataVec_2_3);
  assign _zz_rdataVec_2_3 = {1'd0, bestRot};
  assign _zz_rdataVec_3_2 = (4'b0011 - _zz_rdataVec_3_3);
  assign _zz_rdataVec_3_3 = {1'd0, bestRot};
  assign _zz_rdataVec_4_2 = (4'b0100 - _zz_rdataVec_4_3);
  assign _zz_rdataVec_4_3 = {1'd0, bestRot};
  assign _zz_rdataVec_5_2 = (4'b0101 - _zz_rdataVec_5_3);
  assign _zz_rdataVec_5_3 = {1'd0, bestRot};
  assign _zz_rdataVec_6_2 = (4'b0110 - _zz_rdataVec_6_3);
  assign _zz_rdataVec_6_3 = {1'd0, bestRot};
  assign _zz_rdataVec_7_2 = (4'b0111 - _zz_rdataVec_7_3);
  assign _zz_rdataVec_7_3 = {1'd0, bestRot};
  assign _zz_rdataVec_0_1 = _zz_rdataVec_0_2[2 : 0];
  assign _zz_rdataVec_1_1 = _zz_rdataVec_1_2[2 : 0];
  assign _zz_rdataVec_2_1 = _zz_rdataVec_2_2[2 : 0];
  assign _zz_rdataVec_3_1 = _zz_rdataVec_3_2[2 : 0];
  assign _zz_rdataVec_4_1 = _zz_rdataVec_4_2[2 : 0];
  assign _zz_rdataVec_5_1 = _zz_rdataVec_5_2[2 : 0];
  assign _zz_rdataVec_6_1 = _zz_rdataVec_6_2[2 : 0];
  assign _zz_rdataVec_7_1 = _zz_rdataVec_7_2[2 : 0];
  always @(*) begin
    case(_zz_rdataVec_0_1)
      3'b000 : _zz_rdataVec_0 = io_phy_dq_in_0;
      3'b001 : _zz_rdataVec_0 = io_phy_dq_in_1;
      3'b010 : _zz_rdataVec_0 = io_phy_dq_in_2;
      3'b011 : _zz_rdataVec_0 = io_phy_dq_in_3;
      3'b100 : _zz_rdataVec_0 = io_phy_dq_in_4;
      3'b101 : _zz_rdataVec_0 = io_phy_dq_in_5;
      3'b110 : _zz_rdataVec_0 = io_phy_dq_in_6;
      default : _zz_rdataVec_0 = io_phy_dq_in_7;
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_1_1)
      3'b000 : _zz_rdataVec_1 = io_phy_dq_in_0;
      3'b001 : _zz_rdataVec_1 = io_phy_dq_in_1;
      3'b010 : _zz_rdataVec_1 = io_phy_dq_in_2;
      3'b011 : _zz_rdataVec_1 = io_phy_dq_in_3;
      3'b100 : _zz_rdataVec_1 = io_phy_dq_in_4;
      3'b101 : _zz_rdataVec_1 = io_phy_dq_in_5;
      3'b110 : _zz_rdataVec_1 = io_phy_dq_in_6;
      default : _zz_rdataVec_1 = io_phy_dq_in_7;
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_2_1)
      3'b000 : _zz_rdataVec_2 = io_phy_dq_in_0;
      3'b001 : _zz_rdataVec_2 = io_phy_dq_in_1;
      3'b010 : _zz_rdataVec_2 = io_phy_dq_in_2;
      3'b011 : _zz_rdataVec_2 = io_phy_dq_in_3;
      3'b100 : _zz_rdataVec_2 = io_phy_dq_in_4;
      3'b101 : _zz_rdataVec_2 = io_phy_dq_in_5;
      3'b110 : _zz_rdataVec_2 = io_phy_dq_in_6;
      default : _zz_rdataVec_2 = io_phy_dq_in_7;
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_3_1)
      3'b000 : _zz_rdataVec_3 = io_phy_dq_in_0;
      3'b001 : _zz_rdataVec_3 = io_phy_dq_in_1;
      3'b010 : _zz_rdataVec_3 = io_phy_dq_in_2;
      3'b011 : _zz_rdataVec_3 = io_phy_dq_in_3;
      3'b100 : _zz_rdataVec_3 = io_phy_dq_in_4;
      3'b101 : _zz_rdataVec_3 = io_phy_dq_in_5;
      3'b110 : _zz_rdataVec_3 = io_phy_dq_in_6;
      default : _zz_rdataVec_3 = io_phy_dq_in_7;
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_4_1)
      3'b000 : _zz_rdataVec_4 = io_phy_dq_in_0;
      3'b001 : _zz_rdataVec_4 = io_phy_dq_in_1;
      3'b010 : _zz_rdataVec_4 = io_phy_dq_in_2;
      3'b011 : _zz_rdataVec_4 = io_phy_dq_in_3;
      3'b100 : _zz_rdataVec_4 = io_phy_dq_in_4;
      3'b101 : _zz_rdataVec_4 = io_phy_dq_in_5;
      3'b110 : _zz_rdataVec_4 = io_phy_dq_in_6;
      default : _zz_rdataVec_4 = io_phy_dq_in_7;
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_5_1)
      3'b000 : _zz_rdataVec_5 = io_phy_dq_in_0;
      3'b001 : _zz_rdataVec_5 = io_phy_dq_in_1;
      3'b010 : _zz_rdataVec_5 = io_phy_dq_in_2;
      3'b011 : _zz_rdataVec_5 = io_phy_dq_in_3;
      3'b100 : _zz_rdataVec_5 = io_phy_dq_in_4;
      3'b101 : _zz_rdataVec_5 = io_phy_dq_in_5;
      3'b110 : _zz_rdataVec_5 = io_phy_dq_in_6;
      default : _zz_rdataVec_5 = io_phy_dq_in_7;
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_6_1)
      3'b000 : _zz_rdataVec_6 = io_phy_dq_in_0;
      3'b001 : _zz_rdataVec_6 = io_phy_dq_in_1;
      3'b010 : _zz_rdataVec_6 = io_phy_dq_in_2;
      3'b011 : _zz_rdataVec_6 = io_phy_dq_in_3;
      3'b100 : _zz_rdataVec_6 = io_phy_dq_in_4;
      3'b101 : _zz_rdataVec_6 = io_phy_dq_in_5;
      3'b110 : _zz_rdataVec_6 = io_phy_dq_in_6;
      default : _zz_rdataVec_6 = io_phy_dq_in_7;
    endcase
  end

  always @(*) begin
    case(_zz_rdataVec_7_1)
      3'b000 : _zz_rdataVec_7 = io_phy_dq_in_0;
      3'b001 : _zz_rdataVec_7 = io_phy_dq_in_1;
      3'b010 : _zz_rdataVec_7 = io_phy_dq_in_2;
      3'b011 : _zz_rdataVec_7 = io_phy_dq_in_3;
      3'b100 : _zz_rdataVec_7 = io_phy_dq_in_4;
      3'b101 : _zz_rdataVec_7 = io_phy_dq_in_5;
      3'b110 : _zz_rdataVec_7 = io_phy_dq_in_6;
      default : _zz_rdataVec_7 = io_phy_dq_in_7;
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
      Ddr3State_REFRESH : state_string = "REFRESH       ";
      default : state_string = "??????????????";
    endcase
  end
  always @(*) begin
    case(_zz_state)
      Ddr3State_RST_WAIT : _zz_state_string = "RST_WAIT      ";
      Ddr3State_CKE_WAIT : _zz_state_string = "CKE_WAIT      ";
      Ddr3State_CONFIG_1 : _zz_state_string = "CONFIG_1      ";
      Ddr3State_ZQCL : _zz_state_string = "ZQCL          ";
      Ddr3State_WRITE_LEVELING : _zz_state_string = "WRITE_LEVELING";
      Ddr3State_READ_CALIB : _zz_state_string = "READ_CALIB    ";
      Ddr3State_IDLE : _zz_state_string = "IDLE          ";
      Ddr3State_READ : _zz_state_string = "READ          ";
      Ddr3State_WRITE : _zz_state_string = "WRITE         ";
      Ddr3State_REFRESH : _zz_state_string = "REFRESH       ";
      default : _zz_state_string = "??????????????";
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
  assign trainPat = 128'h10071006100510041003100210011000;
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
  assign rotScoreW_0 = rotScores_0;
  assign rotIdxW_0 = 3'b000;
  assign _zz_rotScoreW_1 = (rotScoreW_0 < rotScores_1);
  assign rotScoreW_1 = (_zz_rotScoreW_1 ? rotScores_1 : rotScoreW_0);
  assign rotIdxW_1 = (_zz_rotScoreW_1 ? 3'b001 : rotIdxW_0);
  assign _zz_rotScoreW_2 = (rotScoreW_1 < rotScores_2);
  assign rotScoreW_2 = (_zz_rotScoreW_2 ? rotScores_2 : rotScoreW_1);
  assign rotIdxW_2 = (_zz_rotScoreW_2 ? 3'b010 : rotIdxW_1);
  assign _zz_rotScoreW_3 = (rotScoreW_2 < rotScores_3);
  assign rotScoreW_3 = (_zz_rotScoreW_3 ? rotScores_3 : rotScoreW_2);
  assign rotIdxW_3 = (_zz_rotScoreW_3 ? 3'b011 : rotIdxW_2);
  assign _zz_rotScoreW_4 = (rotScoreW_3 < rotScores_4);
  assign rotScoreW_4 = (_zz_rotScoreW_4 ? rotScores_4 : rotScoreW_3);
  assign rotIdxW_4 = (_zz_rotScoreW_4 ? 3'b100 : rotIdxW_3);
  assign _zz_rotScoreW_5 = (rotScoreW_4 < rotScores_5);
  assign rotScoreW_5 = (_zz_rotScoreW_5 ? rotScores_5 : rotScoreW_4);
  assign rotIdxW_5 = (_zz_rotScoreW_5 ? 3'b101 : rotIdxW_4);
  assign _zz_rotScoreW_6 = (rotScoreW_5 < rotScores_6);
  assign rotScoreW_6 = (_zz_rotScoreW_6 ? rotScores_6 : rotScoreW_5);
  assign rotIdxW_6 = (_zz_rotScoreW_6 ? 3'b110 : rotIdxW_5);
  assign _zz_rotScoreW_7 = (rotScoreW_6 < rotScores_7);
  assign rotScoreW_7 = (_zz_rotScoreW_7 ? rotScores_7 : rotScoreW_6);
  assign rotIdxW_7 = (_zz_rotScoreW_7 ? 3'b111 : rotIdxW_6);
  assign when_Ddr3ControllerCore_l218 = (((state == Ddr3State_IDLE) || (state == Ddr3State_READ)) || (state == Ddr3State_WRITE));
  assign when_Ddr3ControllerCore_l219 = (refresh_timer == 11'h30c);
  assign when_Ddr3ControllerCore_l253 = io_phy_rburst[0];
  assign when_Ddr3ControllerCore_l254 = io_phy_rburst[1];
  assign rdCyc = (_zz_rdCyc + 5'h01);
  assign when_Ddr3ControllerCore_l281 = (((state == Ddr3State_READ) || (state == Ddr3State_READ_CALIB)) && ((((cycle == rdCyc) || (cycle == _zz_when_Ddr3ControllerCore_l281)) || (cycle == _zz_when_Ddr3ControllerCore_l281_1)) || (cycle == _zz_when_Ddr3ControllerCore_l281_2)));
  assign when_Ddr3ControllerCore_l284 = (state == Ddr3State_WRITE);
  assign acceptReq = (((state == Ddr3State_IDLE) && (! busy)) && (! refresh_due));
  assign io_req_ready = acceptReq;
  assign when_Ddr3ControllerCore_l322 = (tick_counter == 17'h0000f);
  assign _zz_A_0 = (MR1 | 16'h0084);
  assign when_Ddr3ControllerCore_l383 = ((! io_phy_dq_raw[0]) || (! io_phy_dq_raw[8]));
  assign when_Ddr3ControllerCore_l389 = (wlevel_cnt == 4'b0000);
  assign when_Ddr3ControllerCore_l455 = (bestCnt < rotScoreW_7);
  assign when_Ddr3ControllerCore_l462 = (rclksel == 3'b111);
  assign when_Ddr3ControllerCore_l469 = (rcalib_tries == 6'h28);
  assign _zz_state = (io_req_payload_write ? Ddr3State_WRITE : Ddr3State_READ);
  assign when_Ddr3ControllerCore_l520 = (! io_req_payload_write);
  assign _zz_A_2 = {reqReg_addr[6 : 0],3'b000};
  assign _zz_BA_2 = reqReg_addr[23 : 21];
  assign when_Ddr3ControllerCore_l535 = (cycle == 5'h01);
  assign when_Ddr3ControllerCore_l541 = (cycle == 5'h02);
  assign when_Ddr3ControllerCore_l546 = (cycle == 5'h0b);
  assign when_Ddr3ControllerCore_l550 = (cycle == 5'h0c);
  assign when_Ddr3ControllerCore_l555 = (cycle == 5'h0d);
  assign when_Ddr3ControllerCore_l566 = (cycle == 5'h01);
  assign when_Ddr3ControllerCore_l572 = (cycle == 5'h02);
  assign when_Ddr3ControllerCore_l585 = (cycle == 5'h03);
  assign when_Ddr3ControllerCore_l610 = (cycle == 5'h04);
  assign when_Ddr3ControllerCore_l616 = (cycle == 5'h07);
  assign when_Ddr3ControllerCore_l631 = (cycle == 5'h10);
  assign rdataVec_0 = _zz_rdataVec_0;
  assign rdataVec_1 = _zz_rdataVec_1;
  assign rdataVec_2 = _zz_rdataVec_2;
  assign rdataVec_3 = _zz_rdataVec_3;
  assign rdataVec_4 = _zz_rdataVec_4;
  assign rdataVec_5 = _zz_rdataVec_5;
  assign rdataVec_6 = _zz_rdataVec_6;
  assign rdataVec_7 = _zz_rdataVec_7;
  assign io_rsp_valid = data_ready;
  assign io_rsp_payload_rdata = {{{{{{{rdataVec_7,rdataVec_6},rdataVec_5},rdataVec_4},rdataVec_3},rdataVec_2},rdataVec_1},rdataVec_0};
  assign io_phy_dqs_hold = dqs_hold;
  assign io_phy_wstep = wstep;
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
  assign when_Ddr3ControllerCore_l714 = (((((io_phy_rst_lock_n && (! _zz_when_Ddr3ControllerCore_l714)) && (! busy)) && (state == Ddr3State_IDLE)) && wlevel_done) && rcalib_done);
  assign io_init_done = init_done_latched;
  assign io_write_level_done = wlevel_done;
  assign io_read_calib_done = rcalib_done;
  assign io_wstep = wstep;
  assign io_rclkpos = rclkpos;
  assign io_rclksel = rclksel;
  always @(posedge io_pclk or posedge _zz_when_Ddr3ControllerCore_l714) begin
    if(_zz_when_Ddr3ControllerCore_l714) begin
      state <= Ddr3State_RST_WAIT;
      cycle <= 5'h0;
      tick_counter <= 17'h0ea60;
      tick <= 1'b0;
      resetn_delay <= 1'b0;
      CKE <= 1'b0;
      busy <= 1'b1;
      data_ready <= 1'b0;
      init_done_latched <= 1'b0;
      wlevel_done <= 1'b0;
      wlevel_cnt <= 4'b0000;
      wstep <= 8'h0;
      rcalib_done <= 1'b0;
      rcalib_cnt <= 4'b0000;
      rcalib_tries <= 6'h0;
      rclkpos <= 2'b00;
      rclksel <= 3'b000;
      rburst_seen <= 2'b00;
      dqs_hold <= 1'b0;
      training <= 1'b1;
      trainDone <= 1'b0;
      trainLatch <= 128'h0;
      bestCnt <= 4'b0000;
      bestPos <= 2'b00;
      bestSel <= 3'b000;
      bestRot <= 3'b000;
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
    end else begin
      if(when_Ddr3ControllerCore_l218) begin
        if(when_Ddr3ControllerCore_l219) begin
          refresh_due <= 1'b1;
          refresh_timer <= 11'h0;
        end else begin
          refresh_timer <= (refresh_timer + 11'h001);
        end
      end
      if(when_Ddr3ControllerCore_l253) begin
        rburst_seen[0] <= 1'b1;
      end
      if(when_Ddr3ControllerCore_l254) begin
        rburst_seen[1] <= 1'b1;
      end
      dqs_read <= 4'b0000;
      if(when_Ddr3ControllerCore_l281) begin
        dqs_read <= 4'b1111;
      end
      if(when_Ddr3ControllerCore_l284) begin
        dqs_read <= 4'b1111;
      end
      if(io_phy_rst_lock_n) begin
        cycle <= ((cycle == 5'h1f) ? 5'h1f : _zz_cycle);
        tick <= (tick_counter == 17'h00001);
        tick_counter <= ((tick_counter == 17'h0) ? 17'h0 : _zz_tick_counter);
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
        case(state)
          Ddr3State_RST_WAIT : begin
            if(tick) begin
              resetn_delay <= 1'b1;
              tick_counter <= 17'h0c364;
              state <= Ddr3State_CKE_WAIT;
            end
          end
          Ddr3State_CKE_WAIT : begin
            if(when_Ddr3ControllerCore_l322) begin
              CKE <= 1'b1;
            end
            if(tick) begin
              state <= Ddr3State_CONFIG_1;
              cycle <= 5'h0;
            end
          end
          Ddr3State_CONFIG_1 : begin
            case(cycle)
              5'h0 : begin
                nRAS_0 <= CMD_SetModeReg[2];
                nCAS_0 <= CMD_SetModeReg[1];
                nWE_0 <= CMD_SetModeReg[0];
                BA_0 <= MR2[15 : 13];
                A_0 <= {1'd0, _zz_A_0_1};
              end
              5'h02 : begin
                nRAS_0 <= CMD_SetModeReg[2];
                nCAS_0 <= CMD_SetModeReg[1];
                nWE_0 <= CMD_SetModeReg[0];
                BA_0 <= MR3[15 : 13];
                A_0 <= {1'd0, _zz_A_0_2};
              end
              5'h04 : begin
                nRAS_0 <= CMD_SetModeReg[2];
                nCAS_0 <= CMD_SetModeReg[1];
                nWE_0 <= CMD_SetModeReg[0];
                BA_0 <= MR1[15 : 13];
                A_0 <= {1'd0, _zz_A_0_3};
              end
              5'h06 : begin
                nRAS_0 <= CMD_SetModeReg[2];
                nCAS_0 <= CMD_SetModeReg[1];
                nWE_0 <= CMD_SetModeReg[0];
                BA_0 <= MR0[15 : 13];
                A_0 <= {1'd0, _zz_A_0_4};
              end
              5'h0a : begin
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
              cycle <= 5'h0;
            end
          end
          Ddr3State_WRITE_LEVELING : begin
            case(cycle)
              5'h0 : begin
                nRAS_0 <= CMD_SetModeReg[2];
                nCAS_0 <= CMD_SetModeReg[1];
                nWE_0 <= CMD_SetModeReg[0];
                BA_0 <= _zz_A_0[15 : 13];
                A_0 <= {1'd0, _zz_A_0_7};
                wlevel_cnt <= 4'b0000;
              end
              5'h0a, 5'h0c, 5'h0d, 5'h0e, 5'h0f, 5'h10 : begin
                dqs_out <= 8'h0;
                dqs_oen <= 4'b0000;
              end
              5'h0b : begin
                dqs_out <= 8'h55;
                dqs_oen <= 4'b0000;
              end
              5'h11 : begin
                dqs_out <= 8'h0;
                dqs_oen <= 4'b0000;
                if(when_Ddr3ControllerCore_l383) begin
                  wstep <= _zz_wstep;
                  wlevel_cnt <= 4'b0000;
                  cycle <= 5'h0a;
                end else begin
                  wlevel_cnt <= (wlevel_cnt + 4'b0001);
                  if(when_Ddr3ControllerCore_l389) begin
                    wlevel_done <= 1'b1;
                    nRAS_0 <= CMD_SetModeReg[2];
                    nCAS_0 <= CMD_SetModeReg[1];
                    nWE_0 <= CMD_SetModeReg[0];
                    BA_0 <= MR1[15 : 13];
                    A_0 <= {1'd0, _zz_A_0_8};
                  end else begin
                    cycle <= 5'h0a;
                  end
                end
              end
              5'h13 : begin
                nRAS_0 <= CMD_SetModeReg[2];
                nCAS_0 <= CMD_SetModeReg[1];
                nWE_0 <= CMD_SetModeReg[0];
                BA_0 <= MR2_RTT_WR[15 : 13];
                A_0 <= {1'd0, _zz_A_0_9};
              end
              5'h16 : begin
                state <= Ddr3State_READ_CALIB;
                cycle <= 5'h0;
              end
              default : begin
              end
            endcase
          end
          Ddr3State_READ_CALIB : begin
            case(cycle)
              5'h0 : begin
                nRAS_0 <= CMD_BankActivate[2];
                nCAS_0 <= CMD_BankActivate[1];
                nWE_0 <= CMD_BankActivate[0];
                BA_0 <= 3'b000;
                A_0 <= {13'd0, _zz_A_0_10};
                dqs_hold <= 1'b1;
                rcalib_cnt <= 4'b0000;
                rcalib_tries <= 6'h0;
                bestCnt <= 4'b0000;
                bestPos <= rclkpos;
                bestSel <= rclksel;
                bestRot <= 3'b000;
              end
              5'h01 : begin
                nRAS_2 <= CMD_Read[2];
                nCAS_2 <= CMD_Read[1];
                nWE_2 <= CMD_Read[0];
                BA_2 <= 3'b000;
                A_2 <= (_zz_A_2_1 <<< 12);
                dqs_hold <= 1'b1;
                rburst_seen <= 2'b00;
              end
              5'h02 : begin
                nRAS_2 <= CMD_Read[2];
                nCAS_2 <= CMD_Read[1];
                nWE_2 <= CMD_Read[0];
                BA_2 <= 3'b000;
                A_2 <= (_zz_A_2_3 <<< 12);
              end
              5'h0b : begin
                trainLatch <= {{{{{{{io_phy_dq_in_7,io_phy_dq_in_6},io_phy_dq_in_5},io_phy_dq_in_4},io_phy_dq_in_3},io_phy_dq_in_2},io_phy_dq_in_1},io_phy_dq_in_0};
              end
              5'h0c : begin
                `ifndef SYNTHESIS
                  `ifdef FORMAL
                    assert(1'b0); // Ddr3ControllerCore.scala:L450
                  `else
                    if(!1'b0) begin
                      $display("NOTE RCALIB chk pos=%x sel=%x seen=%x score=%x rot=%x latch=%x best=%x tries=%x", rclkpos, rclksel, rburst_seen, rotScoreW_7, rotIdxW_7, trainLatch, bestCnt, rcalib_tries); // Ddr3ControllerCore.scala:L450
                    end
                  `endif
                `endif
                if(when_Ddr3ControllerCore_l455) begin
                  bestCnt <= rotScoreW_7;
                  bestPos <= rclkpos;
                  bestSel <= rclksel;
                  bestRot <= rotIdxW_7;
                end
                rclksel <= _zz_rclksel;
                if(when_Ddr3ControllerCore_l462) begin
                  rclkpos <= _zz_rclkpos;
                end
                rcalib_cnt <= 4'b0000;
                rcalib_tries <= (rcalib_tries + 6'h01);
                if(when_Ddr3ControllerCore_l469) begin
                  `ifndef SYNTHESIS
                    `ifdef FORMAL
                      assert(1'b0); // Ddr3ControllerCore.scala:L471
                    `else
                      if(!1'b0) begin
                        $display("NOTE RCALIB lock best pos=%x sel=%x rot=%x score=%x", bestPos, bestSel, bestRot, bestCnt); // Ddr3ControllerCore.scala:L471
                      end
                    `endif
                  `endif
                  rclkpos <= bestPos;
                  rclksel <= bestSel;
                  rcalib_done <= 1'b1;
                  nRAS_0 <= CMD_PreCharge[2];
                  nCAS_0 <= CMD_PreCharge[1];
                  nWE_0 <= CMD_PreCharge[0];
                  BA_0 <= 3'b000;
                  A_0 <= {13'd0, _zz_A_0_11};
                end else begin
                  cycle <= 5'h01;
                end
              end
              5'h0d : begin
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
              nRAS_0 <= CMD_BankActivate[2];
              nCAS_0 <= CMD_BankActivate[1];
              nWE_0 <= CMD_BankActivate[0];
              BA_0 <= 3'b000;
              A_0 <= {13'd0, _zz_A_0_12};
              state <= Ddr3State_WRITE;
              cycle <= 5'h01;
              busy <= 1'b1;
            end else begin
              if(refresh_due) begin
                nRAS_0 <= CMD_AutoRefresh[2];
                nCAS_0 <= CMD_AutoRefresh[1];
                nWE_0 <= CMD_AutoRefresh[0];
                BA_0 <= 3'b000;
                A_0 <= {13'd0, _zz_A_0_13};
                state <= Ddr3State_REFRESH;
                cycle <= 5'h01;
                busy <= 1'b1;
                refresh_due <= 1'b0;
              end else begin
                if(io_req_valid) begin
                  nRAS_0 <= CMD_BankActivate[2];
                  nCAS_0 <= CMD_BankActivate[1];
                  nWE_0 <= CMD_BankActivate[0];
                  BA_0 <= io_req_payload_addr[23 : 21];
                  A_0 <= io_req_payload_addr[20 : 7];
                  state <= _zz_state;
                  cycle <= 5'h01;
                  busy <= 1'b1;
                  if(when_Ddr3ControllerCore_l520) begin
                    dqs_hold <= 1'b1;
                  end
                end
              end
            end
          end
          Ddr3State_READ : begin
            if(when_Ddr3ControllerCore_l535) begin
              nRAS_2 <= CMD_Read[2];
              nCAS_2 <= CMD_Read[1];
              nWE_2 <= CMD_Read[0];
              BA_2 <= _zz_BA_2;
              A_2 <= _zz_A_2_5[13:0];
              dqs_hold <= 1'b1;
            end
            if(when_Ddr3ControllerCore_l541) begin
              nRAS_2 <= CMD_Read[2];
              nCAS_2 <= CMD_Read[1];
              nWE_2 <= CMD_Read[0];
              BA_2 <= _zz_BA_2;
              A_2 <= _zz_A_2_7[13:0];
            end
            if(when_Ddr3ControllerCore_l546) begin
              data_ready <= 1'b1;
            end
            if(when_Ddr3ControllerCore_l550) begin
              data_ready <= 1'b0;
              nRAS_0 <= CMD_PreCharge[2];
              nCAS_0 <= CMD_PreCharge[1];
              nWE_0 <= CMD_PreCharge[0];
              BA_0 <= 3'b000;
              A_0 <= {13'd0, _zz_A_0_14};
            end
            if(when_Ddr3ControllerCore_l555) begin
              busy <= 1'b0;
              state <= Ddr3State_IDLE;
            end
          end
          Ddr3State_WRITE : begin
            if(when_Ddr3ControllerCore_l566) begin
              nRAS_2 <= CMD_Write[2];
              nCAS_2 <= CMD_Write[1];
              nWE_2 <= CMD_Write[0];
              BA_2 <= reqReg_addr[23 : 21];
              A_2 <= _zz_A_2_9[13:0];
            end
            if(when_Ddr3ControllerCore_l572) begin
              dqs_out <= 8'h40;
              dqs_oen <= 4'b0011;
              dq_oen <= 4'b0111;
              dq_out_6 <= 16'h0;
              dq_out_7 <= reqReg_wdata[15 : 0];
              dm_out[6] <= 1'b1;
              dm_out[7] <= (! (|reqReg_wstrb[1 : 0]));
            end
            if(when_Ddr3ControllerCore_l585) begin
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
            if(when_Ddr3ControllerCore_l610) begin
              dqs_out <= 8'h0;
              dqs_oen <= 4'b1110;
              dq_oen <= 4'b1111;
            end
            if(when_Ddr3ControllerCore_l616) begin
              if(trainDone) begin
                trainDone <= 1'b0;
                state <= Ddr3State_READ_CALIB;
                cycle <= 5'h0;
              end else begin
                busy <= 1'b0;
                state <= Ddr3State_IDLE;
              end
            end
          end
          default : begin
            if(when_Ddr3ControllerCore_l631) begin
              busy <= 1'b0;
              state <= Ddr3State_IDLE;
            end
          end
        endcase
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
        cycle <= 5'h0;
        wlevel_cnt <= 4'b0000;
        wlevel_done <= 1'b0;
        wstep <= 8'h0;
        rcalib_cnt <= 4'b0000;
        rcalib_done <= 1'b0;
        rcalib_tries <= 6'h0;
        bestRot <= 3'b000;
        training <= 1'b1;
        trainDone <= 1'b0;
        trainLatch <= 128'h0;
        rclkpos <= 2'b00;
        rclksel <= 3'b000;
        init_done_latched <= 1'b0;
        rburst_seen <= 2'b00;
        resetn_delay <= 1'b0;
        state <= Ddr3State_RST_WAIT;
      end
      if(when_Ddr3ControllerCore_l714) begin
        init_done_latched <= 1'b1;
      end
    end
  end

  always @(posedge io_pclk) begin
    if(io_phy_rst_lock_n) begin
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
        end
        Ddr3State_IDLE : begin
          if(training) begin
            reqReg_write <= 1'b1;
            reqReg_addr <= 27'h0;
            reqReg_wdata <= trainPat;
            reqReg_wstrb <= 16'hffff;
          end else begin
            if(!refresh_due) begin
              if(io_req_valid) begin
                reqReg_write <= io_req_payload_write;
                reqReg_addr <= io_req_payload_addr;
                reqReg_wdata <= io_req_payload_wdata;
                reqReg_wstrb <= io_req_payload_wstrb;
              end
            end
          end
        end
        Ddr3State_READ : begin
        end
        Ddr3State_WRITE : begin
        end
        default : begin
        end
      endcase
    end
  end


endmodule
