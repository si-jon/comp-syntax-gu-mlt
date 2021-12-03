resource MicroResSwe = {

  param
    Number = Sg | Pl ;
    Species = Indef | Def ;
    Gender = Utr | Neutr ;
    Case = Nom | Obj ;

    VForm = Inf | Pres | Pret | Perf ;
    CompType = Empty | NounP | AdjP | AdvP ;
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

    -- Complement
    Complement : Type = {s : Agreement => Str} ;

    adj2comp : Adjective -> Complement = \a -> {
        s = table { 
          Agr num spec gen => a.s ! num ! Indef ! gen
        }
    } ;

    str2comp : Str -> Complement = \str -> {
        s = \\_ => str
    } ;

    add2comp : Complement -> Str -> Complement = \comp, str -> {
      s = table { Agr num spec gen => comp.s ! Agr num spec gen ++ str }
    } ;
}