--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

	SIGNAL instruction0: std_logic_vector(31 downto 0);
	SIGNAL instruction1: std_logic_vector(31 downto 0);
	SIGNAL instruction2: std_logic_vector(31 downto 0);
	SIGNAL instruction3: std_logic_vector(31 downto 0);
	SIGNAL instruction4: std_logic_vector(31 downto 0);
	SIGNAL instruction5: std_logic_vector(31 downto 0);
	SIGNAL instruction6: std_logic_vector(31 downto 0);
	
begin
	-- Add ALU VHDL implementation here
	add:  adder_subtracter port map(DataIn1, DataIn2, '0', instruction0, Zero);
	addi: adder_subtracter port map(DataIn1, DataIn2, '0', instruction1, Zero);
	sub:  adder_subtracter port map(DataIn1, DataIn2, '1', instruction2, Zero);
	mysll: shift_register  port map(DataIn1, '0', DataIn2(4 downto 0), instruction3);
	myslli:shift_register  port map(DataIn1, '0', DataIn2(4 downto 0), instruction4);
	mysrl: shift_register  port map(DataIn1, '1', DataIn2(4 downto 0), instruction5);
	mysrli:shift_register  port map(DataIn1, '1', DataIn2(4 downto 0), instruction6);
	
	
	with ALUCtrl select
	ALUResult <=	instruction0 when "00000",
					instruction1 when "10001",
					instruction2 when "00010",
					DataIn1 or DataIn2 when "00011",
					DataIn1 or DataIn2 when "10100",
					DataIn1 and DataIn2 when "00101",
					DataIn1 and DataIn2 when "10110",
					instruction3 when "00111",
					instruction4 when "11000",
					instruction5 when "01001",
					instruction6 when "11010",
					X"00000000" when others;
	
end architecture ALU_Arch;
