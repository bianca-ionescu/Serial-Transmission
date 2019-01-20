library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity x74_194 is port (
    clr		: in std_logic;
    s1		: in std_logic;
    s0		: in std_logic;
    sri		: in std_logic;
    sli		: in std_logic;
    clk		: in std_logic;
    abcd	: in std_logic_vector(3 downto 0);
    qabcd	: out std_logic_vector(3 downto 0)
);
end x74_194;

architecture Behavioral of X74_194 is
    signal q_abcd : std_logic_vector(3 downto 0);
begin
    process(clr, s1, s0, sri, sli, clk, abcd)
    begin
    	if (clr = '0') then
    	 q_abcd <= "0000";
    	elsif (rising_edge(clk)) then
    		if (s1 = '1') then
    			if (s0 = '0') then
    				q_abcd(3) <= q_abcd(2);
    				q_abcd(2) <= q_abcd(1);
    				q_abcd(1) <= q_abcd(0);
    				q_abcd(0) <= sli;
    			else
    				q_abcd(3) <= abcd(3);
    				q_abcd(2) <= abcd(2);
    				q_abcd(1) <= abcd(1);
    				q_abcd(0) <= abcd(0);
    			end if;
    		elsif (s0 = '1') then
    			q_abcd(3) <= sri;
    			q_abcd(2) <= q_abcd(3);
    			q_abcd(1) <= q_abcd(2);
    			q_abcd(0) <= q_abcd(1);
    		end if;
    	end if;
    end process;
    qabcd <= q_abcd;   
end Behavioral;
