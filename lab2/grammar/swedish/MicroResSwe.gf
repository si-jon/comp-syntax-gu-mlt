resource MicroResSwe = {

param
  Number = Sg | Pl ;
  Species = Indef | Def ;
  Gender = Utr | Neutr ;

--  Agreement = Agr Number ; ---s Person to be added

  -- all forms of normal Swe verbs, although not yet used in MiniGrammar
--  VForm = Inf | PresSg3 | Past | PastPart | PresPart ; 

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


  Adjective : Type = {s : Str} ;

--  Verb : Type = {s : VForm => Str} ;

--  mkVerb : (inf,pres,past,pastpart,prespart : Str) -> Verb
--    = \inf,pres,past,pastpart,prespart -> {
--    s = table {
--      Inf => inf ;
--      PresSg3 => pres ;
--      Past => past ;
--      PastPart => pastpart ;
--      PresPart => prespart
--      }
--    } ;

--  regVerb : (inf : Str) -> Verb = \inf ->
--    mkVerb inf (inf + "s") (inf + "ed") (inf + "ed") (inf + "ing") ;

  -- regular verbs with predictable variations
--  smartVerb : Str -> Verb = \inf -> case inf of {
--     pl  +  ("a"|"e"|"i"|"o"|"u") + "y" => regVerb inf ;
--     cr  +  "y" =>  mkVerb inf (cr + "ies") (cr + "ied") (cr + "ied") (inf + "ing") ;
--     lov + "e"  => mkVerb inf (inf + "s") (lov + "ed") (lov + "ed") (lov + "ing") ;
--     kis + ("s"|"sh"|"x"|"o") => mkVerb inf (inf + "es") (inf + "ed") (inf + "ed") (inf + "ing") ;
--     _ => regVerb inf
--     } ;

  -- normal irregular verbs e.g. drink,drank,drunk
--  irregVerb : (inf,past,pastpart : Str) -> Verb =
--    \inf,past,pastpart ->
--      let verb = smartVerb inf
--      in mkVerb inf (verb.s ! PresSg3) past pastpart (verb.s ! PresPart) ;   

  -- two-place verb with "case" as preposition; for transitive verbs, c=[]
--  Verb2 : Type = Verb ** {c : Str} ;

--  be_Verb : Verb = mkVerb "are" "is" "was" "been" "being" ; ---s to be generalized


---s a very simplified verb agreement function for Micro
--  agr2vform : Agreement -> VForm = \a -> case a of {
--    Agr Sg => PresSg3 ;
--    Agr Pl => Inf
--    } ;

}
