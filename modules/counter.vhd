library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port (
        clk        : in  std_logic;
        ce_100hz   : in  std_logic;                     
        start_tick : in  std_logic;                      
        reset_tick : in  std_logic;                      
        bcd_data   : out std_logic_vector(23 downto 0)   
    );
end entity counter;



architecture Behavioral of counter is

    
    signal sig_running : std_logic := '0';

    
    signal sig_cs_l : unsigned(3 downto 0) := (others => '0');  
    signal sig_cs_h : unsigned(3 downto 0) := (others => '0');  
    signal sig_s_l  : unsigned(3 downto 0) := (others => '0');  
    signal sig_s_h  : unsigned(3 downto 0) := (others => '0');  
    signal sig_m_l  : unsigned(3 downto 0) := (others => '0');  
    signal sig_m_h  : unsigned(3 downto 0) := (others => '0');  

begin

    
    p_counter : process (clk) is
    begin
        if rising_edge(clk) then

            if reset_tick = '1' then
                sig_running <= '0';
                sig_cs_l <= (others => '0');
                sig_cs_h <= (others => '0');
                sig_s_l  <= (others => '0');
                sig_s_h  <= (others => '0');
                sig_m_l  <= (others => '0');
                sig_m_h  <= (others => '0');

            elsif start_tick = '1' then
                sig_running <= not sig_running;

            elsif sig_running = '1' and ce_100hz = '1' then
               
                if sig_cs_l = 9 then
                    sig_cs_l <= (others => '0');
                    if sig_cs_h = 9 then
                        sig_cs_h <= (others => '0');
                        if sig_s_l = 9 then
                            sig_s_l <= (others => '0');
                            if sig_s_h = 5 then
                                sig_s_h <= (others => '0');
                                if sig_m_l = 9 then
                                    sig_m_l <= (others => '0');
                                    if sig_m_h = 9 then
                                        sig_m_h <= (others => '0');
                                    else
                                        sig_m_h <= sig_m_h + 1;
                                    end if;
                                else
                                    sig_m_l <= sig_m_l + 1;
                                end if;
                            else
                                sig_s_h <= sig_s_h + 1;
                            end if;
                        else
                            sig_s_l <= sig_s_l + 1;
                        end if;
                    else
                        sig_cs_h <= sig_cs_h + 1;
                    end if;
                else
                    sig_cs_l <= sig_cs_l + 1;
                end if;
            end if;

        end if;
    end process p_counter;

   
    bcd_data <= std_logic_vector(sig_m_h)  & std_logic_vector(sig_m_l)  &
                std_logic_vector(sig_s_h)  & std_logic_vector(sig_s_l)  &
                std_logic_vector(sig_cs_h) & std_logic_vector(sig_cs_l);

end Behavioral;
