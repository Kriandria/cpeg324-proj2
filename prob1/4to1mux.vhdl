--Dylan Leh, Tom Huber
--Lab 2: VHDL Components, Problem 1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4to1 is
    Generic (SIZE : natural); --Range(0,inf)
    Port (  SEL : in STD_LOGIC_VECTOR(1 downto 0);
            A, B, C, D : in STD_LOGIC_VECTOR(SIZE-1 downto 0);  
            X : out STD_LOGIC_VECTOR(SIZE-1 downto 0));  
end mux_4to1;

architecture Behavioral of mux_4to1 is
begin
    with sel select X <=
        a when "00",
        b when "01",
        c when "10",
        d when others;

end Behavioral;