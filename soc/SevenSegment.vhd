library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity SevenSegment is
  port (
    ck50MHz : in  STD_LOGIC;
    we : in std_logic;
    segment_display : in std_logic_vector (15 downto 0);
    an   : out   std_logic_vector (3 downto 0);
    seg  : out   std_logic_vector (6 downto 0)
  );
end SevenSegment;

architecture Behavioral of SevenSegment is
  signal active_digit : std_logic_vector (3 downto 0);
  signal buffered_data : std_logic_vector (15 downto 0);
begin

  inputFF: process(ck50MHz)
  begin
    if (rising_edge(ck50MHz) and we='1') then
      buffered_data <= segment_display;
    end if;
  end process;



  with active_digit select
    seg <= 
      "1000000" when x"0",
      "1111001" when x"1",
      "0100100" when x"2",
      "0110000" when x"3",
      "0011001" when x"4",
      "0010010" when x"5",
      "0000010" when x"6",
      "1111000" when x"7",
      "0000000" when x"8",
      "0010000" when x"9",
      "0001000" when x"a",
      "0000011" when x"b",
      "1000110" when x"c",
      "0100001" when x"d",
      "0000110" when x"e",
      "0001110" when others;



  segment_mux: process(ck50MHz)
    variable cnt : integer range 0 to 3 := 0;
    variable slowdown : integer range 0 to 50000 := 0;
  begin
    if rising_edge(ck50MHz) then
      if slowdown=0 then
        an <= (others=>'1');
        an(cnt) <= '0';
        active_digit <= buffered_data(4*cnt+3 downto 4*cnt);
        cnt := cnt + 1;
        slowdown := 50000;
      end if;
      slowdown := slowdown-1;
    end if;
  end process;
end Behavioral;
