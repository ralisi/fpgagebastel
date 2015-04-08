library ieee;
use ieee.std_logic_1164.all;

Library UNISIM;
use UNISIM.vcomponents.all;


entity memory is
  port (
    clka : in std_logic;
    rsta : in std_logic;
    wea : in std_logic;
    addra : in std_logic_vector(9 downto 0);
    dina : in std_logic_vector(31 downto 0);
    douta : out std_logic_vector(31 downto 0)
  );
end memory;


architecture manually of memory is
  attribute LOC : string;
  attribute LOC of RAMB_low:  label is "RAMB16_X0Y0";
  attribute LOC of RAMB_high: label is "RAMB16_X0Y1";
begin

--  <-----Cut code below this line and paste into the architecture body---->

   -- RAMB16_S9: 2k x 8 + 1 Parity bit Single-Port RAM
   --            Spartan-3E
   -- Xilinx HDL Language Template, version 14.7
   RAMB_low : RAMB16_S18
   generic map (
      INIT => X"00000",  --  Value of output RAM registers at startup
      SRVAL => X"00000", --  Output value upon SSR assertion
      WRITE_MODE => "WRITE_FIRST" --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      )
   port map (
      DO => douta(15 downto 0),      -- 32-bit Data Output
      --DOP => DOP,    -- 4-bit parity Output
      ADDR => addra,  -- 9-bit Address Input
      CLK => clka,    -- Clock
      DI => dina(15 downto 0),      -- 32-bit Data Input
      DIP => "00",    -- 2-bit parity Input
      EN => '1',      -- RAM Enable Input
      SSR => rsta,    -- Synchronous Set/Reset Input
      WE => wea       -- Write Enable Input
   );

   RAMB_high : RAMB16_S18
   generic map (
      INIT => X"00000",  --  Value of output RAM registers at startup
      SRVAL => X"00000", --  Output value upon SSR assertion
      WRITE_MODE => "WRITE_FIRST" --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      )
   port map (
      DO => douta(31 downto 16),      -- 32-bit Data Output
      --DOP => DOP,    -- 4-bit parity Output
      ADDR => addra,  -- 9-bit Address Input
      CLK => clka,    -- Clock
      DI => dina(31 downto 16),      -- 32-bit Data Input
      DIP => "00",    -- 2-bit parity Input
      EN => '1',      -- RAM Enable Input
      SSR => rsta,    -- Synchronous Set/Reset Input
      WE => wea       -- Write Enable Input
   );


end manually;
