library ieee;
use ieee.std_logic_1164.all;


entity tb_clk_en is
end entity tb_clk_en;

architecture sim of tb_clk_en is

    constant C_CLK_PERIOD : time := 10 ns;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal ce_100hz : std_logic;
    signal ce_1khz  : std_logic;

begin


    dut : entity work.clk_en
        generic map (
            G_MAX_100HZ => 100,
            G_MAX_1KHZ  => 10
        )
        port map (
            clk      => clk,
            rst      => rst,
            ce_100hz => ce_100hz,
            ce_1khz  => ce_1khz
        );


    p_clk : process is
    begin
        clk <= '0';
        wait for C_CLK_PERIOD / 2;
        clk <= '1';
        wait for C_CLK_PERIOD / 2;
    end process p_clk;


    p_stim : process is
    begin
        
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
       
        wait for 5 us;

        report "Aplikuji reset uprostred behu";
        rst <= '1';
        wait for 100 ns;
        rst <= '0';

        wait for 2 us;

        report "Simulace dokoncena" severity note;
        wait;
    end process p_stim;

end architecture sim;