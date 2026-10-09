//
// Fast capture-mapping test bench: Spinal-generated Ddr3ControllerSim vs the
// Micron DDR3 model, IDENTICAL physics to tb_spinal.v (same vendor Gowin
// primitives, same Micron model) with three changes only:
//
//   1. Micron DEBUG = 0: the vendor model prints one INFO line per beat and one
//      per command. Those $display calls dominate the run time and say nothing
//      we need here. JEDEC violation reports are also silenced (tb_spinal.v
//      stays the compliance oracle).
//   2. STEP_VAL: the DLL STEP output is normally forced to 25. This is the
//      read-side delay tap, i.e. one axis of the alignment we need to map.
//   3. PHASE_PS: permanent offset between pclk and ck/fclk, i.e. the second
//      axis. tb_spinal pins it to a single value (all clocks share one ratio).
//
// Fidelity gate: this TB must reproduce tb_spinal.v's 32-setting survey table
// (score/rot per pos,sel) at STEP=25, PHASE_PS=0. If it does, the vendor
// capture path is intact and only the environment differs.
//
// Compile-time knobs (via iverilog -D):
// Runtime plusargs (one build serves the whole matrix):
//   +step=<0..255>     DLL STEP tap (default 25)
//   +phase=<ps>        permanent pclk offset vs ck/fclk (default 0)
// Compile-time:
//   NO_VCD             skip VCD
//   MAP_ONLY           stop after calibration (skip the functional memtest)
//

`timescale 1ps / 1ps

module tb_spinal;

    // sg125=DDR3-1600 params file, but our clocks run DDR3-800 (slower => ok)
    `define sg125
    `include "1024Mb_ddr3_parameters.vh"

    // DDR3 ports
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

    // Controller-side stimulus
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

    // Micron DDR3 memory module. DEBUG=0: per-beat INFO logging is the main
    // cost of tb_spinal.v and carries no information for mapping purposes.
    ddr3 #(.DEBUG(0)) sdramddr3_0 (
        ddr_nrst, ddr_ck, ~ddr_ck, cke,
        cs_n, ras_n, cas_n, we_n,
        dm, ba, a, dq, dqs, dqs_n,
        tdqs_n, odt
    );

    // Spinal-generated controller under test
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

    // Gowin global-reset model: prim_sim DLL references `GSR.GSRO`
    // hierarchically, so an instance literally named GSR is required.
    // NOTE: no GSR instance (name collides with prim_sim GSR.GSRO refs); DLL grstn tied high in prim_sim_tb.v
    // SIM cheat like nand2mario's `SIM (dlllock=1, dllstep=25):
    // force the Gowin DLL model output instead of waiting 33600 fclk cycles.
    //
    // Both mapping axes are RUNTIME plusargs, so one build serves the whole
    // matrix: vvp tb_fast.vvp +step=64 +phase=312
    //   step  : DLL STEP = read-side delay tap (default 25, what tb_spinal pins)
    //   phase : permanent pclk offset vs ck/fclk in ps (default 0)
    //   mag0/magN : window-scan (default 0/0 = classic full sweep). A nonzero
    //     magN scans plus-side mags [mag0, mag0+magN) then reports WINDOW and
    //     finishes (diag only). Requires a MAP_ONLY build (no memtest).
    integer step_val, phase_val, wl_val, k_val, eff_step;
    integer mag0_val, magN_val, anchor_step;
    initial begin
        step_val = 25;
        phase_val = 0;
        wl_val = -1;
        k_val = 0;
        eff_step = 25;
        mag0_val = 0;
        magN_val = 0;
        anchor_step = -1;
        void'($value$plusargs("step=%d", step_val));
        void'($value$plusargs("phase=%d", phase_val));
        void'($value$plusargs("wl=%d", wl_val));
        void'($value$plusargs("k=%d", k_val));
        void'($value$plusargs("mag0=%d", mag0_val));
        void'($value$plusargs("magN=%d", magN_val));
        void'($value$plusargs("anchor_step=%d", anchor_step));
        eff_step = (step_val + k_val) & 255;
        force u_dut.phy.dll_1.LOCK = 1'b1;
        // K experiment: STEP + K is what actually reaches the DQS primitives.
        // Forcing the DLL port is equivalent to offsetting the assignment in
        // RTL (GowinDdr3Phy: u_dqs.io.DLLSTEP := dllstep + K), so the window can
        // be measured before writing any RTL. Both are constant in time, so a
        // one-shot force is equivalent to a continuous one.
        force u_dut.phy.dll_1.STEP = eff_step[7:0];
        // Window-scan regs (default 0 = full sweep). Forced like LOCK above:
        // same hierarchical-force precedent, constant in time.
        force u_dut.coreArea_core.sweepMag0 = mag0_val[6:0];
        force u_dut.coreArea_core.sweepMagN = magN_val[6:0];
        $display("MAP step=%0d phase_ps=%0d wl=%0d k=%0d eff=%0d mag0=%0d magN=%0d anchor_step=%0d",
                 step_val, phase_val, wl_val, k_val, eff_step, mag0_val, magN_val, anchor_step);
        $fflush();
    end

    // Anchor/survey decomposition: survey runs at eff_step (force above),
    // then on sweep start re-force STEP to anchor_step (if >= 0) BEFORE the
    // sweep's own anchor (anchorLeft reload) samples it. Precedent: WLOVR
    // below (event-driven re-force). survey23/anchor25 = +step=23
    // +anchor_step=25; survey25/anchor23 = +step=25 +anchor_step=23.
    always @(posedge u_dut.coreArea_core.dllSweepOn) begin
        if (anchor_step >= 0) begin
            force u_dut.phy.dll_1.STEP = anchor_step[7:0];
            $display("ANCHOR switch STEP %0d -> %0d at sweep start", eff_step, anchor_step);
            $fflush();
        end
    end

    // WSTEP override, applied once write leveling has locked. Forcing the net
    // that feeds the PHY (not the core register) leaves the WL FSM intact and
    // only changes what the DQS delay line uses from then on: the read
    // calibration then runs with WSTEP = wl instead of the echo-locked value.
    // Used to test whether the capture needs (WSTEP == STEP) or a specific
    // STEP: Micron's model pins the echo window, so WSTEP cannot be moved from
    // the RTL side without disturbing the search.
    always @(posedge wlevel_done) begin
        if (wl_val >= 0) begin
            force u_dut.coreArea_core_io_phy_wstep = wl_val[7:0];
            $display("WLOVR force WSTEP=%0d after write leveling", wl_val);
            $fflush();
        end
    end

    // VCD micro-window: trigger on sweep start (dllSweepOn rises at the
    // survey->sweep hand-off), dump the anchor + first mags, stop. Covers
    // the pin release + first post-pin measurements (the H1 zone).
    // Usage: +vcdwinlen=<ps> (≈250000/iter at pclk 100MHz; 2500000 ≈ 10
    // iters). 0 = off. Needs a --vcd build (read compiled out under NO_VCD).
    integer vcdwin_len;
    initial begin
        vcdwin_len = 0;
`ifndef NO_VCD
        void'($value$plusargs("vcdwinlen=%d", vcdwin_len));
`endif
        if (vcdwin_len != 0) begin
            wait (u_dut.coreArea_core.dllSweepOn === 1'b1);
            $dumpfile($sformatf("tb_fast_win_s%0d_m%0d.vcd", step_val, mag0_val));
            $dumpvars(0, tb_spinal);
            #(vcdwin_len);
            $display("VCDWIN done (%0d ns), finishing", vcdwin_len);
            $fflush();
            $finish(0);
        end
    end

    real tck;
    integer phase_done;
    initial begin
        $timeformat (-9, 1, " ns", 1);
        tck <= 2500;                // DDR-800, tck = 2.5ns
        fclk <= 1'b1;
        ck <= 1'b1;                 // 90-degree shifted fclk
        pclk <= 1'b1;               // 100 MHz
        phase_done = 0;
        forever begin
            #(tck/4) ck = ~ck;
            #(tck/4) fclk = ~fclk;
            #(tck/4) ck = ~ck;
            #(tck/4) fclk = ~fclk;
            #(tck/4) ck = ~ck;
            #(tck/4) fclk = ~fclk;
            #(tck/4) ck = ~ck;
            #(tck/4) fclk = ~fclk;
            // One-shot offset: shifts every later pclk edge (and only those)
            // by phase_val ps, so pclk keeps its nominal period but its phase
            // against ck/fclk moves. tb_spinal.v has this permanently at 0.
            if (phase_done == 0) begin
                phase_done = 1;
                #(phase_val);
            end
            pclk = ~pclk;
        end
    end

    // Cycle-accurate debug monitor (remove once calib understood)
    always @(posedge pclk) begin
        if (!init_done && $time > 100000) begin
            $display("DBG t=%t st=%d cyc=%d dqsrd=%h rburst=%b wstep=%h pos=%d sel=%d",
                $time, u_dut.coreArea_core.state, u_dut.coreArea_core.cycle,
                u_dut.coreArea_core_io_phy_dqs_read, u_dut.phy_io_rburst,
                wstep, rclkpos, rclksel);
            $fflush();
        end
    end

    // TEMP-PROBE-REMOVE-AFTER-DIAG: pointer movie (S23: rstep climbs but
    // latches frozen -> do WPOINT/RPOINT advance?). Per-pclk, both DQS.
    always @(posedge pclk) begin
        if ($time > 100000) begin
            $display("PROBE t=%t RLOADN=%b RMOVE=%b RDIR=%b rstep1=%h rstep2=%h RPOINT1=%d WPOINT1=%d RPOINT2=%d WPOINT2=%d rd_en1=%b dqs_en1=%b HOLD=%b",
                $time, u_dut.phy.dQS_1.RLOADN, u_dut.phy.dQS_1.RMOVE,
                u_dut.phy.dQS_1.RDIR, u_dut.phy.dQS_1.rstep_reg,
                u_dut.phy.dQS_2.rstep_reg, u_dut.phy.dQS_1.RPOINT,
                u_dut.phy.dQS_1.WPOINT, u_dut.phy.dQS_2.RPOINT,
                u_dut.phy.dQS_2.WPOINT, u_dut.phy.dQS_1.rd_en,
                u_dut.phy.dQS_1.dqs_en, u_dut.phy.dQS_1.HOLD);
            $fflush();
        end
    end

    integer errors;
    time start_time;

    task dowrite(input [26:0] blk, input [127:0] v);
        begin
            wait(req_ready == 1'b1);
            @(posedge pclk);
            req_valid <= 1'b1;
            req_write <= 1'b1;
            req_addr  <= blk;
            req_wdata <= v;
            req_strb  <= 16'hFFFF;
            @(posedge pclk);
            req_valid <= 1'b0;
            $display("WRITE blk=%h data=%h", blk, v);
            $fflush();
            @(posedge pclk);
            wait(req_ready == 1'b1);
        end
    endtask

    task doread(input [26:0] blk, input [127:0] expected);
        integer to_cnt;
        begin
            wait(req_ready == 1'b1);
            @(posedge pclk);
            req_valid <= 1'b1;
            req_write <= 1'b0;
            req_addr  <= blk;
            @(posedge pclk);
            req_valid <= 1'b0;
            to_cnt = 0;
            while (!rsp_valid && to_cnt < 200) begin
                @(posedge pclk);
                to_cnt = to_cnt + 1;
            end
            if (!rsp_valid) begin
                $display("ERROR: timeout waiting for rsp_valid at blk %h at %t", blk, $time);
            end
            $display("DEBUG_READ t=%t to_cnt=%d rsp_valid=%b pos=%d sel=%d rburst=%b dqsrd=%h hold=%b wpt=%h/%h rpt=%h/%h [0]=%h [1]=%h [2]=%h [3]=%h [4]=%h [5]=%h [6]=%h [7]=%h",
                $time, to_cnt, rsp_valid, rclkpos, rclksel, u_dut.phy_io_rburst,
                u_dut.coreArea_core_io_phy_dqs_read, u_dut.coreArea_core_io_phy_dqs_hold,
                u_dut.phy.dqs_waddr_0, u_dut.phy.dqs_waddr_1,
                u_dut.phy.dqs_raddr_0, u_dut.phy.dqs_raddr_1,
                u_dut.phy_io_dq_in_0, u_dut.phy_io_dq_in_1, u_dut.phy_io_dq_in_2, u_dut.phy_io_dq_in_3,
                u_dut.phy_io_dq_in_4, u_dut.phy_io_dq_in_5, u_dut.phy_io_dq_in_6, u_dut.phy_io_dq_in_7);
            $display("READ  blk=%h got=%h expected=%h %s", blk, rsp_rdata, expected,
                     (rsp_rdata === expected) ? "OK" : "MISMATCH");
            $fflush();
            if (rsp_rdata !== expected) begin
                $display("ERROR: mismatch at blk %h", blk);
                errors = errors + 1;
            end
            @(posedge pclk);
            wait(req_ready == 1'b1);
        end
    endtask

    localparam [127:0] PAT0 = 128'h88887777666655554444333322221111;
    localparam [127:0] PAT1 = 128'h0123456789ABCDEFFEDCBA9876543210;
    localparam [127:0] PAT2 = 128'hDEADBEEFCAFEBABE12345678ABCDEF01;

    initial begin : test
`ifndef NO_VCD
        // Full VCD (opt-in, huge): +vcdfull=1. Micro-window (diag default):
        // +vcdwinlen=<ns> dumps only [sweep-start, +len] into a per-point
        // file, then $finish: short run, MB-size VCD, no kill needed.
        // Filenames carry step/mag so parallel runs never collide.
        begin
            integer vcdfull;
            vcdfull = 0;
            void'($value$plusargs("vcdfull=%d", vcdfull));
            if (vcdfull != 0) begin
                $dumpfile("tb_fast.vcd");
                $dumpvars(0, tb_spinal);
            end
        end
`endif
        errors = 0;
        $display("Powering up and reset the controller");
        $fflush();
        resetn <= 1'b0;
        req_valid <= 1'b0; req_write <= 1'b0;
        req_addr <= 0; req_wdata <= 0; req_strb <= 0;
        #(10000);
        @(negedge ck) resetn = 1'b1;

        start_time = $time;
        #0.01;
        while (!init_done && $time < start_time + 300_000_000) begin
            #(1_000_000); // 1 us heartbeat (vvp file output is buffered: flush!)
            $display("... waiting init t=%t wlevel=%b rcalib=%b wstep=%h pos=%d sel=%d",
                     $time, wlevel_done, rcalib_done, wstep, rclkpos, rclksel);
            $fflush();
        end
        if (!init_done) begin
            $display("ERROR: init_done timeout. wlevel=%b rcalib=%b wstep=%h pos=%d sel=%d",
                     wlevel_done, rcalib_done, wstep, rclkpos, rclksel);
            $finish(1);
        end
        $display("[SPINAL-OK] W=%h P=%d S=%d", wstep, rclkpos, rclksel);
        $fflush();

`ifndef MAP_ONLY
        // Phase 1: single-burst write/read (block 0 mirrors the HW memtest)
        dowrite(27'h0000000, PAT1);
        doread(27'h0000000, PAT1);
        dowrite(27'h0000100, PAT0);
        dowrite(27'h0000200, PAT1);
        dowrite(27'h0001040, PAT2);
        doread(27'h0000100, PAT0);
        doread(27'h0000200, PAT1);
        doread(27'h0001040, PAT2);

        // Phase 2: short soak past several (sim) autonomous refreshes, re-verify.
        // Sim refresh period = 200 pclk (2 us), so 1 us covers ~5 refreshes.
        #(1_000_000);
        doread(27'h0000000, PAT1);
        doread(27'h0000100, PAT0);
        doread(27'h0000200, PAT1);
        doread(27'h0001040, PAT2);

`else
        // Mapping mode: calibration only. The functional memtest is not part
        // of the map (C comes from the calibration sweep) and would add run
        // time for nothing.
        errors = 0;
`endif

        // Single-line verdict for the mapping driver: STEP, phase, write tap,
        // locked read setting, error count. rot/C come from the DUT's own
        // "NOTE RCALIB lock" report line just above.
        $display("RESULT step=%0d phase_ps=%0d wl=%0d W=%h P=%d S=%d errors=%0d %s",
                 step_val, phase_val, wl_val, wstep, rclkpos, rclksel, errors,
                 (errors == 0) ? "PASS" : "FAIL");
        $fflush();

        if (errors == 0) begin
            $display("SPINAL SIM: ALL TESTS PASSED");
            $fflush();
        end else begin
            $display("SPINAL SIM: %d ERRORS", errors);
            $fflush();
        end
        $finish(0);
    end

endmodule
