--RAM module
--4096*8 bit file
--simultaneous write/read support
--16 bit or 8 bit data bus
--16 bit address bus
--On Reset, will load a "default" RAM image

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all; 



entity blockram is
  port(
    Address: in std_logic_vector(11 downto 0); --memory address
    WriteEnable: in std_logic_vector(1 downto 0); --write 1 byte at a time option
    Enable: in std_logic; 
    Clock: in std_logic;
    DataIn: in std_logic_vector(15 downto 0);
    DataOut: out std_logic_vector(15 downto 0)
  );
end blockram;

architecture Behavioral of blockram is
    type ram_type is array (4095 downto 0) of std_logic_vector (15 downto 0);
    signal RAM: ram_type;
    signal di0, di1, do0, do1: std_logic_vector(7 downto 0); --data inputs and outputs for byte-enable
begin
  process (WriteEnable,DataIn)
  begin
    if WriteEnable(0) = '1' then
      di0 <= DataIn(7 downto 0);
    else
      di0 <= RAM(conv_integer(Address))(7 downto 0);
      do0 <= RAM(conv_integer(Address))(7 downto 0);
    end if;
    if WriteEnable(1)= '1' then
      di1 <= DataIn(15 downto 8);
    else
      di1 <= RAM(conv_integer(Address))(15 downto 8);
      do1 <= RAM(conv_integer(Address))(15 downto 8);
    end if;
  end process;
  process (Clock)
  begin
    if rising_edge(Clock) then
      if Enable = '1' then
          DataOut <= do1 & do0;
          RAM(conv_integer(Address)) <= di1 & di0;
      end if;
    end if;
  end process;

end Behavioral;