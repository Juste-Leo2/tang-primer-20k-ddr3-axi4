// t02 — loi du mover write : init DLLSTEP+WSTEP (X4, saturé 255),
// suivi wstep_reg sous WLOADN=0, WFLAG aux bornes.
// DUT = primitive DQS vendor seule. Squelette uniquement.
`timescale 1ns / 1ps
`include "prim_sim_tb.v"

module tb_t02;
    reg fclk, pclk;
    `include "clocks.v"

    reg reset;
    reg [7:0] dllstep, wstep;
    reg wloadn, wmove, wdir;

    wire dqsr90, dqsw0, dqsw270;
    wire [2:0] rpoint, wpoint;
    wire rvalid, rburst, rflag, wflag;

    DQS #(.DQS_MODE("X4"), .HWL("false")) u_dqs (
        .DQSR90(dqsr90), .DQSW0(dqsw0), .DQSW270(dqsw270),
        .RPOINT(rpoint), .WPOINT(wpoint),
        .RVALID(rvalid), .RBURST(rburst), .RFLAG(rflag), .WFLAG(wflag),
        .DQSIN(1'b0), .DLLSTEP(dllstep), .WSTEP(wstep),
        .READ(4'b0), .RLOADN(1'b1), .RMOVE(1'b0), .RDIR(1'b0),
        .WLOADN(wloadn), .WMOVE(wmove), .WDIR(wdir),
        .HOLD(1'b0), .RCLKSEL(3'b0), .PCLK(pclk), .FCLK(fclk), .RESET(reset)
    );

    integer errors;

    task check_init(input [7:0] d, input [7:0] w, input [7:0] want);
    begin
        dllstep = d; wstep = w; #(40);
        if (u_dqs.wstep_init !== want) begin
            $display("T02 FAIL init(%0d,%0d)=%0d want=%0d",
                     d, w, u_dqs.wstep_init, want);
            errors = errors + 1;
        end
    end
    endtask

    initial begin
        $timeformat(-9, 1, " ns", 1);
        errors = 0;
        reset = 1'b1; wloadn = 1'b1; wmove = 1'b0; wdir = 1'b0;
        dllstep = 8'd0; wstep = 8'd0;
        #(100); reset = 1'b0; #(50);

        // C1 : init = DLLSTEP+WSTEP saturé à 255 (X4)
        check_init(23, 25, 48);
        check_init(25, 25, 50);
        check_init(23, 27, 50);   // cas pair23 : même wstep_init que TB-25
        check_init(0, 0, 0);
        check_init(100, 100, 200);
        check_init(200, 100, 255); // saturation somme
        check_init(255, 255, 255);
        check_init(255, 0, 255);
        check_init(0, 255, 255);

        // C2 : WLOADN=0 -> wstep_reg suit wstep_init en direct
        // (le PHY met WLOADN=False en permanence)
        wloadn = 1'b0;
        dllstep = 8'd23; wstep = 8'd25; #(40);
        if (u_dqs.wstep_reg !== 8'd48) begin
            $display("T02 FAIL follow=%0d want=48", u_dqs.wstep_reg);
            errors = errors + 1;
        end
        wstep = 8'd27; #(40); // WLOVR : le registre suit sans reload
        if (u_dqs.wstep_reg !== 8'd50) begin
            $display("T02 FAIL follow2=%0d want=50", u_dqs.wstep_reg);
            errors = errors + 1;
        end
        wloadn = 1'b1; #(20);

        // C3 : WFLAG aux bornes (WDIR posé avant, cf. piège RFLAG t01)
        wdir = 1'b0; wloadn = 1'b0; dllstep = 8'd255; wstep = 8'd0; #(40);
        if (u_dqs.wstep_reg !== 8'd255 || wflag !== 1'b1) begin
            $display("T02 FAIL sat-hi reg=%0d flag=%b", u_dqs.wstep_reg, wflag);
            errors = errors + 1;
        end
        wdir = 1'b1; dllstep = 8'd0; #(40);
        if (u_dqs.wstep_reg !== 8'd0 || wflag !== 1'b1) begin
            $display("T02 FAIL sat-lo reg=%0d flag=%b", u_dqs.wstep_reg, wflag);
            errors = errors + 1;
        end
        wdir = 1'b0; dllstep = 8'd23; wstep = 8'd25; #(40);
        if (wflag !== 1'b0) begin
            $display("T02 FAIL mid flag=%b", wflag);
            errors = errors + 1;
        end
        wloadn = 1'b1; #(20);

        if (errors == 0) $display("T02 PASS");
        else $display("T02 FAIL errors=%0d", errors);
        $finish(0);
    end
endmodule
