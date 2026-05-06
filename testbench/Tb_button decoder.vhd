library ieee;
use ieee.std_logic_1164.all;

entity tb_button_decoder is
end entity tb_button_decoder;

architecture sim of tb_button_decoder is

    constant C_CLK_PERIOD : time := 10 ns;
    constant C_CE_PERIOD  : time := 100 ns;
    constant C_HOLD_TIME  : integer := 5;

    signal clk      : std_logic := '0';
    signal ce       : std_logic := '0';
    signal btn_in   : std_logic := '0';
    signal tick_out : std_logic;
    signal hold_out : std_logic;

begin

    dut : entity work.button_decoder
        generic map ( G_HOLD_TIME => C_HOLD_TIME )
        port map (
            clk      => clk,
            ce       => ce,
            btn_in   => btn_in,
            tick_out => tick_out,
            hold_out => hold_out
        );

    p_clk : process is
    begin
        clk <= '0';
        wait for C_CLK_PERIOD / 2;
        clk <= '1';
        wait for C_CLK_PERIOD / 2;
    end process p_clk;


    p_ce : process is
    begin
        ce <= '0';
        wait for C_CE_PERIOD - C_CLK_PERIOD;
        ce <= '1';
        wait for C_CLK_PERIOD;
    end process p_ce;

    p_stim : process is
    begin
        wait for 300 ns;

 
        report "TEST 1: Kratky stisk -> ocekavam tick_out";
        btn_in <= '1';
        wait for 250 ns;
        btn_in <= '0';
        wait for 500 ns;

 
        report "TEST 2: Dlouhy stisk -> ocekavam hold_out";
        btn_in <= '1';
        wait for 1000 ns;
        btn_in <= '0';
        wait for 500 ns;


        report "TEST 3: Druhy kratky stisk -> ocekavam tick_out";
        btn_in <= '1';
        wait for 250 ns;
        btn_in <= '0';
        wait for 500 ns;

        report "Simulace dokoncena" severity note;
        wait;
    end process p_stim;

end architecture sim;
