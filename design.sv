module fifo(
  input clk,rst,wr,rd,
  input [7:0] din,
  output reg [7:0] dout,
  output empty,full
);
  //To keep track of write and read operations we have wptr and rptr
  //counter (cnt) which allows us to decide the status of the flag
  //memory which is capable of storing 16 elements each of size 8bit
  
  reg [3:0] wptr=0,rptr=0;
  reg [4:0] cnt=0;
  reg [7:0] mem [15:0];
  
  always@(posedge clk)begin
    if(rst==1'b1)
      begin
        //if rst is high all of the pointers are initialized to zero 
        wptr<=0;
        rptr<=0;
        cnt<=0;
      end
    else if(wr && !full)
      begin
         //if wr is high and fifo is not full then new data added in memory with an address is equal to write pointer and data that we have on the din bus
        mem[wptr] <= din;
        //after this,we increment write pointer as well as count varible by one
        wptr <= wptr+1;
        cnt <=cnt+1;
      end
    else if(rd && !empty) 
      begin
        //if rd is high and fifo is not empty then we have some data to read from fifo.so dout will be updated with the data that we have in an memory with an address specified on an Read pointer.
        dout <= mem[rptr];
        rptr <= rptr+1;
        cnt <= cnt-1;
      end
    end
   
      //Since we have 16 elements that could be stored in the memory, count should go from 0 to 15, and as soon as it becomes 16, we should raise a full flag.
    
    //The full flag will be raised when count reaches to a value of 16.
    
    assign full = (cnt==16)? 1'b1:1'b0;
    
    //when count reaches to a value of zero,this basically means either we have not written any data in an Fifo or we have read back all the data that we have written in an Fifo
      
      //The empty flag will be raised when count reaches to a value of 0.
    
    assign empty = (cnt==0)? 1'b1:1'b0;
           
  
  
endmodule
      