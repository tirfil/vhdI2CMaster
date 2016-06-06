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
		DATA_VALID	: in	std_logic;
		DIN		: in	std_logic_vector(7 downto 0);
		ADR		: out	std_logic_vector(3 downto 0);
		DATA		: out	std_logic_vector(7 downto 0);
		LOAD		: out	std_logic;
		COMPLETED		: out	std_logic;
		RESCAN		: in	std_logic
	);
end MPU6050;

architecture rtl of MPU6050 is
	type tstate is (S_IDLE, S_PWRMGT0, S_PWRMGT1, S_READ0, S_READ1, S_STABLE );
	signal state : tstate;
	signal adr_i : std_logic_vector(3 downto 0);

begin

	ADR <= adr_i;

	OTO: process(MCLK, nRST)
	begin
		if (nRST = '0') then
			SRST <='0';
			DOUT <= (others=>'0');
			RD <= '0';
			WE <= '0';
			adr_i <= (others=>'0');
			LOAD <= '0';
			DATA <= (others=>'1');
			COMPLETED <= '0';
			state <= S_IDLE;
		elsif (MCLK'event and MCLK = '1') then
			if (state = S_IDLE) then
				SRST <='0';
				DOUT <= (others=>'0');
				RD <= '0';
				WE <= '0';
				adr_i <= (others=>'0');
				LOAD <= '0';
				DATA <= (others=>'1');
				COMPLETED <= '0';
				state <= S_PWRMGT0;
			elsif (state = S_PWRMGT0) then -- init power management
				if (TIC = '1') then
					DOUT <= x"6B";
					WE <= '1';
					RD <= '0';
					if (QUEUED = '1') then
						DOUT <= x"00";
						WE <= '1';
						RD <= '0';
						state <= S_PWRMGT1;
					elsif (NACK = '1') then
						state <= S_IDLE;
					end if;
				end if;
			elsif (state = S_PWRMGT1) then
				if (TIC = '1') then
					if (QUEUED = '1') then
						DOUT <= x"00";
						WE <= '0';
						RD <= '0';
						state <= S_READ0;
					elsif (NACK = '1') then
						state <= S_IDLE;
					end if;
				end if;
			elsif (state = S_READ0) then	
				if (TIC = '1') then
					if (STOP = '1') then
						DOUT <= x"3B";			-- read 14 registers
						WE <= '1';
						RD <= '0';
					elsif (QUEUED = '1') then
						WE <= '0';
						RD <= '1';
						adr_i <= (others=>'0');
					elsif (DATA_VALID = '1') then
						LOAD <= '1';
						DATA <= DIN;
						state <= S_READ1;	
					elsif (NACK = '1') then
						state <= S_IDLE;
					end if;	
				end if;
			elsif (state = S_READ1) then
				if (TIC = '1') then
					if (DATA_VALID = '1') then
						LOAD <= '1';
						DATA <= DIN;
					elsif (QUEUED = '1') then
						adr_i <= std_logic_vector(to_unsigned( to_integer(unsigned( adr_i )) + 1, 4) );
						if (adr_i = "1100") then  -- last one
							WE <= '0';
							RD <= '0';
						else
							WE <= '0';
							RD <= '1';
						end if;
					elsif (STOP = '1') then
						state <= S_STABLE;
					else
						LOAD <= '0';
					end if;
				end if;
			elsif (state = S_STABLE) then
				COMPLETED <= '1';
				if (TIC = '1') then
					if (RESCAN = '1') then
						state <= S_IDLE;
					end if;
				end if;
			end if;
		end if;
	end process OTO;

end rtl;

