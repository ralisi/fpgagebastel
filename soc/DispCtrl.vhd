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
        outBlue : out std_logic_vector(2 downto 1);

    an   : out   std_logic_vector (3 downto 0);
    seg  : out   std_logic_vector (6 downto 0);

  wb_clk : in std_logic;
  wb_rst : in std_logic;
  wb_mem_adr : in std_logic_vector(31 downto 0);
  wb_mem_master_data : in std_logic_vector(31 downto 0);
  wb_mem_slave_data : out std_logic_vector(31 downto 0);
  wb_mem_strb : in std_logic;
  wb_mem_cyc : in std_logic;
  wb_mem_ack : out std_logic;
  wb_mem_err : out std_logic;
  wb_mem_rty : out std_logic;
  wb_mem_sel : in std_logic_vector(3 downto 0);
  wb_mem_we : in std_logic;
  wb_mem_bte : in std_logic_vector(1 downto 0);
  wb_mem_cti : in std_logic_vector(2 downto 0);
  wb_mem_lock : in std_logic
		  );
end DispCtrl;

architecture Behavioral of DispCtrl is

  component SevenSegment is
    port (
      ck50MHz : in  STD_LOGIC;
      we : in std_logic;
      segment_display : in std_logic_vector (15 downto 0);
      an   : out   std_logic_vector (3 downto 0);
      seg  : out   std_logic_vector (6 downto 0)
    );
  end component;

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

  component framebuffer IS
    PORT (
      clka : IN STD_LOGIC;
      rsta : IN STD_LOGIC;
      wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
      dina : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      clkb : IN STD_LOGIC;
      rstb : IN STD_LOGIC;
      web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
      dinb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      doutb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
  END component;
  signal scanPos: std_logic_vector(14 downto 0);
  signal data_vec: std_logic_vector(0 downto 0);
  signal data: std_logic;
  signal dataRead, wbWriteDat: std_logic_vector(3 downto 0);

  type state_type is (wb_idle, wb_read, wb_write);  --type of state machine.
  signal current_s,next_s: state_type;  --current and next state declaration.
  signal wbWrite: std_logic_vector(0 downto 0);
  signal debugData: std_logic_vector(15 downto 0);
  signal debugEn: std_logic;

begin

  debugger: SevenSegment port map (
      ck50MHz => wb_clk,
      we => wbWrite(0),
      segment_display => debugData,
      an => an,
      seg => seg
    );
  debugData <= wb_mem_sel & wb_mem_adr(11 downto 0);

  wb_state_proc: process (wb_clk,wb_rst)
  begin
    if (rising_edge(wb_clk)) then
      if (wb_rst='1') then
        current_s <= wb_idle;  --sync reset
      else
        current_s <= next_s;   --state change.
      end if;
    end if;
  end process;

  wb_action: process (current_s,wb_mem_strb,wb_mem_cyc,wb_mem_we,wb_mem_master_data,dataRead,wb_mem_sel)
  begin
    -- default assignments
    wb_mem_ack <= '0';
    wb_mem_rty <= '0';
    wb_mem_err <= '0';
    wbWrite <= "0";
    wbWriteDat <= "1010";
    next_s <= wb_idle;
    case current_s is
      when wb_idle =>
        if(wb_mem_strb='1' and wb_mem_cyc='1') then
          -- is active
          if (wb_mem_we='1') then
            next_s <= wb_write;
          else
            next_s <= wb_read;
          end if;
        end if;
      when wb_write =>
        next_s <= wb_idle;
        wbWrite <= "1";
        wbWriteDat(0) <= (wb_mem_sel(3) and wb_mem_master_data( 0)) or ((not wb_mem_sel(3)) and dataRead(0));
        wbWriteDat(1) <= (wb_mem_sel(2) and wb_mem_master_data( 8)) or ((not wb_mem_sel(2)) and dataRead(1));
        wbWriteDat(2) <= (wb_mem_sel(1) and wb_mem_master_data(16)) or ((not wb_mem_sel(1)) and dataRead(2));
        wbWriteDat(3) <= (wb_mem_sel(0) and wb_mem_master_data(24)) or ((not wb_mem_sel(0)) and dataRead(3));
        wb_mem_ack <= '1';
      when wb_read =>
        next_s <= wb_idle;
        wb_mem_ack <= '1';
    end case;
  end process;

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


  FRAME: framebuffer port map (
      clka => ck25MHz,
      rsta => '0',
      wea => "0",
      douta => data_vec,
      addra => scanPos,
      dina => "0",
      clkb => wb_clk,
      rstb => '0',
      web => wbWrite,
      doutb => dataRead,
      addrb => wb_mem_adr(14 downto 2),
      dinb => wbWriteDat
    );
  data <= data_vec(0);

-- mapping itnernal integers to std_logic_vector ports
  Hcnt <= conv_std_logic_vector(intHcnt,10);
  Vcnt <= conv_std_logic_vector(intVcnt,10);
  scanPos <= Hcnt(9 downto 2) & Vcnt(8 downto 2);

  mixer: process(ck25MHz,intHcnt, intVcnt, data, current_s)
  begin
    if intHcnt < PAL and intVcnt < LAF then	-- in the active screen

         outRed <= (others => data);
         if current_s=wb_idle then
           outGreen <= (others => '1');
            outBlue <= (others => '1');
         else
           outGreen <= (others => '0');
           outBlue <= (others => '0');
         end if;

    else
         outRed <= (others => '0'); 
         outGreen <= (others => '0'); 
         outBlue <= (others => '0'); 
    end if;   
  end process;

end Behavioral;
