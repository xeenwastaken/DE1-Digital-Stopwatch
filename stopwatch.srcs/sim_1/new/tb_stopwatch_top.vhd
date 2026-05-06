library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_stopwatch_top is
end entity tb_stopwatch_top;

architecture sim of tb_stopwatch_top is

    
    constant C_MAX_100HZ : integer := 100;  
    constant C_MAX_1KHZ  : integer := 10;    
    constant C_HOLD_TIME : integer := 20;    

    
    constant C_CLK_PERIOD : time := 10 ns;

    
    signal clk100mhz : std_logic := '0';
    signal btnc      : std_logic := '0';
    signal btnu      : std_logic := '0';
    signal btnd      : std_logic := '0';
    signal btnl      : std_logic := '0';
    signal btnr      : std_logic := '0';

   
    signal seg : std_logic_vector(6 downto 0);
    signal dp  : std_logic;
    signal an  : std_logic_vector(7 downto 0);
    signal led : std_logic_vector(15 downto 0);

    
    procedure press_button (signal btn : out std_logic; constant duration : in time) is
    begin
        btn <= '1';
        wait for duration;
        btn <= '0';
        wait for 5 us;  
    end procedure;

begin


    dut : entity work.stopwatch_top
        generic map (
            G_MAX_100HZ => C_MAX_100HZ,
            G_MAX_1KHZ  => C_MAX_1KHZ,
            G_HOLD_TIME => C_HOLD_TIME
        )
        port map (
            CLK100MHZ => clk100mhz,
            BTNC      => btnc,
            BTNU      => btnu,
            BTND      => btnd,
            BTNL      => btnl,
            BTNR      => btnr,
            SEG       => seg,
            DP        => dp,
            AN        => an,
            LED       => led
        );

 
    p_clk : process is
    begin
        clk100mhz <= '0';
        wait for C_CLK_PERIOD / 2;
        clk100mhz <= '1';
        wait for C_CLK_PERIOD / 2;
    end process p_clk;

    
    p_stim : process is
    begin
        
        wait for 10 us;

        
        report "START - kratky stisk BTNC";
        press_button(btnc, 500 ns);

        
        wait for 50 us;

        
        report "SAVE LAP #1";
        press_button(btnl, 500 ns);
        wait for 30 us;

        
        report "SAVE LAP #2";
        press_button(btnl, 500 ns);
        wait for 30 us;

        
        report "SAVE LAP #3";
        press_button(btnl, 500 ns);
        wait for 20 us;

     
        report "STOP - kratky stisk BTNC";
        press_button(btnc, 500 ns);
        wait for 10 us;

       
        report "PREV LAP (BTND)";
        press_button(btnd, 500 ns);
        wait for 10 us;

        
        report "PREV LAP (BTND)";
        press_button(btnd, 500 ns);
        wait for 10 us;

        
        report "NEXT LAP (BTNU)";
        press_button(btnu, 500 ns);
        wait for 10 us;

        
        report "DELETE LAP (BTNR)";
        press_button(btnr, 500 ns);
        wait for 10 us;

       
        report "RESET - dlouhy stisk BTNC (2 us sim)";
        btnc <= '1';
        wait for 5 us;       
        btnc <= '0';
        wait for 10 us;

        report "Simulace dokoncena" severity note;
        wait;
    end process p_stim;

end architecture sim;