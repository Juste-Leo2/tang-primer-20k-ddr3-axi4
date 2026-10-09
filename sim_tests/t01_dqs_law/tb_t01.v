// t01 — loi du mover read : reload, stepping, saturation, pas de 25 ps.
// DUT = primitive DQS vendor seule (prim_sim_tb.v), DQS_MODE X4 comme hw/gen.
// DLLSTEP piloté par registre (= force d'ancre de tb_fast.v:152).
// Squelette uniquement : stimulus + checks, aucune logique DUT.
`timescale 1ns / 1ps
`include "prim_sim_tb.v"

module tb_t01;
    reg fclk, pclk;
    `include "clocks.v"

    reg reset;
    reg [7:0] dllstep;
    reg rloadn, rmove, rdir;

    wire dqsr90, dqsw0, dqsw270;
    wire [2:0] rpoint, wpoint;
    wire rvalid, rburst, rflag, wflag;

    DQS #(.DQS_MODE("X4"), .HWL("false")) u_dqs (
        .DQSR90(dqsr90), .DQSW0(dqsw0), .DQSW270(dqsw270),
        .RPOINT(rpoint), .WPOINT(wpoint),
        .RVALID(rvalid), .RBURST(rburst), .RFLAG(rflag), .WFLAG(wflag),
        .DQSIN(1'b0), .DLLSTEP(dllstep), .WSTEP(8'd0),
        .READ(4'b0), .RLOADN(rloadn), .RMOVE(rmove), .RDIR(rdir),
        .WLOADN(1'b1), .WMOVE(1'b0), .WDIR(1'b0),
        .HOLD(1'b0), .RCLKSEL(3'b0), .PCLK(pclk), .FCLK(fclk), .RESET(reset)
    );

    integer errors;
    integer i;
    reg [7:0] steps [0:6];

    task check_rstep(input [7:0] want, input [255:0] tag);
    begin
        if (u_dqs.rstep_reg !== want) begin
            $display("T01 FAIL %0s: rstep=%0d want=%0d", tag, u_dqs.rstep_reg, want);
            errors = errors + 1;
        end
    end
    endtask

    task pulse_rmove;
    begin
        // 1 slot à 1 + gap : exactement UN front descendant
        rmove = 1'b1; #(20); rmove = 1'b0; #(20);
    end
    endtask

    task reload(input [7:0] s);
    begin
        dllstep = s; rloadn = 1'b0; #(40);
        check_rstep(s, "reload");
        rloadn = 1'b1; #(20);
    end
    endtask

    initial begin
        $timeformat(-9, 1, " ns", 1);
        errors = 0;
        steps[0] = 0; steps[1] = 1; steps[2] = 23; steps[3] = 25;
        steps[4] = 26; steps[5] = 127; steps[6] = 255;

        reset = 1'b1; rloadn = 1'b1; rmove = 1'b0; rdir = 1'b0; dllstep = 8'd0;
        #(100); reset = 1'b0; #(50);

        // B : pas de 25 ps (l'unité de toute la chaîne de retards)
        if (u_dqs.del < 0.0249 || u_dqs.del > 0.0251) begin
            $display("T01 FAIL del=%f (want 0.025)", u_dqs.del);
            errors = errors + 1;
        end

        // A1 : reload = DLLSTEP sur 7 valeurs (dont 23/25/26, 0, 255)
        for (i = 0; i < 7; i = i + 1) reload(steps[i]);

        // A2 : cas pair23 — ancre 23, +2 pulses isolés -> 25 pile
        reload(8'd23);
        rdir = 1'b0; pulse_rmove; pulse_rmove;
        check_rstep(8'd25, "23+2");

        // A2b : -3 depuis 25 -> 22
        reload(8'd25);
        rdir = 1'b1; pulse_rmove; pulse_rmove; pulse_rmove;
        check_rstep(8'd22, "25-3");

        // A2c : slot tenu à 1 (3 pclk, SANS gap) = UN seul pas (piège :14194)
        reload(8'd40);
        rdir = 1'b0; rmove = 1'b1; #(60); rmove = 1'b0; #(20);
        check_rstep(8'd41, "held-slot");

        // A3 : saturation haute — 255 +plus reste 255, RFLAG=1
        reload(8'd255);
        rdir = 1'b0; pulse_rmove;
        check_rstep(8'd255, "sat-hi");
        if (rflag !== 1'b1) begin
            $display("T01 FAIL sat-hi RFLAG=%b", rflag);
            errors = errors + 1;
        end

        // A3b : saturation basse — 0 +minus reste 0, RFLAG=1.
        // Ordre RTL : RDIR AVANT le reload (RFLAG ne se recalcule que
        // quand rstep_reg change : RDIR posé après = RFLAG stale).
        rdir = 1'b1; reload(8'd0);
        pulse_rmove;
        check_rstep(8'd0, "sat-lo");
        if (rflag !== 1'b1) begin
            $display("T01 FAIL sat-lo RFLAG=%b", rflag);
            errors = errors + 1;
        end

        // A3c : PIEGE MODELE verrouillé — RFLAG stale après changement de
        // RDIR sans mouvement rstep (sensibilité = rstep_reg seul).
        // Ici sans effet (loin des bornes), mais documenté en dur.
        reload(8'd25);
        rdir = 1'b0; #(20);
        if (rflag !== 1'b0) begin
            $display("T01 FAIL mid RFLAG=%b", rflag);
            errors = errors + 1;
        end
        rdir = 1'b1; #(20); // changement de direction SANS mouvement...
        if (rflag !== 1'b0) begin
            $display("T01 FAIL stale RFLAG=%b (want stale 0)", rflag);
            errors = errors + 1;
        end
        pulse_rmove; // ...mais loin des bornes le step reste juste
        check_rstep(8'd24, "stale-step");

        if (errors == 0) $display("T01 PASS");
        else $display("T01 FAIL errors=%0d", errors);
        $finish(0);
    end
endmodule
