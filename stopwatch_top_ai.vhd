library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity stopwatch_top is
    port (
        
        CLK100MHZ : in  std_logic;
        BTNC      : in  std_logic;
        BTNU      : in  std_logic;
        BTND      : in  std_logic;
        BTNL      : in  std_logic;
        BTNR      : in  std_logic;
        -- 7-segmentovy displej (active-low)
        CA, CB, CC, CD, CE_seg, CF, CG : out std_logic;
        DP        : out std_logic;
        AN        : out std_logic_vector(7 downto 0);
        -- Stavove LEDky
        LED       : out std_logic_vector(7 downto 0)
    );
end entity stopwatch_top;
 
architecture Behavioral of stopwatch_top is
 
    -- Komponenty z uzivatelskych souboru
    component clk_en is
        generic (
            G_MAX_100HZ : integer := 1000000;
            G_MAX_1KHZ  : integer := 100000
        );
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            -- ce_in : in std_logic; -- OPRAVENO: Tento radek byl smazan, do děličky hodin nepatří
            ce_100hz : out std_logic;
            ce_1khz  : out std_logic
        );
    end component clk_en;
 
    component debounce is
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            ce_in       : in  std_logic;
            btn_in      : in  std_logic;
            btn_state   : out std_logic;
            btn_press   : out std_logic;
            btn_release : out std_logic
        );
    end component debounce;
 
    component button_decoder is
        generic (
            G_HOLD_TIME : integer := 1250
        );
        port (
            clk      : in  std_logic;
            ce       : in  std_logic;
            btn_in   : in  std_logic;
            tick_out : out std_logic;
            hold_out : out std_logic
        );
    end component button_decoder;
 
    component display_driver is
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            ce_1khz : in  std_logic;
            data0, data1, data2, data3 : in std_logic_vector(3 downto 0);
            data4, data5, data6, data7 : in std_logic_vector(3 downto 0);
            seg     : out std_logic_vector(6 downto 0);
            dig     : out std_logic_vector(7 downto 0)
        );
    end component display_driver;
 
    component counter_top is
        port (
            clk        : in  std_logic;
            rst        : in  std_logic;
            ce_100hz   : in  std_logic;
            start_stop : in  std_logic;
            bcd_data   : out std_logic_vector(31 downto 0);
            running    : out std_logic
        );
    end component counter_top;
 
    component lap_manager is
        generic (
            G_LAP_COUNT : positive := 16
        );
        port (
            clk              : in  std_logic;
            rst              : in  std_logic;
            running_time_in  : in  std_logic_vector(31 downto 0);
            start_stop_tick  : in  std_logic;
            save_lap_tick    : in  std_logic;
            next_lap_tick    : in  std_logic;
            prev_lap_tick    : in  std_logic;
            delete_lap_tick  : in  std_logic;
            clear_all_tick   : in  std_logic;
            display_data_out : out std_logic_vector(31 downto 0);
            lap_led_status   : out std_logic_vector(7 downto 0)
        );
    end component lap_manager;
 
    
    -- Clock enables
    signal sig_ce_100hz : std_logic;
    signal sig_ce_1khz  : std_logic;
 
    -- Vystupy z debouncer-u  (state, press)
    signal sig_btnc_state, sig_btnc_press : std_logic;
    signal sig_btnu_state, sig_btnu_press : std_logic;
    signal sig_btnd_state, sig_btnd_press : std_logic;
    signal sig_btnl_state, sig_btnl_press : std_logic;
    signal sig_btnr_state, sig_btnr_press : std_logic;
    signal sig_dummy_release              : std_logic;
 
    -- Vystupy z BUTTON_DECODER-u
    signal sig_start_stop     : std_logic;  -- BTNC tick
    signal sig_complete_reset : std_logic;  -- BTNC hold
    signal sig_delete_lap     : std_logic;  -- BTNL tick
    signal sig_clear_all      : std_logic;  -- BTNL hold
 
    -- Datove sbernice
    signal sig_running_time : std_logic_vector(31 downto 0);
    signal sig_display_data : std_logic_vector(31 downto 0);
    signal sig_running      : std_logic;
 
    -- 7-seg vystup
    signal sig_seg : std_logic_vector(6 downto 0);
 
    -- LED stav z LAP_MANAGER-u
    signal sig_lap_led : std_logic_vector(7 downto 0);
 
begin
 
 
    clk_gen : clk_en
        generic map (
            G_MAX_100HZ => 1_000_000,
            G_MAX_1KHZ  => 100_000
        )
        port map (
            clk      => CLK100MHZ,
            rst      => '0',
            ce_100hz => sig_ce_100hz,
            ce_1khz  => sig_ce_1khz
        );
 
    
    deb_btnc : debounce
        port map (
            clk         => CLK100MHZ,
            rst         => '0',
            ce_in       => sig_ce_100hz, -- PŘIDÁNO
            btn_in      => BTNC,
            btn_state   => sig_btnc_state,
            btn_press   => sig_btnc_press,
            btn_release => sig_dummy_release
        );
 
    deb_btnu : debounce
        port map (
            clk         => CLK100MHZ,
            rst         => '0',
            ce_in       => sig_ce_100hz, -- PŘIDÁNO
            btn_in      => BTNU,
            btn_state   => sig_btnu_state,
            btn_press   => sig_btnu_press,
            btn_release => open
        );
 
    deb_btnd : debounce
        port map (
            clk         => CLK100MHZ,
            rst         => '0',
            ce_in       => sig_ce_100hz, -- PŘIDÁNO
            btn_in      => BTND,
            btn_state   => sig_btnd_state,
            btn_press   => sig_btnd_press,
            btn_release => open
        );
 
    deb_btnl : debounce
        port map (
            clk         => CLK100MHZ,
            rst         => '0',
            ce_in       => sig_ce_100hz, -- PŘIDÁNO
            btn_in      => BTNL,
            btn_state   => sig_btnl_state,
            btn_press   => sig_btnl_press,
            btn_release => open
        );
 
    deb_btnr : debounce
        port map (
            clk         => CLK100MHZ,
            rst         => '0',
            ce_in       => sig_ce_100hz, -- PŘIDÁNO
            btn_in      => BTNR,
            btn_state   => sig_btnr_state,
            btn_press   => sig_btnr_press,
            btn_release => open
        );
 
 
    dec_btnc : button_decoder
        generic map ( G_HOLD_TIME => 1250 )
        port map (
            clk      => CLK100MHZ,
            ce       => sig_ce_1khz,
            btn_in   => sig_btnc_state,
            tick_out => sig_start_stop,
            hold_out => sig_complete_reset
        );
 
    dec_btnl : button_decoder
        generic map ( G_HOLD_TIME => 1250 )
        port map (
            clk      => CLK100MHZ,
            ce       => sig_ce_1khz,
            btn_in   => sig_btnl_state,
            tick_out => sig_delete_lap,
            hold_out => sig_clear_all
        );

    cnt_inst : counter_top
        port map (
            clk        => CLK100MHZ,
            rst        => sig_complete_reset,
            ce_100hz   => sig_ce_100hz,
            start_stop => sig_start_stop,
            bcd_data   => sig_running_time,
            running    => sig_running
        );
 
    
    lap_inst : lap_manager
        generic map ( G_LAP_COUNT => 16 )
        port map (
            clk              => CLK100MHZ,
            rst              => sig_complete_reset,
            running_time_in  => sig_running_time,
            start_stop_tick  => sig_start_stop,
            save_lap_tick    => sig_btnr_press,
            next_lap_tick    => sig_btnu_press,
            prev_lap_tick    => sig_btnd_press,
            delete_lap_tick  => sig_delete_lap,
            clear_all_tick   => sig_clear_all,
            display_data_out => sig_display_data,
            lap_led_status   => sig_lap_led
        );
 
   
    disp_inst : display_driver
        port map (
            clk     => CLK100MHZ,
            reset   => sig_complete_reset,
            ce_1khz => sig_ce_1khz,
            data0   => sig_display_data(3  downto 0),
            data1   => sig_display_data(7  downto 4),
            data2   => sig_display_data(11 downto 8),
            data3   => sig_display_data(15 downto 12),
            data4   => sig_display_data(19 downto 16),
            data5   => sig_display_data(23 downto 20),
            data6   => sig_display_data(27 downto 24),
            data7   => sig_display_data(31 downto 28),
            seg     => sig_seg,
            dig     => AN
        );
 
   
    CA     <= sig_seg(6);
    CB     <= sig_seg(5);
    CC     <= sig_seg(4);
    CD     <= sig_seg(3);
    CE_seg <= sig_seg(2);
    CF     <= sig_seg(1);
    CG     <= sig_seg(0);
 
   
    DP <= '1';
 
   
    LED(0)          <= sig_running;
    LED(1)          <= sig_lap_led(0);
    LED(2)          <= sig_lap_led(1);
    LED(3)          <= '0';
    LED(7 downto 4) <= sig_lap_led(7 downto 4);
 
end Behavioral;