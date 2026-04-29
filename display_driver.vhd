library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_driver is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        ce_1khz : in  std_logic;
        data0, data1, data2, data3 : in std_logic_vector(3 downto 0);
        data4, data5, data6, data7 : in std_logic_vector(3 downto 0);
        seg     : out std_logic_vector(6 downto 0);
        dig     : out std_logic_vector(7 downto 0)
    );
end display_driver;

architecture Behavioral of display_driver is
    signal sig_cnt : unsigned(2 downto 0) := "000";
    signal sig_hex : std_logic_vector(3 downto 0);
begin
    with sig_cnt select
        sig_hex <= data0 when "000", data1 when "001", data2 when "010", data3 when "011",
                   data4 when "100", data5 when "101", data6 when "110", data7 when others;

    decoder_i : entity work.bin2seg
        port map ( bin => sig_hex, seg => seg );

    p_mux : process(clk) begin
        if rising_edge(clk) then
            if reset = '1' then sig_cnt <= "000";
            elsif ce_1khz = '1' then sig_cnt <= sig_cnt + 1;
            end if;
        end if;
    end process;

    p_anode : process(sig_cnt) begin
        dig <= (others => '1');
        dig(to_integer(sig_cnt)) <= '0';
    end process;
end Behavioral;