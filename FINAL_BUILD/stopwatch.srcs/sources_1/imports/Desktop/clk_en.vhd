library ieee;
use ieee.std_logic_1164.all;

entity clk_en is
    generic (
        G_MAX_100HZ : integer := 1000000;
        G_MAX_1KHZ  : integer := 100000
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        ce_100hz : out std_logic;
        ce_1khz  : out std_logic
    );
end entity clk_en;

architecture Behavioral of clk_en is
    signal s_cnt_100hz : integer range 0 to G_MAX_100HZ - 1;
    signal s_cnt_1khz  : integer range 0 to G_MAX_1KHZ - 1;
begin
    p_clk_en : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_cnt_100hz <= 0; s_cnt_1khz <= 0;
                ce_100hz <= '0'; ce_1khz <= '0';
            else
                if s_cnt_100hz >= G_MAX_100HZ - 1 then
                    s_cnt_100hz <= 0; ce_100hz <= '1';
                else
                    s_cnt_100hz <= s_cnt_100hz + 1; ce_100hz <= '0';
                end if;
                if s_cnt_1khz >= G_MAX_1KHZ - 1 then
                    s_cnt_1khz <= 0; ce_1khz <= '1';
                else
                    s_cnt_1khz <= s_cnt_1khz + 1; ce_1khz <= '0';
                end if;
            end if;
        end if;
    end process p_clk_en;
end Behavioral;
