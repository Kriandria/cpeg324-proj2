--Dylan Leh, Tom Huber
--Lab 2: VHDL Components, Problem 3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


------------------------------------------
entity halfAdder is
    Port (  A, B : in STD_LOGIC;  
            SUM, CARRY : out STD_LOGIC);
end halfAdder;

architecture behavioral of halfAdder is
begin
    SUM <= A xor B;
    CARRY <= A and B;
end behavioral;
-------------------------------------------

-------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity fullAdder is
    Port(   A, B, CIN : in STD_LOGIC;
            S, COUT   : out STD_LOGIC);
end fullAdder;

architecture structural of fullAdder is
component halfAdder is
    port(   A, B : in STD_LOGIC;
            SUM, CARRY : out STD_LOGIC);
end component halfAdder;

signal s1, s2, s3 : std_logic;
begin
    h1: halfAdder port map (a, b, s1, s3);
    h2: halfAdder port map (s1, CIN, S, s2);
    COUT <= s2 or s3;
end structural;
-------------------------------------------

-------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity bit4adder is
    Port(   a, b : in STD_LOGIC_VECTOR(3 downto 0);
            SUM : out STD_LOGIC_VECTOR(3 downto 0);
            overflow, underflow : out std_logic);
end bit4adder;

architecture structual of bit4adder is
component fullAdder is
    Port(   A, B, CIN : in STD_LOGIC;
            S, COUT   : out STD_LOGIC);
end component fullAdder;

signal c0, c1, c2, s3: std_logic;
begin
    fa0: fullAdder port map(a(0), b(0), '0', sum(0), c0); --CIN for the first fullAdder is always 0
    fa1: fullAdder port map(a(1), b(1), c0, sum(1), c1); --If both numbers are positive(leading 0) and ouput is negative.
    fa2: fullAdder port map(a(2), b(2), c1, sum(2), c2); --If both numbers are negative(leading 1) and ouput is positive.
    fa3: fullAdder port map(a(3), b(3), c2, s3, open);
    overflow <= s3 and (not a(3) and b(3));
    underflow <= not(s3) and (a(3) and b(3));
    sum(3) <= s3;
end structual;
-------------------------------------------

-------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity bit4adderSub is
    Port(   SEL : in STD_LOGIC;
            a, b : in STD_LOGIC_VECTOR(3 downto 0);
            SUM : out STD_LOGIC_VECTOR(3 downto 0);
            overflow, underflow : out std_logic);
end bit4adderSub;

architecture structual of bit4adderSub is
component bit4adder is
    Port(   a, b : in STD_LOGIC_VECTOR(3 downto 0);
            SUM : out STD_LOGIC_VECTOR(3 downto 0);
            overflow, underflow : out std_logic);
end component bit4adder;

signal term2, term2inv, term2neg : std_logic_vector(3 downto 0);
signal of0: std_logic := '0';
constant one : std_logic_vector(3 downto 0) := "0001";

begin

term2inv <= not(b);
adder_4bit_1: bit4adder port map(term2inv, one, term2neg, open, open); --Adds 1 for 2's compliment

with SEL select term2 <=
    b when '0',             --original term for addition
    term2neg when others;   --2s compliment for subtraction

adder_4bit_0: bit4adder port map(a, term2, SUM, of0, underflow); --Preform the addition


overflow <= of0 or (b(3) and (not(b(2))) and (not(b(1))) and (not(b(0))) and SEL);
    --You can't do X-(-8) since it becomes X + 8

end architecture structual;