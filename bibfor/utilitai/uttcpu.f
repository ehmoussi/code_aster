      SUBROUTINE UTTCPU ( INDI , PARA , NBV , TEMPS )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C TOLE  CFT_889
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER             INDI ,        NBV
      REAL *8                                 TEMPS(NBV)
      CHARACTER *(*)             PARA
C ----------------------------------------------------------------------
C  ROUTINE DE MESURE DU TEMPS CPU.
C  UTILISE LES ROUTINES C SUIVANTES (ADHERENCE CRAY/SOLARIS)
C     UTTCSM  : RENVOI LE  TEMPS CONSOMME TOTAL DU PROCESSUS (SEC)
C     UTTRST  : RENVOI LES TEMPS RESTANT  TOTAL DU PROCESSUS (SEC)
C     UTTSYS  : INITIALISATION TEMPS SYSTEME (CRAY) DU PROCESSUS (SEC)
C
C IN  INDI    : INDICE D'APPEL ( 0 =< INDI =< 100 )
C               SI INDI = 0, SEUL TPRES EST MODIFIE
C IN  PARA    : PARAMETRE D'INTIALISATION DES APPELS POUR L'INDICE INDI
C               PARA = 'INIT'  LES PARAMETRES SONT (RE)MIS A ZERO
C               PARA = 'DEBUT' LA MESURE DE TEMPS COMMENCE
C               PARA = 'FIN'   LA MESURE DE TEMPS S'ARRETE
C IN  NBV     : NOMBRE DE VALEURS A RECUPERER
C OUT TEMPS   : TEMPS(1) TEMPS CPU RESTANT EN SECONDES
C               TEMPS(2) NOMBRE D'APPEL EFFECTUE AVEC L'INDICE INDI
C               TEMPS(3) TEMPS CPU TOTAL POUR L'INDICE INDI
C               TEMPS(4) TEMPS CPU MOYEN POUR L'INDICE INDI
C               TEMPS(5) TEMPS CPU USER TOTAL POUR L'INDICE INDI
C               TEMPS(6) TEMPS CPU SYSTEME TOTAL POUR L'INDICE INDI
C ----------------------------------------------------------------------
      INTEGER            NB1, NB2, NB
      PARAMETER        ( NB1 = 0 , NB2 = 100 , NB = NB2-NB1+1)
      REAL *8            USCPUI(NB1:NB2),SYCPUI(NB1:NB2)
      REAL *8            USCPU(NB1:NB2),SYCPU(NB1:NB2)
      INTEGER            NBAPPE(NB1:NB2)
      CHARACTER *5       KPARA,PARINI(NB1:NB2)
C
      REAL*8             T(6), TCSM(2), TPRES , TSYS
C
      SAVE               USCPUI,SYCPUI,USCPU,SYCPU,NBAPPE,PARINI
      DATA               USCPUI,SYCPUI,USCPU,SYCPU,NBAPPE,PARINI
     &                  /NB*0D0,NB*0D0,NB*0D0,NB*0D0,NB*0,NB*'INIT '/
C ----------------------------------------------------------------------
C
C     VERIFS ET INITIALISATIONS
C
      IF ( INDI .LT. NB1 .OR. INDI .GT. NB2 ) THEN
        CALL U2MESS('F','UTILITAI5_54')
      ENDIF
C
      DO 1 K = 1,6
        T(K) = 0.D0
 1    CONTINUE
      KPARA = PARA
C
C     INITIALISATION CALCUL TEMPS SYSTEME (CRAY)
C
      IF ((INDI .EQ. NB1) .AND. ( PARA .EQ. 'INIT ')) THEN
        CALL UTTSYS( 0 , TSYS )
      ENDIF
C
C     TEMPS RESTANT
C
      CALL UTTRST (TPRES)
C
C     SI INDI = 0 ACTUALISATION DE T(1) SEULEMENT
C
      T(1) = TPRES
      IF ( INDI .EQ. 0 ) THEN
          NBT = 1
          GOTO 9999
      ELSE
          NBT = 6
      ENDIF
C
C     TEMPS CONSOMME
C
      CALL UTTCSM(TCSM)
C
C     INITIALISATIONS - MISE A ZERO
C
      IF ( KPARA .EQ. 'INIT ' ) THEN
        PARINI(INDI) = 'INIT '
        USCPUI(INDI) = 0.0D0
        USCPU(INDI)  = 0.0D0
        SYCPUI(INDI)  = 0.0D0
        SYCPU(INDI)  = 0.0D0
        NBAPPE(INDI) = 0
C
C     DEBUT DE LA MESURE
C
      ELSE IF ( KPARA .EQ. 'DEBUT' ) THEN
        IF (PARINI(INDI).NE.'FIN  '.AND.PARINI(INDI).NE.'INIT ') THEN
          CALL U2MESS('F','UTILITAI5_55')
        ENDIF
        PARINI(INDI) = 'DEBUT'
        USCPUI(INDI) = TCSM(1)
        SYCPUI(INDI) = TCSM(2)
C
C     FIN DE LA MESURE - CALCUL PAR DIFFERENCE
C
      ELSE IF ( KPARA .EQ. 'FIN  ' ) THEN
        IF ( PARINI(INDI) .NE. 'DEBUT' ) THEN
          CALL U2MESS('F','UTILITAI5_56')
        ENDIF
        PARINI(INDI) = 'FIN  '
        NBAPPE(INDI) = NBAPPE(INDI) + 1
        USCPU (INDI) = USCPU (INDI) + TCSM(1) - USCPUI(INDI)
        USCPUI(INDI) = TCSM(1)
        SYCPU (INDI) = SYCPU (INDI) + TCSM(2) - SYCPUI(INDI)
        SYCPUI(INDI) = TCSM(2)
        T(2) = NBAPPE(INDI)
        T(3) = USCPU(INDI) + SYCPU(INDI)
        T(4) = T(3)/NBAPPE(INDI)
        T(5) = USCPU(INDI)
        T(6) = SYCPU(INDI)
C
      ELSE
        CALL U2MESK('F','UTILITAI5_57',1,KPARA)
      ENDIF
C
 9999 CONTINUE
C
C     RENVOI DU NB DEMANDE DE VALEURS
C
      DO 100 K = 1, MIN(NBV,NBT)
          TEMPS(K) = T(K)
 100  CONTINUE
      END
