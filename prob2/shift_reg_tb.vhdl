library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


--  A testbench has no ports.
entity shift_reg_tb is
end shift_reg_tb;

architecture Behavioral of shift_reg_tb is
--  Declaration of the component that will be instantiated.
component shift_reg
port (	I:	in std_logic_vector (3 downto 0);
		I_SHIFT_IN: in std_logic;
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic; 
		enable:		in std_logic;
		O:	out std_logic_vector(3 downto 0)
);
end component;
--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
signal i, o : std_logic_vector(3 downto 0);
signal i_shift_in, clk, enable : std_logic;
signal sel : std_logic_vector(1 downto 0);
begin
--  Component instantiation.
shift_reg_0: shift_reg port map (
	I => i, I_SHIFT_IN => i_shift_in, sel => sel, clock => clk, enable => enable, O => o);

--  This process does the real job.
process
type pattern_type is record
--  The inputs of the shift_reg.
i: std_logic_vector (3 downto 0);
i_shift_in, clock, enable: std_logic;
sel: std_logic_vector(1 downto 0);
--  The expected outputs of the shift_reg.
o: std_logic_vector (3 downto 0);
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
(("0100", '0', '0', '0', "00", "0000"), -- (input, l/r shift, clock, enable, sel, output
("0100", '0', '0', '0', "01", "0000"), 
("0100", '0', '0', '0', "10", "0000"), 
("0100", '0', '0', '0', "11", "0000"),
("0100", '0', '0', '1', "00", "0000"),
("0100", '0', '0', '1', "01", "0000"),
("0100", '0', '0', '1', "10", "0000"),
("0100", '0', '0', '1', "11", "0000"),
("0100", '0', '1', '0', "00", "0000"),
("0100", '0', '1', '0', "01", "0000"),
("0100", '0', '1', '0', "10", "0000"),
("0100", '0', '1', '0', "11", "0000"),
("0100", '0', '0', '0', "00", "0000"),
("0100", '0', '1', '1', "01", "1000"),
("0100", '0', '1', '1', "00", "1000"),
("0100", '0', '1', '1', "01", "1000"),
("0100", '0', '1', '1', "10", "1000"),
("0010", '0', '1', '1', "11", "1000"), 
("0010", '1', '0', '0', "00", "1000"),
("0010", '1', '0', '0', "01", "1000"),
("0010", '1', '0', '0', "10", "1000"),
("0010", '1', '0', '0', "11", "1000"),
("0010", '1', '0', '1', "00", "1000"),
("0010", '1', '0', '1', "01", "1000"),
("0010", '1', '0', '1', "10", "1000"),
("0010", '1', '0', '1', "11", "1000"),
("0010", '1', '1', '0', "00", "1000"),
("0010", '1', '1', '0', "01", "1000"),
("0010", '1', '1', '0', "10", "1000"),
("0010", '1', '1', '0', "11", "1000"),
("0010", '1', '1', '1', "00", "1000"),
("0010", '1', '1', '1', "01", "1000"),
("0010", '1', '1', '1', "10", "1000"),
("0010", '1', '1', '1', "11", "1000")); -- all possible combinations listed 
begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
i <= patterns(n).i;
i_shift_in <= patterns(n).i_shift_in;
sel <= patterns(n).sel;
clk <= patterns(n).clock;
enable <= patterns(n).enable;
--  Wait for the results.
wait for 1 ns;
--  Check the outputs.
--assert false report integer'image(to_integer(unsigned(O))) severity error;
assert o = patterns(n).o
report "bad output value" severity error;
end loop;
report "TESTS COMPLETED." severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end Behavioral;
