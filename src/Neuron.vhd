----------------------------------------------------------------------------------
-- Engineer: Diego Ceresuela, Oscar Pedrico.
-- 
-- Create Date: 13.04.2016 09:27:04
-- Module Name: Neuron - Behavioral
-- Description: Implements a neuron prepared to be connected into a network using an aproximation of the sigmoid
--  function based on a ROM and using Q15.16 signed codification.
-- 
-- Dependencies: sigmoid.vhd data_types.vhd adder_tree.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 	Worst negative slack is not always in the correct range.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.data_types.all;

entity Neuron is
    generic ( n : integer := 0 );
    Port ( slv_Xin, slv_Win : in STD_LOGIC_VECTOR ((n*32)+31 downto 0); --Values
           clk : in STD_LOGIC;
           O : out STD_LOGIC_VECTOR (31 downto 0)  );
end Neuron;

architecture Behavioral of Neuron is
    component sigmoid
        port ( Y : in STD_LOGIC_VECTOR (31 downto 0);
               O : out STD_LOGIC_VECTOR (31 downto 0);
               clk: in STD_LOGIC );
    end component;
    component adder_tree
    generic (
            NINPUTS : integer;
            IWIDTH  : integer;
            OWIDTH  : integer
        );
        port (
            rstN   : in  std_logic;
            clk    : in  std_logic;
            d      : in  std_logic_vector(NINPUTS*IWIDTH-1 downto 0);
            q      : out signed(OWIDTH-1 downto 0)
        );
    end component;
    signal sum : signed(31 downto 0) := x"00000000";
    signal Y : STD_LOGIC_VECTOR (31 downto 0); 
    signal Xin, Win, Prod : vector (0 to n) := (others => x"00000000"); 
    signal d : STD_LOGIC_VECTOR ((n*32)+31 downto 0); 
begin
    SIG : sigmoid port map (Y => Y, O => O, clk => clk);
    G1: if n>0 generate
        ADDER : adder_tree
            generic map ( NINPUTS => n+1, IWIDTH => 32, OWIDTH => 32)
            port map ( rstN => '1', clk => clk, d => d, q => sum);  
    end generate G1;  
      
    Xin <= to_vec(slv_Xin);
    Win <= to_vec(slv_Win);
    d <= to_slv(Prod);
    
    process (Xin, Win,sum)  
    begin 
        if (n>0) then
            L1: for I in 0 to n loop
                Prod(I) <= to_stdlogicvector(to_bitvector(std_logic_vector(signed(Xin(I)) * signed(Win(I)))) sra 16)(31 downto 0);
            end loop L1;
        end if;  
    end process;
    
    process (clk)
    begin
        if rising_edge(clk) then
            if (n<1) then
                Y <= to_stdlogicvector(to_bitvector(std_logic_vector(signed(Xin(0)) * signed(Win(0)))) sra 16)(31 downto 0);
            else
                Y <= std_logic_vector(sum); 
            end if;
        end if;
    end process;

end Behavioral;
