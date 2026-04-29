library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce_in : in STD_LOGIC;         
           btn_in : in STD_LOGIC;
           btn_state : out STD_LOGIC;
           btn_press : out STD_LOGIC;
           btn_release : out std_logic);
end debounce;

architecture Behavioral of debounce is
    constant C_SHIFT_LEN : positive := 4;

    signal ce_sample : std_logic;
    signal sync0     : std_logic;
    signal sync1     : std_logic;
    signal shift_reg : std_logic_vector(C_SHIFT_LEN-1 downto 0);
    signal debounced : std_logic;
    signal delayed   : std_logic;

begin
    
    ce_sample <= ce_in;

    p_debounce : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sync0     <= '0';
                sync1     <= '0';
                shift_reg <= (others => '0');
                debounced <= '0';
                delayed   <= '0';
            else
                sync1 <= sync0;
                sync0 <= btn_in;

                if ce_sample = '1' then
                    shift_reg <= shift_reg(C_SHIFT_LEN-2 downto 0) & sync1;

                    if shift_reg = (shift_reg'range => '1') then
                        debounced <= '1';
                    elsif shift_reg = (shift_reg'range => '0') then
                        debounced <= '0';
                    end if;
                end if;

                delayed <= debounced;
            end if;
        end if;
    end process;

    btn_state <= debounced;
    btn_press <= debounced and not(delayed);
    btn_release <= not(debounced) and delayed;

end Behavioral;
