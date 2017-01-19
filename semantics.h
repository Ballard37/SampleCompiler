#ifndef SEMANTICS_H
#define SEMANTICS_H

#include <iostream>
#include <map>
#include <string>
#include <sstream>

enum type { unsig , boolean};

 struct var_data{
	 int decl_row;
	 type var_type;
	 
	 var_data(int a, type b): decl_row(a), var_type(b) 
	 {};
	 
	 var_data(){};
 };
 #endif //SEMANTICS_H