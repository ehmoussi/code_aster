      SUBROUTINE VERICO(NBMATO,NBPART,VAL)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C TOLE CRP_4
C-----------------------------------------------------------------------
C    - FONCTION REALISEE:
C       - VERIFICATION DE LA CONNEXITE DES SOUS-DOMAINES
C
C    - IN :     NBMATO : NOMBRE DE MAILLES
C               NBPART : NOMBRE DE PARTITION
C               CO     : CONNECTIVITE DES MAILLES
C               IDCO   : INDEX DE CO
C               RENUM2 : RENUMEROTATION
C               RENUM3 : RENUMEROTATION INVERSE
C               NUMSDM : SOUS DOMAINES DE CHAQUES MAILLE
C
C    - IN & OUT : VAL : VAUT 1 SI NON CONNEXITE
C----------------------------------------------------------------------
C RESPONSABLE ASSIRE A.ASSIRE

C CORPS DU PROGRAMME
      IMPLICIT NONE

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
      INTEGER*4          ZI4
      COMMON  / I4VAJE / ZI4(1)

C --------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------------

C DECLARATION VARIABLES D'APPEL
      INTEGER       NBMATO,NBPART,CO,IDCO,RENUM2,RENUM3,NUMSDM,VAL

C DECLARATION VARIABLES LOCALES
      INTEGER       FLAGMA,FLAGSD,LISTE,IMA,ID,ID2,I,NBRE,IFM,NIV,MAIL
      REAL*8        TMPS(6)

C CORPS DU PROGRAMME
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

      CALL JEVEUO('&&FETSKP.RENUM2','L',RENUM2)
      CALL JEVEUO('&&FETSKP.RENUM3','L',RENUM3)
      CALL JEVEUO('&&FETSKP.CO','L',CO)
      CALL JEVEUO('&&FETSKP.IDCO','L',IDCO)
      CALL JEVEUO('&&FETSKP.NUMSDM','E',NUMSDM)

      IF (NIV.GE.2) THEN
        CALL UTTCPU(18,'INIT',6,TMPS)
        CALL UTTCPU(18,'DEBUT',6,TMPS)
      ENDIF

      CALL WKVECT('&&FETSKP.FLAGMA','V V I',NBMATO,FLAGMA)
      CALL WKVECT('&&FETSKP.FLAGSD','V V I',NBMATO,FLAGSD)
      CALL WKVECT('&&FETSKP.LISTE','V V I',NBMATO,LISTE)

      DO 1 IMA=1,NBMATO

        MAIL=ZI(RENUM2-1+IMA)
        IF (ZI(FLAGMA-1+IMA).EQ.0 ) THEN
          IF ( ZI(FLAGSD+ZI(NUMSDM-1+MAIL)) .EQ. 0 ) THEN
            ZI(FLAGMA-1+IMA)=1
            ZI(FLAGSD+ZI(NUMSDM-1+MAIL))=1
            ZI(LISTE)= IMA
            ID=0
            ID2=0
 2          CONTINUE
            DO 3 I=ZI4(IDCO-1+ZI(LISTE+ID)),
     &                            ZI4(IDCO-1+ZI(LISTE+ID)+1)-1
              IF (ZI(FLAGMA-1+ZI4(CO-1+I)).EQ.0) THEN
                IF(ZI(NUMSDM-1+ZI(RENUM2-1+ZI4(CO-1+I))).EQ.
     &                                     ZI(NUMSDM-1+MAIL)) THEN
                  ID2=ID2+1
                  ZI(LISTE+ID2)=ZI4(CO-1+I)
                  ZI(FLAGMA-1+ZI4(CO-1+I))=1
                ENDIF
              ENDIF
 3          CONTINUE
            ID=ID+1
            IF( ID .LE. ID2 ) GOTO 2

          ELSE
            CALL U2MESS('A','UTILITAI5_60')
            VAL=1
            NBPART=NBPART+1
            ZI(FLAGMA-1+IMA)=1
            NBRE=ZI(NUMSDM-1+MAIL)
            ZI(NUMSDM-1+MAIL)=NBPART-1
            ZI(LISTE)= IMA
            ID=0
            ID2=0
 4          CONTINUE
            DO 5 I=ZI4(IDCO-1+ZI(LISTE+ID)),
     &                    ZI4(IDCO-1+ZI(LISTE+ID)+1)-1
              IF(ZI4(CO-1+I).GT.NBMATO) THEN
C                  WRITE(6,*)'TOTO'
                  WRITE(6,*)'I',I,'LISTE',ZI(LISTE+ID)
                  write(6,*)ZI(RENUM2-1+ZI4(CO-1+I)),ZI4(CO-1+I)
              ENDIF
              IF (ZI(FLAGMA-1+ZI4(CO-1+I)).EQ.0) THEN
                IF(ZI(NUMSDM-1+ZI(RENUM2-1+ZI4(CO-1+I))).EQ.NBRE)THEN
                  ZI(NUMSDM-1+ZI(RENUM2-1+ZI4(CO-1+I)))=NBPART-1
                  ID2=ID2+1
                  ZI(LISTE+ID2)=ZI4(CO-1+I)
                  ZI(FLAGMA-1+ZI4(CO-1+I))=1
                ENDIF
              ENDIF
 5          CONTINUE
            ID=ID+1
            IF( ID .LE. ID2 ) GOTO 4

          ENDIF
        ENDIF

 1    CONTINUE

      CALL JEDETR('&&FETSKP.LISTE')
      CALL JEDETR('&&FETSKP.FLAGMA')
      CALL JEDETR('&&FETSKP.FLAGSD')

      IF (NIV.GE.2) THEN
        CALL UTTCPU(18,'FIN',6,TMPS)
        WRITE(IFM,*)'--- VERIFICATION DE LA CONNEXITE :',TMPS(3)
        WRITE(IFM,*)'  '
      ENDIF

      CALL JEDEMA()
      END
