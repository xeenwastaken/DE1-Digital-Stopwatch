library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce is
end entity tb_debounce;

architecture sim of tb_debounce is

    constant C_CLK_PERIOD : time := 10 ns;
    constant C_CE_PERIOD  : time := 100 ns;  

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal ce          : std_logic := '0';
    signal btn_in      : std_logic := '0';
    signal btn_state   : std_logic;
    signal btn_press   : std_logic;
    signal btn_release : std_logic;

begin

 
    dut : entity work.debounce
        port map (
            clk         => clk,
            rst         => rst,
            ce          => ce,
            btn_in      => btn_in,
            btn_state   => btn_state,
            btn_press   => btn_press,
            btn_release => btn_release
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
        -- 1) Reset
        rst <= '1';
        wait for 200 ns;
        rst <= '0';
        wait for 300 ns;

    
        report "TEST 1: Kratky glitch (mel by byt odfiltrovan)";
        btn_in <= '1';
        wait for 150 ns;      
        btn_in <= '0';
        wait for 500 ns;

        
        report "TEST 2: Zakmitavajici stisk - bounce, pak stabilni '1'";
        btn_in <= '1'; wait for 80 ns;
        btn_in <= '0'; wait for 80 ns;
        btn_in <= '1'; wait for 80 ns;
        btn_in <= '0'; wait for 80 ns;
        btn_in <= '1';            
        wait for 1000 ns;         

 
        wait for 500 ns;
      
        report "TEST 3: Uvolneni - mel by pulznout btn_release";
        btn_in <= '0'; wait for 80 ns;
        btn_in <= '1'; wait for 80 ns;
        btn_in <= '0';           
        wait for 1000 ns;

        report "Simulace dokoncena" severity note;
        wait;
    end process p_stim;

end architecture sim;
