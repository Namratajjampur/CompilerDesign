#include<stdio.h>
//#include<stido.h>		// error handling

struct outer
{
	float mem_arr[10][2],mem_flt;		// array declaration, multiple declarations seperated by comma
	int mem_int;
	//  int err_assign=1;			//error as cant assign in structure
}global_struct_outer1,global_struct_outer2;

struct inner
{
	int inner_mem;
	struct outer nested_struct;		// nested structure implementation

}inner_arr[10],in_struct;		// multiple global declaration, including array

float global_var=30;				// global variables

int main()
{

	int b= 5,a[1][2][3],c;		//all combinations of declaration
	
	int d;
	struct inner local_decl;	// local declaration of structure with nested structure member

	local_decl.nested_struct.mem_int = 1;
	local_decl.nested_struct.mem_int++;     //use of unary operator , value should be 2

	b += 1;					// use of += operator	so value will be 16;
	c = 2*b+1; 
	
	//arithmetic operatons
	
	d = b + c;
	in_struct.inner_mem = local_decl.nested_struct.mem_int * d;   // type mismatch, warning 

	global_struct_outer1.mem_flt = 100.12; 	// global structure member asignment
	
	//int g = 1+ global_struct_outer1.mem_flt ;	//float to int converion

	// WHILE 

	/*while( b ==  c )			// checking for while
	{
		c = 50;
		
		while( c > 10 || c == 5)			// nested while         
		{
			c--;
			c = d/2;
		}
	}*/
	
	//int d =9;		// error redifining same variable in scope
	//SWITCH
	
	switch(b)
	{
		case 1:	c = b + d; c = b - d; break;
		case 2:	switch(a)				//nested switch
			{
				case 1: c = 2;break;
				case 5:	c +=2;break;
				case 4: c-=2;break;
				default: c--;break;
			}
			break;
		default: c++;

	}
	

}


