--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
               opcode : in  STD_LOGIC_VECTOR (6 downto 0);
               funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
               funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
               Branch : out  STD_LOGIC_VECTOR(1 downto 0);
               MemRead : out  STD_LOGIC;
               MemtoReg : out  STD_LOGIC;
               ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
               MemWrite : out  STD_LOGIC;
               ALUSrc : out  STD_LOGIC;
               RegWrite : out  STD_LOGIC;
               ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	SIGNAL pcResult: 		std_logic_vector (31 downto 0);
	SIGNAL nextInstruction: std_logic_vector (31 downto 0);
	SIGNAL pcADD:			std_logic_vector (31 downto 0);
	SIGNAL cOut:			std_logic;
	SIGNAL currInstruction: std_logic_vector (31 downto 0);
	SIGNAL writeData:		std_logic_vector (31 downto 0);
	SIGNAL writeCommand:    std_logic;
	SIGNAL readDataout1:    std_logic_vector (31 downto 0);
	SIGNAL readDataout2:	std_logic_vector (31 downto 0);
	SIGNAL branch:			std_logic_vector (1  downto 0);
	SIGNAL memRead:			std_logic;
	SIGNAL memToReg:		std_logic;
	SIGNAL aluCtrl:			std_logic_vector (4 downto 0);
	SIGNAL memWrite:		std_logic;
	SIGNAL aluSrc:			std_logic;
	SIGNAL regWrite:		std_logic;
	SIGNAL immediate:		std_logic_vector (1 downto 0);
	SIGNAL genImmediate:    std_logic_vector (31 downto 0);
	SIGNAL muxResult:		std_logic_vector (31 downto 0);
	SIGNAL Zero:			std_logic;
	SIGNAL aluResult:		std_logic_vector (31 downto 0);
	SIGNAL cOut2:			std_logic;
	SIGNAL addressOff:		std_logic_vector (31 downto 0);
	SIGNAL cOut3:			std_logic;
	SIGNAL adder:			std_logic_vector (31 downto 0);
	SIGNAL selectBranch:	std_logic_vector;
	SIGNAL ramResult:		std_logic_vector (31 downto 0);

begin
	-- Add your code here
	progcount:	ProgramCounter   port map (reset, clock, nextInstruction, pcResult)
	pcadder: 	adder_subtracter port map (pcResult, X"00000004", '0', pcADD, cOut);
	memoryInstr:InstructionRAM   port map (reset, clock, pcResult (31 downto 2), currInstruction);
	regStore:	Registers 		 port map (currInstruction(19 downto 15), currInstruction(24 downto 20), currInstruction(11 downto 7), writeData, regWrite, readDataout1, readDataout2);
	cntrl:		Control			 port map (clock, currInstruction(6 downto 0), currInstruction(14 downto 12), currInstruction(31 downto 25), branch, memRead, memToReg, aluCtrl, memWRite, aluSrc, regWrite, immediate);
	aluMux:		BusMux2to1       port map (aluSrc, readDataout2, genImmediate,  muxResult);
	ALU:		ALU				 port map (readDataout1, muxResult, aluCtrl, Zero, aluResult);
	offSet:		adder_subtracter port map (aluResult, X"10000000", '1', addressOff, cOut2);
	pcImgenadd: adder_subtracter port map (pcResult, genImmediate, '0', adder, cOut3);
	muxBranch:  BusMux2to1		 port map (selectBranch, pcADD, adder, nextInstruction);
	dmemory:    RAM				 port map (reset, clock, memRead, memWRite, addressOff(31 downto 2), readDataout2, ramResult);
	dmemoryMux: BusMux2to1		 port map (memToReg, aluResult, ramResult, writeData);
	
	genImmediate (31 downto 12) <=		(others => currInstruction(31)) when immediate = "00" else
										(others => currInstruction(31)) when immediate = "01" else
										(others => currInstruction(31)) when immediate = "10" else
										currInstruction(31 downto 12);
										
	genImmediate (11 downto 0) <=		 currInstruction(31 downto 20)) when immediate = "00" else
										 currInstruction(31 downto 25)) & currInstruction(11 downto 7) when immediate = "01" else
										 currInstruction(7) & currInstruction(30 downto 25) & currInstruction(11 downto 8) & '0' when immediate = "10" else
										(others => '0');
										
	selectBranch <= '1' when (Branch = "01" and Zero = '1') or (Branch = "10" and Zero = '0') else
					'0';
	
end holistic;							 
