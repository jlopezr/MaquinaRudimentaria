package PaqueteMRFuncional is
	
	type tVectorDatos is array (natural range<>) of integer;	
	
	type tCodigoOperacion is (ADD,SUB,ASR,ANDL,ADDI,SUBI,LOAD,STORE,BR,BL,BG,BEQ,BNE,BLE,BGE);
	
	type tInstruccion is
		record
		CodigoOperacion: tCodigoOperacion;
		Campo1: natural;
		Campo2: natural;
		Campo3: natural;
	end record;
	
	type tVectorInst is array(natural range<>) of tInstruccion;
	
	constant cNumInst: natural;
	constant cNumDatos: natural;
	constant cNumeroRegistros: natural;
	
	function "AND" (A,B: integer) return integer;
		
end package PaqueteMRFuncional;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

package body PaqueteMRFuncional is
	
	constant cNumInst		: natural := 10;
	constant cNumDatos		: natural := 200;
	constant cNumRegistros	: natural := 8;
	constant cMaxBits		: natural := 128;
	
	function "AND" (A,B: integer) return integer is
		variable ABV: signed(0 to cMaxNumBits-1);
		variable BBV: signed(0 to cMaxNumBits-1);
	begin
		ABV := Conv_signed(A, cMaxNumBits);
		BBV := Conv_signed(B, cMaxNumBits);
		Result := std_logic_vector(ABV) and std_logic_vector(BBV);
		return Conv_integer(signed(Result));
	end "AND";
end package body PaqueteMRFuncional;
