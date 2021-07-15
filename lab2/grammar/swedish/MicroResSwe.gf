resource MicroResSwe = {

param
  Number = Sg | Pl ;
  Species = Indef | Def ;
  Gender = Utr | Neutr ;
  Case = Nom | Acc;
  Degree = Positive | Comparative | Superlative ;
  Agreement = Agr Number Species Gender ;

  VForm = Inf | Pres | Pret | Perf ; 
  AForm = PosIndefSgUtr | PosIndefSgNeutr | PosDefSg | PosPl | Cmp | IndefSuper | DefSuper ;

oper
  Noun = { s :Number => Species => Str ; g : Gender} ;

  mkNoun : Str -> Str -> Str -> Str -> Gender -> Noun
    = \sgIndef,sgDef,plIndef,plDef,gen -> {
      s = table {
          Sg => table {Indef => sgIndef ; Def => sgDef} ;
          Pl => table {Indef => plIndef; Def => plDef}
          } ;
      g = gen
      } ;

  smartNoun : Str -> Gender -> Noun = \sgIndef,gen -> case gen of {
      Utr => case sgIndef of {
          pojk + "e" => mkNoun sgIndef (sgIndef + "en") (pojk + "ar") (pojk + "arna") gen ;
          flick + "a" => mkNoun sgIndef (flick + "an") (flick + "or") (flick + "orna") gen ;
          cyk + "el" => mkNoun sgIndef (cyk + "eln") (cyk + "lar") (cyk + "larna") gen ;
          vä + "n" => mkNoun sgIndef (vä + "nnen") (vä + "nner") (vä + "nnerna") gen ;
          dat + "or" => mkNoun sgIndef (dat + "orn") (dat + "orer") (dat + "orerna") gen ;
          _ => mkNoun sgIndef (sgIndef + "en") (sgIndef + "ar") (sgIndef + "arna") gen
          } ;
      Neutr => case sgIndef of {
          äppl + "e" => mkNoun sgIndef (äppl + "et")  (äppl + "en") (äppl + "ena") gen ;
          vatt + "en" => mkNoun sgIndef (vatt + "net")  (vatt + "en") (vatt + "nen") gen ;
          _ => mkNoun sgIndef (sgIndef + "et") (sgIndef) (sgIndef + "en") gen
          }
      } ;


  Adjective : Type = {s : AForm => Str} ;

  mkAdjective : Str -> Str -> Str -> Str -> Str -> Str -> Adjective
    = \posUtr,posNeutr,posDefSg,posPl,cmp,super -> {
      s = table {
        PosIndefSgUtr => posUtr ;
        PosIndefSgNeutr => posNeutr ;
        PosDefSg => posDefSg ;
        PosPl => posPl ;
        Cmp => cmp ;
        IndefSuper => super ;
        DefSuper => super + "e"
      }
    } ;

  smartAdjective : Str -> Adjective = \pos -> case pos of {
    smar + "t" => smartAdjective2 pos pos ;
    _ => smartAdjective2 pos (pos + "t")
  } ;

  smartAdjective2 : Str -> Str -> Adjective = \posUtr,posNeutr ->
    smartAdjective4 posUtr  posNeutr (posUtr + "are") (posUtr + "ast") ;

  smartAdjective3 : Str -> Str -> Str -> Adjective = \pos,cmp,super ->
    smartAdjective4 pos (pos + "t") cmp super ;
  
  smartAdjective4 : Str -> Str -> Str -> Str -> Adjective = \posUtr,posNeutr,cmp,super ->
    mkAdjective posUtr posNeutr (posUtr + "a") (posUtr + "a") cmp super ;
  
  mkAdjective2 : Str -> Adjective
    = \adj -> {
      s = table {
        PosIndefSgUtr => adj ;
        PosIndefSgNeutr => adj ;
        PosDefSg => adj ;
        PosPl => adj ;
        Cmp => "mer" ++ adj ;
        IndefSuper => "mest" ++ adj ;
        DefSuper => "mest" ++ adj
      }
    } ;

  Verb : Type = {s : VForm => Str} ;

  mkVerb : (inf,pres,pret,perf : Str) -> Verb
    = \inf,pres,pret,perf -> {
    s = table {
      Inf => inf ;
      Pres => pres ;
      Pret => pret ;
      Perf => perf
      }
    } ;

  regVerb : (inf : Str) -> Verb = \inf ->
    mkVerb inf (inf + "r") (inf + "de") (inf + "t") ;

  irregVerb : (inf,pres,pret,perf : Str) -> Verb = 
    \inf,pres,pret,perf ->
      mkVerb inf pres pret perf ;

  Verb2 : Type = Verb ** {c : Str} ;

  be_Verb : Verb = mkVerb "vara" "är" "var" "varit" ;

  agr2aform : Agreement -> AForm = \a -> case a of {
    Agr Sg Indef Utr    => PosIndefSgUtr ;
    Agr Sg Indef Neutr  => PosIndefSgNeutr ;
    Agr Sg Def _        => PosDefSg ;
    Agr Pl _ _          => PosPl
    } ;
  
  

}
