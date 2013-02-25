----------------------------------------------------------------------------------
-- Engineer: Donny Percivalle & Alvin Ng
--
-- Create Date:    14:40:18 02/05/2013
-- Description:    Structural module for RAT microprocessor.
--                 contains all components for CPU to be
--                 wrapped in RAT_wrapper.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

   entity RAT_CPU is
    Port ( IN_PORT : in  STD_LOGIC_VECTOR (7 downto 0);
               RST : in  STD_LOGIC;
            INT_IN : in  STD_LOGIC;
               CLK : in  STD_LOGIC;
          OUT_PORT : out  STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID : out  STD_LOGIC_VECTOR (7 downto 0);
             IO_OE : out  STD_LOGIC);
end RAT_CPU;

architecture Behavioral of RAT_CPU is

--DEFINE CPU COMPONENTS: REGISTER, PC, ALU, CONTROL UNIT, PROM, FLAGREGS

--FlagRegisters
component FlagReg
    Port ( IN_FLAG  : in  STD_LOGIC; --flag input
           LD       : in  STD_LOGIC; --load the out_flag with the in_flag value
           SET      : in  STD_LOGIC; --set the flag to '1'
           CLR      : in  STD_LOGIC; --clear the flag to '0'
           CLK      : in  STD_LOGIC; --system clock
           OUT_FLAG : out  STD_LOGIC); --flag output
end component;

--REGISTER
component RegisterFile
    Port (  REG_mux_sel : in     STD_LOGIC_VECTOR (1 downto 0);
                IN_port : in     STD_LOGIC_VECTOR (7 downto 0);
                TRI_bus : in     STD_LOGIC_VECTOR (7 downto 0);
                ALU_sum : in     STD_LOGIC_VECTOR (7 downto 0);
                 DX_OUT : inout  STD_LOGIC_VECTOR (7 downto 0);
                 DY_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
                 ADRX   : in     STD_LOGIC_VECTOR (4 downto 0);
                 ADRY   : in     STD_LOGIC_VECTOR (4 downto 0);
                 DX_OE  : in     STD_LOGIC;
                 WE     : in     STD_LOGIC;
                 CLK    : in     STD_LOGIC);
end component;

--Program Counter
component program_counter
    PORT(
         CLK        : IN  std_logic;
         RST        : IN  std_logic;
         LOAD       : IN  std_logic;
         OE         : IN  std_logic;
         SEL        : IN  std_logic_vector(1 downto 0);
         FROM_IMMED : IN  std_logic_vector(9 downto 0);
         FROM_STACK : IN  std_logic_vector(9 downto 0);
         PC_COUNT   : OUT  std_logic_vector(9 downto 0);
         PC_TRI     : INOUT  std_logic_vector(9 downto 0));
end component;

--ALU
component ALU
    Port (    A : in  STD_LOGIC_VECTOR (7 downto 0);
           C_in : in  STD_LOGIC;
         REG_in : in  STD_LOGIC_VECTOR (7 downto 0);
          IMMED : in  STD_LOGIC_VECTOR (7 downto 0);
        MUX_SEL : in  STD_LOGIC;
            SEL : in  STD_LOGIC_VECTOR (3 downto 0);
            SUM : out  STD_LOGIC_VECTOR (7 downto 0);
         C_FLAG : out  STD_LOGIC;
         Z_FLAG : out  STD_LOGIC);
end component;

--CONTROL UNIT
component control_unit
    Port ( CLK           : in   STD_LOGIC;
           C             : in   STD_LOGIC;
           Z             : in   STD_LOGIC;
           INT           : in   STD_LOGIC;
           RST           : in   STD_LOGIC;
           --From the instruction register:
           OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
           OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);

           --Program counter
           PC_LD         : out  STD_LOGIC; --Load program counter
           PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0); --Program counter mux
           PC_OE         : out  STD_LOGIC; --Program counter output enable

           --Stack Pointer
           SP_LD         : out  STD_LOGIC; --stack pointer load
           SP_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0); --SP input mux

           --Reset to program counter and stack pointer
           RESET         : out  STD_LOGIC; --Reset program counter and stack pointer

           --Register File
           RF_WR         : out  STD_LOGIC; --Reg File Write Enable
           RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0); --Reg File Mux
           RF_OE         : out  STD_LOGIC; --Register File Tristate Ooutput

           --ALU
           ALU_MUX_SEL   : out  STD_LOGIC;
           ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);

           --Scratchpad RAM
           SCR_WR        : out  STD_LOGIC; --scratchpad write enable
           SCR_OE        : out  STD_LOGIC; --sp output enable
           SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0); --sp mux sel

           --C Flag
           C_FLAG_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
           C_FLAG_LD     : out  STD_LOGIC;
           C_FLAG_SET    : out  STD_LOGIC;
           C_FLAG_CLR    : out  STD_LOGIC;

           --Z Flag
           Z_FLAG_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
           Z_FLAG_LD     : out  STD_LOGIC; --Load Z
           Z_FLAG_SET    : out  STD_LOGIC; --Set Z
           Z_FLAG_CLR    : out  STD_LOGIC; --Clear Z

           --Interrupt Flag
           I_FLAG_SET    : out  STD_LOGIC; --Set Interrupt
           I_FLAG_CLR    : out  STD_LOGIC; --Clear Interrupt

           --I/O Output Enable
                  IO_OE  : out  STD_LOGIC);
end component;

--Program ROM
component prog_rom
   port (     ADDRESS : in std_logic_vector(9 downto 0);
          INSTRUCTION : out std_logic_vector(17 downto 0);
                  CLK : in std_logic);
end component;

--Stack Pointer
component StackPointer
    Port ( INC_DEC : in  STD_LOGIC_VECTOR (1 downto 0);
              D_IN : in  STD_LOGIC_VECTOR (7 downto 0);
                WE : in  STD_LOGIC;
               RST : in  STD_LOGIC;
               CLK : in  STD_LOGIC;
          STK_PNTR : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

--Scratch Pad
component ScratchPadMemory
    Port(IMMED_ADR : in STD_LOGIC_VECTOR (7 downto 0);
            SP_ADR : in STD_LOGIC_VECTOR (7 downto 0);
            RS_ADR : in STD_LOGIC_VECTOR (7 downto 0);
       SCR_ADR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
             SP_WE : in  STD_LOGIC;
             SP_OE : in  STD_LOGIC;
               CLK : in  STD_LOGIC;
           SP_DATA : inout  STD_LOGIC_VECTOR (9 downto 0));
end component;

--DEFINE INTERNAL SIGNALS TO COMMUNICATE BETWEEN THE COMPONENTS

   signal in_PC_LD, in_PC_OE, in_SP_LD, in_RESET, in_RF_WR,
          in_RF_OE, in_ALU_MUX_SEL, in_SCR_WR, in_SCR_OE,
          in_C_FLAG_LD, in_C_FLAG_SET, in_C_FLAG_CLR,
          in_Z_FLAG_LD, in_Z_FLAG_SET, in_Z_FLAG_CLR,
          in_I_FLAG_SET, in_I_FLAG_CLR,
          in_C_FLAG, in_Z_FLAG, in_INT_FLAG,
          in_C_FLAG_IN, in_Z_FLAG_IN
            : STD_LOGIC;

   signal in_PC_MUX_SEL, in_SP_MUX_SEL, in_RF_WR_SEL,
          in_SCR_ADR_SEL, in_C_FLAG_SEL, in_Z_FLAG_SEL
            : STD_LOGIC_VECTOR (1 downto 0);

   signal in_ALU_SEL : STD_LOGIC_VECTOR (3 downto 0);

   signal REG_DY_OUT, ALU_SUM_OUT, pointer : STD_LOGIC_VECTOR (7 downto 0);

   signal instruction : STD_LOGIC_VECTOR (17 downto 0);

   signal tri_state_bus, in_PC_CNT : STD_LOGIC_VECTOR (9 downto 0);

   begin


--MAP PORTS TO EACH RELEVENT COMPONENT FOLLOWING RAT ARCHITECTURE

PROGRAM_COUTNER: program_counter port map (
                     --PROGRAM COUNTER INPUTS
                     LOAD => in_PC_LD,     --FROM CONTROL UNIT
                     OE => in_PC_OE,       --FROM CONTROL UNIT
                     SEL => in_PC_MUX_SEL, --FROM CONTROL UNIT
                     FROM_IMMED => instruction (12 downto 3), --FROM INST
                     FROM_STACK => tri_state_bus, --INTERNAL BUS
                     CLK => CLK,          --FROM BOARD
                     RST => RST,          --FROM BOARD
                     --PROGRAM COUNTER OUTPUTS
                     PC_COUNT => in_PC_CNT,     --TO PROM
                     PC_TRI => tri_state_bus    --TO INTERNAL BUS
                     );


P_ROM: prog_rom port map (
            --PROGRAM ROM INPUTS
            ADDRESS => in_PC_CNT,      --FROM PROGRAM COUNTER
            CLK => CLK,                --FROM BOARD
            --PROGRAM ROM OUTPUTS
            INSTRUCTION => instruction --TO INSTRUCTION
            );


REGISTER_FILE: RegisterFile port map (
                  --REGISTER FILE INPUTS
                  REG_MUX_SEL => in_RF_WR_SEL,          --FROM CONTROL UNIT
                  IN_PORT => IN_PORT,                   --FROM BOARD
                  TRI_BUS => tri_state_bus (7 downto 0),--INTERNAL BUS
                  ALU_SUM => ALU_SUM_OUT,               --FROM ALU
                  ADRX => instruction (12 downto 8),    --FROM INSTRUCTION
                  ADRY => instruction (7 downto 3),     --FROM INSTRUCTION
                  DX_OE => in_RF_OE,                    --FROM CONTROL UNIT
                  WE => in_RF_WR,                       --FROM CONTROL UNIT
                  CLK => CLK,                           --FROM BOARD
                  --REGISTER FILE OUTPUTS
                  DX_OUT => tri_state_bus (7 downto 0), --TO INTERNAL BUS
                  DY_OUT => REG_DY_OUT                  --TO ALU and SCRATCH PAD
                  );


CONTROLUNIT: control_unit port map (
                        --CONTROL UNIT INPUTS
                        C => in_C_FLAG,
                        Z => in_Z_FLAG,
                        INT => '0', --not used Lab 7
                        RST => RST,
                        OPCODE_HI_5 => instruction (17 downto 13),
                        OPCODE_LO_2 => instruction (1 downto 0),
                        CLK => CLK,

                        --CONTROL UNIT OUTPUTS
                        --OUTPUTS TO PROGRAM COUNTER
                        PC_LD => in_PC_LD,
                        PC_MUX_SEL => in_PC_MUX_SEL,
                        PC_OE => in_PC_OE,
                        --OUTPUTS TO STACK POINTER
                        SP_LD => in_SP_LD,
                        SP_MUX_SEL => in_SP_MUX_SEL,
                        --OUPUT RESET TO PROGRAM COUNTER AND STACK POINTER
                        RESET => in_RESET,
                        --OUTPUTS TO REGISTER FILE
                        RF_WR => in_RF_WR,
                        RF_WR_SEL => in_RF_WR_SEL,
                        RF_OE => in_RF_OE,
                        --OUTPUTS TO ALU
                        ALU_MUX_SEL => in_ALU_MUX_SEL,
                        ALU_SEL => in_ALU_SEL,
                        --OUTPUTS TO SCRATCHPAD
                        SCR_WR => in_SCR_WR,
                        SCR_OE => in_SCR_OE,
                        SCR_ADDR_SEL => in_SCR_ADR_SEL,
                        --OUTPUTS TO C_FLAG REGISTER
                        C_FLAG_SEL => in_C_FLAG_SEL,
                        C_FLAG_LD => in_C_FLAG_LD,
                        C_FLAG_SET => in_C_FLAG_SET,
                        C_FLAG_CLR => in_C_FLAG_CLR,
                        --OUTPUTS TO Z_FLAG REGISTER
                        Z_FLAG_SEL => in_Z_FLAG_SEL,
                        Z_FLAG_LD => in_Z_FLAG_LD,
                        Z_FLAG_SET => in_Z_FLAG_SET,
                        Z_FLAG_CLR => in_Z_FLAG_CLR,
                        --OUTPUTS TO INTERRUPT REGISTER
                        I_FLAG_SET => in_I_FLAG_SET,
                        I_FLAG_CLR => in_I_FLAG_CLR,
                        --OUTPUTS TO OUTPUTS MODULE
                        IO_OE => IO_OE);

STACK: StackPointer port map (
      --STACK POINTER INPUTS
      INC_DEC => in_SP_MUX_SEL,           --FROM CONTROL UNIT
      D_IN => tri_state_bus (7 downto 0), --INTERNAL BUS
      WE => in_SP_LD,                     --FROM CONTROL UNIT
      RST => RST,                         --FROM BOARD
      CLK => CLK,                         --FROM BOARD
      --STACK POINTER OUTPUTS
      STK_PNTR => pointer                 --INTERNAL POINTER SIGNAL
      );

Scratch: ScratchPadMemory port map (
            --SCRATCH PAD INPUTS
            IMMED_ADR => instruction (7 downto 0), --INSTRUCTION
            SP_ADR => pointer,                     --POINTER
            RS_ADR => REG_DY_OUT,                  --FROM REGISTER
            SCR_ADR_SEL => in_SCR_ADR_SEL,         --FROM CONTROL UNIT
            SP_WE => in_SCR_WR,                    --FROM CONTROL UNIT
            SP_OE => in_SCR_OE,                    --FROM CONTROL UNIT
            CLK => CLK,                            --FROM BOARD
            --SCRATCH PAD OUTPUTS
            SP_DATA => tri_state_bus               --TO TRI-STATE-BUS
            );

ALUnit: ALU port map (
            --ALU INPUTS
            A => tri_state_bus (7 downto 0),    --INTERNAL BUS
            C_in => in_C_FLAG,                  --FROM C_FLAG REGISTER
            REG_in => REG_DY_OUT,               --FROM REGISTER FILE
            IMMED => instruction (7 downto 0),  --FROM INSTRUCTION
            MUX_SEL => in_ALU_MUX_SEL,          --FROM CONTROL UNIT
            SEL => in_ALU_SEL,                  --FROM CONTROL UNIT
            --ALU OUTPUTS
            SUM => ALU_SUM_OUT,                 --TO REGISTER FILE
            C_FLAG => in_C_FLAG_IN,             --TO C_FLAG REGISTER
            Z_FLAG => in_Z_FLAG_IN              --TO Z_FLAG REGISTER
            );

CREG: FlagReg port map (
           --C FLAG REG INPUTS
           IN_FLAG  => in_C_FLAG_IN,   --FROM ALU
           LD => in_C_FLAG_LD,         --FORM CONTROL UNIT
           SET => in_C_FLAG_SET,       --FROM CONTROL UNIT
           CLR => in_C_FLAG_CLR,       --FROM CONTROL UNIT
           CLK => CLK,                 --FROM BOARD
           --C FLAG REG OUTPUTS
           OUT_FLAG => in_C_FLAG       --TO ALU
           );

ZREG: FlagReg port map (
           --Z FLAG REG INPUTS
           IN_FLAG  => in_Z_FLAG_IN,   --FROM ALU
           LD => in_Z_FLAG_LD,         --FORM CONTROL UNIT
           SET => in_Z_FLAG_SET,       --FROM CONTROL UNIT
           CLR => in_Z_FLAG_CLR,       --FROM CONTROL UNIT
           CLK => CLK,                 --FROM BOARD
           --C FLAG REG OUTPUTS
           OUT_FLAG => in_Z_FLAG       --TO ALU
           );

   --GIVE PORT_ID VALUE FROM INSTRUCTION
   port_id <= instruction (7 downto 0);
   out_port <= tri_state_bus (7 downto 0);

end Behavioral;
