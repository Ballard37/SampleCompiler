%option noyywrap c++ yylineno

%{
#include <iostream>
#include <cstdlib>
#include "Parserbase.h"
%}

DIGIT [0-9]
WS  [ \t\n]

%%

"\n"		//NEWLINE
"("         return Parser::ZAROJEL_NYIT;
")"         return Parser::ZAROJEL_ZAR;
"{"         return Parser::KAPCSOS_NYIT;
"}"         return Parser::KAPCSOS_ZAR;
"+"         return Parser::PLUSZ;
"-"         return Parser::MINUSZ;
"*"         return Parser::SZORZAS;
"/"         return Parser::OSZTAS;
"%"         return Parser::MOD;
"<"         return Parser::KISEBB;
">"         return Parser::NAGYOBB;
"!"         return Parser::NOT;
"&&"        return Parser::AND;
"||"        return Parser::OR;
"="         return Parser::EQUALS;
"=="        return Parser::ISEQUAL;
">>"		return Parser::SHIFTRIGHT;
"<<"		return Parser::SHIFTLEFT;
";"         return Parser::PONTOSVESSZO;
"int"       return Parser::INT;
"main"      return Parser::MAIN;
"unsigned"  return Parser::UNSIGNED;
"bool"      return Parser::BOOL;
"true"      return Parser::TRUE;
"false"     return Parser::FALSE;
"if"        return Parser::IF;
"else"      return Parser::ELSE;
"while"     return Parser::WHILE;
"cout"      return Parser::COUT;
"cin"       return Parser::CIN;
"//".*		//kommment nem megy át a szintaktikus elemzőbe! 
[a-zA-Z_]+[0-9a-zA-Z_]*     return Parser::VALTOZO;
{DIGIT}+	return Parser::SZAMERTEK;

{WS}+       // feher szokozok: semmi teendo

"&"[^&]  		{
                std::cerr << lineno() << ": Lexikalis hiba."<< std::endl;
                exit(1);
            }
"|"[^|]		{
                std::cerr << lineno() << ": Lexikalis hiba."<< std::endl;
                exit(1);
            }

.           {
                std::cerr << lineno() << ": Lexikalis hiba."<< std::endl;
                exit(1);
            }

%%
