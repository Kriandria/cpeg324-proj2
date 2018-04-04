-- Dylan Leh, Tom Huber
-- Lab 2: VHDL Components, Problem 3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity shift_reg_8 is
port(	I:	in std_logic_vector (7 downto 0);
		i_shift_in: in std_logic; --number to shift in, 0: shift in a 0, 1: shift in a 1
		SEL:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		CLOCK:		in std_logic; -- positive level triggering in problem 3
		ENABLE:		in std_logic; -- 0: don't do anything; 1: shift_reg is enabled
		O:	out std_logic_vector(7 downto 0)
);
end shift_reg_8;

architecture behavior of shift_reg_8 is
    component shift_reg
    port (	I:	in std_logic_vector (3 downto 0);
		I_SHIFT_IN: in std_logic;
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic; 
		enable:		in std_logic;
		O:	out std_logic_vector(3 downto 0)
                );
  end component; 

  signal I1, I2, O1, O2: std_logic_vector(3 downto 0);
  signal i_shift_in_s, CLOCK_s, ENABLE_s: std_logic;
  signal SEL_s: std_logic_vector(1 downto 0);

  begin
    I1<= I(3 downto 0);
    I2<= I(7 downto 4);
    sr1: shift_reg port map (I => I1, I_SHIFT_IN => i_shift_in_s, sel => SEL_s, clock => CLOCK_s, enable => ENABLE_s, O => O1);
    sr2: shift_reg port map (I => I2, I_SHIFT_IN => i_shift_in_s, sel => SEL_s, clock => CLOCK_s, enable => ENABLE_s, O => O2);
    O <= O1 & O2;
end behavior;
