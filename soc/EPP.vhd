----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/10/2013 01:34:07 AM
-- Design Name: 
-- Module Name: epp_interface - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

 entity epp_interface is
   port (Clk     : in    std_logic;
         -- EPP interface
         EppAstb : in    std_logic;
         EppDstb : in    std_logic;
         EppWR   : in    std_logic;
         EppWait : out   std_logic;
         EppDB   : inout std_logic_vector(7 downto 0);

         -- output
         reg0 : in    std_logic_vector(7 downto 0);
         reg1 : in    std_logic_vector(7 downto 0)
   );
 end epp_interface;

 architecture Behavioral of epp_interface is
   
   signal address    : std_logic_vector(7 downto 0) := (others => '0');
   signal port0data : std_logic_vector(7 downto 0) := (others => '0');
   begin   
      process(clk)
      --type   epp_state is (idle, data_read, data_read_b, data_write, data_write_b, addr_read, addr_read_b, addr_write, addr_write_b);
      type   epp_state is (idle, data_read, data_write, data_clean, addr_read, addr_write, addr_clean);
      variable state : epp_state := idle;
      variable next_state : epp_state := idle;
            begin
      
            if rising_edge(clk) then
               case state is
                  when data_read  =>
                     case address is
                        when "00000000" =>
                           EppDB <= reg0;
                        when "00000001" =>
                           EppDB <= reg1;
                        when others =>
                     end case;
                     next_state := data_clean;
                     
                  when data_write =>
                     next_state := data_clean;
                  
                  when data_clean =>
                     EppWait <= '1';
    
                     if EppDstb = '1' then
                        next_state := idle;
                     end if;
      
                  when addr_read  =>
                     EppDB   <= address;
                     next_state := addr_clean;
      
                  when addr_write =>
                     address <= eppDB;
                     next_state := addr_clean;
                  
                  when addr_clean =>
                     EppWait <= '1';
                     if EppAstb = '1' then
                        next_state := idle;
                     end if;
      
                  when others =>
                     EppWait  <= '0';
                     EppDB <= "ZZZZZZZZ";
                     if EppWr = '0' then
                        if  EppAstb = '0' then
                           next_state := addr_write;
                        elsif EppDstb = '0' then
                           next_state := data_write;
                        end if;
                     else
                        if EppDstb = '0' then
                           next_state := data_read;
                        elsif EppAstb = '0' then
                           next_state := addr_read;
                        end if;
                     end if;
               end case;
               state := next_state;
            end if;
         end process;
   end Behavioral;