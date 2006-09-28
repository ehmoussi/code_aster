      SUBROUTINE PACOJE (CONIZ, IOCC, MOTFAZ, NOMAZ, CONRZ, NDIM )
      IMPLICIT NONE
      CHARACTER*(*)      CONIZ, MOTFAZ, NOMAZ, CONRZ
      CHARACTER*8        NOMA
      CHARACTER*16       MOTFAC
      CHARACTER*24       CONI, CONR
      INTEGER            IOCC, NDIM
C ---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C TOLE CRP_6
C
C     BUT : CREATION ET AFFECTATION DE LA .S.D. CONR
C           CONTENANT LES COMPOSANTES DU VECTEUR NORMAL
C           POUR CHAQUE NOEUD EN VIS-A-VIS DONNE PAR
C           LA S.D. CONI, AINSI QUE LE JEU ENTRE CES NOEUDS.
C           LA LISTE DES MAILLES AUXQUELLES APPARTIENNENT CES NOEUDS
C           EST RELUE DANS CETTE ROUTINE.
C
C           CONR EST A L'INSTAR DE CONI UNE COLLECTION
C           ET C'EST L'OBJET D'INDICE IOCC DE CETTE COLLECTION
C           QUI EST CREE ET AFFECTE.
C
C
C
C IN  CONIZ  K24  : S.D. /
C                   CONI(1) = NBCOUPLE (NOMBRE DE COUPLES DE NOEUDS
C                                       EN VIS-A-VIS)
C                   I = 1, NBCOUPLE
C                       CONI(2*(I-1)+1) = NUNO1
C                       CONI(2*(I-1)+2) = NUNO2
C
C                   NUNO1 ET NUNO2 SONT LES 2 NUMEROS DE NOEUDS
C                   EN VIS-A-VIS.
C
C IN  IOCC     I  : SI >0 ON TRAITE L'OCCURENCE IOCC DE MOTFAC
C                         (CAS DE LIAISON_GROUP)
C                   SI <0 ERREUR FATALE
C
C IN  MOTFAZ  K16  : MOT CLE FACTEUR A TRAITER = LIAISON_GROUP
C
C IN  NOMAZ    K8  : NOM DU MAILLAGE
C
C OUT CONRZ    K24 : S.D. /
C                     CONRZ EST CREE ET AFFECTE DANS LA ROUTINE
C                     LE NOM CONRZ EST UNE ENTREE DE LA ROUTINE
C                     CONRZ CONTIENT LES VALEURS DES COMPOSANTES
C                     NORMALES AUX NOEUDS EN VIS-A-VIS ET LE
C                     JEU ENTRE CES NOEUDS.
C
C                    CONR : OJB BASE V R DIM = 12 * NBCOUPLE EN 2D
C                                              22 * NBCOUPLE EN 3D
C                      I = 1, NBCOUPLE ,  J = 1, 3
C                      CONR( (2*NDIM+1)*(I-1)+J      )  = NORM1(J)
C                      CONR( (2*NDIM+1)*(I-1)+J+NDIM )  = NORM2(J)
C
C                      CONR( (2*NDIM+1)*I            )  = JEU
C
C ---------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX -----------------------------
C
      INTEGER       NBCMP, IVALE, IDCONI, NBCOUP, IDRAD, IDANGL, NO1,
     &              NO2, I, J, INOMA
      REAL *8       NORM1(3), NORM2(3), JEU
      REAL *8       NRMBID, NOR1(3), NOR2(3)
      CHARACTER*24  LLIST1, LLIST2
C     -----------------------------------------------------------------
C
      CALL JEMARQ()
      CONI   = CONIZ
      CONR   = CONRZ
      NOMA   = NOMAZ
      MOTFAC = MOTFAZ
C
      NBCMP = 3
      CALL JEVEUO(NOMA(1:8)//'.COORDO    .VALE','L',IVALE)
C
      IF ( MOTFAC .EQ. 'LIAISON_GROUP' ) THEN
         CALL JEVEUO(JEXNUM(CONI,IOCC),'L',IDCONI)
         NBCOUP = ZI(IDCONI)
C
         CALL JECROC(JEXNUM(CONR,IOCC))
C
         IF (NDIM.EQ.2) THEN
            CALL JEECRA(JEXNUM(CONR,IOCC),'LONMAX',12*NBCOUP,' ')
         ELSE
            CALL JEECRA(JEXNUM(CONR,IOCC),'LONMAX',22*NBCOUP,' ')
         ENDIF
         CALL JEVEUO(JEXNUM(CONR,IOCC),'E',IDRAD)
      ELSE
         CALL U2MESK('F','MODELISA2_61',1,MOTFAC)
      ENDIF
C
      CALL  WKVECT ( '&&PACOJE.ANGL', 'V V R', NBCOUP, IDANGL )
C
C
      DO 10 I= 1, NBCOUP
C
         NO1 = ZI(IDCONI+2*(I-1)+1)
         NO2 = ZI(IDCONI+2*(I-1)+2)
C
         DO 20 J =1, 3
            NORM1(J) = 0.0D0
            NORM2(J) = 0.0D0
 20     CONTINUE
C
C ----- CONSTRUCTION DE LA LISTE DE MAILLES LLIST1 SPECIFIEE APRES
C ----- LES MOTS-CLES GROUP_MA_1 OU MAILLE_1
C
        LLIST1 = '&&PACOJE.LLIST1'
        CALL PALIMA(NOMA,MOTFAC,'GROUP_MA_1','MAILLE_1',IOCC,LLIST1)
C
C ----- CONSTRUCTION DE LA LISTE DE MAILLES LLIST2 SPECIFIEE APRES
C ----- LES MOTS-CLES GROUP_MA_2 OU MAILLE_2
C
        LLIST2 = '&&PACOJE.LLIST2'
        CALL PALIMA(NOMA,MOTFAC,'GROUP_MA_2','MAILLE_2',IOCC,LLIST2)
C
C ----- DETERMINATION DU VECTEUR NORMAL NOR1 (RESP. NOR2)
C ----- AUX MAILLES DE LA LISTE LLIST1 (RESP. LLIST2)
C ----- AUXQUELLES APPARTIENT LE NOEUD NO1 (RESP. NO2),
C ----- CALCULE AU NOEUD NO1 (RESP. NO2)
C
        CALL CACONO(NOMA,NDIM,LLIST1,LLIST2,NO1,NO2,NOR1,NOR2,INOMA)
C
        DO 40 J =1, NDIM
           NORM1(J) = NORM1(J) + NOR1(J)
           NORM2(J) = NORM2(J) + NOR2(J)
 40     CONTINUE
C
C       SI INOMA = -1 => NORM1 = 0 CAR MAILLE POI1
C       SI INOMA = -2 => NORM2 = 0 CAR MAILLE POI1
C
        IF (INOMA.NE.-1) THEN
           CALL NORMEV ( NORM1, NRMBID )
        ENDIF
        IF (INOMA.NE.-2) THEN
           CALL NORMEV ( NORM2, NRMBID )
        ENDIF
        JEU = 0.0D0
C
C       ANGLE ENTRE NORMALES ET MOYENNE DES NORMALES UNITILE SI POI1
C
        IF ((INOMA.NE.-1).AND.(INOMA.NE.-2)) THEN
C
           DO 50 J =1, NDIM
              NORM1(J) = (NORM1(J) - NORM2(J))/2.0D0
 50        CONTINUE
C
        ELSE IF (INOMA.EQ.-1) THEN
C
C          NO1 APPARTIENT A UNE MAILLE POI1 : LA NORMALE EST NORM2
C
           DO 51 J =1, NDIM
              NORM1(J) =  - NORM2(J)
 51        CONTINUE
C
        ELSE IF (INOMA.EQ.-2) THEN
C
C          NO2 APPARTIENT A UNE MAILLE POI1 : LA NORMALE EST NORM1
C
        ENDIF
C
C
        DO 70 J = 1, NDIM
           ZR(IDRAD-1+(2*NDIM+1)*(I-1)+J)      =  NORM1(J)
           ZR(IDRAD-1+(2*NDIM+1)*(I-1)+J+NDIM) =  NORM2(J)
C
           JEU = JEU - ZR(IVALE-1+NBCMP*(NO1-1)+J) * NORM1(J)
     &               + ZR(IVALE-1+NBCMP*(NO2-1)+J) * NORM1(J)
 70     CONTINUE
C
        ZR(IDRAD- 1+(2*NDIM+1)*I) =  JEU
C
C
 10   CONTINUE
C
      CALL JEDETR ( LLIST1 )
      CALL JEDETR ( LLIST2 )
      CALL JEDETR ( '&&PACOJE.ANGL' )
C FIN -----------------------------------------------------------------
      CALL JEDEMA()
      END
