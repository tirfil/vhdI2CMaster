--###############################
--# Project Name : 
--# File         : 
--# Author       : 
--# Description  : 
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MPU6050 is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		TIC		: in	std_logic;
		SRST		: out	std_logic;
		DOUT		: out	std_logic_vector(7 downto 0);
		RD		: out	std_logic;
		WE		: out	std_logic;
		QUEUED		: in	std_logic;
		NACK		: in	std_logic;
		STOP		: in	std_logic;
		DATA_VALID		: in	std_logic;
		DIN		: in	std_logic_vector(7 downto 0);
		ADR		: out	std_logic_vector(3 downto 0);
		DATA		: out	std_logic_vector(7 downto 0);
		LOAD		: out	std_logic;
		COMPLETED		: out	std_logic;
		RESCAN		: in	std_logic
	);
end MPU6050;

architecture rtl of MPU6050 is

begin

	TODO: process(MCLK, nRST)
	begin
		if (nRST = '0') then

		elsif (MCLK'event and MCLK = '1') then

	end process TODO;

end rtl;

