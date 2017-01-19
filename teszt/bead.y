%baseclass-preinclude <iostream>
%lsp-needed

%token ZAROJEL_NYIT ZAROJEL_ZAR
%token KAPCSOS_NYIT KAPCSOS_ZAR
%token NOT
%token SHIFTRIGHT SHIFTLEFT PONTOSVESSZO
%token INT MAIN UNSIGNED BOOL IF ELSE WHILE COUT CIN
%token TRUE FALSE 
%token VALTOZO SZAMERTEK

%left AND OR
%left ISEQUAL
%left KISEBB NAGYOBB
%left PLUSZ MINUSZ
%left SZORZAS OSZTAS MOD

%right EQUALS

%%

start:
    INT MAIN ZAROJEL_NYIT ZAROJEL_ZAR KAPCSOS_NYIT utasitasok KAPCSOS_ZAR
    {
        std::cout << "start -> INT MAIN ZAROJEL_NYIT ZAROJEL_ZAR KAPCSOS_NYIT utasitasok KAPCSOS_ZAR" << std::endl;
    }
;

utasitasok:
	// ures
    {
        std::cout << "utasitasok -> epszilon" << std::endl;
    }
|
    utasitas utasitasok
    {
        std::cout << "utasitasok -> utasitas utasitasok" << std::endl;
    }
;

utasitas:
    deklaralas
    {
        std::cout << "utasitas -> deklaralas" << std::endl;
    }
|
   ertekadas
    {
        std::cout << "utasitas -> ertekadas" << std::endl;
    }
|
    beolvas
    {
        std::cout << "utasitas -> beolvas" << std::endl;
    }
|
    kiir
    {
        std::cout << "utasitas -> kiir" << std::endl;
    }
|
    elagazas
    {
        std::cout << "utasitas -> elagazas" << std::endl;
    }
|
    ciklus
    {
        std::cout << "utasitas -> ciklus" << std::endl;
    }
;

deklaralas:
    BOOL VALTOZO PONTOSVESSZO
    {
        std::cout << "deklaralas -> BOOL VALTOZO PONTOSVESSZO" << std::endl;
    }
|
    UNSIGNED VALTOZO PONTOSVESSZO
    {
        std::cout << "deklaralas -> UNSIGNED VALTOZO PONTOSVESSZO" << std::endl;
    }
;    

ertekadas:
	BOOL VALTOZO EQUALS TRUE PONTOSVESSZO
	{
		std::cout << "ertekadas -> BOOL VALTOZO EQUALS TRUE PONTOSVESSZO" << std::endl;
	}
|
	BOOL VALTOZO EQUALS FALSE PONTOSVESSZO
	{
		std::cout << "ertekadas -> BOOL VALTOZO EQUALS FALSE PONTOSVESSZO" << std::endl;
	}
|
	BOOL VALTOZO EQUALS VALTOZO
	{
		std::cout << "ertekadas -> BOOL VALTOZO EQUALS FALSE PONTOSVESSZO" << std::endl;
	}
|
	BOOL VALTOZO EQUALS NOT VALTOZO
	{
		std::cout << "ertekadas -> BOOL VALTOZO EQUALS NOT VALTOZO" << std::endl;
	}
|	
	UNSIGNED VALTOZO EQUALS SZAMERTEK PONTOSVESSZO
	{
		std::cout << "ertekadas -> UNSIGNED VALTOZO EQUALS SZAMERTEK PONTOSVESSZO" << std::endl;
	}
|
	UNSIGNED VALTOZO EQUALS VALTOZO PONTOSVESSZO
	{
		std::cout << "ertekadas -> UNSIGNED VALTOZO EQUALS VALTOZO PONTOSVESSZO" << std::endl;
	}
;

beolvas:
	CIN SHIFTRIGHT VALTOZO PONTOSVESSZO
	{
		std::cout << "beolvas -> CIN SHIFTRIGHT VALTOZO PONTOSVESSZO" << std::endl;
	}
;

kiir:
	COUT SHIFTLEFT kifejezes PONTOSVESSZO
	{
		std::cout << "kiir -> COUT SHIFTLEFT kifejezes" << std::endl;
	}
;

kifejezes:
	VALTOZO
	{
		std::cout << "kifejezes -> VALTOZO" << std::endl;
	}
|
	NOT VALTOZO
	{
		std::cout << "kifejezes -> NOT VALTOZO" << std::endl;
	}
|
	SZAMERTEK
	{
		std::cout << "kifejezes -> SZAMERTEK" << std::endl;
	}
|
	kifejezes PLUSZ kifejezes
	{
		std::cout << "kifejezes -> kifejezes PLUSZ kifejezes" << std::endl;
	}
|
	kifejezes MINUSZ kifejezes
	{
		std::cout << "kifejezes -> kifejezes MINUSZ kifejezes" << std::endl;
	}
|
	kifejezes SZORZAS kifejezes
	{
		std::cout << "kifejezes -> kifejezes SZORZAS kifejezes" << std::endl;
	}
|
	kifejezes OSZTAS kifejezes
	{
		std::cout << "kifejezes -> kifejezes OSZTAS kifejezes" << std::endl;
	}
|
	kifejezes MOD kifejezes
	{
		std::cout << "kifejezes -> kifejezes MOD kifejezes" << std::endl;
	}
|
	kifejezes KISEBB kifejezes
	{
		std::cout << "kifejezes -> kifejezes KISEBB kifejezes" << std::endl;
	}
|
	kifejezes NAGYOBB kifejezes
	{
		std::cout << "kifejezes -> kifejezes NAGYOBB kifejezes" << std::endl;
	}
|
	kifejezes ISEQUAL kifejezes
	{
		std::cout << "kifejezes -> kifejezes ISEQUAL kifejezes" << std::endl;
	}
|
	kifejezes AND kifejezes
	{
		std::cout << "kifejezes -> kifejezes AND kifejezes" << std::endl;
	}
|
	kifejezes OR kifejezes
	{
		std::cout << "kifejezes -> kifejezes OR kifejezes" << std::endl;
	}
;

elagazas:
	IF ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitasok KAPCSOS_ZAR
	{
		std::cout << "elagazas -> IF ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR" << std::endl;
	}
|
	IF ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitasok KAPCSOS_ZAR ELSE KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR
	{
		std::cout << "elagazas -> IF ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR ELSE KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR" << std::endl;
	}
;

ciklus:
	WHILE ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitasok KAPCSOS_ZAR
	{
		std::cout << "ciklus -> WHILE ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR" << std::endl;
	}
;
