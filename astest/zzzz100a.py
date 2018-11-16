from code_aster.Commands import FORMULE 

def F_FORMULE(NAP):

   PARA1=5.
#
   NAP1 = FORMULE(VALE='NAP(INST,PARA1,AMOR) ',
                  NAP=NAP,
                  PARA1=PARA1,
                  NOM_PARA=['INST', 'AMOR'],)
   aaa=NAP1(2.,3.)

   DETRUIRE(CONCEPT=_F(NOM=NAP1))
return aaa

