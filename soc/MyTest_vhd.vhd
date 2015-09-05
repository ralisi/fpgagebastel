library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity MyTest_vhd is
port(
clk_i   : in std_logic
; clk_ext_i   : in std_logic
; reset : in std_logic
; gpioPIO_OUT : out std_logic_vector(7 downto 0);

  HS: out std_logic;
  VS: out std_logic;
  outRed  : out std_logic_vector(2 downto 0);
  outGreen: out std_logic_vector(2 downto 0);
  outBlue : out std_logic_vector(2 downto 1);

  an   : out   std_logic_vector (3 downto 0);
  seg  : out   std_logic_vector (6 downto 0)
);
end MyTest_vhd;

architecture MyTest_vhd_a of MyTest_vhd is

component MyTest
   port(
      clk_i   : in std_logic
      ; reset_n : in std_logic
      ; gpioPIO_OUT : out std_logic_vector(7 downto 0)
      ; memory_passthruclk : out std_logic
      ; memory_passthrurst : out std_logic
      ; memory_passthrumem_adr : out std_logic_vector(31 downto 0)
      ; memory_passthrumem_master_data : out std_logic_vector(31 downto 0)
      ; memory_passthrumem_slave_data : in std_logic_vector(31 downto 0)
      ; memory_passthrumem_strb : out std_logic
      ; memory_passthrumem_cyc : out std_logic
      ; memory_passthrumem_ack : in std_logic
      ; memory_passthrumem_err : in std_logic
      ; memory_passthrumem_rty : in std_logic
      ; memory_passthrumem_sel : out std_logic_vector(3 downto 0)
      ; memory_passthrumem_we : out std_logic
      ; memory_passthrumem_bte : out std_logic_vector(1 downto 0)
      ; memory_passthrumem_cti : out std_logic_vector(2 downto 0)
      ; memory_passthrumem_lock : out std_logic
      );
   end component;

component DispCtrl is
  Port (ck: in std_logic;  -- 50MHz
        ck25MHz: in std_logic;
--        Hcnt: in std_logic_vector(9 downto 0);      -- horizontal counter
--        Vcnt: in std_logic_vector(9 downto 0);      -- verical counter
        HS: out std_logic;					-- horizontal synchro signal					
        VS: out std_logic;					-- verical synchro signal 

        outRed  : out std_logic_vector(2 downto 0); -- final color
        outGreen: out std_logic_vector(2 downto 0);	 -- outputs
        outBlue : out std_logic_vector(2 downto 1);

      an : out std_logic_vector (3 downto 0);
      seg : out std_logic_vector (6 downto 0);

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
end component;

signal reset_n : std_logic;
signal memory_passthruclk : std_logic;
signal memory_passthrurst : std_logic;
signal memory_passthrumem_adr : std_logic_vector(31 downto 0);
signal memory_passthrumem_master_data : std_logic_vector(31 downto 0);
signal memory_passthrumem_slave_data : std_logic_vector(31 downto 0);
signal memory_passthrumem_strb : std_logic;
signal memory_passthrumem_cyc : std_logic;
signal memory_passthrumem_ack : std_logic;
signal memory_passthrumem_err : std_logic;
signal memory_passthrumem_rty : std_logic;
signal memory_passthrumem_sel : std_logic_vector(3 downto 0);
signal memory_passthrumem_we : std_logic;
signal memory_passthrumem_bte : std_logic_vector(1 downto 0);
signal memory_passthrumem_cti : std_logic_vector(2 downto 0);
signal memory_passthrumem_lock : std_logic;

begin
  reset_n <= not reset;

lm32_inst : MyTest
port map (
   clk_i  => clk_i
   ,reset_n  => reset_n
   ,gpioPIO_OUT  => gpioPIO_OUT
   ,memory_passthruclk  => memory_passthruclk
   ,memory_passthrurst  => memory_passthrurst
   ,memory_passthrumem_adr  => memory_passthrumem_adr
   ,memory_passthrumem_master_data  => memory_passthrumem_master_data
   ,memory_passthrumem_slave_data  => memory_passthrumem_slave_data
   ,memory_passthrumem_strb  => memory_passthrumem_strb
   ,memory_passthrumem_cyc  => memory_passthrumem_cyc
   ,memory_passthrumem_ack  => memory_passthrumem_ack
   ,memory_passthrumem_err  => memory_passthrumem_err
   ,memory_passthrumem_rty  => memory_passthrumem_rty
   ,memory_passthrumem_sel  => memory_passthrumem_sel
   ,memory_passthrumem_we  => memory_passthrumem_we
   ,memory_passthrumem_bte  => memory_passthrumem_bte
   ,memory_passthrumem_cti  => memory_passthrumem_cti
   ,memory_passthrumem_lock  => memory_passthrumem_lock
   );

  vga: DispCtrl port map (
    ck => clk_i,
    ck25MHz => clk_ext_i,

    wb_clk  => memory_passthruclk,
    wb_rst  => memory_passthrurst,
    wb_mem_adr  => memory_passthrumem_adr,
    wb_mem_master_data  => memory_passthrumem_master_data,
    wb_mem_slave_data  => memory_passthrumem_slave_data,
    wb_mem_strb  => memory_passthrumem_strb,
    wb_mem_cyc  => memory_passthrumem_cyc,
    wb_mem_ack  => memory_passthrumem_ack,
    wb_mem_err  => memory_passthrumem_err,
    wb_mem_rty  => memory_passthrumem_rty,
    wb_mem_sel  => memory_passthrumem_sel,
    wb_mem_we  => memory_passthrumem_we,
    wb_mem_bte  => memory_passthrumem_bte,
    wb_mem_cti  => memory_passthrumem_cti,
    wb_mem_lock  => memory_passthrumem_lock,

    an => an,
    seg => seg,
    HS => HS,
    VS => VS,
    outRed => outRed,
    outGreen => outGreen,
    outBlue => outBlue
  );

end MyTest_vhd_a;

