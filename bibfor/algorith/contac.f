      SUBROUTINE CONTAC(MACOR,NBCOR,MACOC,NBCOC,
     .           LFACE,LOMODI,LOCORR,LOREOR,MA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR   
C (AT YOUR OPTION) ANY LATER VERSION.                                 
C
C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT 
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF          
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU    
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.                            
C
C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE   
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,       
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C
C  ROUTINE CONTAC
C    ROUTINE D ORIENTATION EN FONCTION DE KTYC
C  DECLARATIONS
C    KTYC   : NOM DU TYPE                   POUR UNE MAILLE CONTACT
C    KTYR   : NOM DU TYPE                   POUR UNE MAILLE REFERENCE
C    LOMODI : LOGICAL PRECISANT SI LA MAILLE EST UNE MAILLE MODIFIE
C    LOCORR : LOGICAL PRECISANT SI LA MAILLE EST BIEN ORIENTEE
C    LOREOR : LOGICAL PRECISANT SI LA MAILLE EST BIEN ORIENTEE
C    MA     : L OBJET DU MAILLAGE
C    MACOC  : TABLEAU DES NOMS DES NOEUDS   POUR UNE MAILLE CONTACT
C    MACOR  : TABLEAU DES NOMS DES NOEUDS   POUR UNE MAILLE REFERENCE
C    NBCOC  : NOMBRE DE CONNEX              POUR UNE MAILLE CONTACT
C    NBCOR  : NOMBRE DE CONNEX              POUR UNE MAILLE REFERENCE
C
C  MOT_CLEF : ORIE_CONTACT
C
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
C     ------------------------------------------------------------------
C
      CHARACTER*8  KTYC,KTYR
      CHARACTER*8  MACOR(NBCOR+2),MACOC(NBCOC+2),MA
C
      LOGICAL      LFACE,LOMODI,LOCORR,LOREOR
C
      LOGICAL  PAR,QUA,PEN,HEX
C     FONCTIONS FORMULES PERMETTANT DE SAVOIR SI L'APPUI EST POSSIBLE
      QUA()=(KTYC.EQ.'QUAD4'.AND.(KTYR.EQ.'QUAD4'.OR.KTYR.EQ.'TRIA3'))
     . .OR. (KTYC.EQ.'QUAD8'.AND.(KTYR.EQ.'QUAD9'.OR.KTYR.EQ.'QUAD8'
     .                        .OR.KTYR.EQ.'TRIA6'))
      PEN()=(KTYC.EQ.'PENTA6 '.AND.
     .      (KTYR.EQ.'PENTA6 '.OR.KTYR.EQ.'PYRAM5 '))
     . .OR. (KTYC.EQ.'PENTA15'.AND.
     .      (KTYR.EQ.'PENTA15'.OR.KTYR.EQ.'PYRAM13'))
      HEX()=(KTYC.EQ.'HEXA8 '.AND.
     .     (KTYR.EQ.'HEXA8 '.OR.KTYR.EQ.'PENTA6 '.OR.KTYR.EQ.'PYRAM5 '))
     . .OR. (KTYC.EQ.'HEXA20'.AND.
     .     (KTYR.EQ.'HEXA20'.OR.KTYR.EQ.'PENTA15'.OR.KTYR.EQ.'PYRAM13'))
C     ------------------------------------------------------------------
C
      KTYC = MACOC(2)
      KTYR = MACOR(2)
C
      IF     (QUA()) THEN
C
        CALL CONQUA(MACOR,NBCOR,MACOC,NBCOC,
     .              LFACE,LOMODI,LOCORR,LOREOR,MA)
C
      ELSEIF (PEN()) THEN
C
        CALL CONPEN(MACOR,NBCOR,MACOC,NBCOC,
     .              LFACE,LOCORR,LOREOR,MA)
C
      ELSEIF (HEX()) THEN
C
        CALL CONHEX(MACOR,NBCOR,MACOC,NBCOC,
     .              LFACE,LOMODI,LOCORR,LOREOR,MA)
C
      ENDIF
C     ------------------------------------------------------------------
      END
