library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity button_decoder is
generic (
G_HOLD_TIME : integer := 1250
);
   Port ( clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           tick_out : out STD_LOGIC;
           hold_out : out STD_LOGIC);
end button_decoder;

architecture Behavioral of button_decoder is

    signal btn_prev : std_logic := '0';
    signal hold_cnt : integer range 0 to G_HOLD_TIME := 0;
    signal is_held : std_logic := '0';
begin
 process (clk)
 begin 
    if rising_edge(clk) then
        tick_out <= '0';
        hold_out <= '0';
 
    if ce = '1' then
    btn_prev <= btn_in;
    
    if btn_in = '1' and btn_prev = '0' then
        hold_cnt <= 0;
        is_held <= '0';
        
        
       elsif btn_in = '1' and btn_prev = '1' then
       if is_held = '0' then
        if hold_cnt < (G_HOLD_TIME - 1) then
            hold_cnt <= hold_cnt + 1;
        else    
            hold_out <= '1';
            is_held <= '1'; 
            end if;
          end if;

    elsif btn_in = '0' and btn_prev = '1' then
    if is_held = '0' then
        tick_out <= '1';
        end if;
     end if;
   end if;
   end if;
   end process;
   

end Behavioral;
