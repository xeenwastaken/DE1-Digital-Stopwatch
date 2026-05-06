library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_lap_manager is
end entity tb_lap_manager;

architecture sim of tb_lap_manager is

    constant C_CLK_PERIOD : time := 10 ns;
    constant C_LAP_DEPTH  : integer := 4;

    signal clk              : std_logic := '0';
    signal current_time_in  : std_logic_vector(23 downto 0) := (others => '0');
    signal start_stop_tick  : std_logic := '0';
    signal reset_tick       : std_logic := '0';
    signal next_lap_tick    : std_logic := '0';
    signal prev_lap_tick    : std_logic := '0';
    signal delete_lap_tick  : std_logic := '0';
    signal save_lap_tick    : std_logic := '0';
    signal lap_led_status   : std_logic_vector(C_LAP_DEPTH - 1 downto 0);
    signal display_data_out : std_logic_vector(23 downto 0);

    
    procedure pulse (signal s : out std_logic) is
    begin
        s <= '1';
        wait for C_CLK_PERIOD;
        s <= '0';
        wait for C_CLK_PERIOD;
    end procedure;

begin


    dut : entity work.lap_manager
        generic map ( G_LAP_DEPTH => C_LAP_DEPTH )
        port map (
            clk              => clk,
            current_time_in  => current_time_in,
            start_stop_tick  => start_stop_tick,
            reset_tick       => reset_tick,
            next_lap_tick    => next_lap_tick,
            prev_lap_tick    => prev_lap_tick,
            delete_lap_tick  => delete_lap_tick,
            save_lap_tick    => save_lap_tick,
            lap_led_status   => lap_led_status,
            display_data_out => display_data_out
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
        wait for 100 ns;

   
        report "SAVE #1 (cas 00:01.11)";
        current_time_in <= x"000111";
        wait for 50 ns;
        pulse(save_lap_tick);

        report "SAVE #2 (cas 00:02.22)";
        current_time_in <= x"000222";
        wait for 50 ns;
        pulse(save_lap_tick);

        report "SAVE #3 (cas 00:03.33)";
        current_time_in <= x"000333";
        wait for 50 ns;
        pulse(save_lap_tick);

        report "SAVE #4 (cas 00:04.44) - pamet plna";
        current_time_in <= x"000444";
        wait for 50 ns;
        pulse(save_lap_tick);

        report "SAVE #5 - mel by byt ignorovan";
        current_time_in <= x"000555";
        wait for 50 ns;
        pulse(save_lap_tick);
        wait for 100 ns;

        report "PREV LAP - display by mel ukazat slot 0 (000111)";
        pulse(prev_lap_tick);
        wait for 200 ns;

        report "NEXT LAP - display by mel ukazat slot 1 (000222)";
        pulse(next_lap_tick);
        wait for 200 ns;

        report "NEXT LAP - display by mel ukazat slot 2 (000333)";
        pulse(next_lap_tick);
        wait for 200 ns;

        report "NEXT LAP - display by mel ukazat slot 3 (000444)";
        pulse(next_lap_tick);
        wait for 200 ns;

        report "DELETE - smazani slotu 3, display by mel ukazat 000333";
        pulse(delete_lap_tick);
        wait for 200 ns;

        report "PREV PREV - posun na slot 0 (000111)";
        pulse(prev_lap_tick);
        wait for 200 ns;
        pulse(prev_lap_tick);
        wait for 200 ns;

        report "DELETE - smazani slotu 0, display by mel ukazat 000222";
        pulse(delete_lap_tick);
        wait for 200 ns;

        report "START_STOP - opusteni browse rezimu";
        current_time_in <= x"000999";
        wait for 50 ns;
        pulse(start_stop_tick);
        wait for 200 ns;

        report "RESET - vyprazdneni pameti";
        pulse(reset_tick);
        wait for 300 ns;

        report "Simulace dokoncena" severity note;
        wait;
    end process p_stim;

end architecture sim;
