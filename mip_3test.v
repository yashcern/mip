module test_mips32;
 
   reg clk1, clk2;
   integer k;

   pipe_mips32  mips (clk1, clk2);

   initial 
     begin
       clk1 = 0; clk2 =0;
       repeat (50)                                        // Generating two-phase clock
         begin
           #5 clk1 = 1;  #5 clk2 = 0;
           #5 clk1 = 1;  #5 clk2 = 0;
         end 
     end
    initial 
       begin
            for (k=0; k<31; k++)
            mips.reg [k] = k;

            mips.mem[0] = 32'h280a00c8;                       // ADDI  R10, R0, 200
            mips.mem[1] = 32'h28020001;                       // ADDI  R2,  R0, 1
            mips.mem[2] = 32'h0e94a000;                       // OR    R20, R20, R20  -- dummy instr
            mips.mem[3] = 32'h21430000;                       // LW    R3,  0 (R10) 
            mips.mem[4] = 32'h0e94a000;                       // OR    R20, R20, R20 -- dummy instr
            mips.mem[5] = 32'h14431000;                       // LOOP  MUL  R2, R2, R3
            mips.mem[6] = 32'h2c630001;                       // SUBI  R3,  R3,  1 
            mips.mem[7] = 32'h0e94a000;                       // OR    R20, R20, R20  -- dummy instr
            mips.mem[8] = 32'h3460fffc;                       // BNEQZ R3,  LOOP     (i.e. -4 offset)
            mips.mem[9] = 32'h3460fffc;                       // SW    R2, -2(R10)
            mips.mem[10] = 32'hfc000000;                      // HLT
        
            mips.mem[200] = 7;                                // Find factorial of 7

            mips.PC = 0;
            mips.HALTED = 0;
            mips.TAKEN_BRANCH = 0;

            #2000 $ display ("Mem[200] = %2d, Mem[198] = %6d", mips.Mem[200], mips.Mem[198]);
       end
    initial 
       begin
           $dumpfile ("mips.vcd");
           $dumpvars (0, test_mips32);
           $monitor  ("R2: %4d, mips.Reg[2]");
           #3000  $finish;
       end
endmodule