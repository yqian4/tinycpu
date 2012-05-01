LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY blockram_tb IS
END blockram_tb;
 
ARCHITECTURE behavior OF blockram_tb IS 
 
-- Component Declaration for the Unit Under Test (UUT)
 
  component blockram
    port(
      Address: in std_logic_vector(11 downto 0); --memory address
      WriteEnable: in std_logic_vector(1 downto 0); --write or read
      Enable: in std_logic; 
      Clock: in std_logic;
      DataIn: in std_logic_vector(15 downto 0);
      DataOut: out std_logic_vector(15 downto 0)
    );
  end component;
    

  --Inputs
  signal Address: std_logic_vector(11 downto 0) := (others => '0');
  signal WriteEnable: std_logic_vector(1 downto 0) := (others => '0');
  signal DataIn: std_logic_vector(15 downto 0) := (others => '0');
  signal Enable: std_logic := '0';

  --Outputs
  signal DataOut: std_logic_vector(15 downto 0);

  signal Clock: std_logic;
  constant clock_period : time := 10 ns;
 
BEGIN

  -- Instantiate the Unit Under Test (UUT)
  uut: blockram PORT MAP (
    Address => Address,
    WriteEnable => WriteEnable,
    Enable => Enable,
    Clock => Clock,
    DataIn => DataIn,
    DataOut => DataOut
  );

  -- Clock process definitions
  clock_process :process
  begin
    Clock <= '0';
    wait for clock_period/2;
    Clock <= '1';
    wait for clock_period/2;
  end process;
 

  -- Stimulus process
  stim_proc: process
    variable err_cnt: integer :=0;
  begin         
    -- hold reset state for 100 ns.
    Enable <= '1';
    wait for 100 ns;    

    wait for clock_period*10;
    
    --case 1
    WriteEnable(0) <= '0';
    WriteEnable(1) <= '0';
    wait for 10 ns;
    Address <= x"001";
    DataIn <= "1000000000001000";
    WriteEnable(0) <= '1';
    WriteEnable(1) <= '1';
    wait for 10 ns;
    WriteEnable(0) <= '0';
    WriteEnable(1) <= '0';
    wait for 10 ns;
    assert (DataOut="1000000000001000") report "Storage error case 1" severity error;

     --case 2
    Address <= x"033";
    DataIn <= "1000000000001100";
    WriteEnable(0) <= '1';
    WriteEnable(1) <= '1';
    wait for 10 ns;
    WriteEnable(0) <= '0';
    WriteEnable(1) <= '0';
    wait for 10 ns;
    assert (DataOut="1000000000001100") report "memory selection error case 2" severity error;

    -- case 3
    Address <= x"001";
    wait for 10 ns;
    assert (DataOut="1000000000001000") report "memory retention error case 3" severity error;
    
    
    --case 5
    --Address <= x"FFFF";
    --Write <= '0';
    --wait for 10 ns;
    --assert (DataOut=x"FFC0") report "memory out of range error case 5" severity error;



   assert false
   report "Testbench of memory completed successfully!"
   severity note;
            
    wait;

    -- insert stimulus here 

    wait;
  end process;


END;