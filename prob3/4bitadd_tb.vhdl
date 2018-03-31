--Dylan Leh, Tom Huber
--Lab 2: VHDL Components, Problem 3 tb

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit4adderSub_tb is
end bit4adderSub_tb;

architecture behavioral of bit4adderSub_tb is
component bit4adderSub is
    Port(   SEL : in STD_LOGIC;
            a, b : in STD_LOGIC_VECTOR(3 downto 0);
            SUM : out STD_LOGIC_VECTOR(3 downto 0);
            overflow, underflow : out std_logic);
end component bit4adderSub;

signal a1, b1, sum : std_logic_vector(3 downto 0);
signal o, u, sel : std_logic;

begin
    bit4adderSub0: bit4adderSub port map(sel, a1, b1, sum, o, u);
    process
    type pattern_type is record
        test1, test2 : std_logic_vector(3 downto 0);
        testSel : std_logic;
        expectedSum : std_logic_vector(3 downto 0);
        expectedO, expectedU : std_logic;
    end record;

    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=(
        ("0000", "0000", '0', "0000", '0', '0'), -- 0+0 = 0
        ("0010", "0001", '1', "0001", '0', '0'), -- 2-1 = 1
        ("0010", "1111", '0', "0001", '0', '0'), -- 2+(-1) = 1
        ("1001", "0100", '1', "0101", '0', '1'), -- -7-4 = -11, underflow
        ("0000", "0001", '0', "0001", '0', '0'), -- 0+1 = 1
        ("1111", "1001", '0', "1000", '0', '0'), -- -1+(-7) = -8
        ("1110", "0011", '0', "0001", '0', '0'), -- -2+3 = 1
        ("1010", "0010", '0', "1100", '0', '0'), -- -6+2 = -4
        ("0101", "0010", '0', "0111", '0', '0'), -- 5+2 = 7
        ("1011", "1100", '0', "0111", '0', '1'), -- -5+(-4) = -9, underflow
        ("0000", "0000", '1', "0000", '0', '0'), -- 0-0 = 0
        ("0101", "0011", '1', "0010", '0', '0'), -- 5-3 = 2
        ("0101", "1110", '1', "0111", '0', '0'), -- 5-(-2) = 7
        ("1010", "0010", '1', "1000", '0', '0'), -- -6-2 = -8
        ("0000", "1111", '1', "0001", '0', '0'), -- 0-(-1) = -1
        ("0000", "1000", '1', "1000", '1', '0'), -- 0-(-8) = 8, overflow; You can't do (# -(-8)) since you can't represent positive 8.
        ("0010", "1000", '1', "1010", '1', '0'), -- 2-(-8) = 10, overflow (2 + -8 = -6 != 10)
        ("1100", "1000", '1', "0100", '1', '1'), -- -4-(-8) = 4, overflow, underflow. In this case, after -(-8) fails to become positve 8 (overflow),
                                                                --the operation becomes, -4 + (-8) = -12, which results in an underflow. It just happens to
                                                                --produce the correct value of 4 due to 2s complement.
        ("1101", "1011", '1', "0010", '0', '0') -- -3-(-5) = 2
    );

    --Can't enter # -(-8) without creating an overflow error.

    begin
        for n in patterns'range loop
            a1 <= patterns(n).test1;
            b1 <= patterns(n).test2;
            sel <= patterns(n).testSel;
            wait for 5 ns;
            assert sum = patterns(n).expectedSum report "BAD SUM VALUE" severity error;
            assert o = patterns(n).expectedO report "BAD OVERFLOW VALUE" severity error;
            assert u = patterns(n).expectedU report "BAD UNDERFLOW VALUE" severity error;
        end loop;
        report "TESTS COMPLETED" severity note;
        wait; --  Wait forever; this will finish the simulation.
    end process;
end architecture behavioral;