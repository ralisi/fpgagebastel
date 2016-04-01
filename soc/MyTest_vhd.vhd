library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity MyTest_vhd is
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

begin

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

end MyTest_vhd_a;

