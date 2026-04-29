library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity lap_manager is
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
        -- vystupy
        display_data_out : out std_logic_vector(31 downto 0);
        lap_led_status   : out std_logic_vector(7 downto 0)
    );
end entity lap_manager;
 
architecture Behavioral of lap_manager is
 
    
    type t_lap_mem is array (0 to G_LAP_COUNT-1)
        of std_logic_vector(31 downto 0);
 
    signal lap_mem    : t_lap_mem := (others => (others => '0'));
 
    
    signal lap_count  : integer range 0 to G_LAP_COUNT := 0;
 
    
    signal view_idx   : integer range 0 to G_LAP_COUNT-1 := 0;
 
    
    signal view_mode  : std_logic := '0';
 
begin
 
    
    p_lap : process (clk) is
        variable v_idx : integer range 0 to G_LAP_COUNT-1;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                
                lap_mem    <= (others => (others => '0'));
                lap_count  <= 0;
                view_idx   <= 0;
                view_mode  <= '0';
 
            else
             
                if start_stop_tick = '1' then
                    view_mode <= '0';
                end if;
 
              
                if save_lap_tick = '1' and lap_count < G_LAP_COUNT then
                    lap_mem(lap_count) <= running_time_in;
                    lap_count          <= lap_count + 1;
                end if;
 
               
                if clear_all_tick = '1' then
                    lap_mem   <= (others => (others => '0'));
                    lap_count <= 0;
                    view_idx  <= 0;
                    view_mode <= '0';
                end if;
 
                
                if next_lap_tick = '1' and lap_count > 0 then
                    view_mode <= '1';
                    if view_mode = '0' then
                        
                        view_idx <= 0;
                    elsif view_idx < (lap_count - 1) then
                        view_idx <= view_idx + 1;
                    else
                        
                        view_idx <= 0;
                    end if;
                end if;
 
              
                if prev_lap_tick = '1' and lap_count > 0 then
                    view_mode <= '1';
                    if view_mode = '0' then
                        view_idx <= lap_count - 1;
                    elsif view_idx > 0 then
                        view_idx <= view_idx - 1;
                    else
                        view_idx <= lap_count - 1;
                    end if;
                end if;
 
                
                if delete_lap_tick = '1' and view_mode = '1'
                    and lap_count > 0 then
 
                    v_idx := view_idx;
 
                   
                    for i in 0 to G_LAP_COUNT-2 loop
                        if i >= v_idx then
                            lap_mem(i) <= lap_mem(i+1);
                        end if;
                    end loop;
                    lap_mem(G_LAP_COUNT-1) <= (others => '0');
 
                    
                    lap_count <= lap_count - 1;
 
                    
                    if (lap_count - 1) = 0 then
                        view_mode <= '0';
                        view_idx  <= 0;
                    elsif v_idx >= (lap_count - 1) then
                        view_idx <= lap_count - 2;
                    end if;
                end if;
 
            end if;
        end if;
    end process p_lap;
 
   
    display_data_out <= running_time_in when view_mode = '0'
                        else lap_mem(view_idx);
 
    lap_led_status(0) <= view_mode;
    lap_led_status(1) <= '1' when lap_count = G_LAP_COUNT else '0';
    lap_led_status(2) <= '0';
    lap_led_status(3) <= '0';
    lap_led_status(7 downto 4) <=
        std_logic_vector(to_unsigned(lap_count mod 16, 4));
 
end Behavioral;