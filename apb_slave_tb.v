// APB Testbench - Implements a simple APB Slave

`define CLK @(posedge pclk)

module apb_slave_tb ();
  
	reg	pclk;
	reg 			preset_n; 	
    reg [31:0]	prdata_i;
 	reg			pready_i;
    reg[1:0]		add_i;		
  
	wire 			psel_o;
	wire 			penable_o;
  	wire [31:0]	paddr_o;
	wire			pwrite_o;
  	wire [31:0] 	pwdata_o;
  	
  // clock
  always begin
    pclk = 1'b0;
    #5;
    pclk = 1'b1;
    #5;
  end
  
  // Instantiate the RTL
  apb_add_master  APB_MASTER ( .pclk(pclk),
  .preset_n(preset_n), 	
  .add_i(add_i),		
  .prdata_i(prdata_i), 
 .pready_i(pready_i),
  
   .psel_o(psel_o),
   .penable_o(penable_o), 
  .paddr_o(paddr_o),
 .pwrite_o(pwrite_o),
  .pwdata_o(pwdata_o));
  
  // stimulus
  initial begin
    preset_n = 1'b0; 
    add_i = 2'b00;
    repeat (2) `CLK;
    preset_n = 1'b1;
    repeat (2) `CLK; 
    
    add_i = 2'b01; 
    `CLK; 
    add_i = 2'b00;
    repeat (4) `CLK; 
    
    add_i = 2'b11;
    `CLK; 
    add_i = 2'b00;
    repeat (4) `CLK; 
    //$finish();
  end
  
  always @(posedge pclk or negedge preset_n) 
  begin
    if (~preset_n)
      pready_i <= 1'b0; 
    else 
	begin
       if (psel_o && penable_o)  
	    begin
          pready_i <= 1'b1; 
          prdata_i <= $random%32'h20;
        end 
	   else 
	    begin
          pready_i <= 1'b0; 
          prdata_i <= $random%32'hFF; 
       end
    end
  end
  
endmodule 