// t03c — transport à tout-forcé, sans WL ni RCALIB. Ancre par +step=.
// Init JEDEC gardée (Micron), WL+RCALIB sautés, WSTEP=19 + taps forcés.
// 1 write + 1 read. DUT = Ddr3ControllerSim GENERE depuis le Scala.
// Harnais, pas DUT. Verdict : T03C PASS / T03C FAIL + détail.
`timescale 1ps / 1ps

module tb_t03c;

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
        $display("T03C anchor step=%0d", step_val);
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

    integer errors;
    integer meas_ok;
    time start_time;

    task dowrite(input [26:0] blk, input [127:0] v);
        integer stable;
        time t0;
        reg [5:0] wpt_prev;
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
            @(posedge pclk);
            wait(req_ready == 1'b1);
            // Fin REELLE du burst en 2 temps : d'abord attendre qu'il
            // COMMENCE (WPOINT bouge), puis qu'il finisse (stable).
            // Sans le temps 1, on conclut "fini" sur WPOINT figé AVANT
            // le burst — le stop-trop-tôt du 10/10.
            wpt_prev = {u_dut.phy.dqs_waddr_0, u_dut.phy.dqs_waddr_1};
            t0 = $time;
            while ({u_dut.phy.dqs_waddr_0, u_dut.phy.dqs_waddr_1} == wpt_prev &&
                   ($time - t0) < 10000000) @(posedge pclk);
            if ({u_dut.phy.dqs_waddr_0, u_dut.phy.dqs_waddr_1} == wpt_prev) begin
                $display("T03C FAIL burst jamais commence blk=%h", blk);
                errors = errors + 1;
            end
            wpt_prev = {u_dut.phy.dqs_waddr_0, u_dut.phy.dqs_waddr_1};
            stable = 0;
            t0 = $time;
            while (stable < 20 && ($time - t0) < 10000000) begin
                @(posedge pclk);
                if ({u_dut.phy.dqs_waddr_0, u_dut.phy.dqs_waddr_1} == wpt_prev)
                    stable = stable + 1;
                else begin
                    stable = 0;
                    wpt_prev = {u_dut.phy.dqs_waddr_0, u_dut.phy.dqs_waddr_1};
                end
            end
            if (stable < 20) begin
                $display("T03C FAIL burst jamais fini blk=%h", blk);
                errors = errors + 1;
            end
            $display("T03C wrote blk=%h wpt=%h/%h", blk,
                     u_dut.phy.dqs_waddr_0, u_dut.phy.dqs_waddr_1);
            $fflush();
        end
    endtask

    task doread_meas(input [26:0] blk, input [127:0] expected);
        integer to_cnt;
        begin
            meas_ok = 1;
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
                meas_ok = 0;
                $display("T03C read NO RSP blk=%h to_cnt=%0d", blk, to_cnt);
            end else if (rsp_rdata !== expected) begin
                meas_ok = 0;
                $display("T03C read MISMATCH blk=%h got=%h exp=%h",
                         blk, rsp_rdata, expected);
            end else begin
                $display("T03C read OK blk=%h", blk);
            end
            $display("T03C DBG pos=%d sel=%d rburst=%b dqsrd=%h rstep=%0d/%0d",
                     rclkpos, rclksel, u_dut.phy_io_rburst,
                     u_dut.coreArea_core_io_phy_dqs_read,
                     u_dut.phy.dQS_1.rstep_reg, u_dut.phy.dQS_2.rstep_reg);
            $fflush();
            @(posedge pclk);
            wait(req_ready == 1'b1);
        end
    endtask

    task goto_rstep(input integer target);
        integer base, n, k;
        begin
            base = u_dut.phy.dll_1.STEP;
            force u_dut.phy.dQS_1.RLOADN = 1'b0;
            force u_dut.phy.dQS_2.RLOADN = 1'b0;
            #(40000);
            release u_dut.phy.dQS_1.RLOADN;
            release u_dut.phy.dQS_2.RLOADN;
            #(20000);
            if (target >= base) begin
                force u_dut.phy.dQS_1.RDIR = 1'b0;
                force u_dut.phy.dQS_2.RDIR = 1'b0;
                n = target - base;
            end else begin
                force u_dut.phy.dQS_1.RDIR = 1'b1;
                force u_dut.phy.dQS_2.RDIR = 1'b1;
                n = base - target;
            end
            for (k = 0; k < n; k = k + 1) begin
                force u_dut.phy.dQS_1.RMOVE = 1'b1;
                force u_dut.phy.dQS_2.RMOVE = 1'b1;
                #(20000);
                force u_dut.phy.dQS_1.RMOVE = 1'b0;
                force u_dut.phy.dQS_2.RMOVE = 1'b0;
                #(20000);
            end
            release u_dut.phy.dQS_1.RDIR;
            release u_dut.phy.dQS_2.RDIR;
            release u_dut.phy.dQS_1.RMOVE;
            release u_dut.phy.dQS_2.RMOVE;
            #(20000);
            if (u_dut.phy.dQS_1.rstep_reg !== target[7:0] ||
                u_dut.phy.dQS_2.rstep_reg !== target[7:0]) begin
                $display("T03C FAIL pose rstep1=%0d rstep2=%0d want=%0d",
                         u_dut.phy.dQS_1.rstep_reg,
                         u_dut.phy.dQS_2.rstep_reg, target);
                errors = errors + 1;
            end
        end
    endtask

    localparam [127:0] PAT1 = 128'h0123456789ABCDEFFEDCBA9876543210;

    // Heartbeat : voir où ça coince en temps réel (tail du log).
    // S'arrête tout seul quand init_done se lève.
    initial begin : hb
        #(10000);
        while (!init_done && $time < 300_000_000) begin
            #(1_000_000);
            $display("... t=%t st=%d wl=%b rc=%b init=%b wstep=%h busy=%b",
                     $time, u_dut.coreArea_core.state,
                     wlevel_done, rcalib_done, init_done, wstep,
                     u_dut.coreArea_core.busy);
            $fflush();
        end
    end

    initial begin : test
        errors = 0;
        resetn <= 1'b0;
        req_valid <= 1'b0; req_write <= 1'b0;
        req_addr <= 0; req_wdata <= 0; req_strb <= 0;
        #(10000);
        @(negedge ck) resetn = 1'b1;
        start_time = $time;
        #0.01;

        // 1. Init JEDEC gardée : attendre l'entrée en WRITE_LEVELING (st=4),
        // puis sauter WL + RCALIB (IDLE + done forcés, WSTEP=19 forcé).
        // wlevel_done AUSSI forcé : on saute le WL, son flag ne se lèverait
        // jamais tout seul — c'est LUI qui bloquait init_done en v1
        // (diagnostic 10/10 : silence après "Jedec done").
        while (u_dut.coreArea_core.state !== 4'd4 &&
               ($time - start_time) < 100000000) #(1000000);
        if (u_dut.coreArea_core.state !== 4'd4) begin
            $display("T03C FAIL no WL entry st=%d t=%t",
                     u_dut.coreArea_core.state, $time);
            $finish(1);
        end
        $display("T03C Jedec done, skipping WL+RCALIB");
        $fflush();
        force u_dut.coreArea_core.state = 4'd6;
        force u_dut.coreArea_core.rcalib_done = 1'b1;
        force u_dut.coreArea_core.wlevel_done = 1'b1;
        force u_dut.coreArea_core.training = 1'b0;
        force u_dut.coreArea_core.busy = 1'b0;
        force u_dut.coreArea_core_io_phy_wstep = 8'd19;
        while (!init_done && ($time - start_time) < 100000000) #(1000000);
        if (!init_done) begin
            $display("T03C FAIL no init_done st=%d wl=%b rc=%b busy=%b",
                     u_dut.coreArea_core.state, wlevel_done, rcalib_done,
                     u_dut.coreArea_core.busy);
            $finish(1);
        end
        release u_dut.coreArea_core.state;
        $display("T03C shortcut to IDLE");
        $fflush();

        // 2. Taps read identiques + rstep -> 25
        force u_dut.coreArea_core.rclkpos = 2'd0;
        force u_dut.coreArea_core.rclksel = 3'd0;
        goto_rstep(25);

        // 3. Une transition : 1 write + 1 read
        dowrite(27'h0000000, PAT1);
        doread_meas(27'h0000000, PAT1);
        $display("T03C readback -> %s", meas_ok ? "OK" : "KO");
        $fflush();

        if (errors == 0 && meas_ok) $display("T03C PASS");
        else $display("T03C FAIL errors=%0d meas_ok=%0d", errors, meas_ok);
        $finish(0);
    end

    initial begin : watchdog
        #(1_000_000_000);
        $display("T03C FAIL global timeout");
        $fflush();
        $finish(1);
    end

endmodule
