      SUBROUTINE RECHME (IZONE,REAAPP,REACTU,NZOCO,NSYME,
     &                   NOMA,NEWGEO,DEFICO,RESOCO,IESCL)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/05/2005   AUTEUR MABBAS M.ABBAS 
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
      IMPLICIT     NONE
      INTEGER      IZONE
      INTEGER      REAAPP
      INTEGER      REACTU
      INTEGER      NSYME
      INTEGER      NZOCO
      CHARACTER*8  NOMA
      CHARACTER*24 NEWGEO
      CHARACTER*24 DEFICO
      CHARACTER*24 RESOCO
      INTEGER      IESCL
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : RECHCO
C ----------------------------------------------------------------------
C
C APPARIEMENT MAITRE - ESCLAVE : RECHERCHE POUR CHAQUE NOEUD ESCLAVE
C DE LA MAILLE MAITRE LA PLUS PROCHE DANS LA MEME SURFACE DE CONTACT,
C POUR UNE ZONE DE CONTACT DONNEE.
C
C IN  IZONE  : NUMERO DE LA ZONE DE CONTACT
C IN  REAAPP : > 0 SI ON CHERCHE LE NOEUD LE + PROCHE, PUIS LA MAILLE
C              < 0 SI ON CHERCHE DIRECTEMENT LA MAILLE LA PLUS PROCHE
C              1 SI ON CHERCHE LE NOEUD LE + PROCHE PAR "BRUTE FORCE"
C              +/-2 SI ON CHERCHE PAR VOISINAGE   (GRACE AU "PASSE")
C              +/-3 SI ON CHERCHE AVEC DES BOITES (SANS LE "PASSE")
C IN  REACTU : INDICATEUR DE REACTUALISATION POUR TOUTE LA ZONE
C IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
C IN  NSYME  : NOMBRE DE ZONES DE CONTACT SYMETRIQUES
C IN  NOMA   : NOM DU MAILLAGE
C IN  NEWGEO : GEOMETRIE ACTUALISEE EN TENANT COMPTE DU CHAMP DE
C              DEPLACEMENTS COURANT
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C VAR IESCL  : NUMERO DU DERNIER NOEUD ESCLAVE CONNU
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IESCL0,IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL INFNIV(IFM,NIV)
      CALL JEMARQ ()
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,1000) IZONE,' - MAITRE/ESCLAVE'
      ENDIF
C
C ======================================================================
C                           APPARIEMENT
C ======================================================================
C

      IF (REAAPP.GE.0) THEN
C
C --- APPARIEMENT EN CHERCHANT PREALABLEMENT LE NOEUD MAITRE LE + PROCHE
C
C
C --- IESCL0 : REPERE DU DEBUT DE STOCKAGE DES NOEUDS ESCLAVES 
C --- POUR LA ZONE COURANTE 
C
        IESCL0 = IESCL + 1

C --- RECHERCHE DU NOEUD MAITRE LE PLUS PROCHE
        CALL RECHMN(IZONE,NZOCO,NSYME,REAAPP,REACTU,
     &              NOMA,NEWGEO,DEFICO,RESOCO,IESCL)
C
C --- IESCL : REPERE DE FIN DE STOCKAGE DES NOEUDS ESCLAVES 
C --- POUR LA ZONE COURANTE (ON A SUPPRIME LES NOEUDS DECRITS DANS
C --- SANS_NOEUD ET SANS_GROUP_NO)
C
C --- RECHERCHE DE LA MAILLE MAITRE LA PLUS PROCHE
C

        CALL CHMANO(IZONE,IESCL0,NZOCO,NSYME,NOMA,NEWGEO,DEFICO,
     &              RESOCO,IESCL)
C
C --- IESCL : REPERE DE FIN DE STOCKAGE DES NOEUDS ESCLAVES 
C --- POUR LA ZONE COURANTE (ON A SUPPRIME LES NOEUDS DONNANT DES
C --- PIVOTS NULS SI APPARIEMENT SYMETRIQUE)
C
      ELSE
C
C --- APPARIEMENT EN CHERCHANT DIRECTEMENT LA MAILLE LA + PROCHE
C
        CALL UTMESS ('F','RECHME','LA RECHERCHE DIRECTE DE LA MAILLE'
     &               //' LA PLUS PROCHE N''EST PAS OPERATIONNELLE')
C
        IF (REAAPP.EQ.-2) THEN
C
         CALL UTMESS ('F','RECHME','LA RECHERCHE PAR VOISINAGE DU PASSE'
     &               //' N''EST PAS OPERATIONNELLE')
        ELSE IF (REAAPP.EQ.-3) THEN
C
          CALL UTMESS ('F','RECHME','LA RECHERCHE PAR BOITES'
     &               //' N''EST PAS OPERATIONNELLE')
C
        END IF
      END IF
C
C ----------------------------------------------------------------------
C
      CALL JEDEMA ()
 1000 FORMAT (' <CONTACT> <> APPARIEMENT - ZONE: ',I6,A17)
      END
