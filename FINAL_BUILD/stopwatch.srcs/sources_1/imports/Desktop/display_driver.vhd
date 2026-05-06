library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- autor: Jakub Žalud // Zdroje: Cvičení DE1 - github.com/tomas-fryza/vhdl-examples

entity display_driver is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        ce_1khz : in  std_logic;
        data_in : in  std_logic_vector(23 downto 0);   
        seg     : out std_logic_vector(6 downto 0);    
        dp      : out std_logic;                     
        an      : out std_logic_vector(7 downto 0)     
    );
end display_driver;

architecture Behavioral of display_driver is
    signal sig_cnt : unsigned(2 downto 0) := "000";
    signal sig_hex : std_logic_vector(3 downto 0);
begin

    
    with sig_cnt select
        sig_hex <= data_in( 3 downto  0) when "000",   
                   data_in( 7 downto  4) when "001",   
                   data_in(11 downto  8) when "010",   
                   data_in(15 downto 12) when "011",   
                   data_in(19 downto 16) when "100",   
                   data_in(23 downto 20) when "101",   
                   "0000"                 when others; 

    decoder_i : entity work.bin2seg
        port map ( bin => sig_hex, seg => seg );

    
    p_mux : process(clk) begin
        if rising_edge(clk) then
            if reset = '1' then
                sig_cnt <= "000";
            elsif ce_1khz = '1' then
                if sig_cnt = 5 then
                    sig_cnt <= "000";
                else
                    sig_cnt <= sig_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    
    p_anode : process(sig_cnt) begin
        an <= (others => '1');
        if sig_cnt < 6 then
            an(to_integer(sig_cnt)) <= '0';
        end if;
    end process;

    dp <= '0' when (sig_cnt = 4 or sig_cnt = 2) else '1';

end Behavioral;
