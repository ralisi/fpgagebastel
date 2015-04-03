library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity MyTest_vhd is
port(
clk_i   : in std_logic
; reset_n : in std_logic
; gpioPIO_OUT : out std_logic_vector(7 downto 0);

  HS: out std_logic;
  VS: out std_logic;
  outRed  : out std_logic_vector(2 downto 0);
  outGreen: out std_logic_vector(2 downto 0);
  outBlue : out std_logic_vector(2 downto 1)
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

component DispCtrl is
  Port (ck: in std_logic;  -- 50MHz
--        Hcnt: in std_logic_vector(9 downto 0);      -- horizontal counter
--        Vcnt: in std_logic_vector(9 downto 0);      -- verical counter
        HS: out std_logic;					-- horizontal synchro signal					
        VS: out std_logic;					-- verical synchro signal 

        outRed  : out std_logic_vector(2 downto 0); -- final color
        outGreen: out std_logic_vector(2 downto 0);	 -- outputs
        outBlue : out std_logic_vector(2 downto 1)
		  );
end component;

begin

lm32_inst : MyTest
port map (
   clk_i  => clk_i
   ,reset_n  => reset_n
   ,gpioPIO_OUT  => gpioPIO_OUT
   );

  vga: DispCtrl port map (
    ck => clk_i,
    HS => HS,
    VS => VS,
    outRed => outRed,
    outGreen => outGreen,
    outBlue => outBlue
  );

end MyTest_vhd_a;

