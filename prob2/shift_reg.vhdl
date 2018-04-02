--Dylan Leh, Tom Huber
--Lab 2: VHDL Components, Problem 2


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift_reg is
port(	I:	in std_logic_vector (3 downto 0);
		I_SHIFT_IN: in std_logic; --number to shift in, 0: shift in a 0, 1: shift in a 1
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic; -- positive level triggering in problem 3
		enable:		in std_logic; -- 0: don't do anything; 1: shift_reg is enabled
		O:	out std_logic_vector(3 downto 0)
);
end shift_reg;

architecture Behavioral of shift_reg is
	signal temp: std_logic_vector(3 downto 0):="0000"; -- temporary value to hold and update initial input
	begin
	process (clock,enable,I_SHIFT_IN,sel)
		begin
		if (enable = '1') then
			if (clock'event and clock='1') then
				if (sel = "00") then -- HOLD function
					temp <= temp;
					O <= temp;
				elsif (sel = "01") then -- LEFT SHIFT function
					temp <= (I(2 downto 0) & I_SHIFT_IN);
					O <= (I(2 downto 0) & I_SHIFT_IN);
				elsif (sel = "10") then -- RIGHT SHIFT function
					temp <= (I_SHIFT_IN & I(3 downto 1));
					O <= (I_SHIFT_IN & I(3 downto 1));
				elsif (sel = "11") then -- LOAD function
					--report integer'image(to_integer(unsigned(I))) severity note;
					temp <= I;
					O <= I;
				end if;
			else
				O <= temp;--"0000";
			end if;
		else 
			O <= temp;--"0000";
		end if;
	end process;
end Behavioral;
