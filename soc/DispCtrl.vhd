--------------------------------------------------------------------------------
-- Company: 	Digilent Ro
-- Engineer:	Mircea Dabacan
--
-- Create Date:    11:43:28 10/28/06
-- Design Name:    
-- Module Name:    DispCtrl - Behavioral
-- Project Name:   
-- Target Device:  
-- Tool versions:  
-- Description:	 Generates the immage for the VGA Demo
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Modified for Basys: mouse removed, 
--                                     text removed, 
--                                     transparent background
-- Revision 0.03 - March 22, 2009: Modified for Basys2UserDemo:
--                                    - combined with the Synchro component
--                                    - mouse removed, 
--                                    - logo removed, 
--                                    - static horizontal bars
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DispCtrl is
  Port (ck: in std_logic;  -- 50MHz
--        Hcnt: in std_logic_vector(9 downto 0);      -- horizontal counter
--        Vcnt: in std_logic_vector(9 downto 0);      -- verical counter
        HS: out std_logic;					-- horizontal synchro signal					
        VS: out std_logic;					-- verical synchro signal 

        outRed  : out std_logic_vector(2 downto 0); -- final color
        outGreen: out std_logic_vector(2 downto 0);	 -- outputs
        outBlue : out std_logic_vector(2 downto 1)
		  );
end DispCtrl;

architecture Behavioral of DispCtrl is

-- constants for Synchro module
  constant PAL:integer:=640;		--Pixels/Active Line (pixels)
  constant LAF:integer:=480;		--Lines/Active Frame (lines)
  constant PLD: integer:=800;	--Pixel/Line Divider
  constant LFD: integer:=521;	--Line/Frame Divider
  constant HPW:integer:=96;		--Horizontal synchro Pulse Width (pixels)
  constant HFP:integer:=16;		--Horizontal synchro Front Porch (pixels)
--  constant HBP:integer:=48;		--Horizontal synchro Back Porch (pixels)
  constant VPW:integer:=2;		--Verical synchro Pulse Width (lines)
  constant VFP:integer:=10;		--Verical synchro Front Porch (lines)
--  constant VBP:integer:=29;		--Verical synchro Back Porch (lines)


-- signals for VGA Demo
  signal Hcnt: std_logic_vector(9 downto 0);      -- horizontal counter
  signal Vcnt: std_logic_vector(9 downto 0);      -- verical counter
  signal intHcnt: integer range 0 to 800-1; --PLD-1 - horizontal counter
  signal intVcnt: integer range 0 to 521-1; -- LFD-1 - verical counter

  signal ck25MHz: std_logic;		-- ck 25MHz

begin

-- divide 50MHz clock to 25MHz
  div2: process(ck)
  begin
    if ck'event and ck = '1' then
	   ck25MHz <= not ck25MHz; 
    end if;
  end process;	 

  syncro: process (ck25MHz)
  begin

  if ck25MHz'event and ck25MHz='1' then
    if intHcnt=PLD-1 then
       intHcnt<=0;
      if intVcnt=LFD-1 then intVcnt<=0;
      else intVcnt<=intVcnt+1;
      end if;
    else intHcnt<=intHcnt+1;
    end if;
	
	-- Generates HS - active low
	if intHcnt=PAL-1+HFP then 
		HS<='0';
	elsif intHcnt=PAL-1+HFP+HPW then 
		HS<='1';
	end if;

	-- Generates VS - active low
	if intVcnt=LAF-1+VFP then 
		VS<='0';
	elsif intVcnt=LAF-1+VFP+VPW then
		VS<='1';
	end if;
end if;
end process; 

-- mapping itnernal integers to std_logic_vector ports
  Hcnt <= conv_std_logic_vector(intHcnt,10);
  Vcnt <= conv_std_logic_vector(intVcnt,10);

  mixer: process(ck25MHz,intHcnt, intVcnt) 
  begin
    if intHcnt < PAL and intVcnt < LAF then	-- in the active screen

      if Vcnt(7 downto 6) = "00" then
         outRed <= Vcnt(5 downto 3); 
         outGreen <= "000"; 
         outBlue <= "00"; 
      elsif Vcnt(7 downto 6) = "01" then
         outRed <= "000"; 
         outGreen <= Vcnt(5 downto 3); 
         outBlue <= "00"; 
      elsif Vcnt(7 downto 6) = "10" then
         outRed <= "000"; 
         outGreen <= "000"; 
         outBlue <= Vcnt(5 downto 4); 
      else
         outRed(2 downto 1) <= Vcnt(5 downto 4); 
         outGreen(2 downto 1) <= Vcnt(5 downto 4); 
         outBlue <= Vcnt(5 downto 4); 
      end if;

    else
         outRed <= (others => '0'); 
         outGreen <= (others => '0'); 
         outBlue <= (others => '0'); 
    end if;   
  end process;

end Behavioral;
