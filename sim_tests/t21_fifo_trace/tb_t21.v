// t21 — trace FIFO DQS/IDES8_MEM sur UNE itération de calib (rcalib_tries
// == +trt). Même harnais que t20 (init naturelle, ancre LOCK/STEP forcée).
// Harnais pur, pas de logique DUT. Lignes :
//   F  : posedge FCLK  (pointeurs, rd_en/dqs_en, D_en, DQ[2:0])
//   R+/R- : fronts DQSR90 (écriture FIFO sur R-)
//   I  : changement DQSIN
//   C  : capture IDES (D_en) -> slots (beat index par slot, lanes 0..2)
//   M  : contenu FIFO (entrée -> beat pair) au cycle de latch
// Verdict : T21 DONE (trace complète) / T21 FAIL timeout.
`timescale 1ps / 1ps

module tb_t21;

    `define sg125
    `include "1024Mb_ddr3_parameters.vh"

    reg                         ck;
    wire                        cke;
    wire                        cs_n;
    wire                        ras_n;
    wire                        cas_n;
    wire                        we_n;
    wire           [BA_BITS-1:0] ba;
    wire         [ADDR_BITS-1:0] a;
    wire          [DM_BITS-1:0] dm;
    wire          [DQ_BITS-1:0] dq;
    wire         [DQS_BITS-1:0] dqs;
    wire         [DQS_BITS-1:0] dqs_n = ~dqs;
    wire         [DQS_BITS-1:0] tdqs_n = 2'bzz;
    wire                        odt;

    reg             pclk;
    reg             fclk;
    reg             resetn;
    reg             req_valid;
    reg             req_write;
    reg     [26:0]  req_addr;
    reg     [127:0] req_wdata;
    reg     [15:0]  req_strb;
    wire            req_ready;
    wire            rsp_valid;
    wire    [127:0] rsp_rdata;
    wire            init_done;
    wire            wlevel_done;
    wire            rcalib_done;
    wire    [7:0]   wstep;
    wire    [1:0]   rclkpos;
    wire    [2:0]   rclksel;

    wire ddr_nrst;
    wire ddr_ck;

    ddr3 #(.DEBUG(0)) sdramddr3_0 (
        ddr_nrst, ddr_ck, ~ddr_ck, cke,
        cs_n, ras_n, cas_n, we_n,
        dm, ba, a, dq, dqs, dqs_n,
        tdqs_n, odt
    );

    Ddr3ControllerSim u_dut (
        .io_pclk(pclk), .io_fclk(fclk), .io_ck(ck), .io_resetn(resetn),
        .io_req_valid(req_valid), .io_req_ready(req_ready),
        .io_req_payload_write(req_write),
        .io_req_payload_addr(req_addr),
        .io_req_payload_wdata(req_wdata),
        .io_req_payload_wstrb(req_strb),
        .io_rsp_valid(rsp_valid),
        .io_rsp_payload_rdata(rsp_rdata),
        .io_init_done(init_done),
        .io_write_level_done(wlevel_done), .io_wstep(wstep),
        .io_read_calib_done(rcalib_done), .io_rclkpos(rclkpos), .io_rclksel(rclksel),
        .io_pad_DDR3_nRESET(ddr_nrst),
        .io_pad_DDR3_CK(ddr_ck),
        .io_pad_DDR3_CKE(cke),
        .io_pad_DDR3_nCS(cs_n),
        .io_pad_DDR3_nRAS(ras_n),
        .io_pad_DDR3_nCAS(cas_n),
        .io_pad_DDR3_nWE(we_n),
        .io_pad_DDR3_DM(dm),
        .io_pad_DDR3_BA(ba),
        .io_pad_DDR3_A(a),
        .io_pad_DDR3_DQ(dq),
        .io_pad_DDR3_DQS(dqs),
        .io_pad_DDR3_ODT(odt)
    );

    integer step_val;
    integer trt;
    initial begin
        step_val = 25;
        trt = 1;
        void'($value$plusargs("step=%d", step_val));
        void'($value$plusargs("trt=%d", trt));
        force u_dut.phy.dll_1.LOCK = 1'b1;
        force u_dut.phy.dll_1.STEP = step_val[7:0];
        $display("T21 anchor step=%0d trace tries=%0d", step_val, trt);
        $fflush();
    end

    real tck;
    initial begin
        $timeformat(-9, 3, " ns", 1);
        tck <= 2500;
        fclk <= 1'b1;
        ck <= 1'b1;
        pclk <= 1'b1;
        forever begin
            #(tck/4) ck = ~ck;
            #(tck/4) fclk = ~fclk;
            #(tck/4) ck = ~ck;
            #(tck/4) fclk = ~fclk;
            #(tck/4) ck = ~ck;
            #(tck/4) fclk = ~fclk;
            #(tck/4) ck = ~ck;
            #(tck/4) fclk = ~fclk;
            pclk = ~pclk;
        end
    end

    initial begin : test
        resetn <= 1'b0;
        req_valid <= 1'b0; req_write <= 1'b0;
        req_addr <= 0; req_wdata <= 0; req_strb <= 0;
        #(10000);
        @(negedge ck) resetn = 1'b1;
    end

    // ---- trace window ------------------------------------------------
    wire [9:0] tries = u_dut.coreArea_core.rcalib_tries;
    wire       tr    = (tries == trt[9:0]) && (rcalib_done !== 1'b1);
    reg        seen;
    initial seen = 0;
    always @(posedge pclk) begin
        if (tr) seen <= 1'b1;
        if (seen && !tr) begin
            $display("T21 DONE t=%t", $time);
            $fflush();
            $finish(0);
        end
    end
    initial begin
        #(300_000_000);
        $display("T21 FAIL timeout");
        $finish(1);
    end

    // beat index carried by DQ[2:0] (pattern 0x1000+k), DQ12 = valid marker
    wire [2:0] dqk = dq[2:0];

    always @(posedge fclk) if (tr)
        $display("F %t cyc=%0d st=%0d hold=%b rd0=%b rdpost=%b rdpre=%b rden=%b dqsen=%b wptq=%0d WP=%0d RP=%0d sgn=%b rdq=%b upa=%b Den=%b dq=%b/%b dqs=%b",
            $time, u_dut.coreArea_core.cycle, u_dut.coreArea_core.state,
            u_dut.phy.dQS_1.HOLD, u_dut.phy.dQS_1.rd_d0[0],
            u_dut.phy.dQS_1.rd_post, u_dut.phy.dQS_1.rd_pre,
            u_dut.phy.dQS_1.rd_en, u_dut.phy.dQS_1.dqs_en,
            u_dut.phy.dQS_1.wpt_q, u_dut.phy.dQS_1.WPOINT, u_dut.phy.dQS_1.RPOINT,
            u_dut.phy.dQS_1.sign_q, u_dut.phy.dQS_1.rd_q, u_dut.phy.dQS_1.update_a,
            u_dut.phy.iDES8_MEM_1.D_en, dq[12], dqk, dqs[0]);

    always @(posedge u_dut.phy.dQS_1.DQSR90) if (tr)
        $display("R+ %t dq=%b/%b WP=%0d wptq=%0d", $time, dq[12], dqk,
                 u_dut.phy.dQS_1.WPOINT, u_dut.phy.dQS_1.wpt_q);
    always @(negedge u_dut.phy.dQS_1.DQSR90) if (tr)
        $display("R- %t dq=%b/%b WP=%0d wptq=%0d (write entry %0d)", $time, dq[12], dqk,
                 u_dut.phy.dQS_1.WPOINT, u_dut.phy.dQS_1.wpt_q, u_dut.phy.dQS_1.WPOINT);
    always @(u_dut.phy.dQS_1.DQSIN) if (tr)
        $display("I %t dqsin=%b dqsen=%b rden=%b", $time, u_dut.phy.dQS_1.DQSIN,
                 u_dut.phy.dQS_1.dqs_en, u_dut.phy.dQS_1.rd_en);

    // IDES capture strobe: print the 8 slot beat indices (lanes 2..0)
    integer s;
    always @(posedge fclk) if (tr && u_dut.phy.iDES8_MEM_1.D_en) begin
        $write("C %t sel=%b slots(0..7)=", $time, u_dut.phy.iDES8_MEM_1.Dd_sel);
        for (s = 0; s < 8; s = s + 1)
            $write(" %b%b%b%b", u_dut.phy.iDES8_MEM_13.D_data[s],
                   u_dut.phy.iDES8_MEM_3.D_data[s], u_dut.phy.iDES8_MEM_2.D_data[s],
                   u_dut.phy.iDES8_MEM_1.D_data[s]);
        $write("\n");
    end

    integer e;
    always @(posedge pclk) if (tr && u_dut.coreArea_core.cycle == 11) begin
        $write("M %t entries(e:Dd0/Dd1)=", $time);
        for (e = 0; e < 8; e = e + 1)
            $write(" %0d:%b%b%b%b/%b%b%b%b", e,
                   u_dut.phy.iDES8_MEM_13.Dd0_mem[e], u_dut.phy.iDES8_MEM_3.Dd0_mem[e],
                   u_dut.phy.iDES8_MEM_2.Dd0_mem[e], u_dut.phy.iDES8_MEM_1.Dd0_mem[e],
                   u_dut.phy.iDES8_MEM_13.Dd1_mem[e], u_dut.phy.iDES8_MEM_3.Dd1_mem[e],
                   u_dut.phy.iDES8_MEM_2.Dd1_mem[e], u_dut.phy.iDES8_MEM_1.Dd1_mem[e]);
        $write("  latch=%h\n", u_dut.coreArea_core.trainLatch);
    end

    // ---- optional VCD (plusarg +vcd, default OFF: t21 traces unchanged) ----
    // Window 3.19 -> 3.43 us: BIST write (~3275 ns) + survey reads + latch.
    // Run from simulation/ (run.py cwd): VCD lands next to the .log.
    // Usage: vvp t21_23.vvp +step=23 +trt=1 +vcd
    initial begin
        #1;
        if ($test$plusargs("vcd")) begin
            if (step_val == 23)
                $dumpfile("t21_23_shift.vcd");
            else
                $dumpfile("t21_25_shift.vcd");
            $dumpvars(0, tb_t21.u_dut.phy);
            $dumpvars(0, tb_t21.u_dut.coreArea_core);
            $dumpvars(1, tb_t21.dq);
            $dumpvars(1, tb_t21.dqs);
            $dumpvars(1, tb_t21.fclk);
            $dumpvars(1, tb_t21.pclk);
            $dumpvars(1, tb_t21.ck);
            $dumpoff;
            #3189000;
            $dumpon;
        end
    end

endmodule
