library ieee;
use ieee.std_logic_1164.all;


entity tb_counter is
end entity tb_counter;

architecture sim of tb_counter is

    constant C_CLK_PERIOD : time := 10 ns;
    constant C_CE_PERIOD  : time := 100 ns; 

    signal clk        : std_logic := '0';
    signal ce_100hz   : std_logic := '0';
    signal start_tick : std_logic := '0';
    signal reset_tick : std_logic := '0';
    signal bcd_data   : std_logic_vector(23 downto 0);

begin

    dut : entity work.counter
        port map (
            clk        => clk,
            ce_100hz   => ce_100hz,
            start_tick => start_tick,
            reset_tick => reset_tick,
            bcd_data   => bcd_data
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
        ce_100hz <= '0';
        wait for C_CE_PERIOD - C_CLK_PERIOD;
        ce_100hz <= '1';
        wait for C_CLK_PERIOD;
    end process p_ce;


    p_stim : process is
    begin
        wait for 300 ns;

  
        report "START - puls start_tick";
        start_tick <= '1';
        wait for C_CLK_PERIOD;
        start_tick <= '0';


        wait for 12 us;

        report "STOP - puls start_tick";
        start_tick <= '1';
        wait for C_CLK_PERIOD;
        start_tick <= '0';
        wait for 2 us;       

      
        report "RESTART - puls start_tick";
        start_tick <= '1';
        wait for C_CLK_PERIOD;
        start_tick <= '0';
        wait for 3 us;

    
        report "RESET - puls reset_tick";
        reset_tick <= '1';
        wait for C_CLK_PERIOD;
        reset_tick <= '0';
        wait for 1 us;

        report "Simulace dokoncena" severity note;
        wait;
    end process p_stim;

end architecture sim;