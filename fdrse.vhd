library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fdrse is port (
    r	: in std_logic;
    s	: in std_logic;
    ce	: in std_logic;
    d	: in std_logic;
    clk	: in std_logic;
    q	: out std_logic
);
end fdrse;

architecture Behavioral of fdrse is

begin
    process(clk, r, d)
    begin
        if (rising_edge(clk)) then
            if (r = '1') then
                q <= '0';
            elsif (s = '1') then
                q <= '1';
            elsif (ce = '1') then
                q <= d;
            end if;
        end if;    
    end process;
end Behavioral;
