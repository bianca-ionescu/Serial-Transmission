library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity cb4cle is port (
    clr	: in std_logic;
    l	: in std_logic;
    ce	: in std_logic;
    clk	: in std_logic;
    d	: in std_logic_vector(3 downto 0);
    q	: out std_logic_vector(3 downto 0);
    tc	: out std_logic;
    ceo	: out std_logic
);
end cb4cle;

architecture Behavioral of cb4cle is
    signal r : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(clk, clr, d, l, ce)
    begin
        if (clr = '1') then
            r <= "0000";
            ceo <= '0';
            tc <= '0';
        elsif (l = '0' and ce = '0') then
            ceo <= '0';
        elsif (rising_edge(clk)) then
            if (l = '1') then
                r <= d;
            elsif (l = '0' and ce = '1') then
                r <= STD_LOGIC_VECTOR(unsigned(r) + 1);
            end if;
        end if;
    end process;
    q <= r;
end Behavioral;
