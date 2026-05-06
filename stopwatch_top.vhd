library ieee;
use ieee.std_logic_1164.all;

--Autor: Robert Martinec a Jakub Žalud

entity stopwatch_top is
    generic (
        G_MAX_100HZ : integer := 1000000;  
        G_MAX_1KHZ  : integer := 100000;   
        G_HOLD_TIME : integer := 1250      
    );
    port (
        CLK100MHZ : in  std_logic;
        BTNC      : in  std_logic;
        BTNU      : in  std_logic;
        BTND      : in  std_logic;
        BTNL      : in  std_logic;
        BTNR      : in  std_logic;
        SEG       : out std_logic_vector(6 downto 0);   
        DP        : out std_logic;                      
        AN        : out std_logic_vector(7 downto 0);   
        LED       : out std_logic_vector(15 downto 0)   
    );
end entity stopwatch_top;


architecture Behavioral of stopwatch_top is

  
    signal sig_rst : std_logic := '0';

    
    signal sig_ce_100hz : std_logic;
    signal sig_ce_1khz  : std_logic;

    
    signal sig_btnc_state, sig_btnc_press : std_logic;
    signal sig_btnu_state, sig_btnu_press : std_logic;
    signal sig_btnd_state, sig_btnd_press : std_logic;
    signal sig_btnl_state, sig_btnl_press : std_logic;
    signal sig_btnr_state, sig_btnr_press : std_logic;

    
    signal sig_start_stop_tick : std_logic;
    signal sig_reset_tick      : std_logic;

    
    signal sig_delete_tick     : std_logic;
    signal sig_clear_all_tick  : std_logic;

    signal sig_bcd_data : std_logic_vector(23 downto 0);

    signal sig_display_data : std_logic_vector(23 downto 0);

    signal sig_lap_led : std_logic_vector(9 downto 0);

begin

    clk_en_inst : entity work.clk_en
        generic map (
            G_MAX_100HZ => G_MAX_100HZ,
            G_MAX_1KHZ  => G_MAX_1KHZ
        )
        port map (
            clk      => CLK100MHZ,
            rst      => sig_rst,
            ce_100hz => sig_ce_100hz,
            ce_1khz  => sig_ce_1khz
        );

  
    deb_btnc : entity work.debounce
        port map (
            clk         => CLK100MHZ,
            rst         => sig_rst,
            ce          => sig_ce_1khz,
            btn_in      => BTNC,
            btn_state   => sig_btnc_state,
            btn_press   => sig_btnc_press,
            btn_release => open
        );

    deb_btnu : entity work.debounce
        port map (
            clk         => CLK100MHZ,
            rst         => sig_rst,
            ce          => sig_ce_1khz,
            btn_in      => BTNU,
            btn_state   => sig_btnu_state,
            btn_press   => sig_btnu_press,
            btn_release => open
        );

    deb_btnd : entity work.debounce
        port map (
            clk         => CLK100MHZ,
            rst         => sig_rst,
            ce          => sig_ce_1khz,
            btn_in      => BTND,
            btn_state   => sig_btnd_state,
            btn_press   => sig_btnd_press,
            btn_release => open
        );

    deb_btnl : entity work.debounce
        port map (
            clk         => CLK100MHZ,
            rst         => sig_rst,
            ce          => sig_ce_1khz,
            btn_in      => BTNL,
            btn_state   => sig_btnl_state,
            btn_press   => sig_btnl_press,
            btn_release => open
        );

    deb_btnr : entity work.debounce
        port map (
            clk         => CLK100MHZ,
            rst         => sig_rst,
            ce          => sig_ce_1khz,
            btn_in      => BTNR,
            btn_state   => sig_btnr_state,
            btn_press   => sig_btnr_press,
            btn_release => open
        );


    bd_btnc : entity work.button_decoder
        generic map ( G_HOLD_TIME => G_HOLD_TIME )
        port map (
            clk      => CLK100MHZ,
            ce       => sig_ce_1khz,
            btn_in   => sig_btnc_state,
            tick_out => sig_start_stop_tick,
            hold_out => sig_reset_tick
        );

  
    bd_btnl : entity work.button_decoder
        generic map ( G_HOLD_TIME => G_HOLD_TIME )
        port map (
            clk      => CLK100MHZ,
            ce       => sig_ce_1khz,
            btn_in   => sig_btnl_state,
            tick_out => sig_delete_tick,
            hold_out => sig_clear_all_tick
        );


    counter_inst : entity work.counter
        port map (
            clk        => CLK100MHZ,
            ce_100hz   => sig_ce_100hz,
            start_tick => sig_start_stop_tick,
            reset_tick => sig_reset_tick,
            bcd_data   => sig_bcd_data
        );


    lap_mgr_inst : entity work.lap_manager
        generic map ( G_LAP_DEPTH => 10 )
        port map (
            clk              => CLK100MHZ,
            current_time_in  => sig_bcd_data,
            start_stop_tick  => sig_start_stop_tick,
            reset_tick       => sig_reset_tick,
            next_lap_tick    => sig_btnu_press,
            prev_lap_tick    => sig_btnd_press,
            delete_lap_tick  => sig_delete_tick,
            clear_all_tick   => sig_clear_all_tick,
            save_lap_tick    => sig_btnr_press,
            lap_led_status   => sig_lap_led,
            display_data_out => sig_display_data
        );

  
    disp_inst : entity work.display_driver
        port map (
            clk     => CLK100MHZ,
            reset   => sig_rst,
            ce_1khz => sig_ce_1khz,
            data_in => sig_display_data,
            seg     => SEG,
            dp      => DP,
            an      => AN
        );

    
    LED(9 downto 0)   <= sig_lap_led;
    LED(15 downto 10) <= (others => '0');

end Behavioral;
