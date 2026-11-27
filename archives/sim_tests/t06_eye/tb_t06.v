// t06 — oeil read : DQS + IDES seuls, burst edge-aligned 1010 par le TB,
// RMOVE +-5 autour de l'ancre (+s=), 1 mesure par point. Secondes wall.
// DUT = primitives vendor (pas de source Scala, comme t01/t02).
// Squelette : stimulus + checks, dqs_en forcé (on mesure la capture).
`timescale 1ns / 1ps
`include "prim_sim_tb.v"

module tb_t06;
    reg fclk, pclk;
    `include "clocks.v"

    reg reset;
    reg [7:0] dllstep;
    reg rloadn, rmove, rdir;
    reg dqsin_tb, dq_tb;

    wire dqsr90, dqsw0, dqsw270;
    wire [2:0] rpoint, wpoint;
    wire rvalid, rburst, rflag, wflag;
    wire q0, q1, q2, q3, q4, q5, q6, q7;

    DQS #(.DQS_MODE("X4"), .HWL("false")) u_dqs (
        .DQSR90(dqsr90), .DQSW0(dqsw0), .DQSW270(dqsw270),
        .RPOINT(rpoint), .WPOINT(wpoint),
        .RVALID(rvalid), .RBURST(rburst), .RFLAG(rflag), .WFLAG(wflag),
        .DQSIN(dqsin_tb), .DLLSTEP(dllstep), .WSTEP(8'd0),
        .READ(4'b0), .RLOADN(rloadn), .RMOVE(rmove), .RDIR(rdir),
        .WLOADN(1'b1), .WMOVE(1'b0), .WDIR(1'b0),
        .HOLD(1'b0), .RCLKSEL(3'b0), .PCLK(pclk), .FCLK(fclk), .RESET(reset)
    );

    IDES8_MEM u_ides (
        .Q0(q0), .Q1(q1), .Q2(q2), .Q3(q3),
        .Q4(q4), .Q5(q5), .Q6(q6), .Q7(q7),
        .D(dq_tb), .WADDR(wpoint), .RADDR(rpoint),
        .CALIB(1'b0), .PCLK(pclk), .FCLK(fclk), .ICLK(dqsr90), .RESET(reset)
    );

    integer errors;
    integer s_val, off, b;
    reg meas_ok;
    reg [7:0] qbyte;

    task pulse_rmove;
    begin
        rmove = 1'b1; #(5); rmove = 1'b0; #(5);
    end
    endtask

    // 1 burst BL8 edge-aligned 1010 + mesure. qbyte OK ssi rotation de 1010.
    task measure;
    begin
        for (b = 0; b < 8; b = b + 1) begin
            dq_tb = (b % 2 == 0);
            dqsin_tb = ~dqsin_tb;
            #(1.25);
        end
        repeat (4) @(posedge pclk);
        #(1);
        qbyte = {q7, q6, q5, q4, q3, q2, q1, q0};
        meas_ok = (qbyte === 8'hAA || qbyte === 8'h55);
    end
    endtask

    initial begin
        $timeformat(-9, 1, " ns", 1);
        errors = 0;
        s_val = 25;
        void'($value$plusargs("s=%d", s_val));
        $display("T06 anchor S=%0d", s_val);

        reset = 1'b1; rloadn = 1'b1; rmove = 1'b0; rdir = 1'b0;
        dllstep = s_val[7:0]; dqsin_tb = 1'b0; dq_tb = 1'b0;
        #(100); reset = 1'b0; #(50);
        force u_dqs.dqs_en = 1'b1;

        // Chauffe : vide les résidus de reset (non mesuré)
        for (b = 0; b < 8; b = b + 1) begin
            dq_tb = (b % 2 == 0);
            dqsin_tb = ~dqsin_tb;
            #(1.25);
        end
        repeat (3) @(posedge pclk);

        // Reload à l'ancre puis balayage par pas de 2 (bords à ~50 ps près)
        rloadn = 1'b0; #(20); rloadn = 1'b1; #(10);
        for (off = -15; off <= 15; off = off + 2) begin
            // re-reload à chaque point (base propre), puis navigate
            rloadn = 1'b0; #(20); rloadn = 1'b1; #(10);
            if (off >= 0) begin
                rdir = 1'b0;
                for (b = 0; b < off; b = b + 1) pulse_rmove;
            end else begin
                rdir = 1'b1;
                for (b = 0; b < -off; b = b + 1) pulse_rmove;
            end
            measure;
            $display("T06 S=%0d off=%0d rstep=%0d q=%h -> %s",
                     s_val, off, u_dqs.rstep_reg, qbyte,
                     meas_ok ? "OK" : "KO");
            $fflush();
        end

        $display("T06 PASS");
        $finish(0);
    end
endmodule
