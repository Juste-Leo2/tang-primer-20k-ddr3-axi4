// t20 — arrêt précoce sur verdict survey. Init NATURELLE (zéro force sauf
// ancre LOCK/STEP comme tb_fast). Moniteur : fin de survey (retombée
// rcalib_tries ou dllSweepOn) -> lire bestCnt : 8 -> PASS+finish,
// 6 -> compte, 4x -> finish. DUT = Ddr3ControllerSim GENERE (Scala).
// Harnais, pas DUT. Verdict : T20 PASS / T20 ... / T20 FAIL.
`timescale 1ps / 1ps

module tb_t20;

    `define sg125
    `include "1024Mb_ddr3_parameters.vh"

    reg                         rst_n;
    reg                         ck;
    wire                        ck_n = ~ck;
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
    initial begin
        step_val = 25;
        void'($value$plusargs("step=%d", step_val));
        force u_dut.phy.dll_1.LOCK = 1'b1;
        force u_dut.phy.dll_1.STEP = step_val[7:0];
        $display("T20 anchor step=%0d", step_val);
        $fflush();
    end

    real tck;
    initial begin
        $timeformat(-9, 1, " ns", 1);
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

    integer prev_tries;
    integer n6;
    integer tries_now;
    integer best_now;
    integer score_now;
    reg sweep_now;

    // Fast-pass : dès que best==8 apparaît (n'importe quel sel/pos/tries),
    // succès immédiat sans attendre la fin du survey. A 25 : tries=001.
    // (bestCnt vaut 0/X avant la première mesure : pas de faux déclenchement.)
    initial begin : fastpass
        wait (u_dut.coreArea_core.bestCnt == 8);
        $display("T20 PASS best=8 t=%t", $time);
        $fflush();
        $finish(0);
    end

    initial begin : monitor
        prev_tries = 0;
        n6 = 0;
        #(10000);
        $display("T20 monitor start");
        $fflush();
        while ($time < 300_000_000) begin
            #(1_000_000);
            tries_now = u_dut.coreArea_core.rcalib_tries;
            best_now = u_dut.coreArea_core.bestCnt;
            sweep_now = u_dut.coreArea_core.dllSweepOn;
            score_now = u_dut.coreArea_core.rotScoreW_7;
            $display("... t=%t st=%d tries=%0d score=%0d best=%0d scan=%b sweep=%b n6=%0d",
                     $time, u_dut.coreArea_core.state, tries_now, score_now,
                     best_now, u_dut.coreArea_core.scanOn, sweep_now, n6);
            $fflush();
            // Assert sur le SCORE (la mesure), pas best/sel : X = latch
            // pas encore rempli -> X==8 et X==6 sont faux, ignorés.
            if (score_now == 8) begin
                $display("T20 PASS score=8");
                $fflush();
                $finish(0);
            end else if (score_now == 6) begin
                n6 = n6 + 1;
                $display("T20 score=6 n6=%0d", n6);
                $fflush();
                if (n6 >= 4) begin
                    $display("T20 best=6 confirme (4 polls)");
                    $fflush();
                    $finish(0);
                end
            end
            prev_tries = tries_now;
        end
        $display("T20 FAIL global timeout");
        $fflush();
        $finish(1);
    end

    initial begin : test
        resetn <= 1'b0;
        req_valid <= 1'b0; req_write <= 1'b0;
        req_addr <= 0; req_wdata <= 0; req_strb <= 0;
        #(10000);
        @(negedge ck) resetn = 1'b1;
    end

endmodule
