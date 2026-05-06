library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lap_manager is
    generic (
        G_LAP_DEPTH : integer := 10 
    );
    port (
        clk              : in  std_logic;
        current_time_in  : in  std_logic_vector(23 downto 0);             
        start_stop_tick  : in  std_logic;                                 
        reset_tick       : in  std_logic;                                
        next_lap_tick    : in  std_logic;                                 
        prev_lap_tick    : in  std_logic;                                 
        delete_lap_tick  : in  std_logic;                                 
        save_lap_tick    : in  std_logic;                                 
        lap_led_status   : out std_logic_vector(G_LAP_DEPTH - 1 downto 0);
        display_data_out : out std_logic_vector(23 downto 0)              
    );
end entity lap_manager;



architecture Behavioral of lap_manager is

    
    type t_lap_mem is array (0 to G_LAP_DEPTH - 1) of std_logic_vector(23 downto 0);
    signal sig_lap_mem    : t_lap_mem := (others => (others => '0'));

    
    signal sig_occupied   : std_logic_vector(G_LAP_DEPTH - 1 downto 0) := (others => '0');

    
    signal sig_lap_count  : integer range 0 to G_LAP_DEPTH := 0;

  
    signal sig_view_index : integer range 0 to G_LAP_DEPTH - 1 := 0;

    
    signal sig_browse     : std_logic := '0';

begin

    p_lap_manager : process (clk) is
    begin
        if rising_edge(clk) then

            
            if reset_tick = '1' then
                sig_lap_mem    <= (others => (others => '0'));
                sig_occupied   <= (others => '0');
                sig_lap_count  <= 0;
                sig_view_index <= 0;
                sig_browse     <= '0';

            
            elsif save_lap_tick = '1' then
                if sig_lap_count < G_LAP_DEPTH then
                    sig_lap_mem(sig_lap_count)  <= current_time_in;
                    sig_occupied(sig_lap_count) <= '1';
                    sig_lap_count               <= sig_lap_count + 1;
                end if;

            
            elsif delete_lap_tick = '1' then
                if sig_browse = '1' and sig_lap_count > 0 then
                    
                    for i in 0 to G_LAP_DEPTH - 2 loop
                        if i >= sig_view_index then
                            sig_lap_mem(i)  <= sig_lap_mem(i + 1);
                            sig_occupied(i) <= sig_occupied(i + 1);
                        end if;
                    end loop;
                    sig_lap_mem(G_LAP_DEPTH - 1)  <= (others => '0');
                    sig_occupied(G_LAP_DEPTH - 1) <= '0';
                    sig_lap_count <= sig_lap_count - 1;

                    
                    if sig_lap_count = 1 then
                        sig_view_index <= 0;
                        sig_browse     <= '0';
                    elsif sig_view_index = sig_lap_count - 1 then
                        sig_view_index <= sig_view_index - 1;
                    end if;
                end if;

         
            elsif next_lap_tick = '1' then
                if sig_lap_count > 0 then
                    sig_browse <= '1';
                    if sig_view_index < sig_lap_count - 1 then
                        sig_view_index <= sig_view_index + 1;
                    end if;
                end if;

            
            elsif prev_lap_tick = '1' then
                if sig_lap_count > 0 then
                    sig_browse <= '1';
                    if sig_view_index > 0 then
                        sig_view_index <= sig_view_index - 1;
                    end if;
                end if;

         
            elsif start_stop_tick = '1' then
                sig_browse <= '0';
            end if;

        end if;
    end process p_lap_manager;

    
    display_data_out <= sig_lap_mem(sig_view_index) when sig_browse = '1'
                        else current_time_in;

    
    lap_led_status <= sig_occupied;

end Behavioral;
