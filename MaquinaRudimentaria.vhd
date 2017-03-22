library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PaqueteMRFuncional.all;

entity MaquinaRudimentaria is
	port (
		clk : in std_logic;
		rst : in std_logic
	);
end entity MaquinaRudimentaria;

architecture Funcional of MaquinaRudimentaria is
begin
	Processador: process
		variable CP				: integer;
		variable RI				: tInstruccion;
		variable Programa		: tVectorInst(0 to cNumInst);
		variable MemDatos		: tVectorInst(0 to cNumInst);
		variable N				: boolean;
		variable C				: boolean;
		variable Registros		: tVectorDatos(0 to cNumRegistros);
		
		alias Rd				: integer is RI.Campo1;
		alias Rx				: integer is RI.Campo2;
		alias DireccionBase		: integer is RI.Campo3;
		alias Rf				: integer is RI.Campo1;
		alias Rf1				: integer is RI.Campo2;
		alias Numero			: integer is RI.Campo3;
		alias Rf2				: integer is RI.Campo3;
		alias Direccion			: integer is RI.Campo1;
		
		procedure LeerInstruccion is
		begin
			RI := Programa(CP);
			CP := CP + 1;
		end LeerInstruccion;
		
		procedure EjecutarInstruccion is
			variable DirAbsoluta: integer;
		begin
			case RI.CodigoOperacion is
			when LOAD =>
				DirAbsoluta := DireccionBase + Registros(Rx);
				Registros(Rd) := MemDatos(DirAbsoluta);
				N := (Registros(Rd) < 0);
				C := (Registros(Rd) = 0);
			when STORE =>
				DirAbsoluta := DireccionBase + Registros(Rx);
				MemDatos(DirAbsoluta) := Registros(Rd);
				N := (Registros(Rd) < 0);
				C := (Registros(Rd) = 0);
			when BR =>
				CP := Direccion;
			when BEQ =>
				if C then
					CP := Direccion;
				end if;				
			when BL =>
				if N then
					CP := Direccion;
				end if;
			when BLE =>
				if C or N then
					CP := Direccion;
				end if;
			when BNE =>
				if not C then
					CP := Direccion;
				end if;
			when BGE =>
				if C or (not N) then
					CP := Direccion;
				end if;
			when BG =>
				if (not C) or (not N) then
					CP := Direccion;
				end if;
			when ADDI =>
				Registros(Rd) := Registros(Rf1) + Numero;
				N := (Registros(Rd) < 0);
				C := (Registros(Rd) = 0);				
			when SUBI =>
				Registros(Rd) := Registros(Rf1) - Numero;
				N := (Registros(Rd) < 0);
				C := (Registros(Rd) = 0);
			when ADD =>
				Registros(Rd) := Registros(Rf1) + Registros(Rf2);
				N := (Registros(Rd) < 0);
				C := (Registros(Rd) = 0);
			when SUB =>
				Registros(Rd) := Registros(Rf1) - Registros(Rf2);
				N := (Registros(Rd) < 0);
				C := (Registros(Rd) = 0);
			when ASR =>
				Registros(Rd) := Registros(Rf1) / 2;
				N := (Registros(Rd) < 0);
				C := (Registros(Rd) = 0);
			when ANDL =>
				Registros(Rd) := Registros(Rf1) and Registros(Rf2);
				N := (Registros(Rd) < 0);
				C := (Registros(Rd) = 0);
			end case;
		end EjecutarInstruccion;
		
		procedure InicializaMemoria is
		begin
			Programa(0) := ( LOAD,  2, 0, 0 );
			Programa(1) := ( LOAD,  3, 0, 0 );
			Programa(2) := ( ADD,   4, 3, 2 );
			Programa(3) := ( STORE, 4, 0, 2 );
			MemDatos(0) := 10;
			MemDatos(1) := 20;
		end InicializaMemoria;
		
	begin
		-- Inicialización del programa
		InicializaMemoria;
		CP := 0;
		Registros(0) := 0;
		loop
			LeerInstruccion;
			EjecutarInstruccion;
			wait for 10 ns;
		end loop;
	end process;
	
end architecture Funcional;