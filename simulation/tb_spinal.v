//
// Test bench of Spinal-generated Ddr3ControllerSim vs Micron DDR3 model.
// Validates the new 128-bit BL8 write/read path + autonomous refresh.
// Mirrors nand2mario's tb_controller.v clocking.
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

    // Micron DDR3 memory module
    ddr3 sdramddr3_0 (
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
    initial begin
        force u_dut.phy.dll_1.LOCK = 1'b1;
        force u_dut.phy.dll_1.STEP = 8'd25;
    end

    real tck;
    initial begin
        $timeformat (-9, 1, " ns", 1);
        tck <= 2500;                // DDR-800, tck = 2.5ns
        fclk <= 1'b1;
        ck <= 1'b1;                 // 90-degree shifted fclk
        pclk <= 1'b1;               // 100 MHz
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
        $dumpfile("tb_spinal.vcd");
        $dumpvars(0, tb_spinal);
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
