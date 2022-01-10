--# -path=.:/home/sigrid/.gf/prelude
resource MiniResSwe = open Prelude in {

  param
    Number = Sg | Pl ;
    Species = Indef | Def ;
    Gender = Utr | Neutr ;
    Case = Nom | Obj ;

    VForm = Inf | Pres | Pret | Supine | Imperativ ;
    HasComp = Yes | No ;

    Agreement = Agr Number Species Gender ;

  oper
    -- Noun
    Noun : Type = { s : Number => Species => Str ; g : Gender} ;

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
        pojk + "e" => mkNoun sgIndef (pojk + "en") (pojk + "ar") (pojk + "arna") gen ;
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

    -- Adjective
    Adjective : Type = {s : Number => Species => Gender => Str} ;

    mkAdjective : Str -> Str -> Str -> Str -> Adjective
      = \utrSgIndef, neutrSgIndef, sgDef, pl -> {
        s = table {
          Sg => table {
              Indef => table {Utr => utrSgIndef ; Neutr => neutrSgIndef};
              Def => table {_ => sgDef}
          } ;
          Pl => table {
              _=> table {
                  _ => pl
              }
            }
        }
    } ;

    smartAdjective : Str -> Adjective = \adj -> case adj of {
      smar + "t" => mkAdjective adj adj (adj + "a") (adj + "a") ;
      _ => mkAdjective adj (adj + "t") (adj + "a") (adj + "a")
    } ;

    -- Verb
    Verb : Type = {s : VForm => Str} ;

    mkVerb : (inf,pres,pret,supine,imp : Str) -> Verb
      = \inf,pres,pret,supine,imp -> {
        s = table {
          Inf       => inf ;
          Pres      => pres ;
          Pret      => pret ;
          Supine    => supine ;
          Imperativ => imp
        }
    } ;

    regVerb : (inf : Str) -> Verb = \inf ->
      mkVerb inf (inf + "r") (inf + "de") (inf + "t") inf ;

    irregVerb : (inf,pres,pret,supine,imp : Str) -> Verb =
      \inf,pres,pret,supine,imp ->
        mkVerb inf pres pret supine imp ;

    Verb2 : Type = Verb ** {c : Str} ;

    negation : Bool -> Str = \b -> case b of {True => [] ; False => "inte"} ; 

    -- Complement
    Complement : Type = {s : Agreement => Str} ;

    adj2comp : Adjective -> Complement = \adj -> {
        s = table { 
          Agr num spec gen => adj.s ! num ! Indef ! gen
        }
    } ;

    str2comp : Str -> Complement = \str -> {
        s = \\_ => str
    } ;

    add2comp : Complement -> Str -> Complement = \comp, str -> {
      s = table { 
        Agr num spec gen => comp.s ! Agr num spec gen ++ str
      }
    } ;

    defaultAgr : Agreement = Agr Sg Def Utr ;
    
-- generalized verb, here just "be"
  param
    GVForm = VF VForm ;    

  oper
    GVerb : Type = {
      s : GVForm => Str ;
      isAux : Bool
    } ;

    be_GVerb : GVerb = {
      s = table {
        VF vf => (mkVerb "vara" "är" "var" "varit" "var").s ! vf
      } ;
      isAux = True
    } ;

  -- in VP formation, all verbs are lifted to GVerb, but morphology doesn't need to know this
    verb2gverb : Verb -> GVerb = \v -> {s =
      table {
        VF vf   => v.s ! vf
      } ;
      isAux = False
    } ;

    gv2comp : GVerb -> Complement = \v -> {
        s = \\_ => v.s ! VF Inf
    } ;

}