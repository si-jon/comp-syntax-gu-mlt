--# -path=.:../abstract
--# -path=.:/home/sigrid/.gf/prelude
concrete MiniGrammarSwe of MiniGrammar = open 

  MiniResSwe,
  Prelude

in {

  lincat

-- Common
    Utt = {s : Str} ;
    Pol  = {s : Str ; isTrue : Bool} ; -- the s field is empty, but needed for parsing
    Temp = {s : Str ; isPres : Bool} ;

-- Cat
    S = {s : Str} ;
    QS = {s : Str} ; -- question sentence

-- declarative clause, with all tenses
    Cl = {   -- word order is fixed in S and QS
      subj : Str ;                             -- subject
      verb : Bool => Bool => {fin,inf : Str} ; -- dep. on Pol,Temp, e.g. "does","sleep"
      compl : Str                              -- after verb: complement, adverbs
      } ;

-- question clause
    QCl = Cl ** {isWh : Bool} ;
    Imp = {s : Bool => Str} ;

    VP = {verb : Verb ; compl : Complement} ;
    Comp = {s : Complement} ;
    AP = Adjective ;
    CN = {s : Noun ; hasComp : HasComp} ;
    NP = {s : Case => Str ; a : Agreement} ;
    IP = {s : Case => Str ; a : Agreement} ; -- interrogative phrase
    Pron = {s : Case => Str ; a : Agreement};
    Det = {s : HasComp => Gender => Str ; n : Number ; sp : Species} ;
    Conj = {s : Str} ;
    Prep = {s : Str} ;
    V = Verb ;
    V2 = Verb2 ; -- two-place verb
    VS = Verb ; -- sentence-complement verb
    VV = Verb ; ---- only VV to VP -- verb-phrase-complement verb
    A = Adjective ;
    N = Noun ;
    PN = {s : Str} ;
    Adv = {s : Str} ;
    IAdv = {s : Str} ;

  lin
-- Phrase
    UttS s = s ;
    UttQS s = s ;
    UttNP np = {s = np.s ! Nom} ;
    UttAdv adv = adv ;
    UttIAdv iadv = iadv ;
    UttImpSg pol imp = {s = pol.s ++ imp.s ! pol.isTrue} ;

-- Sentence
--    UseCl     : Temp -> Pol -> Cl   -> S ;  -- John has not walked
    UseCl temp pol cl = {
      s = cl.subj ++ (cl.verb ! temp.isPres ! pol.isTrue).fin ++ cl.compl
    } ;
--    UseQCl    : Temp -> Pol -> QCl  -> QS ; -- has John walked

    PredVP np vp = {
      subj = np.s ! Nom ;
      compl = vp.compl.s ! np.a ;
      verb = \\plain,isPres => case <True, plain, isPres, np.a> of {

        -- non-auxiliary verbs, negative/question present: "does (not) drink" 
        <False,False,True,_> => {fin = "does" ; inf = []} ;--inf = vp.verb.s ! VF Inf} ;
        <_,_,_,_          > => {fin = "do"   ; inf = []} --inf = vp.verb.s ! VF Inf} ;
	
        -- non-auxiliary, plain present ; auxiliary, all present: "drinks", "is (not)"
        --<_,_, True, Agr Sg> => {fin = [] ; inf = []} ;
        --<_,_, True, Agr Sg> => {fin = [] ; inf = []} ;
        --<_,_, True, _>           => {fin = [] ; inf = []} ;

        -- all verbs, past: "has (not) drunk", "has (not) been"
        --<_,_, False,Agr Sg> => {fin = "has"  ; inf = []} ;
        --<_,_, False,_          > => {fin = "have" ; inf = []} 

        -- the negation word "not" is put in place in UseCl, UseQCl
      }
    } ;

--    QuestCl   : Cl -> QCl ;                 -- does John (not) walk
--    QuestVP   : IP -> VP -> QCl ;           -- who does (not) walk
--    ImpVP     : VP -> Imp ;                 -- walk / do not walk

-- Verb
    UseV v = {
      verb = v ;
      compl = str2comp [];
    } ;

    ComplV2 v2 np = {
      verb = v2 ;
      compl =  str2comp (v2.c ++ np.s ! Obj)
    } ;

--    ComplVS   : VS -> S -> VP ;         -- know that it is good
--    ComplVV   : VV -> VP -> VP ;        -- want to be good

    UseComp comp = {
      verb = be_Verb ;
      compl = comp.s
    } ;

    CompAP ap = {
      s = adj2comp ap
    } ;

--    CompNP    : NP  -> Comp ;           -- a man
--    CompAdv   : Adv -> Comp ;           -- in the house

    AdvVP vp adv =
      vp ** {compl = add2comp vp.compl adv.s} ;

-- Noun
    DetCN det cn = {
      s = \\c => det.s ! cn.hasComp ! cn.s.g ++ cn.s.s ! det.n ! det.sp ;
      a = Agr det.n det.sp cn.s.g
    } ;

--    UsePN     : PN -> NP ;              -- John

    UsePron p = p ;

--    MassNP    : CN -> NP ;              -- milk

    a_Det = {
      s = table {
        _ => table {
          Utr => "en" ;
          Neutr => "ett"
        }
      } ;
      n = Sg ;
      sp = Indef
    } ;

    aPl_Det = {
      s = \\_ => \\_ => [];
      n = Pl ;
      sp = Indef
    } ;

    the_Det = {
      s = table {
        Yes => table {
          Utr => "den" ;
          Neutr => "det"
        } ;
        No => table { _ => [] }
      } ;
      n = Sg ;
      sp = Def
    } ;

    thePl_Det = {
      s = table {
        Yes => table { _ => "de" } ;
        No => table { _ => [] }
      } ;
      n = Pl ;
      sp = Def
    } ;

    every_Det = {
      s = \\_ => \\_ => "varje";
      n = Pl ;
      sp = Indef
    } ;

    UseN n = {
      s = n ;
      hasComp = No
    };

    AdjCN ap cn = {
      s = {
        g = cn.s.g ;
        s = table {
          n => table {
            sp => ap.s ! n ! sp ! cn.s.g ++ cn.s.s ! n ! sp
          }
        } ;
      } ;
      hasComp = Yes
    } ;

-- Adjective
    PositA a = a ;

-- Adverb
    PrepNP prep np = {
      s = prep.s ++ np.s ! Obj
    } ;

-- Conjunction
    CoordS conj a b = {s = a.s ++ conj.s ++ b.s} ;

-- Tense
    PPos = {s = [] ; isTrue = True} ;
    PNeg = {s = [] ; isTrue = False} ;
    TSim = {s = [] ; isPres = True} ;
    TAnt = {s = []    ; isPres = False} ;

-- Structural
    and_Conj = {s = "och"} ;
    or_Conj = {s = "eller"} ;

    in_Prep = {s = "i"} ;
    on_Prep = {s = "på"} ;
    with_Prep = {s = "med"} ;

    i_Pron = {
      s = table {Nom => "jag" ; Obj => "mig"} ;
      a = Agr Sg Def Utr
    } ;
   youSg_Pron = {
      s = table {Nom => "du" ; Obj => "dig"} ;
      a = Agr Sg Def Utr
    } ;
    he_Pron = {
      s = table {Nom => "han" ; Obj => "honom"} ;
      a = Agr Sg Def Utr
    } ;
    she_Pron = {
      s = table {Nom => "hon" ; Obj => "henne"} ;
      a = Agr Sg Def Utr
    } ;
    we_Pron = {
      s = table {Nom => "vi" ; Obj => "oss"} ;
      a = Agr Pl Def Utr
    } ;
    youPl_Pron = {
      s = table {Nom => "ni" ; Obj => "er"} ;
      a = Agr Pl Def Utr
    } ;
    they_Pron = {
      s = table {Nom => "de" ; Obj => "dem"} ;
      a = Agr Pl Def Utr
    } ;

    whoSg_IP = {
      s = table {_ => "vem"} ;
      a = Agr Pl Def Utr
    } ;

    where_IAdv = {s = "var"} ;
    why_IAdv = {s = "varför"} ;

    have_V2 = mkVerb "ha" "har" "hade" "haft"  ** {c = []} ;
    want_VV = mkVerb "vilja" "vill" "ville" "velat"  ** {c = []} ;

}