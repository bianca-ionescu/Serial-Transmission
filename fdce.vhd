library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fdce is port (
    clr	: in std_logic;
    ce	: in std_logic;
    d	: in std_logic;
    clk	: in std_logic;
    q	: out std_logic
);
end fdce;

architecture Behavioral of FDCE is

begin
    process(clk, clr, ce, d)
    begin
        if (clr = '1') then
            q <= '0';
        elsif (ce = '1' and rising_edge(clk)) then
            q <= D;
        end if;
    end process;
end Behavioral;
