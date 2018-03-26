--Dylan Leh, Tom Huber
--Lab 2: VHDL Components, Problem 1 tb

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_4to1_tb is
end mux_4to1_tb;


architecture behavioral of mux_4to1_tb is
component mux_4to1 is
    Generic (SIZE : natural); --Range(0,inf)
    Port (  SEL : in STD_LOGIC_VECTOR(1 downto 0);
            A, B, C, D : in STD_LOGIC_VECTOR(SIZE-1 downto 0);  
            X : out STD_LOGIC_VECTOR(SIZE-1 downto 0));
end component mux_4to1;

signal A : std_logic_vector(7 downto 0) := "10101010";
signal B : std_logic_vector(7 downto 0) := "10011010";
signal C : std_logic_vector(7 downto 0) := "11111111";
signal D : std_logic_vector(7 downto 0) := "10110011";
signal SEL : std_logic_vector(1 downto 0);
signal X : std_logic_vector(7 downto 0);
begin
    mux_4to1_0: mux_4to1 generic map(8) port map(SEL, A, B, C, D, X);
    process
    begin
        sel <= "00";
        wait for 5 ns;
        assert X = "10101010" report "unexpected X" severity error;

        sel <= "01";
        wait for 5 ns;
        assert X = "10011010" report "unexpected X" severity error;

        sel <= "10";
        wait for 5 ns;
        assert X = "11111111" report "unexpected X" severity error;

        sel <= "11";
        wait for 5 ns;
        assert X = "10110011" report "unexpected X" severity error;
        report "TESTS COMPLETED." severity note;
        wait;
    end process;
end architecture behavioral;