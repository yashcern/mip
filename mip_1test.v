module test_mips32;
 
   reg clk1, clk2;
   integer k;

   pipe_mips32  mips (clk1, clk2);

   initial 
     begin
       clk1 = 0; clk2 =0;
       repeat (20)                                        // Generating two-phase clock
         begin
           #5 clk1 = 1;  #5 clk2 = 0;
           #5 clk1 = 1;  #5 clk2 = 0;
         end 
     end

     initial 
       begin
         for (k=0; k<32; k++)
           mips.reg [k] = k;

         mips.mem[0] = 32'h2801000a;                       // ADDI  R1, R0, 10
         mips.mem[1] = 32'h28020014;                       // ADDI  R1, R0, 10
         mips.mem[2] = 32'h28030019;                       // ADDI  R1, R0, 10
         mips.mem[3] = 32'h0ce77800;                       // ADDI  R1, R0, 10 -- dummy instr
         mips.mem[4] = 32'h0ce77800;                       // ADDI  R1, R0, 10 -- dummy instr
         mips.mem[5] = 32'h00222000;                       // ADDI  R1, R0, 10
         mips.mem[6] = 32'h0ce77800;                       // ADDI  R1, R0, 10 -- dummy instr
         mips.mem[7] = 32'h00832800;                       // ADDI  R1, R0, 10
         mips.mem[8] = 32'hfc000000;                       // ADDI  R1, R0, 10
         mips.HALTED = 0;
         mips.PC = 0;
         mips.TAKEN_BRANCH = 0;

         #280
         for (k=0; k<6; k++)
           $display ("R%1d - %2d", k, mips.reg[k]);
       end
     initial 
       begin
         $dumpfile ("mips.vcd");
         $dumpfile(0, test_mips32);
         #300  $finish;
       end
endmodule