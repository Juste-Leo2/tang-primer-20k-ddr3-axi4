// common/clocks.v — squelette horloges partagé (inclus, jamais copié).
// A inclure APRES déclaration de `reg fclk, pclk;` dans le TB.
// fclk 400 MHz (2.5 ns), pclk 100 MHz (10 ns), fronts alignés à t=0.
initial begin
    fclk = 1'b0;
    pclk = 1'b0;
end
always #(1.25) fclk = ~fclk;
always #(5) pclk = ~pclk;
