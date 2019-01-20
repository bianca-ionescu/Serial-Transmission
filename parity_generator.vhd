library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parity_generator is
    Port ( d : in STD_LOGIC_VECTOR (7 downto 0);
           par : out STD_LOGIC);
end parity_generator;

architecture Behavioral of parity_generator is

begin
    par <= d(0) xor d(1) xor d(2) xor d(3) xor d(4) xor d(5) xor d(6) xor d(7);
end Behavioral;
