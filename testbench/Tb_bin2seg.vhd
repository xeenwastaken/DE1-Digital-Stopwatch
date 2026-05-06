library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_bin2seg is
end entity tb_bin2seg;

architecture sim of tb_bin2seg is

    signal bin : std_logic_vector(3 downto 0) := (others => '0');
    signal seg : std_logic_vector(6 downto 0);

begin

    dut : entity work.bin2seg
        port map (
            bin => bin,
            seg => seg
        );

 
    p_stim : process is
    begin
        report "Spoustim sweep 0..F";

        for i in 0 to 15 loop
            bin <= std_logic_vector(to_unsigned(i, 4));
            wait for 100 ns;
        end loop;

        
        bin <= "ZZZZ";  
        wait for 100 ns;

        report "Sweep dokoncen" severity note;
        wait;
    end process p_stim;

end architecture sim;
