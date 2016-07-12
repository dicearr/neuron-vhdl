----------------------------------------------------------------------------------
-- Engineer: Diego Ceresuela, Oscar Clemente.
-- 
-- Create Date: 18.04.2016 11:33:46
-- Module Name: data_types - Package
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package data_types is
    type vector is array (natural range <>) of STD_LOGIC_VECTOR (31 downto 0); 
    function to_vec (slv: std_logic_vector) return vector;
     function to_slv (v: vector) return std_logic_vector;
end data_types;

package body data_types is

    function to_vec (slv: std_logic_vector) return vector is
    variable c : vector (0 to (slv'length/32)-1);
    begin
        for I in c'range loop
            c(I) := slv((I*32)+31 downto (I*32));
        end loop;
        return c;
    end function to_vec;
    
    function to_slv (v: vector) return std_logic_vector is
    variable slv : std_logic_vector ((v'length*32)-1 downto 0);
    begin
        for I in v'range loop
            slv((I*32)+31 downto (I*32)) := v(I);  
        end loop;
        return slv;
    end function to_slv;
end data_types; 
