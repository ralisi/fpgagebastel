library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity MyTest_vhd is
port(
clk_i   : in std_logic
; reset_n : in std_logic
; gpioPIO_OUT : out std_logic_vector(7 downto 0)
);
end MyTest_vhd;

architecture MyTest_vhd_a of MyTest_vhd is

component MyTest
   port(
      clk_i   : in std_logic
      ; reset_n : in std_logic
      ; gpioPIO_OUT : out std_logic_vector(7 downto 0)
      );
   end component;

begin

lm32_inst : MyTest
port map (
   clk_i  => clk_i
   ,reset_n  => reset_n
   ,gpioPIO_OUT  => gpioPIO_OUT
   );

end MyTest_vhd_a;

