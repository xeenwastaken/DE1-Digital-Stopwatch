library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity counter_top is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        ce_100hz   : in  std_logic;
        start_stop : in  std_logic;
        bcd_data   : out std_logic_vector(31 downto 0);
        running    : out std_logic
    );
end entity counter_top;
 
architecture Behavioral of counter_top is
 
    
    signal d_c_ones : unsigned(3 downto 0);  
    signal d_c_tens : unsigned(3 downto 0);  
    signal d_s_ones : unsigned(3 downto 0);  
    signal d_s_tens : unsigned(3 downto 0);  
    signal d_m_ones : unsigned(3 downto 0);  
    signal d_m_tens : unsigned(3 downto 0);  
    signal d_h_ones : unsigned(3 downto 0);  
    signal d_h_tens : unsigned(3 downto 0);  
 
    
    signal sig_running : std_logic;
 
begin
 

    p_bcd_counter : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                d_c_ones <= (others => '0');
                d_c_tens <= (others => '0');
                d_s_ones <= (others => '0');
                d_s_tens <= (others => '0');
                d_m_ones <= (others => '0');
                d_m_tens <= (others => '0');
                d_h_ones <= (others => '0');
                d_h_tens <= (others => '0');
                sig_running <= '0';
            else
 
                
                if start_stop = '1' then
                    sig_running <= not sig_running;
                end if;
 
                
                if (ce_100hz = '1') and (sig_running = '1') then
 
                   
                    if d_c_ones = 9 then
                        d_c_ones <= (others => '0');
 
                        
                        if d_c_tens = 9 then
                            d_c_tens <= (others => '0');
 
                            
                            if d_s_ones = 9 then
                                d_s_ones <= (others => '0');
 
                                
                                if d_s_tens = 5 then
                                    d_s_tens <= (others => '0');
 
                                    
                                    if d_m_ones = 9 then
                                        d_m_ones <= (others => '0');
 
                                        
                                        if d_m_tens = 5 then
                                            d_m_tens <= (others => '0');
 
                                            
                                            if d_h_ones = 9 then
                                                d_h_ones <= (others => '0');
 
                                                
                                                if d_h_tens = 9 then
                                                    
                                                    d_h_tens <= (others => '0');
                                                else
                                                    d_h_tens <= d_h_tens + 1;
                                                end if;
                                            else
                                                d_h_ones <= d_h_ones + 1;
                                            end if;
                                        else
                                            d_m_tens <= d_m_tens + 1;
                                        end if;
                                    else
                                        d_m_ones <= d_m_ones + 1;
                                    end if;
                                else
                                    d_s_tens <= d_s_tens + 1;
                                end if;
                            else
                                d_s_ones <= d_s_ones + 1;
                            end if;
                        else
                            d_c_tens <= d_c_tens + 1;
                        end if;
                    else
                        d_c_ones <= d_c_ones + 1;
                    end if;
                end if;
            end if;
        end if;
    end process p_bcd_counter;
 

    bcd_data <= std_logic_vector(d_h_tens) & std_logic_vector(d_h_ones) &
                std_logic_vector(d_m_tens) & std_logic_vector(d_m_ones) &
                std_logic_vector(d_s_tens) & std_logic_vector(d_s_ones) &
                std_logic_vector(d_c_tens) & std_logic_vector(d_c_ones);
 
    running <= sig_running;
 
end Behavioral;