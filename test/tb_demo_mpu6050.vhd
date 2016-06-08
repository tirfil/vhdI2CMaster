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

entity tb_DEMO_MPU6050 is
end tb_DEMO_MPU6050;

architecture stimulus of tb_DEMO_MPU6050 is

-- COMPONENTS --
	component DEMO_MPU6050
		port(
			MCLK		: in	std_logic;
			RESET		: in	std_logic;
			SDA		: inout	std_logic;
			SCL		: inout	std_logic;
			LEDX		: out	std_logic;
			LEDY		: out	std_logic;
			LEDZ		: out	std_logic;
			LEDSIGN		: out	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal RESET		: std_logic;
	signal SDA		: std_logic;
	signal SCL		: std_logic;
	signal LEDX		: std_logic;
	signal LEDY		: std_logic;
	signal LEDZ		: std_logic;
	signal LEDSIGN		: std_logic;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_DEMO_MPU6050_0 : DEMO_MPU6050
		port map (
			MCLK		=> MCLK,
			RESET		=> RESET,
			SDA		=> SDA,
			SCL		=> SCL,
			LEDX		=> LEDX,
			LEDY		=> LEDY,
			LEDZ		=> LEDZ,
			LEDSIGN		=> LEDSIGN
		);

--
	CLOCK: process
	begin
		while (RUNNING = '1') loop
			MCLK <= '1';
			wait for 10 ns;
			MCLK <= '0';
			wait for 10 ns;
		end loop;
		wait;
	end process CLOCK;

	GO: process
	begin
		RESET <= '1';
		SDA <= 'H';
		SCL <= 'H';
		wait for 1000 ns;
		RESET <= '0';
		wait for 93380 ns;
		SDA <= '0';
		wait for 9740 ns;
		SDA <= 'H';
		wait for 77280 ns;
		SDA <= '0';
		wait for 9660 ns;
		SDA <= 'H';
		wait for 77280 ns;
		SDA <= '0';
		wait for 9660 ns;
		SDA <= 'H';
		wait for 93380 ns;
		SDA <= '0';
		wait for 9660 ns;
		SDA <= 'H';
		wait for 77280 ns;
		SDA <= '0';
		wait for 9660 ns;
		SDA <= 'H';
		wait for 90160 ns;
		SDA <= '0';
		wait for 9660 ns;
		SDA <= 'H';
		wait for 2000000 ns;
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
