--# -path=.:/home/sigrid/.gf/prelude
resource MiniParadigmsSwe = open
  MiniGrammarSwe,
  MiniResSwe
in { 

  oper
    mkN = overload {
      mkN : Str -> Gender -> Noun   -- predictable noun, e.g. bil-bilen-bilar-bilarna, fluga-flugan-flugor-flugorna
        = \n,g -> lin N (smartNoun n g) ;
      mkN : Str -> Str -> Str -> Str -> Gender -> Noun  -- irregular noun, e.g. man-mannen-män-männen,
        = \sgIndef,sgDef,plIndef,plDef,gen -> lin N (mkNoun sgIndef sgDef plIndef plDef gen) ;
      } ;

    mkPN : Str -> PN
      = \s -> lin PN {s = s} ;

    mkA = overload {
      mkA : Str -> A -- predictable adjective
        = \adj -> lin A (smartAdjective adj) ;
      mkA : Str -> Str -> Str -> Str -> A -- very irregular adjective
        = \utrSgIndef,neutrSgIndef,sgDef,pl -> lin A (mkAdjective utrSgIndef neutrSgIndef sgDef pl) ;
    } ;

    mkV = overload {
      mkV : (inf : Str) -> V  -- predictable verb, e.g. baka-bakar-bakade-bakat, titta-tittar-tittade-tittat
        = \s -> lin V (regVerb s) ;
      mkV : (inf,pres,pret,perf : Str) -> V  -- irregular verb, e.g. sjunga-sjunger-sjöng-sjungit
        = \inf,pres,pret,perf -> lin V (irregVerb inf pres pret perf) ;
    } ;

    mkV2 = overload {
      mkV2 : Str -> V2          -- predictable verb with direct object, e.g. "hitta"
        = \s   -> lin V2 (regVerb s ** {c = []}) ;
      mkV2 : Str  -> Str -> V2  -- predictable verb with preposition, e.g. "vänta - på"
        = \s,p -> lin V2 (regVerb s ** {c = p}) ;
      mkV2 : V -> V2            -- any verb with direct object, e.g. "drink"
        = \v   -> lin V2 (v ** {c = []}) ;
      mkV2 : V -> Str -> V2     -- any verb with preposition
        = \v,p -> lin V2 (v ** {c = p}) ;
    } ;

    mkVS : V -> VS
      = \v -> lin VS v ;

    mkAdv : Str -> Adv
      = \s -> lin Adv {s = s} ;

    mkPrep : Str -> Prep
      = \s -> lin Prep {s = s} ;
}