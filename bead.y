%baseclass-preinclude "semantics.h"
%lsp-needed

%token ZAROJEL_NYIT ZAROJEL_ZAR
%token KAPCSOS_NYIT KAPCSOS_ZAR
%token NOT
%token SHIFTRIGHT SHIFTLEFT PONTOSVESSZO
%token INT MAIN IF ELSE WHILE COUT CIN
%token UNSIGNED BOOL
%token TRUE FALSE 
%token <valtozonev> VALTOZO 
%token SZAMERTEK

%left AND OR
%left ISEQUAL
%left KISEBB NAGYOBB
%left PLUSZ MINUSZ
%left SZORZAS OSZTAS MOD

%right EQUALS

%union
{
  std::string *valtozonev;
  var_data  *vardata;
}

%type<vardata> kifejezes

%%

start:
    INT MAIN ZAROJEL_NYIT ZAROJEL_ZAR KAPCSOS_NYIT deklaraciok utasitas utasitasok KAPCSOS_ZAR
    {
        std::cout << std::string("") +
            "extern ki_elojeles_egesz\n" +
            "extern ki_logikai\n" +
            "global main\n" +
            "section .text\n" +
            "main:\n" +
            $1->kod +
            "ret\n";
			delete $1;
    }
;

deklaraciok:
	//ures
	{
		std::cout << "deklaraciok -> epszilon" << std::endl;
	}
|	
	deklaralas deklaraciok
	{
		std::cout << "deklaraciok -> deklaralas deklaraciok" << std::endl;
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
        std::cout << "deklaralas -> BOOL VALTOZO PONTOSVESSZO "  << std::endl;
		 if( szimbolumtabla.count(*$2) > 0 )
		  {
			std::stringstream ss;
			ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
			<< "Korabbi deklaracio sora: " << szimbolumtabla[*$2].decl_row << std::endl;
			error( ss.str().c_str() );
		  }
		szimbolumtabla[*$2] = var_data( d_loc__.first_line, boolean );
    }
|
    UNSIGNED VALTOZO PONTOSVESSZO
    {
        std::cout << "deklaralas -> UNSIGNED VALTOZO PONTOSVESSZO" << std::endl;
		 if( szimbolumtabla.count(*$2) > 0 )
		  {
			std::stringstream ss;
			ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
			<< "Korabbi deklaracio sora: " << szimbolumtabla[*$2].decl_row << std::endl;
			error( ss.str().c_str() );
		  }
		szimbolumtabla[*$2] = var_data( d_loc__.first_line, unsig );
    }
;    

ertekadas:
    VALTOZO EQUALS kifejezes PONTOSVESSZO
    {
        std::cout << "ertekadas -> VALTOZO EQUALS kifejezes" << std::endl;
		 if( szimbolumtabla.count(*$1) == 0 )
		  {
			std::stringstream ss;
			ss << "Nem deklarált változó: " << *$1 << ".\n";
			error( ss.str().c_str() );
		  }
		 /* if ($1->var_type != $3->var_type){
			  std::stringstream ss;
			ss <<  $1->decl_row<< ". sor. Rossz típusú értékadás: " << $1->var_type << " Elvárt: "<< $3->var_type << "\n";
			error( ss.str().c_str() );
		  } */
    }
;

beolvas:
	CIN SHIFTRIGHT VALTOZO PONTOSVESSZO
	{
		std::cout << "beolvas -> CIN SHIFTRIGHT VALTOZO PONTOSVESSZO" << std::endl;
		if( szimbolumtabla.count(*$3) == 0 )
		  {
			std::stringstream ss;
			ss << "Nem deklarált változó: " << *$3 << ".\n";
			error( ss.str().c_str() );
		  }
	}
;

kiir:
	COUT SHIFTLEFT kifejezes PONTOSVESSZO
	{
		std::cout << "kiir -> COUT SHIFTLEFT kifejezes" << std::endl;
	}
;

kifejezes:
    TRUE
    {
        std::cout << "kifejezes -> TRUE" << std::endl;
		$$ = new var_data( d_loc__.first_line, boolean );
        //delete $1;
    }
|
    FALSE
    {
        std::cout << "kifejezes -> FALSE" << std::endl;
		$$ = new var_data( d_loc__.first_line, boolean );
        //delete $1;
    }
|
	VALTOZO
	{
		std::cout << "kifejezes -> VALTOZO" << std::endl;
		if( szimbolumtabla.count(*$1) == 0 )
		  {
			std::stringstream ss;
			ss << "Nem deklarált változó: " << *$1 << ".\n";
			error( ss.str().c_str() );
		  }
		  $$ = new var_data(d_loc__.first_line,szimbolumtabla[*$1].var_type );
		  delete $1;
	}
|
	NOT kifejezes
	{
		std::cout << "kifejezes -> NOT kifejezes" << std::endl;
		const std::string hibauzenet = ": Az ! argumentuma csak boolean tipusu kifejezes lehet.\n";
        if( $2->var_type != boolean )
        {
            std::cerr << $2->decl_row << hibauzenet;
            exit(1);
        }
		$$ = new var_data( d_loc__.first_line, boolean );
		delete $2;
	}
|
	SZAMERTEK
	{
		std::cout << "kifejezes -> SZAMERTEK" << std::endl;
		$$ = new var_data( d_loc__.first_line, unsig );
	}
|
	kifejezes PLUSZ kifejezes
	{
		std::cout << "kifejezes -> kifejezes PLUSZ kifejezes" << std::endl;
		const std::string hibauzenet = ": Az osszeadas argumentuma csak unsigned tipusu kifejezes lehet.\n";
        if( $1->var_type != unsig )
        {
            std::cerr << $1->decl_row << hibauzenet;
            exit(1);
        }
        if( $3->var_type != unsig )
        {
            std::cerr << $3->decl_row << hibauzenet;
            exit(1);
        }
		$$ = new var_data( d_loc__.first_line, unsig );
		delete $1;
		delete $3;
	}
|
	kifejezes MINUSZ kifejezes
	{
		std::cout << "kifejezes -> kifejezes MINUSZ kifejezes" << std::endl;
		const std::string hibauzenet = ": Az kivonas argumentuma csak unsigned tipusu kifejezes lehet.\n";
		if( $1->var_type != unsig )
        {
            std::cerr << $1->decl_row << hibauzenet;
            exit(1);
        }
        if( $3->var_type != unsig )
        {
            std::cerr << $3->decl_row << hibauzenet;
            exit(1);
        }
		$$ = new var_data( d_loc__.first_line, unsig );
		delete $1;
		delete $3;
	}
|
	kifejezes SZORZAS kifejezes
	{
		std::cout << "kifejezes -> kifejezes SZORZAS kifejezes" << std::endl;
		const std::string hibauzenet = ": Az szorzas argumentuma csak unsigned tipusu kifejezes lehet.\n";
		if( $1->var_type != unsig )
        {
            std::cerr << $1->decl_row << hibauzenet;
            exit(1);
        }
        if( $3->var_type != unsig )
        {
            std::cerr << $3->decl_row << hibauzenet;
            exit(1);
        }
		$$ = new var_data( d_loc__.first_line, unsig );
		delete $1;
		delete $3;
	}
|
	kifejezes OSZTAS kifejezes
	{
		std::cout << "kifejezes -> kifejezes OSZTAS kifejezes" << std::endl;
		const std::string hibauzenet = ": Az osztas argumentuma csak unsigned tipusu kifejezes lehet.\n";
		if( $1->var_type != unsig )
        {
            std::cerr << $1->decl_row << hibauzenet;
            exit(1);
        }
        if( $3->var_type != unsig )
        {
            std::cerr << $3->decl_row << hibauzenet;
            exit(1);
        }
		$$ = new var_data( d_loc__.first_line, unsig );
		delete $1;
		delete $3;
	}
|
	kifejezes MOD kifejezes
	{
		std::cout << "kifejezes -> kifejezes MOD kifejezes" << std::endl;
		const std::string hibauzenet = ": Az mod argumentuma csak unsigned tipusu kifejezes lehet.\n";
		if( $1->var_type != unsig )
        {
            std::cerr << $1->decl_row << hibauzenet;
            exit(1);
        }
        if( $3->var_type != unsig )
        {
            std::cerr << $3->decl_row << hibauzenet;
            exit(1);
        }
		$$ = new var_data( d_loc__.first_line, unsig );
		delete $1;
		delete $3;
	}
|
	kifejezes KISEBB kifejezes
	{
		std::cout << "kifejezes -> kifejezes KISEBB kifejezes" << std::endl;
		const std::string hibauzenet = ": Az osszehasonlitas argumentuma csak unsigned tipusu kifejezes lehet.\n";
		if( $1->var_type != unsig )
        {
            std::cerr << $1->decl_row << hibauzenet;
            exit(1);
        }
        if( $3->var_type != unsig )
        {
            std::cerr << $3->decl_row << hibauzenet;
            exit(1);
        }
		$$ = new var_data( d_loc__.first_line, boolean );
		delete $1;
		delete $3;
	}
|
	kifejezes NAGYOBB kifejezes
	{
		std::cout << "kifejezes -> kifejezes NAGYOBB kifejezes" << std::endl;
		const std::string hibauzenet = ": Az osszehasonlitas argumentuma csak unsigned tipusu kifejezes lehet.\n";
		if( $1->var_type != unsig )
        {
            std::cerr << $1->decl_row << hibauzenet;
            exit(1);
        }
        if( $3->var_type != unsig )
        {
            std::cerr << $3->decl_row << hibauzenet;
            exit(1);
        }
		$$ = new var_data( d_loc__.first_line, boolean );
		delete $1;
		delete $3;
	}
|
	kifejezes ISEQUAL kifejezes
	{
		std::cout << "kifejezes -> kifejezes ISEQUAL kifejezes" << std::endl;
		$$ = new var_data( d_loc__.first_line, boolean );
		delete $1;
		delete $3;
	}
|
	kifejezes AND kifejezes
	{
		std::cout << "kifejezes -> kifejezes AND kifejezes" << std::endl;
		const std::string hibauzenet = ": Az AND argumentuma csak boolean tipusu kifejezes lehet.\n";
		if( $1->var_type != boolean )
        {
            std::cerr << $1->decl_row << hibauzenet;
            exit(1);
        }
        if( $3->var_type != boolean )
        {
            std::cerr << $3->decl_row << hibauzenet;
            exit(1);
        }
		$$ = new var_data( d_loc__.first_line, boolean );
		delete $1;
		delete $3;
	}
|
	kifejezes OR kifejezes
	{
		std::cout << "kifejezes -> kifejezes OR kifejezes" << std::endl;
		const std::string hibauzenet = ": Az OR argumentuma csak boolean tipusu kifejezes lehet.\n";
		if( $1->var_type != boolean )
        {
            std::cerr << $1->decl_row << hibauzenet;
            exit(1);
        }
        if( $3->var_type != boolean )
        {
            std::cerr << $3->decl_row << hibauzenet;
            exit(1);
        }
		$$ = new var_data( d_loc__.first_line, boolean );
		delete $1;
		delete $3;
	}
|
	ZAROJEL_NYIT kifejezes ZAROJEL_ZAR
	{
		std::cout << "kifejezes -> ZAROJEL_NYIT kifejezes ZAROJEL_ZAR" << std::endl;
		$$ = new var_data( d_loc__.first_line, $2->var_type );
	}
;

elagazas:
	IF ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR
	{
		std::cout << "elagazas -> IF ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR" << std::endl;
	}
|
	IF ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR ELSE KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR
	{
		std::cout << "elagazas -> IF ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR ELSE KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR" << std::endl;
	}
;

ciklus:
	WHILE ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR
	{
		std::cout << "ciklus -> WHILE ZAROJEL_NYIT kifejezes ZAROJEL_ZAR KAPCSOS_NYIT utasitas utasitasok KAPCSOS_ZAR" << std::endl;
	}
;
